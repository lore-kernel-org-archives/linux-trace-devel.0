Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AFC4C3BD
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 15:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72AFC43390;
	Wed, 10 Jan 2024 15:38:41 +0000 (UTC)
Date: Wed, 10 Jan 2024 10:39:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: pierre.gondois@arm.com
Subject: [PATCH] libtracecmd rbtree: Fix deletion of leaf nodes
Message-ID: <20240110103941.2e26da60@gandalf.local.home>
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

In the rbtree deletion, the deletion had the logic:

	if (!node->left || !node->right)
		y = node;
	else
		y = next_node(node);

	if (y->left)
		x = y->left;
	else
		x = y->right;

	x->parent = y->parent;

Where if the node had both right and left, the y returned would not have
children. This is fine, but the x would be NULL. In that case, do not update
the parent of x. But instead, skip over and continue the work. As x->parent
would be the same as y->parent, instead of checking the x->parent (where x
could be NULL), check y->parent, which is already known to be the same as
x->parent if x is not NULL.

Also add another check_tree() at the end of the deletion routine.

Fixes: 5274db32a ("libtracecmd: Use an rbtree for mapping of cache pages")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
Reported-by: pierre.gondois@arm.com
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-rbtree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
index 24beabec..90671819 100644
--- a/lib/trace-cmd/trace-rbtree.c
+++ b/lib/trace-cmd/trace-rbtree.c
@@ -314,7 +314,7 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
 	struct trace_rbtree_node *x, *y;
 	bool do_fixup = false;
 
-	if (!node->left && !node->right) {
+	if (!node->left && !node->right && !node->parent) {
 		tree->node = NULL;
 		goto out;
 	}
@@ -329,9 +329,10 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
 	else
 		x = y->right;
 
-	x->parent = y->parent;
+	if (x)
+		x->parent = y->parent;
 
-	if (!x->parent) {
+	if (!y->parent) {
 		tree->node = x;
 	} else {
 		if (is_left(y))
@@ -367,6 +368,7 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
  out:
 	node->parent = node->left = node->right = NULL;
 	tree->nr_nodes--;
+	check_tree(tree);
 }
 
 __hidden struct trace_rbtree_node *trace_rbtree_next(struct trace_rbtree *tree,
-- 
2.42.0

