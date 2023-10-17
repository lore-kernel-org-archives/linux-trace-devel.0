Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89C5440D
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 02:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92112C433C8;
	Tue, 17 Oct 2023 02:59:24 +0000 (UTC)
Date: Mon, 16 Oct 2023 23:00:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>, Ross Zwisler
 <zwisler@google.com>
Subject: [PATCH] libtracecmd: Use an rbtree for mapping of cache pages
Message-ID: <20231016230058.2f0e95b1@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I was loading a very large trace.dat file into kernelshark when it just
stopped near the end off the load and hung there for a very long time. I
ran it under gdb and hit Ctrl^C when it hit the hang to see what it was
doing and found that it was spinning in:

  libtracecmd trace-input.c: free_zpage

static void free_zpage(struct cpu_data *cpu_data, void *map)
{
	struct zchunk_cache *cache;

	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
		if (map <= cache->map && map > (cache->map + cache->chunk->size))
			goto found;
	}
	return;

found:

It seems that there can be over 10 thousand cache pages in that link
list and that kernelshark is constantly hitting that. So it's doing a
linear search for the mapped page to free it.

I ran:  time kernelshark trace.dat

And exited out when it finished loading and the result was:

real    6m14.772s
user    6m0.649s
sys     0m12.718s

That's over 6 minutes to load the trace.dat file!!!

I ran perf record on it and it showed 77% of the time was in free_zpage().

I pulled out my old algorithms book and wrote up a rbtree for internal use
of libtracecmd. Then I switched the cache into a binary rbtree to do the
look ups. As the lookups used both where the memory of the compressed page
is mapped as well as the offset depending on how the search was done, I
found that it only used the memory allocation address in one location.
Luckily, the memory allocation mapping lookup also had access to the
offset of the file the memory represented. That allowed me to make all
lookups use the file offset (Thanks to Masami Hiramatsu for helping me
realize that).

After converting the cache to an rbtree lookup, I ran kernelshark again on
opening that file and exited out as soon as it finished loading and the
timings was:

real    1m22.356s
user    1m10.532s
sys     0m10.901s

Still a bit long, but it dropped from over 6 minutes to under 1 1/2
minutes. Also, free_zpages() was no longer in the perf record output.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile                       |   1 +
 lib/trace-cmd/include/private/trace-rbtree.h |  34 ++
 lib/trace-cmd/trace-input.c                  |  81 +++--
 lib/trace-cmd/trace-rbtree.c                 | 345 +++++++++++++++++++
 4 files changed, 438 insertions(+), 23 deletions(-)
 create mode 100644 lib/trace-cmd/include/private/trace-rbtree.h
 create mode 100644 lib/trace-cmd/trace-rbtree.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index e9d26b2bb367..aba6fda5b0f6 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -9,6 +9,7 @@ DEFAULT_TARGET = $(LIBTRACECMD_STATIC)
 
 OBJS =
 OBJS += trace-hash.o
+OBJS += trace-rbtree.o
 OBJS += trace-hooks.o
 OBJS += trace-input.o
 OBJS += trace-output.o
diff --git a/lib/trace-cmd/include/private/trace-rbtree.h b/lib/trace-cmd/include/private/trace-rbtree.h
new file mode 100644
index 000000000000..822111998e7a
--- /dev/null
+++ b/lib/trace-cmd/include/private/trace-rbtree.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2023 Google, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#ifndef _TRACE_RBTREE_H
+#define _TRACE_RBTREE_H
+
+struct trace_rbtree_node {
+	struct trace_rbtree_node	*parent;
+	struct trace_rbtree_node	*left;
+	struct trace_rbtree_node	*right;
+	int				color;
+};
+
+typedef int (*trace_rbtree_cmp_fn)(const struct trace_rbtree_node *A, const struct trace_rbtree_node *B);
+
+typedef int (*trace_rbtree_search_fn)(const struct trace_rbtree_node *n, const void *data);
+
+struct trace_rbtree {
+	struct trace_rbtree_node	*node;
+	trace_rbtree_search_fn		search;
+	trace_rbtree_cmp_fn		cmp;
+	size_t				nr_nodes;
+};
+
+void trace_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
+		       trace_rbtree_search_fn search_fn);
+struct trace_rbtree_node *trace_rbtree_find(struct trace_rbtree *tree, const void *data);
+void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *node);
+int trace_rbtree_insert(struct trace_rbtree *tree, struct trace_rbtree_node *node);
+struct trace_rbtree_node *trace_rbtree_pop_nobalance(struct trace_rbtree *tree);
+
+#endif /* _TRACE_RBTREE_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af51b3d71e1a..42c8312f8395 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -16,6 +16,7 @@
 
 #include "trace-write-local.h"
 #include "trace-cmd-local.h"
+#include "trace-rbtree.h"
 #include "trace-local.h"
 #include "kbuffer.h"
 #include "list.h"
@@ -66,7 +67,7 @@ struct page {
 };
 
 struct zchunk_cache {
-	struct list_head		list;
+	struct trace_rbtree_node	node;
 	struct tracecmd_compress_chunk *chunk;
 	void				*map;
 	int				ref;
@@ -78,7 +79,7 @@ struct cpu_zdata {
 	char			file[26]; /* strlen(COMPR_TEMP_FILE) */
 	unsigned int		count;
 	unsigned int		last_chunk;
-	struct list_head	cache;
+	struct trace_rbtree	cache;
 	struct tracecmd_compress_chunk	*chunks;
 };
 
@@ -1378,21 +1379,24 @@ static struct tracecmd_compress_chunk *get_zchunk(struct cpu_data *cpu, off_t of
 	return chunk;
 }
 
-static void free_zpage(struct cpu_data *cpu_data, void *map)
+static void free_zpage(struct cpu_data *cpu_data, off_t offset)
 {
+	struct trace_rbtree_node *node;
 	struct zchunk_cache *cache;
 
-	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
-		if (map <= cache->map && map > (cache->map + cache->chunk->size))
-			goto found;
-	}
-	return;
+	node = trace_rbtree_find(&cpu_data->compress.cache, (void *)&offset);
+
+	if (!node)
+		return;
+
+	cache = container_of(node, struct zchunk_cache, node);
 
-found:
 	cache->ref--;
 	if (cache->ref)
 		return;
-	list_del(&cache->list);
+
+	trace_rbtree_delete(&cpu_data->compress.cache, node);
+
 	free(cache->map);
 	free(cache);
 }
@@ -1401,6 +1405,7 @@ static void *read_zpage(struct tracecmd_input *handle, int cpu, off_t offset)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
 	struct tracecmd_compress_chunk *chunk;
+	struct trace_rbtree_node *node;
 	struct zchunk_cache *cache;
 	void *map = NULL;
 	int pindex;
@@ -1409,11 +1414,11 @@ static void *read_zpage(struct tracecmd_input *handle, int cpu, off_t offset)
 	offset -= cpu_data->file_offset;
 
 	/* Look in the cache of already loaded chunks */
-	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
-		if (CHUNK_CHECK_OFFSET(cache->chunk, offset)) {
-			cache->ref++;
-			goto out;
-		}
+	node = trace_rbtree_find(&cpu_data->compress.cache, (void *)&offset);
+	if (node) {
+		cache = container_of(node, struct zchunk_cache, node);
+		cache->ref++;
+		goto out;
 	}
 
 	chunk =  get_zchunk(cpu_data, offset);
@@ -1435,7 +1440,7 @@ static void *read_zpage(struct tracecmd_input *handle, int cpu, off_t offset)
 	cache->ref = 1;
 	cache->chunk = chunk;
 	cache->map = map;
-	list_add(&cache->list, &cpu_data->compress.cache);
+	trace_rbtree_insert(&cpu_data->compress.cache, &cache->node);
 
 	/* a chunk can hold multiple pages, get the requested one */
 out:
@@ -1606,7 +1611,7 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	if (handle->read_page)
 		free(page->map);
 	else if (handle->read_zpage)
-		free_zpage(cpu_data, page->map);
+		free_zpage(cpu_data, page->offset);
 	else
 		free_page_map(page->page_map);
 
@@ -2102,7 +2107,7 @@ tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 	/* If the page was already mapped, we need to reset it */
 	if (ret)
 		update_page_info(handle, cpu);
-		
+
 	free_next(handle, cpu);
 
 	return tracecmd_read_data(handle, cpu);
@@ -3348,6 +3353,35 @@ static int init_cpu_zpage(struct tracecmd_input *handle, int cpu)
 	return 0;
 }
 
+static int compress_cmp(const struct trace_rbtree_node *A,
+			const struct trace_rbtree_node *B)
+{
+	const struct zchunk_cache *cacheA;
+	const struct zchunk_cache *cacheB;
+
+	cacheA = container_of(A, struct zchunk_cache, node);
+	cacheB = container_of(B, struct zchunk_cache, node);
+
+	return chunk_cmp(cacheA->chunk, cacheB->chunk);
+}
+
+static int compress_search(const struct trace_rbtree_node *A,
+			   const void *data)
+{
+	const struct zchunk_cache *cache;
+	off_t offset = *(off_t *)data;
+
+	cache = container_of(A, struct zchunk_cache, node);
+
+	if (CHUNK_CHECK_OFFSET(cache->chunk, offset))
+		return 0;
+
+	if (cache->chunk->offset < offset)
+		return -1;
+
+	return 1;
+}
+
 static int init_cpu(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
@@ -3368,7 +3402,8 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 	cpu_data->timestamp = 0;
 
 	list_head_init(&cpu_data->page_maps);
-	list_head_init(&cpu_data->compress.cache);
+
+	trace_rbtree_init(&cpu_data->compress.cache, compress_cmp, compress_search);
 
 	if (!cpu_data->size) {
 		tracecmd_info("CPU %d is empty", cpu);
@@ -5131,10 +5166,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 				close(cpu_data->compress.fd);
 				unlink(cpu_data->compress.file);
 			}
-			while (!list_empty(&cpu_data->compress.cache)) {
-				cache = container_of(cpu_data->compress.cache.next,
-						     struct zchunk_cache, list);
-				list_del(&cache->list);
+			while (cpu_data->compress.cache.node) {
+				struct trace_rbtree_node *node;
+				node = trace_rbtree_pop_nobalance(&cpu_data->compress.cache);
+				cache = container_of(node, struct zchunk_cache, node);
 				free(cache->map);
 				free(cache);
 			}
diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
new file mode 100644
index 000000000000..b015773ed2d6
--- /dev/null
+++ b/lib/trace-cmd/trace-rbtree.c
@@ -0,0 +1,345 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2023 Google, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#include <stdlib.h>
+#include <stdbool.h>
+#include "trace-local.h"
+#include "trace-rbtree.h"
+
+enum {
+	RED,
+	BLACK,
+};
+
+void __hidden trace_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
+				trace_rbtree_search_fn search_fn)
+{
+	memset(tree, 0, sizeof(*tree));
+	tree->search = search_fn;
+	tree->cmp = cmp_fn;
+}
+
+static bool is_left(struct trace_rbtree_node *node)
+{
+	return node == node->parent->left;
+}
+
+static void check_tree(struct trace_rbtree_node *node)
+{
+	if (!node)
+		return;
+
+	if (node->color == RED &&
+	    ((node->left && node->left->color == RED) ||
+	    ((node->right && node->right->color == RED))))
+		breakpoint();
+
+	check_tree(node->left);
+	check_tree(node->right);
+}
+
+static struct trace_rbtree_node **get_parent_ptr(struct trace_rbtree *tree,
+						 struct trace_rbtree_node *node)
+{
+	if (!node->parent)
+		return &tree->node;
+	else if (is_left(node))
+		return &node->parent->left;
+	else
+		return &node->parent->right;
+}
+
+static void rotate_left(struct trace_rbtree *tree,
+			struct trace_rbtree_node *node)
+{
+	struct trace_rbtree_node **parent_ptr = get_parent_ptr(tree, node);
+	struct trace_rbtree_node *parent = node->parent;
+	struct trace_rbtree_node *old_right = node->right;
+
+	*parent_ptr = old_right;
+	node->right = old_right->left;
+	old_right->left = node;
+
+	node->parent = old_right;
+	old_right->parent = parent;
+}
+
+static void rotate_right(struct trace_rbtree *tree,
+			 struct trace_rbtree_node *node)
+{
+	struct trace_rbtree_node **parent_ptr = get_parent_ptr(tree, node);
+	struct trace_rbtree_node *parent = node->parent;
+	struct trace_rbtree_node *old_left = node->left;
+
+	*parent_ptr = old_left;
+	node->left = old_left->right;
+	old_left->right = node;
+
+	node->parent = old_left;
+	old_left->parent = parent;
+}
+
+static void insert_tree(struct trace_rbtree *tree,
+			struct trace_rbtree_node *node)
+{
+	struct trace_rbtree_node *next = tree->node;
+	struct trace_rbtree_node *last_next = NULL;
+	bool went_left = false;
+
+	while (next) {
+		last_next = next;
+		if (tree->cmp(next, node) > 0) {
+			next = next->right;
+			went_left = false;
+		} else {
+			next = next->left;
+			went_left = true;
+		}
+	}
+
+	if (!last_next) {
+		tree->node = node;
+		return;
+	}
+
+	if (went_left)
+		last_next->left = node;
+	else
+		last_next->right = node;
+
+	node->parent = last_next;
+}
+
+int __hidden trace_rbtree_insert(struct trace_rbtree *tree,
+				 struct trace_rbtree_node *node)
+{
+	memset(node, 0, sizeof(*node));
+
+	insert_tree(tree, node);
+	node->color = RED;
+	while (node && node->parent && node->parent->color == RED) {
+		if (is_left(node->parent)) {
+			struct trace_rbtree_node *old_right;
+
+			old_right = node->parent->parent->right;
+			if (old_right && old_right->color == RED) {
+				node->parent->color = BLACK;
+				old_right->color = BLACK;
+				node->parent->parent = RED;
+				node = node->parent->parent;
+			} else {
+				if (!is_left(node)) {
+					node = node->parent;
+					rotate_left(tree, node);
+				}
+				node->parent->color = BLACK;
+				node->parent->parent->color = RED;
+				rotate_right(tree, node->parent->parent);
+			}
+		} else {
+			struct trace_rbtree_node *old_left;
+
+			old_left = node->parent->parent->right;
+			if (old_left && old_left->color == RED) {
+				node->parent->color = BLACK;
+				old_left->color = BLACK;
+				node->parent->parent = RED;
+				node = node->parent->parent;
+			} else {
+				if (is_left(node)) {
+					node = node->parent;
+					rotate_right(tree, node);
+				}
+				node->parent->color = BLACK;
+				node->parent->parent->color = RED;
+				rotate_left(tree, node->parent->parent);
+			}
+		}
+	}
+	tree->node->color = BLACK;
+	tree->nr_nodes++;
+	check_tree(tree->node);
+	return 0;
+}
+
+struct trace_rbtree_node *trace_rbtree_find(struct trace_rbtree *tree, const void *data)
+{
+	struct trace_rbtree_node *node = tree->node;
+	int ret;
+
+	while (node) {
+		ret = tree->search(node, data);
+		if (!ret)
+			return node;
+		if (ret > 0)
+			node = node->right;
+		else
+			node = node->left;
+	}
+	return NULL;
+}
+
+static struct trace_rbtree_node *next_node(struct trace_rbtree_node *node)
+{
+	if (node->right) {
+		node = node->right;
+		while (node->left)
+			node = node->left;
+		return node;
+	}
+
+	while (node->parent && !is_left(node))
+		node = node->parent;
+
+	return node->parent;
+}
+
+static void tree_fixup(struct trace_rbtree *tree, struct trace_rbtree_node *node)
+{
+	while (node->parent && node->color == BLACK) {
+		if (is_left(node)) {
+			struct trace_rbtree_node *old_right = node->parent->right;
+
+			if (old_right->color == RED) {
+				old_right->color = BLACK;
+				node->parent->color = RED;
+				rotate_left(tree, node->parent);
+				old_right = node->parent->right;
+			}
+			if (old_right->left->color == BLACK &&
+			    old_right->right->color == BLACK) {
+				old_right->color = RED;
+				node = node->parent;
+			} else {
+				if (old_right->right->color == BLACK) {
+					old_right->left->color = BLACK;
+					old_right->color = RED;
+					rotate_right(tree, old_right);
+					old_right = node->parent->right;
+				}
+				old_right->color = node->parent->color;
+				node->parent->color = BLACK;
+				old_right->right->color = BLACK;
+				rotate_left(tree, node->parent);
+				node = tree->node;
+			}
+		} else {
+			struct trace_rbtree_node *old_left = node->parent->left;
+
+			if (old_left->color == RED) {
+				old_left->color = BLACK;
+				node->parent->color = RED;
+				rotate_right(tree, node->parent);
+				old_left = node->parent->left;
+			}
+			if (old_left->right->color == BLACK &&
+			    old_left->left->color == BLACK) {
+				old_left->color = RED;
+				node = node->parent;
+			} else {
+				if (old_left->left->color == BLACK) {
+					old_left->right->color = BLACK;
+					old_left->color = RED;
+					rotate_left(tree, old_left);
+					old_left = node->parent->left;
+				}
+				old_left->color = node->parent->color;
+				node->parent->color = BLACK;
+				old_left->left->color = BLACK;
+				rotate_right(tree, node->parent);
+				node = tree->node;
+			}
+		}
+	}
+	node->color = BLACK;
+}
+
+void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *node)
+{
+	struct trace_rbtree_node *x, *y;
+
+	if (!node->left && !node->right) {
+		tree->node = NULL;
+		goto out;
+	}
+
+	if (!node->left || !node->right)
+		y = node;
+	else
+		y = next_node(node);
+
+	if (y->left)
+		x = y->left;
+	else
+		x = y->right;
+
+	x->parent = y->parent;
+
+	if (!x->parent) {
+		tree->node = x;
+	} else {
+		if (is_left(y))
+			y->parent->left = x;
+		else
+			y->parent->right = x;
+	}
+
+	if (y != node) {
+		y->parent = node->parent;
+		y->left = node->left;
+		y->right = node->right;
+		if (y->left)
+			y->left->parent = y;
+		if (y->right)
+			y->right->parent = y;
+		if (!y->parent) {
+			tree->node = y;
+		} else {
+			if (is_left(node))
+				y->parent->left = y;
+			else
+				y->parent->right = y;
+		}
+	}
+
+	if (y->color == BLACK)
+		tree_fixup(tree, x);
+
+ out:
+	node->parent = node->left = node->right = NULL;
+	tree->nr_nodes--;
+	check_tree(tree->node);
+}
+
+/*
+ * Used for freeing a tree, just quickly pop off the children in
+ * no particular order. This will corrupt the tree! That is,
+ * do not do any inserting or deleting of this tree after calling
+ * this function.
+ */
+struct trace_rbtree_node *trace_rbtree_pop_nobalance(struct trace_rbtree *tree)
+{
+	struct trace_rbtree_node *node = tree->node;
+
+	if (!node)
+		return NULL;
+
+	while (node->left)
+		node = node->left;
+
+	while (node->right)
+		node = node->right;
+
+	if (node->parent) {
+		if (is_left(node))
+			node->parent->left = NULL;
+		else
+			node->parent->right = NULL;
+	} else {
+		tree->node = NULL;
+	}
+
+	return node;
+}
-- 
2.42.0

