Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181E81D8E1D
	for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 12:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730118186; cv=none; b=UToAjzxlzx0YzeT5306Ny9du58kIS6LP4wNMSQIGpqiBCjP2wepgB4sbiFOu2o4FeqesTbG+G4VzQfztUpsR5EJi8Ot5ahSRMrlLa3acOOPyBkTOPLTL8Sn+LrF3S+CRoRWpWDXr+I3L4Es2zO6qOSz3ePa85x1u7saEGnwBYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730118186; c=relaxed/simple;
	bh=nRFm6r+DQwyF0d8CL6yEkPbRthqQ9s3KMQKKlZ7P3kA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UIAt2wG53wicB6JM1p5kjZGONOvs/N00mmTXVncTLUNi335zuGC68Z4ba1FGIHgL2AG4wY+vlrEPpsGQAFGtZmF0f4NkSMCdge3jNguzDwHfPUjFSS8Ujbwwt/Jp8QwyKaaJOM7aD2zeyBpBND0WIDAvtAurslxDimcpQub0xDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DAAA497;
	Mon, 28 Oct 2024 05:23:26 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7BD223F73B;
	Mon, 28 Oct 2024 05:22:55 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: [PATCH] trace-cmd: libtracecmd: Rename private functions to fix static building
Date: Mon, 28 Oct 2024 12:22:47 +0000
Message-Id: <20241028122247.1594967-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building trace-cmd statically fails because of duplicated symbols for
strstrip() function which is also implemented in libtracefs. The
__hidden attribute does not resolve these conflicts for static builds
due to the lack of namespacing support in C. Refer to the associated
Bugzilla page [1] for further details.

Although only strstrip() breaks the static build as of now, we should
fix the underlying issue comprehensively across the libtraceevent,
libtracefs, and trace-cmd packages. The recommendation on [1] is
prepending package name (e.g., "tracecmd_") to private functions (tagged
with __hidden attribute).

Thus:
1. Retain private functions which already start with "tracecmd_".
2. If a private function starts with "trace_", then just change its
   prefix to "tracecmd_".
3. If prepending "tracecmd_" prefix to a private function's name clashes
   with an existing one, rename one of the functions per its context
   (e.g., rename trace_load_plugins() to
   tracecmd_load_plugins_from_handle() and trace_append_options() to
   tracecmd_append_options_to_file()).
4. Prepend "tracecmd_" prefix to all remaining "__hidden" functions.

Future __hidden functions should follow this prefixing schemed to avoid
new naming conflicts.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217768

Cc: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 .../include/private/trace-cmd-private.h       |  14 +-
 lib/trace-cmd/include/private/trace-hash.h    |  10 +-
 lib/trace-cmd/include/private/trace-rbtree.h  |   4 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  56 ++--
 lib/trace-cmd/trace-hash.c                    |  10 +-
 lib/trace-cmd/trace-input.c                   | 206 ++++++------
 lib/trace-cmd/trace-maps.c                    |  20 +-
 lib/trace-cmd/trace-msg.c                     |   6 +-
 lib/trace-cmd/trace-output.c                  | 303 +++++++++---------
 lib/trace-cmd/trace-perf.c                    |  22 +-
 lib/trace-cmd/trace-rbtree.c                  |   6 +-
 lib/trace-cmd/trace-timesync.c                |   2 +-
 lib/trace-cmd/trace-util.c                    |  18 +-
 tracecmd/include/trace-local.h                |  24 +-
 tracecmd/trace-agent.c                        |  12 +-
 tracecmd/trace-check-events.c                 |   2 +-
 tracecmd/trace-list.c                         |   4 +-
 tracecmd/trace-listen.c                       |   6 +-
 tracecmd/trace-profile.c                      |  58 ++--
 tracecmd/trace-read.c                         |  10 +-
 tracecmd/trace-record.c                       |  28 +-
 tracecmd/trace-vm.c                           |   2 +-
 tracecmd/trace-vsock.c                        |  14 +-
 23 files changed, 419 insertions(+), 418 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index e2f22315..a0f397a3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -28,7 +28,7 @@
 
 #define TSCNSEC_CLOCK	"tsc2nsec"
 
-struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
+struct tep_plugin_list *tracecmd_load_plugins_from_handle(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
 
@@ -504,7 +504,7 @@ enum tracecmd_time_sync_role {
 
 void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
-bool tsync_proto_is_supported(const char *proto_name);
+bool tracecmd_tsync_proto_is_supported(const char *proto_name);
 struct tracecmd_time_sync *
 tracecmd_tsync_with_host(int fd, const char *proto, const char *clock,
 			 int remote_id, int local_id);
@@ -571,8 +571,8 @@ int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
-char **trace_util_find_plugin_files(const char *suffix);
-void trace_util_free_plugin_files(char **files);
+char **tracecmd_util_find_plugin_files(const char *suffix);
+void tracecmd_util_free_plugin_files(char **files);
 
 /* Used for trace-cmd list */
 void tracecmd_ftrace_load_options(void);
@@ -633,9 +633,9 @@ struct trace_perf {
 	struct perf_event_attr pe;
 	struct perf_event_mmap_page *mmap;
 };
-int trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid);
-int trace_perf_open(struct trace_perf *perf);
-void trace_perf_close(struct trace_perf *perf);
+int tracecmd_perf_init(struct trace_perf *perf, int pages, int cpu, int pid);
+int tracecmd_perf_open(struct trace_perf *perf);
+void tracecmd_perf_close(struct trace_perf *perf);
 #endif
 
 #endif /* _TRACE_CMD_PRIVATE_H */
diff --git a/lib/trace-cmd/include/private/trace-hash.h b/lib/trace-cmd/include/private/trace-hash.h
index aa92cdfe..74906555 100644
--- a/lib/trace-cmd/include/private/trace-hash.h
+++ b/lib/trace-cmd/include/private/trace-hash.h
@@ -18,10 +18,10 @@ struct trace_hash {
 	int			power;
 };
 
-int trace_hash_init(struct trace_hash *hash, int buckets);
-void trace_hash_free(struct trace_hash *hash);
-int trace_hash_add(struct trace_hash *hash, struct trace_hash_item *item);
-int trace_hash_empty(struct trace_hash *hash);
+int tracecmd_hash_init(struct trace_hash *hash, int buckets);
+void tracecmd_hash_free(struct trace_hash *hash);
+int tracecmd_hash_add(struct trace_hash *hash, struct trace_hash_item *item);
+int tracecmd_hash_empty(struct trace_hash *hash);
 
 static inline void trace_hash_del(struct trace_hash_item *item)
 {
@@ -49,7 +49,7 @@ static inline void trace_hash_del(struct trace_hash_item *item)
 typedef int (*trace_hash_func)(struct trace_hash_item *item, void *data);
 
 struct trace_hash_item *
-trace_hash_find(struct trace_hash *hash, unsigned long long key,
+tracecmd_hash_find(struct trace_hash *hash, unsigned long long key,
 		trace_hash_func match, void *data);
 
 #endif /* _TRACE_HASH_H */
diff --git a/lib/trace-cmd/include/private/trace-rbtree.h b/lib/trace-cmd/include/private/trace-rbtree.h
index 82211199..a0ee1d71 100644
--- a/lib/trace-cmd/include/private/trace-rbtree.h
+++ b/lib/trace-cmd/include/private/trace-rbtree.h
@@ -24,11 +24,11 @@ struct trace_rbtree {
 	size_t				nr_nodes;
 };
 
-void trace_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
+void tracecmd_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
 		       trace_rbtree_search_fn search_fn);
 struct trace_rbtree_node *trace_rbtree_find(struct trace_rbtree *tree, const void *data);
 void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *node);
-int trace_rbtree_insert(struct trace_rbtree *tree, struct trace_rbtree_node *node);
+int tracecmd_rbtree_insert(struct trace_rbtree *tree, struct trace_rbtree_node *node);
 struct trace_rbtree_node *trace_rbtree_pop_nobalance(struct trace_rbtree *tree);
 
 #endif /* _TRACE_RBTREE_H */
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 1a37e817..82977dc3 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -52,42 +52,42 @@ struct data_file_write {
 enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
 					    struct tep_record *record);
 
-void trace_set_guest_map(struct tracecmd_input *handle, struct tracecmd_cpu_map *map);
-struct tracecmd_cpu_map *trace_get_guest_map(struct tracecmd_input *handle);
-void trace_set_guest_map_cnt(struct tracecmd_input *handle, int count);
-int trace_get_guest_map_cnt(struct tracecmd_input *handle);
-void trace_guest_map_free(struct tracecmd_cpu_map *map);
+void tracecmd_set_guest_map(struct tracecmd_input *handle, struct tracecmd_cpu_map *map);
+struct tracecmd_cpu_map *tracecmd_get_guest_map(struct tracecmd_input *handle);
+void tracecmd_set_guest_map_cnt(struct tracecmd_input *handle, int count);
+int tracecmd_get_guest_map_cnt(struct tracecmd_input *handle);
+void tracecmd_guest_map_free(struct tracecmd_cpu_map *map);
 
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
-bool check_file_state(unsigned long file_version, int current_state, int new_state);
-bool check_out_state(struct tracecmd_output *handle, int new_state);
+bool tracecmd_check_file_state(unsigned long file_version, int current_state, int new_state);
+bool tracecmd_check_out_state(struct tracecmd_output *handle, int new_state);
 
-int out_uncompress_block(struct tracecmd_output *handle);
-int out_compression_start(struct tracecmd_output *handle, bool compress);
-int out_compression_end(struct tracecmd_output *handle, bool compress);
-void out_compression_reset(struct tracecmd_output *handle, bool compress);
-bool out_check_compression(struct tracecmd_output *handle);
+int tracecmd_out_uncompress_block(struct tracecmd_output *handle);
+int tracecmd_out_compression_start(struct tracecmd_output *handle, bool compress);
+int tracecmd_out_compression_end(struct tracecmd_output *handle, bool compress);
+void tracecmd_out_compression_reset(struct tracecmd_output *handle, bool compress);
+bool tracecmd_out_check_compression(struct tracecmd_output *handle);
 
-void out_set_file_state(struct tracecmd_output *handle, int new_state);
-int out_save_options_offset(struct tracecmd_output *handle,
+void tracecmd_out_set_file_state(struct tracecmd_output *handle, int new_state);
+int tracecmd_out_save_options_offset(struct tracecmd_output *handle,
 			    unsigned long long start);
-unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+unsigned long long tracecmd_out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size, int page);
-void in_uncompress_reset(struct tracecmd_input *handle);
-int in_uncompress_block(struct tracecmd_input *handle);
+void tracecmd_in_uncompress_reset(struct tracecmd_input *handle);
+int tracecmd_in_uncompress_block(struct tracecmd_input *handle);
 
 unsigned long long
-out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+tracecmd_out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, int flags, bool option);
-int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
+int tracecmd_out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
-long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
+long long tracecmd_do_write_check(struct tracecmd_output *handle, const void *data, long long size);
 
 struct tracecmd_option *
-out_add_buffer_option(struct tracecmd_output *handle, const char *name,
+tracecmd_out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		      unsigned short id, unsigned long long data_offset,
 		      int cpus, struct data_file_write *cpu_data, int page_size);
 
@@ -97,14 +97,14 @@ struct cpu_data_source {
 	off_t offset;
 };
 
-int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
+int tracecmd_out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
-int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
-off_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
-unsigned long long get_last_option_offset(struct tracecmd_input *handle);
-unsigned int get_meta_strings_size(struct tracecmd_input *handle);
-int trace_append_options(struct tracecmd_output *handle, void *buf, size_t len);
-void *trace_get_options(struct tracecmd_output *handle, size_t *len);
+int tracecmd_out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
+off_t tracecmd_msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long tracecmd_get_last_option_offset(struct tracecmd_input *handle);
+unsigned int tracecmd_get_meta_strings_size(struct tracecmd_input *handle);
+int tracecmd_append_options_to_file(struct tracecmd_output *handle, void *buf, size_t len);
+void *tracecmd_get_options(struct tracecmd_output *handle, size_t *len);
 
 /* filters */
 struct tracecmd_filter *tracecmd_filter_get(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-hash.c b/lib/trace-cmd/trace-hash.c
index bed97323..dc39f7da 100644
--- a/lib/trace-cmd/trace-hash.c
+++ b/lib/trace-cmd/trace-hash.c
@@ -12,7 +12,7 @@
 #include "trace-cmd-private.h"
 #include "trace-hash.h"
 
-int __hidden trace_hash_init(struct trace_hash *hash, int buckets)
+int __hidden tracecmd_hash_init(struct trace_hash *hash, int buckets)
 {
 	memset(hash, 0, sizeof(*hash));
 
@@ -28,12 +28,12 @@ int __hidden trace_hash_init(struct trace_hash *hash, int buckets)
 	return 0;
 }
 
-void __hidden trace_hash_free(struct trace_hash *hash)
+void __hidden tracecmd_hash_free(struct trace_hash *hash)
 {
 	free(hash->buckets);
 }
 
-int __hidden trace_hash_empty(struct trace_hash *hash)
+int __hidden tracecmd_hash_empty(struct trace_hash *hash)
 {
 	struct trace_hash_item **bucket;
 
@@ -43,7 +43,7 @@ int __hidden trace_hash_empty(struct trace_hash *hash)
 	return 1;
 }
 
-int __hidden trace_hash_add(struct trace_hash *hash, struct trace_hash_item *item)
+int __hidden tracecmd_hash_add(struct trace_hash *hash, struct trace_hash_item *item)
 {
 	struct trace_hash_item *next;
 	int bucket = hash->power ? item->key & hash->power :
@@ -64,7 +64,7 @@ int __hidden trace_hash_add(struct trace_hash *hash, struct trace_hash_item *ite
 }
 
  __hidden struct trace_hash_item *
-trace_hash_find(struct trace_hash *hash, unsigned long long key,
+tracecmd_hash_find(struct trace_hash *hash, unsigned long long key,
 		trace_hash_func match, void *data)
 {
 	struct trace_hash_item *item;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8b6e3d0c..88f1ed4a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -325,29 +325,29 @@ static const char *show_records(struct page **pages, int nr_pages)
 #endif
 
 /**
- * trace_set_guest_map - set map to input handle
+ * tracecmd_set_guest_map - set map to input handle
  * @handle: The handle to set the cpu map to
  * @map: The cpu map for this handle (to the host)
  *
  * Assign the mapping of host to guest for a guest handle.
  */
-__hidden void trace_set_guest_map(struct tracecmd_input *handle,
+__hidden void tracecmd_set_guest_map(struct tracecmd_input *handle,
 				  struct tracecmd_cpu_map *map)
 {
 	handle->map = map;
 }
 
-__hidden struct tracecmd_cpu_map *trace_get_guest_map(struct tracecmd_input *handle)
+__hidden struct tracecmd_cpu_map *tracecmd_get_guest_map(struct tracecmd_input *handle)
 {
 	return handle->map;
 }
 
-__hidden void trace_set_guest_map_cnt(struct tracecmd_input *handle, int count)
+__hidden void tracecmd_set_guest_map_cnt(struct tracecmd_input *handle, int count)
 {
 	handle->map_cnt = count;
 }
 
-__hidden int trace_get_guest_map_cnt(struct tracecmd_input *handle)
+__hidden int tracecmd_get_guest_map_cnt(struct tracecmd_input *handle)
 {
 	return handle->map_cnt;
 }
@@ -500,7 +500,7 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	return 0;
 }
 
-__hidden void in_uncompress_reset(struct tracecmd_input *handle)
+__hidden void tracecmd_in_uncompress_reset(struct tracecmd_input *handle)
 {
 	if (handle->compress) {
 		handle->read_compress = false;
@@ -508,7 +508,7 @@ __hidden void in_uncompress_reset(struct tracecmd_input *handle)
 	}
 }
 
-__hidden int in_uncompress_block(struct tracecmd_input *handle)
+__hidden int tracecmd_in_uncompress_block(struct tracecmd_input *handle)
 {
 	int ret = 0;
 
@@ -542,7 +542,7 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 	if (lseek(handle->fd, sec->data_offset, SEEK_SET) == (off_t)-1)
 		return NULL;
 
-	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && tracecmd_in_uncompress_block(handle))
 		return NULL;
 
 	return sec;
@@ -551,7 +551,7 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 static void section_close(struct tracecmd_input *handle, struct file_section *sec)
 {
 	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
-		in_uncompress_reset(handle);
+		tracecmd_in_uncompress_reset(handle);
 }
 
 static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
@@ -1181,7 +1181,7 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek(handle->fd, 0, SEEK_CUR);
-	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && tracecmd_in_uncompress_block(handle))
 		return -1;
 
 	switch (section->id) {
@@ -1209,7 +1209,7 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 	}
 
 	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
-		in_uncompress_reset(handle);
+		tracecmd_in_uncompress_reset(handle);
 
 	return ret;
 }
@@ -1441,7 +1441,7 @@ static void *read_zpage(struct tracecmd_input *handle, int cpu, off_t offset)
 	cache->ref = 1;
 	cache->chunk = chunk;
 	cache->map = map;
-	trace_rbtree_insert(&cpu_data->compress.cache, &cache->node);
+	tracecmd_rbtree_insert(&cpu_data->compress.cache, &cache->node);
 
 	/* a chunk can hold multiple pages, get the requested one */
 out:
@@ -3411,7 +3411,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 
 	list_head_init(&cpu_data->page_maps);
 
-	trace_rbtree_init(&cpu_data->compress.cache, compress_cmp, compress_search);
+	tracecmd_rbtree_init(&cpu_data->compress.cache, compress_cmp, compress_search);
 
 	if (!cpu_data->size) {
 		tracecmd_info("CPU %d is empty", cpu);
@@ -3829,12 +3829,12 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
-__hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
+__hidden unsigned int tracecmd_get_meta_strings_size(struct tracecmd_input *handle)
 {
 	return handle->strings_size;
 }
 
-__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
+__hidden unsigned long long tracecmd_get_last_option_offset(struct tracecmd_input *handle)
 {
 	return handle->options_last_offset;
 }
@@ -4021,7 +4021,7 @@ static int handle_options(struct tracecmd_input *handle)
 			compress = true;
 	}
 
-	if (compress && in_uncompress_block(handle))
+	if (compress && tracecmd_in_uncompress_block(handle))
 		return -1;
 
 	for (;;) {
@@ -4180,7 +4180,7 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_DONE:
 			if (compress)
-				in_uncompress_reset(handle);
+				tracecmd_in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -4198,7 +4198,7 @@ static int handle_options(struct tracecmd_input *handle)
 
 out:
 	if (compress)
-		in_uncompress_reset(handle);
+		tracecmd_in_uncompress_reset(handle);
 	return ret;
 }
 
@@ -4836,14 +4836,14 @@ static int read_metadata_strings(struct tracecmd_input *handle)
 				read4(handle, &csize);
 				read4(handle, &rsize);
 				do_lseek(handle, -8, SEEK_CUR);
-				if (in_uncompress_block(handle))
+				if (tracecmd_in_uncompress_block(handle))
 					break;
 			} else {
 				rsize = size;
 			}
 			init_metadata_strings(handle, rsize);
 			if (flags & TRACECMD_SEC_FL_COMPRESS)
-				in_uncompress_reset(handle);
+				tracecmd_in_uncompress_reset(handle);
 		} else {
 			if (lseek(handle->fd, size, SEEK_CUR) == (off_t)-1)
 				break;
@@ -4940,7 +4940,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	    !(flags & TRACECMD_FL_LOAD_NO_SYSTEM_PLUGINS))
 		tracecmd_ftrace_overrides(handle, &handle->finfo);
 
-	handle->plugin_list = trace_load_plugins(handle->pevent, flags);
+	handle->plugin_list = tracecmd_load_plugins_from_handle(handle->pevent, flags);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
@@ -5197,7 +5197,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	free(handle->followers);
 	free(handle->missed_followers);
-	trace_guest_map_free(handle->map);
+	tracecmd_guest_map_free(handle->map);
 	close(handle->fd);
 	free(handle->latz.chunks);
 	if (handle->latz.fd >= 0) {
@@ -5244,7 +5244,7 @@ static int read_copy_size8(struct tracecmd_input *in_handle,
 	if (do_read_check(in_handle, size, 8))
 		return -1;
 
-	if (do_write_check(out_handle, size, 8))
+	if (tracecmd_do_write_check(out_handle, size, 8))
 		return -1;
 
 	*size = tep_read_number(in_handle->pevent, size, 8);
@@ -5258,7 +5258,7 @@ static int read_copy_size4(struct tracecmd_input *in_handle, struct tracecmd_out
 	if (do_read_check(in_handle, size, 4))
 		return -1;
 
-	if (do_write_check(out_handle, size, 4))
+	if (tracecmd_do_write_check(out_handle, size, 4))
 		return -1;
 
 	*size = tep_read_number(in_handle->pevent, size, 4);
@@ -5277,7 +5277,7 @@ static int read_copy_data(struct tracecmd_input *in_handle,
 	if (do_read_check(in_handle, buf, size))
 		goto failed_read;
 
-	if (do_write_check(out_handle, buf, size))
+	if (tracecmd_do_write_check(out_handle, buf, size))
 		goto failed_read;
 	
 	free(buf);
@@ -5292,28 +5292,28 @@ static int read_copy_data(struct tracecmd_input *in_handle,
 
 static bool check_in_state(struct tracecmd_input *handle, int new_state)
 {
-	return check_file_state(handle->file_version, handle->file_state, new_state);
+	return tracecmd_check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
 static int copy_header_files(struct tracecmd_input *in_handle,
 			     struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_HEADERS) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_HEADERS))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_HEADERS))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_HEADER_INFO);
 	if (!sec)
 		return -1;
 
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_HEADER_INFO,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_HEADER_INFO,
 					  "headers", TRACECMD_SEC_FL_COMPRESS, true);
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 
 	/* "header_page"  */
 	if (read_copy_data(in_handle, 12, out_handle) < 0)
@@ -5336,25 +5336,25 @@ static int copy_header_files(struct tracecmd_input *in_handle,
 		goto error;
 
 	in_handle->file_state = TRACECMD_FILE_HEADERS;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5362,16 +5362,16 @@ static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_o
 	unsigned int i;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_FTRACE_EVENTS) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_FTRACE_EVENTS))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_FTRACE_EVENTS))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_FTRACE_EVENTS);
 	if (!sec)
 		return -1;
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_FTRACE_EVENTS,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_FTRACE_EVENTS,
 					  "ftrace events", TRACECMD_SEC_FL_COMPRESS, true);
 
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 
 	if (read_copy_size4(in_handle, out_handle, &count) < 0)
 		goto error;
@@ -5386,26 +5386,26 @@ static int copy_ftrace_files(struct tracecmd_input *in_handle, struct tracecmd_o
 	}
 
 	in_handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
@@ -5415,16 +5415,16 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 	unsigned int i,x;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_ALL_EVENTS) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_ALL_EVENTS))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_ALL_EVENTS))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_EVENT_FORMATS);
 	if (!sec)
 		return -1;
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_EVENT_FORMATS,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", TRACECMD_SEC_FL_COMPRESS, true);
 
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 
 	if (read_copy_size4(in_handle, out_handle, &systems) < 0)
 		goto error;
@@ -5433,7 +5433,7 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 		system = read_string(in_handle);
 		if (!system)
 			goto error;
-		if (do_write_check(out_handle, system, strlen(system) + 1)) {
+		if (tracecmd_do_write_check(out_handle, system, strlen(system) + 1)) {
 			free(system);
 			goto error;
 		}
@@ -5452,41 +5452,41 @@ static int copy_event_files(struct tracecmd_input *in_handle, struct tracecmd_ou
 	}
 
 	in_handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned int size;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_KALLSYMS) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_KALLSYMS))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_KALLSYMS))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_KALLSYMS);
 	if (!sec)
 		return -1;
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_KALLSYMS,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_KALLSYMS,
 					  "kallsyms", TRACECMD_SEC_FL_COMPRESS, true);
 
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		goto error;
 
@@ -5497,42 +5497,42 @@ static int copy_proc_kallsyms(struct tracecmd_input *in_handle, struct tracecmd_
 		goto error;
 out:
 	in_handle->file_state = TRACECMD_FILE_KALLSYMS;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned int size;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_PRINTK) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_PRINTK))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_PRINTK))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_PRINTK);
 	if (!sec)
 		return -1;
 
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_PRINTK,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_PRINTK,
 					  "printk", TRACECMD_SEC_FL_COMPRESS, true);
 
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 
 	if (read_copy_size4(in_handle, out_handle, &size) < 0)
 		goto error;
@@ -5545,41 +5545,41 @@ static int copy_ftrace_printk(struct tracecmd_input *in_handle, struct tracecmd_
 
 out:
 	in_handle->file_state = TRACECMD_FILE_PRINTK;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
 
 static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
 {
-	bool compress = out_check_compression(out_handle);
+	bool compress = tracecmd_out_check_compression(out_handle);
 	struct file_section *sec;
 	unsigned long long offset;
 	unsigned long long size;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_CMD_LINES) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_CMD_LINES))
 		return -1;
 
 	sec = section_open(in_handle, TRACECMD_OPTION_CMDLINES);
 	if (!sec)
 		return -1;
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_CMDLINES,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_CMDLINES,
 					  "command lines", TRACECMD_SEC_FL_COMPRESS, true);
 
-	out_compression_start(out_handle, compress);
+	tracecmd_out_compression_start(out_handle, compress);
 
 	if (read_copy_size8(in_handle, out_handle, &size) < 0)
 		goto error;
@@ -5592,19 +5592,19 @@ static int copy_command_lines(struct tracecmd_input *in_handle, struct tracecmd_
 
 out:
 	in_handle->file_state = TRACECMD_FILE_CMD_LINES;
-	if (out_compression_end(out_handle, compress))
+	if (tracecmd_out_compression_end(out_handle, compress))
 		goto error;
 
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	section_close(in_handle, sec);
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		goto error;
 
 	return 0;
 error:
-	out_compression_reset(out_handle, compress);
+	tracecmd_out_compression_reset(out_handle, compress);
 	section_close(in_handle, sec);
 	return -1;
 }
@@ -5614,7 +5614,7 @@ static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_outp
 	unsigned int cpus;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_COUNT) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_CPU_COUNT))
 		return -1;
 
 	if (!HAS_SECTIONS(in_handle)) {
@@ -5626,14 +5626,14 @@ static int copy_cpu_count(struct tracecmd_input *in_handle, struct tracecmd_outp
 
 	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
 		cpus = tep_read_number(in_handle->pevent, &cpus, 4);
-		if (do_write_check(out_handle, &cpus, 4))
+		if (tracecmd_do_write_check(out_handle, &cpus, 4))
 			return -1;
 	} else {
 		tracecmd_add_option(out_handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
 	}
 
 	in_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 
 	return 0;
 }
@@ -5813,7 +5813,7 @@ static int copy_options_recursive(struct tracecmd_input *in_handle,
 			if (id != TRACECMD_OPTION_DONE)
 				return -1;
 
-			if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+			if (flags & TRACECMD_SEC_FL_COMPRESS && tracecmd_in_uncompress_block(in_handle))
 				return -1;
 
 			return copy_options_recursive(in_handle, out_handle);
@@ -5838,10 +5838,10 @@ static int copy_options_recursive(struct tracecmd_input *in_handle,
 			do_lseek(in_handle, en4, SEEK_CUR);
 			continue;
 		}
-		if (do_write_check(out_handle, &option, 2))
+		if (tracecmd_do_write_check(out_handle, &option, 2))
 			return -1;
 
-		if (do_write_check(out_handle, &size, 4))
+		if (tracecmd_do_write_check(out_handle, &size, 4))
 			return -1;
 
 		if (read_copy_data(in_handle, en4, out_handle))
@@ -5864,48 +5864,48 @@ static int copy_options(struct tracecmd_input *in_handle, struct tracecmd_output
 		if (id != TRACECMD_OPTION_DONE)
 			return -1;
 
-		if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+		if (flags & TRACECMD_SEC_FL_COMPRESS && tracecmd_in_uncompress_block(in_handle))
 			return -1;
 	}
 	start = tracecmd_get_out_file_offset(out_handle);
 	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
-		if (do_write_check(out_handle, "options  ", 10))
+		if (tracecmd_do_write_check(out_handle, "options  ", 10))
 			return -1;
 	}
 
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_DONE, "options", 0, false);
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_DONE, "options", 0, false);
 
 	if (copy_options_recursive(in_handle, out_handle))
 		goto error;
 
 	id = TRACECMD_OPTION_DONE;
 	en2 = tep_read_number(in_handle->pevent, &id, 2);
-	if (do_write_check(out_handle, &en2, 2))
+	if (tracecmd_do_write_check(out_handle, &en2, 2))
 		goto error;
 
 	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
-		out_save_options_offset(out_handle, start);
+		tracecmd_out_save_options_offset(out_handle, start);
 	} else {
 		tmp = 8;
-		if (do_write_check(out_handle, &tmp, 4))
+		if (tracecmd_do_write_check(out_handle, &tmp, 4))
 			goto error;
 
-		out_save_options_offset(out_handle, start);
+		tracecmd_out_save_options_offset(out_handle, start);
 		start = 0;
-		if (do_write_check(out_handle, &start, 8))
+		if (tracecmd_do_write_check(out_handle, &start, 8))
 			goto error;
 	}
-	out_update_section_header(out_handle, offset);
+	tracecmd_out_update_section_header(out_handle, offset);
 	if (flags & TRACECMD_SEC_FL_COMPRESS)
-		in_uncompress_reset(in_handle);
+		tracecmd_in_uncompress_reset(in_handle);
 	in_handle->file_state = TRACECMD_FILE_OPTIONS;
-	out_set_file_state(out_handle, in_handle->file_state);
+	tracecmd_out_set_file_state(out_handle, in_handle->file_state);
 	/* Append local options */
 	return tracecmd_append_options(out_handle);
 
 error:
 	if (flags & TRACECMD_SEC_FL_COMPRESS)
-		in_uncompress_reset(in_handle);
+		tracecmd_in_uncompress_reset(in_handle);
 	return 0;
 }
 
@@ -5913,7 +5913,7 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle)
 {
 	if (!check_in_state(in_handle, TRACECMD_FILE_OPTIONS) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_OPTIONS))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_OPTIONS))
 		return -1;
 
 	if (!in_handle->options_start)
@@ -5937,17 +5937,17 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	int fd;
 
 	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS &&
-	    do_write_check(out_handle, "latency  ", 10))
+	    tracecmd_do_write_check(out_handle, "latency  ", 10))
 		return -1;
 
 	offset = tracecmd_get_out_file_offset(out_handle);
 
 	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
-	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
+	    !tracecmd_out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
 				   offset, 0, NULL, page_size))
 		return -1;
 
-	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
+	offset = tracecmd_out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
 					  "buffer latency", TRACECMD_SEC_FL_COMPRESS, false);
 
 	if (in_handle->latz.fd >= 0)
@@ -5955,13 +5955,13 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	else
 		fd = in_handle->fd;
 
-	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
+	if (!tracecmd_out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
 		return -1;
 
-	if (out_update_section_header(out_handle, offset))
+	if (tracecmd_out_update_section_header(out_handle, offset))
 		return -1;
 
-	out_set_file_state(out_handle, TRACECMD_FILE_CPU_LATENCY);
+	tracecmd_out_set_file_state(out_handle, TRACECMD_FILE_CPU_LATENCY);
 	return 0;
 }
 
@@ -5996,7 +5996,7 @@ static int copy_trace_flyrecord_data(struct tracecmd_input *in_handle,
 		}
 	}
 	if (total_size || tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
-		ret = out_write_cpu_data(out_handle, cpus, data, buff_name);
+		ret = tracecmd_out_write_cpu_data(out_handle, cpus, data, buff_name);
 	else
 		ret = 0;
 	free(data);
@@ -6083,7 +6083,7 @@ static int copy_trace_data_from_v7(struct tracecmd_input *in_handle,
 		ret = copy_trace_flyrecord_data(in_handle, out_handle,
 						in_handle->top_buffer.name);
 	else if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS)
-		ret = out_write_emty_cpu_data(out_handle, in_handle->max_cpu);
+		ret = tracecmd_out_write_emty_cpu_data(out_handle, in_handle->max_cpu);
 	if (ret)
 		return ret;
 
@@ -6099,7 +6099,7 @@ __hidden int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
 	int ret;
 
 	if (!check_in_state(in_handle, TRACECMD_FILE_CPU_FLYRECORD) ||
-	    !check_out_state(out_handle, TRACECMD_FILE_CPU_FLYRECORD))
+	    !tracecmd_check_out_state(out_handle, TRACECMD_FILE_CPU_FLYRECORD))
 		return -1;
 
 	if (in_handle->file_version < FILE_VERSION_SECTIONS)
diff --git a/lib/trace-cmd/trace-maps.c b/lib/trace-cmd/trace-maps.c
index bd16486f..31689364 100644
--- a/lib/trace-cmd/trace-maps.c
+++ b/lib/trace-cmd/trace-maps.c
@@ -74,8 +74,8 @@ int tracecmd_map_vcpus(struct tracecmd_input **handles, int nr_handles)
 			gmap[k].self = &gmap[k];
 		}
 
-		trace_set_guest_map(handles[i], gmap);
-		trace_set_guest_map_cnt(handles[i], vcpu_count);
+		tracecmd_set_guest_map(handles[i], gmap);
+		tracecmd_set_guest_map_cnt(handles[i], vcpu_count);
 
 		/* Update the host mapping of all guests to the host */
 		map = realloc(vcpu_maps, sizeof(*map) * (nr_vcpu_maps + vcpu_count));
@@ -96,8 +96,8 @@ int tracecmd_map_vcpus(struct tracecmd_input **handles, int nr_handles)
 	/* We want to do a binary search via host_pid to find these mappings */
 	qsort(vcpu_maps, nr_vcpu_maps, sizeof(*map), cmp_map);
 
-	trace_set_guest_map(handles[0], vcpu_maps);
-	trace_set_guest_map_cnt(handles[0], nr_vcpu_maps);
+	tracecmd_set_guest_map(handles[0], vcpu_maps);
+	tracecmd_set_guest_map_cnt(handles[0], nr_vcpu_maps);
 
 	return mappings;
 
@@ -106,7 +106,7 @@ int tracecmd_map_vcpus(struct tracecmd_input **handles, int nr_handles)
 	return -1;
 }
 
-__hidden void trace_guest_map_free(struct tracecmd_cpu_map *map)
+__hidden void tracecmd_guest_map_free(struct tracecmd_cpu_map *map)
 {
 	free(map);
 }
@@ -118,7 +118,7 @@ struct tracecmd_cpu_map *tracecmd_map_find_by_host_pid(struct tracecmd_input *ha
 	struct tracecmd_cpu_map key;
 	int nr_maps;
 
-	map = trace_get_guest_map(handle);
+	map = tracecmd_get_guest_map(handle);
 	if (!map)
 		return NULL;
 
@@ -126,11 +126,11 @@ struct tracecmd_cpu_map *tracecmd_map_find_by_host_pid(struct tracecmd_input *ha
 	handle = map->host_handle;
 
 	/* And again, get the mapping of the host, as it has all the mappings */
-	map = trace_get_guest_map(handle);
+	map = tracecmd_get_guest_map(handle);
 	if (!map)
 		return NULL;
 
-	nr_maps = trace_get_guest_map_cnt(handle);
+	nr_maps = tracecmd_get_guest_map_cnt(handle);
 
 	key.host_pid = host_pid;
 
@@ -168,10 +168,10 @@ struct tracecmd_cpu_map *tracecmd_get_cpu_map(struct tracecmd_input *handle, int
 	struct tracecmd_cpu_map *map;
 	int cnt;
 
-	map = trace_get_guest_map(handle);
+	map = tracecmd_get_guest_map(handle);
 	/* Make sure it's for the guest handle, as this could be a host handle */
 	map = map->self;
-	cnt = trace_get_guest_map_cnt(map->guest_handle);
+	cnt = tracecmd_get_guest_map_cnt(map->guest_handle);
 	if (cnt <= cpu)
 		return NULL;
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index f5c604f1..ac409591 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -183,7 +183,7 @@ static int __msg_write(int fd, struct tracecmd_msg *msg, bool network)
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
-__hidden off_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence)
+__hidden off_t tracecmd_msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence)
 {
 	off_t cache_offset = msg_handle->cache_start_offset;
 	off_t ret;
@@ -855,7 +855,7 @@ int tracecmd_msg_send_options(struct tracecmd_msg_handle *msg_handle,
 	void *buf;
 	int ret;
 
-	buf = trace_get_options(handle, &len);
+	buf = tracecmd_get_options(handle, &len);
 	if (!buf)
 		return -1;
 
@@ -963,7 +963,7 @@ int tracecmd_msg_read_options(struct tracecmd_msg_handle *msg_handle,
 	}
 	msg_free(&msg);
 
-	ret = trace_append_options(handle, buf, len);
+	ret = tracecmd_append_options_to_file(handle, buf, len);
 	free(buf);
 
 	return ret;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 66e11ddc..de265149 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -100,7 +100,7 @@ static int write_options(struct tracecmd_output *handle);
 static int save_string_section(struct tracecmd_output *handle, bool compress);
 
 __hidden long long
-do_write_check(struct tracecmd_output *handle, const void *data, long long size)
+tracecmd_do_write_check(struct tracecmd_output *handle, const void *data, long long size)
 {
 	if (handle->do_compress)
 		return tracecmd_compress_buffer_write(handle->compress, data, size);
@@ -117,7 +117,7 @@ static inline off_t do_lseek(struct tracecmd_output *handle, off_t offset, int w
 		return tracecmd_compress_lseek(handle->compress, offset, whence);
 
 	if (handle->msg_handle)
-		return msg_lseek(handle->msg_handle, offset, whence);
+		return tracecmd_msg_lseek(handle->msg_handle, offset, whence);
 
 	return lseek(handle->fd, offset, whence);
 }
@@ -155,7 +155,7 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
-__hidden void out_compression_reset(struct tracecmd_output *handle, bool compress)
+__hidden void tracecmd_out_compression_reset(struct tracecmd_output *handle, bool compress)
 {
 	if (!compress || !handle->compress)
 		return;
@@ -164,7 +164,7 @@ __hidden void out_compression_reset(struct tracecmd_output *handle, bool compres
 	handle->do_compress = false;
 }
 
-__hidden int out_uncompress_block(struct tracecmd_output *handle)
+__hidden int tracecmd_out_uncompress_block(struct tracecmd_output *handle)
 {
 	int ret = 0;
 
@@ -178,7 +178,7 @@ __hidden int out_uncompress_block(struct tracecmd_output *handle)
 	return ret;
 }
 
-__hidden int out_compression_start(struct tracecmd_output *handle, bool compress)
+__hidden int tracecmd_out_compression_start(struct tracecmd_output *handle, bool compress)
 {
 	if (!compress || !handle->compress)
 		return 0;
@@ -189,7 +189,7 @@ __hidden int out_compression_start(struct tracecmd_output *handle, bool compress
 	return 0;
 }
 
-__hidden int out_compression_end(struct tracecmd_output *handle, bool compress)
+__hidden int tracecmd_out_compression_end(struct tracecmd_output *handle, bool compress)
 {
 	if (!compress || !handle->compress)
 		return 0;
@@ -355,7 +355,7 @@ static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned lon
 		r = read(fd, buf, rsize);
 		if (r > 0) {
 			size += r;
-			if (do_write_check(handle, buf, r))
+			if (tracecmd_do_write_check(handle, buf, r))
 				return 0;
 			if (max) {
 				max -= r;
@@ -386,7 +386,7 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 }
 
 #define PAGES_IN_CHUNK 10
-__hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+__hidden unsigned long long tracecmd_out_copy_fd_compress(struct tracecmd_output *handle,
 						 int fd, unsigned long long max,
 						 unsigned long long *write_size,
 						 int page)
@@ -428,7 +428,7 @@ static tsize_t copy_file_compress(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	ret = out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
+	ret = tracecmd_out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
 	if (!ret)
 		tracecmd_warning("Can't compress '%s'", file);
 
@@ -500,7 +500,7 @@ int tracecmd_ftrace_enable(int set)
 }
 
 __hidden unsigned long long
-out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+tracecmd_out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
 			 char *description, int flags, bool option)
 {
 	tsize_t endian8;
@@ -524,12 +524,12 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 	}
 	/* Section ID */
 	endian2 = convert_endian_2(handle, header_id);
-	if (do_write_check(handle, &endian2, 2))
+	if (tracecmd_do_write_check(handle, &endian2, 2))
 		return (off_t)-1;
 
 	/* Section flags */
 	endian2 = convert_endian_2(handle, flags);
-	if (do_write_check(handle, &endian2, 2))
+	if (tracecmd_do_write_check(handle, &endian2, 2))
 		return (off_t)-1;
 
 	/* Section description */
@@ -538,18 +538,18 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 	else
 		desc = -1;
 	endian4 = convert_endian_4(handle, desc);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		return (off_t)-1;
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	size = 0;
 	/* Reserve for section size */
-	if (do_write_check(handle, &size, 8))
+	if (tracecmd_do_write_check(handle, &size, 8))
 		return (off_t)-1;
 	return offset;
 }
 
-__hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t offset)
+__hidden int tracecmd_out_update_section_header(struct tracecmd_output *handle, tsize_t offset)
 {
 	tsize_t current;
 	tsize_t endian8;
@@ -570,7 +570,7 @@ __hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t o
 		return -1;
 
 	endian8 = convert_endian_8(handle, size);
-	if (do_write_check(handle, &endian8, 8))
+	if (tracecmd_do_write_check(handle, &endian8, 8))
 		return -1;
 	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
 		return -1;
@@ -585,7 +585,7 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 	if (!handle->strings || !handle->strings_p)
 		return 0;
 
-	if (!check_out_state(handle, TRACECMD_OPTION_STRINGS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_OPTION_STRINGS)) {
 		tracecmd_warning("Cannot write strings, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -593,19 +593,19 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_STRINGS, "strings", flags, false);
 	if (offset == (off_t)-1)
 		return -1;
 
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 
-	if (do_write_check(handle, handle->strings, handle->strings_p))
+	if (tracecmd_do_write_check(handle, handle->strings, handle->strings_p))
 		goto error;
 
-	if (out_compression_end(handle, compress))
+	if (tracecmd_out_compression_end(handle, compress))
 		goto error;
 
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		return -1;
 
 	handle->strings_offs += handle->strings_p;
@@ -616,7 +616,7 @@ static int save_string_section(struct tracecmd_output *handle, bool compress)
 	return 0;
 
 error:
-	out_compression_reset(handle, compress);
+	tracecmd_out_compression_reset(handle, compress);
 	return -1;
 }
 
@@ -630,7 +630,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	int fd = -1;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_HEADERS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_HEADERS)) {
 		tracecmd_warning("Cannot read header files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -642,30 +642,30 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
 					  "headers", flags, true);
 	if (offset == (off_t)-1) {
 		put_tracing_file(path);
 		return -1;
 	}
 
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* old style did not show this info, just add zero */
 		put_tracing_file(path);
-		if (do_write_check(handle, "header_page", 12))
+		if (tracecmd_do_write_check(handle, "header_page", 12))
 			goto out_close;
 		size = 0;
-		if (do_write_check(handle, &size, 8))
+		if (tracecmd_do_write_check(handle, &size, 8))
 			goto out_close;
-		if (do_write_check(handle, "header_event", 13))
+		if (tracecmd_do_write_check(handle, "header_event", 13))
 			goto out_close;
-		if (do_write_check(handle, &size, 8))
+		if (tracecmd_do_write_check(handle, &size, 8))
 			goto out_close;
-		if (out_compression_end(handle, compress))
+		if (tracecmd_out_compression_end(handle, compress))
 			goto out_close;
-		if (out_update_section_header(handle, offset))
+		if (tracecmd_out_update_section_header(handle, offset))
 			goto out_close;
 		return 0;
 	}
@@ -679,10 +679,10 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	/* unfortunately, you can not stat debugfs files for size */
 	size = get_size_fd(fd);
 
-	if (do_write_check(handle, "header_page", 12))
+	if (tracecmd_do_write_check(handle, "header_page", 12))
 		goto out_free;
 	endian8 = convert_endian_8(handle, size);
-	if (do_write_check(handle, &endian8, 8))
+	if (tracecmd_do_write_check(handle, &endian8, 8))
 		goto out_free;
 	check_size = copy_file_fd(handle, fd, 0);
 	if (size != check_size) {
@@ -705,10 +705,10 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 
 	size = get_size_fd(fd);
 
-	if (do_write_check(handle, "header_event", 13))
+	if (tracecmd_do_write_check(handle, "header_event", 13))
 		goto out_free;
 	endian8 = convert_endian_8(handle, size);
-	if (do_write_check(handle, &endian8, 8))
+	if (tracecmd_do_write_check(handle, &endian8, 8))
 		goto out_free;
 	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
@@ -717,10 +717,10 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 		goto out_free;
 	}
 	put_tracing_file(path);
-	if (out_compression_end(handle, compress))
+	if (tracecmd_out_compression_end(handle, compress))
 		goto out_close;
 
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		goto out_close;
 	handle->file_state = TRACECMD_FILE_HEADERS;
 
@@ -729,7 +729,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
  out_free:
 	put_tracing_file(path);
  out_close:
-	out_compression_reset(handle, compress);
+	tracecmd_out_compression_reset(handle, compress);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -750,7 +750,7 @@ static int copy_event_system(struct tracecmd_output *handle,
 		count++;
 
 	endian4 = convert_endian_4(handle, count);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		return -1;
 
 	for (elist = slist->events; elist; elist = elist->next) {
@@ -761,7 +761,7 @@ static int copy_event_system(struct tracecmd_output *handle,
 			/* unfortunately, you can not stat debugfs files for size */
 			size = get_size(format);
 			endian8 = convert_endian_8(handle, size);
-			if (do_write_check(handle, &endian8, 8))
+			if (tracecmd_do_write_check(handle, &endian8, 8))
 				return -1;
 			check_size = copy_file(handle, format);
 			if (size != check_size) {
@@ -968,7 +968,7 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 	tsize_t offset;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS)) {
 		tracecmd_warning("Cannot read ftrace files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -976,24 +976,24 @@ static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_FTRACE_EVENTS,
 					  "ftrace events", flags, true);
 	if (offset == (off_t)-1)
 		return -1;
 
 	create_event_list_item(handle, &systems, &list);
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 
 	ret = copy_event_system(handle, systems);
 	if (!ret)
-		ret = out_compression_end(handle, compress);
+		ret = tracecmd_out_compression_end(handle, compress);
 	else
-		out_compression_reset(handle, compress);
+		tracecmd_out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 	if (ret)
 		return ret;
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
@@ -1027,7 +1027,7 @@ static int read_event_files(struct tracecmd_output *handle,
 	int endian4;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_ALL_EVENTS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_ALL_EVENTS)) {
 		tracecmd_warning("Cannot read event files, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1035,7 +1035,7 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_EVENT_FORMATS,
 					  "events format", flags, true);
 	if (offset == (off_t)-1)
 		return -1;
@@ -1055,15 +1055,15 @@ static int read_event_files(struct tracecmd_output *handle,
 
 	for (slist = systems; slist; slist = slist->next)
 		count++;
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 	ret = -1;
 	endian4 = convert_endian_4(handle, count);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		goto out_free;
 
 	ret = 0;
 	for (slist = systems; !ret && slist; slist = slist->next) {
-		if (do_write_check(handle, slist->name,
+		if (tracecmd_do_write_check(handle, slist->name,
 				   strlen(slist->name) + 1)) {
 			ret = -1;
 			continue;
@@ -1073,16 +1073,16 @@ static int read_event_files(struct tracecmd_output *handle,
 	if (ret)
 		goto out_free;
 
-	ret = out_compression_end(handle, compress);
+	ret = tracecmd_out_compression_end(handle, compress);
 	if (ret)
 		goto out_free;
-	ret = out_update_section_header(handle, offset);
+	ret = tracecmd_out_update_section_header(handle, offset);
 
  out_free:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_ALL_EVENTS;
 	else
-		out_compression_reset(handle, compress);
+		tracecmd_out_compression_reset(handle, compress);
 
 	free_list_events(systems);
 
@@ -1138,7 +1138,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	struct stat st;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_KALLSYMS)) {
 		tracecmd_warning("Cannot read kallsyms, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1149,23 +1149,23 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_KALLSYMS,
 					  "kallsyms", flags, true);
 	if (offset == (off_t)-1)
 		return -1;
 
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
 		endian4 = convert_endian_4(handle, size);
-		ret = do_write_check(handle, &endian4, 4);
+		ret = tracecmd_do_write_check(handle, &endian4, 4);
 		goto out;
 	}
 	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
-	ret = do_write_check(handle, &endian4, 4);
+	ret = tracecmd_do_write_check(handle, &endian4, 4);
 	if (ret)
 		goto out;
 
@@ -1180,16 +1180,16 @@ static int read_proc_kallsyms(struct tracecmd_output *handle, bool compress)
 	}
 	set_proc_kptr_restrict(1);
 
-	ret = out_compression_end(handle, compress);
+	ret = tracecmd_out_compression_end(handle, compress);
 	if (ret)
 		goto out;
 
-	ret = out_update_section_header(handle, offset);
+	ret = tracecmd_out_update_section_header(handle, offset);
 out:
 	if (!ret)
 		handle->file_state = TRACECMD_FILE_KALLSYMS;
 	else
-		out_compression_reset(handle, compress);
+		tracecmd_out_compression_reset(handle, compress);
 	return ret;
 }
 
@@ -1202,7 +1202,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	char *path;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_PRINTK)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_PRINTK)) {
 		tracecmd_warning("Cannot read printk, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1214,25 +1214,25 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
 	if (offset == (off_t)-1) {
 		put_tracing_file(path);
 		return -1;
 	}
 
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 	ret = stat(path, &st);
 	if (ret < 0) {
 		/* not found */
 		size = 0;
 		endian4 = convert_endian_4(handle, size);
-		if (do_write_check(handle, &endian4, 4))
+		if (tracecmd_do_write_check(handle, &endian4, 4))
 			goto fail;
 		goto out;
 	}
 	size = get_size(path);
 	endian4 = convert_endian_4(handle, size);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		goto fail;
 	check_size = copy_file(handle, path);
 	if (size != check_size) {
@@ -1243,16 +1243,16 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 
  out:
 	put_tracing_file(path);
-	if (out_compression_end(handle, compress))
+	if (tracecmd_out_compression_end(handle, compress))
 		return -1;
 
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		return -1;
 	handle->file_state = TRACECMD_FILE_PRINTK;
 	return 0;
  fail:
 	put_tracing_file(path);
-	out_compression_reset(handle, compress);
+	tracecmd_out_compression_reset(handle, compress);
 	return -1;
 }
 
@@ -1274,7 +1274,7 @@ static int save_tracing_file_data(struct tracecmd_output *handle,
 	if (ret >= 0) {
 		size = get_size(file);
 		endian8 = convert_endian_8(handle, size);
-		if (do_write_check(handle, &endian8, 8))
+		if (tracecmd_do_write_check(handle, &endian8, 8))
 			goto out_free;
 		check_size = copy_file(handle, file);
 		if (size != check_size) {
@@ -1285,7 +1285,7 @@ static int save_tracing_file_data(struct tracecmd_output *handle,
 	} else {
 		size = 0;
 		endian8 = convert_endian_8(handle, size);
-		if (do_write_check(handle, &endian8, 8))
+		if (tracecmd_do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
 	ret = 0;
@@ -1307,10 +1307,10 @@ static int write_compression_header(struct tracecmd_output *handle)
 		ver = "";
 	}
 
-	if (do_write_check(handle, name, strlen(name) + 1))
+	if (tracecmd_do_write_check(handle, name, strlen(name) + 1))
 		return -1;
 
-	if (do_write_check(handle, ver, strlen(ver) + 1))
+	if (tracecmd_do_write_check(handle, ver, strlen(ver) + 1))
 		return -1;
 
 	return 0;
@@ -1622,27 +1622,27 @@ static int output_write_init(struct tracecmd_output *handle)
 	buf[2] = 68;
 	memcpy(buf + 3, "tracing", 7);
 
-	if (do_write_check(handle, buf, 10))
+	if (tracecmd_do_write_check(handle, buf, 10))
 		return -1;
 
 	sprintf(buf, "%lu", handle->file_version);
-	if (do_write_check(handle, buf, strlen(buf) + 1))
+	if (tracecmd_do_write_check(handle, buf, strlen(buf) + 1))
 		return -1;
 
 	if (handle->big_endian)
 		buf[0] = 1;
 	else
 		buf[0] = 0;
-	if (do_write_check(handle, buf, 1))
+	if (tracecmd_do_write_check(handle, buf, 1))
 		return -1;
 
 	/* save size of long (this may not be what the kernel is) */
 	buf[0] = sizeof(long);
-	if (do_write_check(handle, buf, 1))
+	if (tracecmd_do_write_check(handle, buf, 1))
 		return -1;
 
 	endian4 = convert_endian_4(handle, handle->page_size);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		return -1;
 
 	if (handle->file_version >= FILE_VERSION_COMPRESSION) {
@@ -1654,7 +1654,7 @@ static int output_write_init(struct tracecmd_output *handle)
 		/* Write 0 as options offset and save its location */
 		offset = 0;
 		handle->options_start = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, &offset, 8))
+		if (tracecmd_do_write_check(handle, &offset, 8))
 			return -1;
 	}
 
@@ -1793,7 +1793,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 {
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_CPU_COUNT)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_CPU_COUNT)) {
 		tracecmd_warning("Cannot write CPU count into the file, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -1801,7 +1801,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 
 	if (!HAS_SECTIONS(handle)) {
 		cpus = convert_endian_4(handle, cpus);
-		ret = do_write_check(handle, &cpus, 4);
+		ret = tracecmd_do_write_check(handle, &cpus, 4);
 		if (ret < 0)
 			return ret;
 	} else {
@@ -1822,35 +1822,35 @@ static int write_options_v6(struct tracecmd_output *handle)
 	/* If already written, ignore */
 	if (handle->file_state == TRACECMD_FILE_OPTIONS)
 		return 0;
-	if (!check_out_state(handle, TRACECMD_FILE_OPTIONS)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_OPTIONS)) {
 		tracecmd_warning("Cannot write options into the file, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
 	}
 
-	if (do_write_check(handle, "options  ", 10))
+	if (tracecmd_do_write_check(handle, "options  ", 10))
 		return -1;
 	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
-		if (do_write_check(handle, &endian2, 2))
+		if (tracecmd_do_write_check(handle, &endian2, 2))
 			return -1;
 
 		endian4 = convert_endian_4(handle, options->size);
-		if (do_write_check(handle, &endian4, 4))
+		if (tracecmd_do_write_check(handle, &endian4, 4))
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
 		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
-		if (do_write_check(handle, options->data,
+		if (tracecmd_do_write_check(handle, options->data,
 				   options->size))
 			return -1;
 	}
 
 	option = TRACECMD_OPTION_DONE;
 
-	if (do_write_check(handle, &option, 2))
+	if (tracecmd_do_write_check(handle, &option, 2))
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_OPTIONS;
@@ -1862,7 +1862,7 @@ static int update_options_start(struct tracecmd_output *handle, off_t offset)
 	if (do_lseek(handle, handle->options_start, SEEK_SET) == (off_t)-1)
 		return -1;
 	offset = convert_endian_8(handle, offset);
-	if (do_write_check(handle, &offset, 8))
+	if (tracecmd_do_write_check(handle, &offset, 8))
 		return -1;
 	return 0;
 }
@@ -1946,7 +1946,7 @@ static tsize_t write_options_start(struct tracecmd_output *handle)
 			return -1;
 	}
 
-	return out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
+	return tracecmd_out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
 }
 
 static tsize_t write_options_end(struct tracecmd_output *handle, tsize_t offset)
@@ -1956,16 +1956,16 @@ static tsize_t write_options_end(struct tracecmd_output *handle, tsize_t offset)
 	unsigned int endian4;
 
 	endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
-	if (do_write_check(handle, &endian2, 2))
+	if (tracecmd_do_write_check(handle, &endian2, 2))
 		return -1;
 	endian4 = convert_endian_4(handle, 8);
-	if (do_write_check(handle, &endian4, 4))
+	if (tracecmd_do_write_check(handle, &endian4, 4))
 		return -1;
 	endian8 = 0;
 	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, &endian8, 8))
+	if (tracecmd_do_write_check(handle, &endian8, 8))
 		return -1;
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		return -1;
 
 	return 0;
@@ -2003,14 +2003,14 @@ static int write_options(struct tracecmd_output *handle)
 		if (options->offset)
 			continue;
 		endian2 = convert_endian_2(handle, options->id);
-		if (do_write_check(handle, &endian2, 2))
+		if (tracecmd_do_write_check(handle, &endian2, 2))
 			return -1;
 		endian4 = convert_endian_4(handle, options->size);
-		if (do_write_check(handle, &endian4, 4))
+		if (tracecmd_do_write_check(handle, &endian4, 4))
 			return -1;
 		/* Save the data location */
 		options->offset = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, options->data, options->size))
+		if (tracecmd_do_write_check(handle, options->data, options->size))
 			return -1;
 	}
 
@@ -2018,7 +2018,7 @@ static int write_options(struct tracecmd_output *handle)
 }
 
 /**
- * trace_get_options - Get the current options from the output file handle
+ * tracecmd_get_options - Get the current options from the output file handle
  * @handle: The output file descriptor that has options.
  * @len: Returns the length of the buffer allocated and returned.
  *
@@ -2033,7 +2033,7 @@ static int write_options(struct tracecmd_output *handle)
  *   the options to send, with @len set to the size of the content.
  *   NULL on error (and @len is undefined).
  */
-__hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
+__hidden void *tracecmd_get_options(struct tracecmd_output *handle, size_t *len)
 {
 	struct tracecmd_msg_handle msg_handle;
 	struct tracecmd_output out_handle;
@@ -2058,14 +2058,14 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
 		if (options->offset)
 			continue;
 		endian2 = convert_endian_2(handle, options->id);
-		if (do_write_check(&out_handle, &endian2, 2))
+		if (tracecmd_do_write_check(&out_handle, &endian2, 2))
 			goto out;
 		endian4 = convert_endian_4(handle, options->size);
-		if (do_write_check(&out_handle, &endian4, 4))
+		if (tracecmd_do_write_check(&out_handle, &endian4, 4))
 			goto out;
 		/* The option can not be referenced again */
 		options->offset = -1;
-		if (do_write_check(&out_handle, options->data, options->size))
+		if (tracecmd_do_write_check(&out_handle, options->data, options->size))
 			goto out;
 	}
 
@@ -2088,7 +2088,7 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
 }
 
 /**
- * trace_append_options - Append options to the file
+ * tracecmd_append_options_to_file - Append options to the file
  * @handle: The output file descriptor that has options.
  * @buf: The options to append.
  * @len: The length of @buf.
@@ -2099,8 +2099,9 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
  *
  * Returns 0 on success and -1 on error.
  */
-__hidden int trace_append_options(struct tracecmd_output *handle, void *buf,
-				  size_t len)
+__hidden int
+tracecmd_append_options_to_file(struct tracecmd_output *handle, void *buf,
+				size_t len)
 {
 	tsize_t offset;
 
@@ -2108,7 +2109,7 @@ __hidden int trace_append_options(struct tracecmd_output *handle, void *buf,
 	if (offset == (off_t)-1)
 		return -1;
 
-	if (do_write_check(handle, buf, len))
+	if (tracecmd_do_write_check(handle, buf, len))
 		return -1;
 
 	return write_options_end(handle, offset);
@@ -2157,24 +2158,24 @@ static int append_options_v6(struct tracecmd_output *handle)
 
 	list_for_each_entry(options, &handle->options, list) {
 		endian2 = convert_endian_2(handle, options->id);
-		if (do_write_check(handle, &endian2, 2))
+		if (tracecmd_do_write_check(handle, &endian2, 2))
 			return -1;
 
 		endian4 = convert_endian_4(handle, options->size);
-		if (do_write_check(handle, &endian4, 4))
+		if (tracecmd_do_write_check(handle, &endian4, 4))
 			return -1;
 
 		/* Save the data location in case it needs to be updated */
 		options->offset = do_lseek(handle, 0, SEEK_CUR);
 
-		if (do_write_check(handle, options->data,
+		if (tracecmd_do_write_check(handle, options->data,
 				   options->size))
 			return -1;
 	}
 
 	option = TRACECMD_OPTION_DONE;
 
-	if (do_write_check(handle, &option, 2))
+	if (tracecmd_do_write_check(handle, &option, 2))
 		return -1;
 
 	return 0;
@@ -2272,7 +2273,7 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	tsize_t offset;
 	int ret;
 
-	if (!check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_CMD_LINES)) {
 		tracecmd_warning("Cannot write command lines into the file, unexpected state 0x%X",
 				 handle->file_state);
 		return -1;
@@ -2283,23 +2284,23 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_CMDLINES,
 					  "command lines", flags, true);
 	if (offset == (off_t)-1)
 		return -1;
 
-	out_compression_start(handle, compress);
+	tracecmd_out_compression_start(handle, compress);
 
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
 	if (ret < 0) {
-		out_compression_reset(handle, compress);
+		tracecmd_out_compression_reset(handle, compress);
 		return ret;
 	}
 
-	if (out_compression_end(handle, compress))
+	if (tracecmd_out_compression_end(handle, compress))
 		return -1;
 
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		return -1;
 
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
@@ -2331,7 +2332,7 @@ static char *get_clock(struct tracecmd_output *handle)
 }
 
 __hidden struct tracecmd_option *
-out_add_buffer_option(struct tracecmd_output *handle, const char *name,
+tracecmd_out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		      unsigned short id, unsigned long long data_offset,
 		      int cpus, struct data_file_write *cpu_data, int page_size)
 {
@@ -2453,13 +2454,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
-	if (!check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
+	if (!tracecmd_check_out_state(handle, TRACECMD_FILE_CPU_LATENCY)) {
 		tracecmd_warning("Cannot write latency data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
 	}
 
-	if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
+	if (!HAS_SECTIONS(handle) && tracecmd_do_write_check(handle, "latency  ", 10))
 		goto out_free;
 
 	path = get_tracing_file(handle, "trace");
@@ -2468,17 +2469,17 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
+	    !tracecmd_out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
 				   offset, 0, NULL, getpagesize()))
 		goto out_free;
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
 
-	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
 					  "buffer latency", flags, false);
 
 	copy_file_compress(handle, path, NULL);
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		goto out_free;
 
 	put_tracing_file(path);
@@ -2506,10 +2507,10 @@ static int save_clock(struct tracecmd_output *handle, char *clock)
 		return -1;
 
 	endian8 = convert_endian_8(handle, strlen(str));
-	ret = do_write_check(handle, &endian8, 8);
+	ret = tracecmd_do_write_check(handle, &endian8, 8);
 	if (ret)
 		goto out;
-	ret = do_write_check(handle, str, strlen(str));
+	ret = tracecmd_do_write_check(handle, str, strlen(str));
 
 out:
 	free(str);
@@ -2539,7 +2540,7 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (do_write_check(handle, &offset, 8))
+	if (tracecmd_do_write_check(handle, &offset, 8))
 		return -1;
 
 	/* Go back to end of file */
@@ -2550,7 +2551,7 @@ static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
 	return 0;
 }
 
-__hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
+__hidden int tracecmd_out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 {
 	unsigned long long zero = 0;
 	char *clock;
@@ -2561,7 +2562,7 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 		return 0;
 
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-				    check_file_state(handle->file_version,
+				    tracecmd_check_file_state(handle->file_version,
 						     handle->file_state,
 						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
@@ -2570,15 +2571,15 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 		return ret;
 	}
 
-	if (do_write_check(handle, "flyrecord", 10))
+	if (tracecmd_do_write_check(handle, "flyrecord", 10))
 		return -1;
 
 	for (i = 0; i < cpus; i++) {
 		/* Write 0 for trace data offset and size */
-		if (do_write_check(handle, &zero, 8))
+		if (tracecmd_do_write_check(handle, &zero, 8))
 			return -1;
 
-		if (do_write_check(handle, &zero, 8))
+		if (tracecmd_do_write_check(handle, &zero, 8))
 			return -1;
 	}
 	clock = get_clock(handle);
@@ -2589,7 +2590,7 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-__hidden int out_write_cpu_data(struct tracecmd_output *handle,
+__hidden int tracecmd_out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
@@ -2605,7 +2606,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 
 	/* This can be called multiple times (when recording instances) */
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-				    check_file_state(handle->file_version,
+				    tracecmd_check_file_state(handle->file_version,
 						     handle->file_state,
 						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
@@ -2620,14 +2621,14 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		page_size = get_trace_page_size(handle, buff_name);
 
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
-	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
+	if (!HAS_SECTIONS(handle) && tracecmd_do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
-	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	offset = tracecmd_out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
 	free(str);
 	if (offset == (off_t)-1)
 		goto out_free;
@@ -2645,10 +2646,10 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (!HAS_SECTIONS(handle)) {
 			endian8 = 0;
 			data_files[i].file_data_offset = do_lseek(handle, 0, SEEK_CUR);
-			if (do_write_check(handle, &endian8, 8))
+			if (tracecmd_do_write_check(handle, &endian8, 8))
 				goto out_free;
 			data_files[i].file_write_size = do_lseek(handle, 0, SEEK_CUR);
-			if (do_write_check(handle, &endian8, 8))
+			if (tracecmd_do_write_check(handle, &endian8, 8))
 				goto out_free;
 		}
 	}
@@ -2677,7 +2678,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek(data[i].fd, data[i].offset, SEEK_SET) == (off_t)-1)
 				goto out_free;
-			read_size = out_copy_fd_compress(handle, data[i].fd,
+			read_size = tracecmd_out_copy_fd_compress(handle, data[i].fd,
 							 data[i].size, &data_files[i].write_size,
 							 page_size);
 
@@ -2696,13 +2697,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (do_lseek(handle, data_files[i].file_data_offset, SEEK_SET) == (off_t)-1)
 				goto out_free;
 			endian8 = convert_endian_8(handle, data_files[i].data_offset);
-			if (do_write_check(handle, &endian8, 8))
+			if (tracecmd_do_write_check(handle, &endian8, 8))
 				goto out_free;
 			/* Write the real CPU data size in the file */
 			if (do_lseek(handle, data_files[i].file_write_size, SEEK_SET) == (off_t)-1)
 				goto out_free;
 			endian8 = convert_endian_8(handle, data_files[i].write_size);
-			if (do_write_check(handle, &endian8, 8))
+			if (tracecmd_do_write_check(handle, &endian8, 8))
 				goto out_free;
 			offset = data_files[i].data_offset + data_files[i].write_size;
 			if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
@@ -2719,7 +2720,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, buff_name,  TRACECMD_OPTION_BUFFER,
+	    !tracecmd_out_add_buffer_option(handle, buff_name,  TRACECMD_OPTION_BUFFER,
 				   data_offs, cpus, data_files, page_size))
 		goto out_free;
 
@@ -2727,7 +2728,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off_t)-1)
 		return -1;
 
-	if (out_update_section_header(handle, offset))
+	if (tracecmd_out_update_section_header(handle, offset))
 		goto out_free;
 
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
@@ -2779,7 +2780,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	if (i < cpus)
 		ret = -1;
 	else
-		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+		ret = tracecmd_out_write_cpu_data(handle, cpus, data, buff_name);
 
 	for (i--; i >= 0; i--)
 		close(data[i].fd);
@@ -2853,8 +2854,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = get_last_option_offset(ihandle);
-	handle->strings_offs = get_meta_strings_size(ihandle);
+	handle->options_start = tracecmd_get_last_option_offset(ihandle);
+	handle->strings_offs = tracecmd_get_meta_strings_size(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
@@ -2968,22 +2969,22 @@ out_free:
 	return NULL;
 }
 
-__hidden void out_set_file_state(struct tracecmd_output *handle, int new_state)
+__hidden void tracecmd_out_set_file_state(struct tracecmd_output *handle, int new_state)
 {
 	handle->file_state = new_state;
 }
 
-__hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
+__hidden bool tracecmd_check_out_state(struct tracecmd_output *handle, int new_state)
 {
-	return check_file_state(handle->file_version, handle->file_state, new_state);
+	return tracecmd_check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
-__hidden bool out_check_compression(struct tracecmd_output *handle)
+__hidden bool tracecmd_out_check_compression(struct tracecmd_output *handle)
 {
 	return (handle->compress != NULL);
 }
 
-__hidden int out_save_options_offset(struct tracecmd_output *handle, unsigned long long start)
+__hidden int tracecmd_out_save_options_offset(struct tracecmd_output *handle, unsigned long long start)
 {
 	unsigned long long new, en8;
 
@@ -2997,7 +2998,7 @@ __hidden int out_save_options_offset(struct tracecmd_output *handle, unsigned lo
 			return -1;
 
 		en8 = convert_endian_8(handle, start);
-		if (do_write_check(handle, &en8, 8))
+		if (tracecmd_do_write_check(handle, &en8, 8))
 			return -1;
 
 		handle->options_start = new;
diff --git a/lib/trace-cmd/trace-perf.c b/lib/trace-cmd/trace-perf.c
index a10da55d..d3df75b6 100644
--- a/lib/trace-cmd/trace-perf.c
+++ b/lib/trace-cmd/trace-perf.c
@@ -31,7 +31,7 @@ static void default_perf_init_pe(struct perf_event_attr *pe)
 }
 
 /**
- * trace_perf_init - Initialize perf context
+ * tracecmd_perf_init - Initialize perf context
  *
  * @perf: structure, representing perf context, that will be initialized.
  * @pages: Number of perf memory mapped pages.
@@ -39,12 +39,12 @@ static void default_perf_init_pe(struct perf_event_attr *pe)
  * @pid: PID, associated with this perf context.
  *
  * The perf context in initialized with default values. The caller can set
- * custom perf parameters in perf->pe, before calling trace_perf_open() API.
+ * custom perf parameters in perf->pe, before calling tracecmd_perf_open() API.
  *
  * Returns 0 on success, or -1 in case of an error.
  *
  */
-int __hidden trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
+int __hidden tracecmd_perf_init(struct trace_perf *perf, int pages, int cpu, int pid)
 {
 	if (!perf)
 		return -1;
@@ -60,13 +60,13 @@ int __hidden trace_perf_init(struct trace_perf *perf, int pages, int cpu, int pi
 }
 
 /**
- * trace_perf_close - Close perf session
+ * tracecmd_perf_close - Close perf session
  *
  * @perf: structure, representing context of a running perf session, opened
- *	  with trace_perf_open()
+ *	  with tracecmd_perf_open()
  *
  */
-void __hidden trace_perf_close(struct trace_perf *perf)
+void __hidden tracecmd_perf_close(struct trace_perf *perf)
 {
 	if (perf->fd >= 0)
 		close(perf->fd);
@@ -77,15 +77,15 @@ void __hidden trace_perf_close(struct trace_perf *perf)
 }
 
 /**
- * trace_perf_open - Open perf session
+ * tracecmd_perf_open - Open perf session
  *
  * @perf: structure, representing perf context that will be opened. It must be
- *	  initialized with trace_perf_init().
+ *	  initialized with tracecmd_perf_init().
  *
  * Returns 0 on success, or -1 in case of an error. In case of success, the
- * session must be closed with trace_perf_close()
+ * session must be closed with tracecmd_perf_close()
  */
-int __hidden trace_perf_open(struct trace_perf *perf)
+int __hidden tracecmd_perf_open(struct trace_perf *perf)
 {
 	perf->fd = syscall(__NR_perf_event_open, &perf->pe, perf->pid, perf->cpu, -1, 0);
 	if (perf->fd < 0)
@@ -100,6 +100,6 @@ int __hidden trace_perf_open(struct trace_perf *perf)
 	return 0;
 
 error:
-	trace_perf_close(perf);
+	tracecmd_perf_close(perf);
 	return -1;
 }
diff --git a/lib/trace-cmd/trace-rbtree.c b/lib/trace-cmd/trace-rbtree.c
index 90671819..62c785c5 100644
--- a/lib/trace-cmd/trace-rbtree.c
+++ b/lib/trace-cmd/trace-rbtree.c
@@ -13,7 +13,7 @@ enum {
 	BLACK,
 };
 
-void __hidden trace_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
+void __hidden tracecmd_rbtree_init(struct trace_rbtree *tree, trace_rbtree_cmp_fn cmp_fn,
 				trace_rbtree_search_fn search_fn)
 {
 	memset(tree, 0, sizeof(*tree));
@@ -163,7 +163,7 @@ static void check_tree(struct trace_rbtree *tree)
 static inline void check_tree(struct trace_rbtree *tree) { }
 #endif
 
-int __hidden trace_rbtree_insert(struct trace_rbtree *tree,
+int __hidden tracecmd_rbtree_insert(struct trace_rbtree *tree,
 				 struct trace_rbtree_node *node)
 {
 	struct trace_rbtree_node *uncle;
@@ -371,7 +371,7 @@ void trace_rbtree_delete(struct trace_rbtree *tree, struct trace_rbtree_node *no
 	check_tree(tree);
 }
 
-__hidden struct trace_rbtree_node *trace_rbtree_next(struct trace_rbtree *tree,
+__hidden struct trace_rbtree_node *tracecmd_rbtree_next(struct trace_rbtree *tree,
 						     struct trace_rbtree_node *node)
 {
 	check_tree(tree);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 6ee4e643..7dfb9523 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -116,7 +116,7 @@ int tracecmd_tsync_proto_unregister(char *proto_name)
 	return -1;
 }
 
-bool __hidden tsync_proto_is_supported(const char *proto_name)
+bool __hidden tracecmd_tsync_proto_is_supported(const char *proto_name)
 {
 	if (tsync_proto_find(proto_name))
 		return true;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 37caab45..e44c3036 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -280,7 +280,7 @@ static void add_plugin_file(struct tep_handle *pevent, const char *path,
 }
 
 /**
- * trace_util_find_plugin_files - find list of possible plugin files
+ * tracecmd_util_find_plugin_files - find list of possible plugin files
  * @suffix: The suffix of the plugin files to find
  *
  * Searches the plugin directory for files that end in @suffix, and
@@ -291,9 +291,9 @@ static void add_plugin_file(struct tep_handle *pevent, const char *path,
  * the errno will be returned with the TRACECMD_ERR_MSK to denote
  * such an error occurred.
  *
- * Use trace_util_free_plugin_files() to free the result.
+ * Use tracecmd_util_free_plugin_files() to free the result.
  */
-__hidden char **trace_util_find_plugin_files(const char *suffix)
+__hidden char **tracecmd_util_find_plugin_files(const char *suffix)
 {
 	struct add_plugin_data pdata;
 
@@ -308,12 +308,12 @@ __hidden char **trace_util_find_plugin_files(const char *suffix)
 }
 
 /**
- * trace_util_free_plugin_files - free the result of trace_util_find_plugin_files()
- * @files: The result from trace_util_find_plugin_files()
+ * tracecmd_util_free_plugin_files - free the result of tracecmd_util_find_plugin_files()
+ * @files: The result from tracecmd_util_find_plugin_files()
  *
- * Frees the contents that were allocated by trace_util_find_plugin_files().
+ * Frees the contents that were allocated by tracecmd_util_find_plugin_files().
  */
-void __hidden trace_util_free_plugin_files(char **files)
+void __hidden tracecmd_util_free_plugin_files(char **files)
 {
 	int i;
 
@@ -349,7 +349,7 @@ static char *get_source_plugins_dir(void)
 }
 
 __hidden struct tep_plugin_list *
-trace_load_plugins(struct tep_handle *tep, int flags)
+tracecmd_load_plugins_from_handle(struct tep_handle *tep, int flags)
 {
 	struct tep_plugin_list *list;
 	char *path;
@@ -659,7 +659,7 @@ static void __attribute__((destructor)) tracecmd_lib_free(void)
 	tracecmd_compress_free();
 }
 
-__hidden bool check_file_state(unsigned long file_version, int current_state, int new_state)
+__hidden bool tracecmd_check_file_state(unsigned long file_version, int current_state, int new_state)
 {
 	if (file_version >= FILE_VERSION_SECTIONS) {
 		if (current_state < TRACECMD_FILE_INIT)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1515fbbe..74de6b35 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -399,27 +399,27 @@ int get_local_cid(unsigned int *cid);
 char *trace_get_guest_file(const char *file, const char *guest);
 
 #ifdef VSOCK
-int trace_vsock_open(unsigned int cid, unsigned int port);
-int trace_vsock_make(unsigned int port);
-int trace_vsock_make_any(void);
+int tracecmd_vsock_open(unsigned int cid, unsigned int port);
+int tracecmd_vsock_make(unsigned int port);
+int tracecmd_vsock_make_any(void);
 int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid);
-int trace_vsock_get_port(int sd, unsigned int *port);
-bool trace_vsock_can_splice_read(void);
-int trace_vsock_local_cid(void);
+int tracecmd_vsock_get_port(int sd, unsigned int *port);
+bool tracecmd_vsock_can_splice_read(void);
+int tracecmd_vsock_local_cid(void);
 int trace_vsock_print_connection(int fd);
 #else
-static inline int trace_vsock_open(unsigned int cid, unsigned int port)
+static inline int tracecmd_vsock_open(unsigned int cid, unsigned int port)
 {
 	return -ENOTSUP;
 }
 
-static inline int trace_vsock_make(unsigned int port)
+static inline int tracecmd_vsock_make(unsigned int port)
 {
 	return -ENOTSUP;
 
 }
 
-static inline int trace_vsock_make_any(void)
+static inline int tracecmd_vsock_make_any(void)
 {
 	return -ENOTSUP;
 
@@ -430,17 +430,17 @@ static inline int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *r
 	return -ENOTSUP;
 }
 
-static inline int trace_vsock_get_port(int sd, unsigned int *port)
+static inline int tracecmd_vsock_get_port(int sd, unsigned int *port)
 {
 	return -ENOTSUP;
 }
 
-static inline bool trace_vsock_can_splice_read(void)
+static inline bool tracecmd_vsock_can_splice_read(void)
 {
 	return false;
 }
 
-static inline int trace_vsock_local_cid(void)
+static inline int tracecmd_vsock_local_cid(void)
 {
 	return -ENOTSUP;
 }
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index b6b44f58..16d3de76 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -32,11 +32,11 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
 	int i, fd, ret;
 
 	for (i = 0; i < nr; i++) {
-		fd = trace_vsock_make_any();
+		fd = tracecmd_vsock_make_any();
 		if (fd < 0)
 			die("Failed to open vsocket");
 
-		ret = trace_vsock_get_port(fd, &port);
+		ret = tracecmd_vsock_get_port(fd, &port);
 		if (ret < 0)
 			die("Failed to get vsocket address");
 
@@ -223,9 +223,9 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 				remote_id = -1;
 				local_id = -2;
 			}
-			fd = trace_vsock_make_any();
+			fd = tracecmd_vsock_make_any();
 			if (fd >= 0 &&
-			    trace_vsock_get_port(fd, &tsync_port) < 0) {
+			    tracecmd_vsock_get_port(fd, &tsync_port) < 0) {
 				close(fd);
 				fd = -1;
 			}
@@ -327,13 +327,13 @@ static void agent_serve(unsigned int port, bool do_daemon, int proxy_id,
 		if (listen(sd, 5) < 0)
 			die("Failed to listen on %d\n", port);
 	} else
-		sd = trace_vsock_make(port);
+		sd = tracecmd_vsock_make(port);
 	if (sd < 0)
 		die("Failed to open socket");
 	tracecmd_tsync_init();
 
 	if (!network) {
-		cid = trace_vsock_local_cid();
+		cid = tracecmd_vsock_local_cid();
 		if (cid >= 0)
 			printf("listening on @%u:%u\n", cid, port);
 	}
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 46f57e17..e5b39352 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -59,7 +59,7 @@ void trace_check_events(int argc, char **argv)
 	if (!pevent)
 		exit(EINVAL);
 
-	list = trace_load_plugins(pevent, open_flags);
+	list = tracecmd_load_plugins_from_handle(pevent, open_flags);
 	ret = tracefs_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 8badd1f2..55542707 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -551,7 +551,7 @@ static void show_plugin_options(void)
 
 	trace_seq_init(&s);
 
-	list = trace_load_plugins(pevent, 0);
+	list = tracecmd_load_plugins_from_handle(pevent, 0);
 	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
@@ -577,7 +577,7 @@ static void show_plugins(void)
 
 	trace_seq_init(&s);
 
-	list = trace_load_plugins(pevent, 0);
+	list = tracecmd_load_plugins_from_handle(pevent, 0);
 	tep_print_plugins(&s, "  ", "\n", list);
 
 	trace_seq_do_printf(&s);
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index e11bca03..68286c5b 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -225,7 +225,7 @@ static int setup_vsock_port(int start_port, int *sfd)
 {
 	int sd;
 
-	sd = trace_vsock_make(start_port);
+	sd = tracecmd_vsock_make(start_port);
 	if (sd < 0)
 		return -errno;
 	*sfd = sd;
@@ -1022,11 +1022,11 @@ static int get_vsock(const char *port)
 	unsigned int cid;
 	int sd;
 
-	sd = trace_vsock_make(atoi(port));
+	sd = tracecmd_vsock_make(atoi(port));
 	if (sd < 0)
 		return sd;
 
-	cid = trace_vsock_local_cid();
+	cid = tracecmd_vsock_local_cid();
 	if (cid >= 0)
 		printf("listening on @%u:%s\n", cid, port);
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index d12a0e5e..e351bf5e 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -226,7 +226,7 @@ add_start(struct task_data *task,
 	start->event_data = event_data;
 	start->cpu = record->cpu;
 	start->task = task;
-	trace_hash_add(&task->start_hash, &start->hash);
+	tracecmd_hash_add(&task->start_hash, &start->hash);
 	if (event_data->migrate)
 		list_add(&start->list, &task->handle->migrate_starts);
 	else
@@ -270,7 +270,7 @@ find_event_hash(struct task_data *task, struct event_data_match *edata)
 		(unsigned long)edata->search_val +
 		(unsigned long)edata->val;
 	key = trace_hash(key);
-	item = trace_hash_find(&task->event_hash, key, match_event, edata);
+	item = tracecmd_hash_find(&task->event_hash, key, match_event, edata);
 	if (item)
 		return event_from_item(item);
 
@@ -283,9 +283,9 @@ find_event_hash(struct task_data *task, struct event_data_match *edata)
 	event_hash->search_val = edata->search_val;
 	event_hash->val = edata->val;
 	event_hash->hash.key = key;
-	trace_hash_init(&event_hash->stacks, 32);
+	tracecmd_hash_init(&event_hash->stacks, 32);
 
-	trace_hash_add(&task->event_hash, &event_hash->hash);
+	tracecmd_hash_add(&task->event_hash, &event_hash->hash);
 
 	return event_hash;
 }
@@ -316,7 +316,7 @@ find_start(struct task_data *task, struct event_data *event_data,
 	edata.event_data = event_data;
 	edata.search_val = search_val;
 
-	item = trace_hash_find(&task->start_hash, key, match_start, data);
+	item = tracecmd_hash_find(&task->start_hash, key, match_start, data);
 	if (!item)
 		return NULL;
 
@@ -360,7 +360,7 @@ static void add_event_stack(struct event_hash *event_hash,
 	for (key = 0, i = 0; i <= size - sizeof(int); i += sizeof(int))
 		key += trace_hash(*(int *)(caller + i));
 
-	item = trace_hash_find(&event_hash->stacks, key, match_stack, &match);
+	item = tracecmd_hash_find(&event_hash->stacks, key, match_stack, &match);
 	if (!item) {
 		stack = malloc(sizeof(*stack) + size);
 		if (!stack) {
@@ -371,7 +371,7 @@ static void add_event_stack(struct event_hash *event_hash,
 		memcpy(&stack->caller, caller, size);
 		stack->size = size;
 		stack->hash.key = key;
-		trace_hash_add(&event_hash->stacks, &stack->hash);
+		tracecmd_hash_add(&event_hash->stacks, &stack->hash);
 	} else
 		stack = stack_from_item(item);
 
@@ -474,8 +474,8 @@ static void init_task(struct handle_data *h, struct task_data *task)
 {
 	task->handle = h;
 
-	trace_hash_init(&task->start_hash, 16);
-	trace_hash_init(&task->event_hash, 32);
+	tracecmd_hash_init(&task->start_hash, 16);
+	tracecmd_hash_init(&task->event_hash, 32);
 }
 
 static struct task_data *
@@ -493,7 +493,7 @@ add_task(struct handle_data *h, int pid)
 
 	task->pid = pid;
 	task->hash.key = key;
-	trace_hash_add(&h->task_hash, &task->hash);
+	tracecmd_hash_add(&h->task_hash, &task->hash);
 
 	init_task(h, task);
 
@@ -511,7 +511,7 @@ find_task(struct handle_data *h, int pid)
 	if (last_task && last_task->pid == pid)
 		return last_task;
 
-	item = trace_hash_find(&h->task_hash, key, match_task, data);
+	item = tracecmd_hash_find(&h->task_hash, key, match_task, data);
 
 	if (item)
 		last_task = task_from_item(item);
@@ -726,7 +726,7 @@ find_event_data(struct handle_data *h, int id)
 	unsigned long long key = trace_hash(id);
 	void *data = (void *)(unsigned long)id;
 
-	item = trace_hash_find(&h->events, key, match_event_data, data);
+	item = tracecmd_hash_find(&h->events, key, match_event_data, data);
 	if (item)
 		return event_data_from_item(item);
 	return NULL;
@@ -818,7 +818,7 @@ add_event(struct handle_data *h, const char *system, const char *event_name,
 	event_data->type = type;
 	event_data->hash.key = trace_hash(event_data->event->id);
 
-	trace_hash_add(&h->events, &event_data->hash);
+	tracecmd_hash_add(&h->events, &event_data->hash);
 
 	return event_data;
 }
@@ -1298,9 +1298,9 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 	h->next = handles;
 	handles = h;
 
-	trace_hash_init(&h->task_hash, 1024);
-	trace_hash_init(&h->events, 1024);
-	trace_hash_init(&h->group_hash, 512);
+	tracecmd_hash_init(&h->task_hash, 1024);
+	tracecmd_hash_init(&h->events, 1024);
+	tracecmd_hash_init(&h->group_hash, 512);
 
 	h->handle = handle;
 	h->pevent = pevent;
@@ -2120,7 +2120,7 @@ static void free_event_hash(struct event_hash *event_hash)
 			free(stack);
 		}
 	}
-	trace_hash_free(&event_hash->stacks);
+	tracecmd_hash_free(&event_hash->stacks);
 	free(event_hash);
 }
 
@@ -2143,7 +2143,7 @@ static void __free_task(struct task_data *task)
 			free(start);
 		}
 	}
-	trace_hash_free(&task->start_hash);
+	tracecmd_hash_free(&task->start_hash);
 
 	trace_hash_for_each_bucket(bucket, &task->event_hash) {
 		trace_hash_while_item(item, bucket) {
@@ -2152,7 +2152,7 @@ static void __free_task(struct task_data *task)
 			free_event_hash(event_hash);
 		}
 	}
-	trace_hash_free(&task->event_hash);
+	tracecmd_hash_free(&task->event_hash);
 
 	if (task->last_stack)
 		tracecmd_free_record(task->last_stack);
@@ -2179,14 +2179,14 @@ static void free_group(struct group_data *group)
 			free_event_hash(event_hash);
 		}
 	}
-	trace_hash_free(&group->event_hash);
+	tracecmd_hash_free(&group->event_hash);
 	free(group);
 }
 
 static void show_global_task(struct handle_data *h,
 			     struct task_data *task)
 {
-	if (trace_hash_empty(&task->event_hash))
+	if (tracecmd_hash_empty(&task->event_hash))
 		return;
 
 	output_task(h, task);
@@ -2294,10 +2294,10 @@ static void merge_event_stack(struct event_hash *event,
 
 	match.caller = stack->caller;
 	match.size = stack->size;
-	item = trace_hash_find(&event->stacks, stack->hash.key, match_stack,
+	item = tracecmd_hash_find(&event->stacks, stack->hash.key, match_stack,
 			       &match);
 	if (!item) {
-		trace_hash_add(&event->stacks, &stack->hash);
+		tracecmd_hash_add(&event->stacks, &stack->hash);
 		return;
 	}
 	exist = stack_from_item(item);
@@ -2357,10 +2357,10 @@ static void merge_event_into_group(struct group_data *group,
 	edata.search_val = event->search_val;
 	edata.val = event->val;
 
-	item = trace_hash_find(&group->event_hash, key, match_event, &edata);
+	item = tracecmd_hash_find(&group->event_hash, key, match_event, &edata);
 	if (!item) {
 		event->hash.key = key;
-		trace_hash_add(&group->event_hash, &event->hash);
+		tracecmd_hash_add(&group->event_hash, &event->hash);
 		return;
 	}
 
@@ -2394,7 +2394,7 @@ static void add_group(struct handle_data *h, struct task_data *task)
 
 	key = trace_hash_str(task->comm);
 
-	item = trace_hash_find(&h->group_hash, key, match_group, data);
+	item = tracecmd_hash_find(&h->group_hash, key, match_group, data);
 	if (item) {
 		grp = group_from_item(item);
 	} else {
@@ -2409,8 +2409,8 @@ static void add_group(struct handle_data *h, struct task_data *task)
 		if (!grp->comm)
 			die("strdup");
 		grp->hash.key = key;
-		trace_hash_add(&h->group_hash, &grp->hash);
-		trace_hash_init(&grp->event_hash, 32);
+		tracecmd_hash_add(&h->group_hash, &grp->hash);
+		tracecmd_hash_init(&grp->event_hash, 32);
 	}
 	task->group = grp;
 
@@ -2447,7 +2447,7 @@ int do_trace_profile(void)
 		if (merge_like_comms)
 			merge_tasks(h);
 		output_handle(h);
-		trace_hash_free(&h->task_hash);
+		tracecmd_hash_free(&h->task_hash);
 	}
 
 	return 0;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index a5a0e10a..6d88d730 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -609,7 +609,7 @@ static void init_wakeup(struct tracecmd_input *handle)
 
 	pevent = tracecmd_get_tep(handle);
 
-	trace_hash_init(&wakeup_hash, WAKEUP_HASH_SIZE);
+	tracecmd_hash_init(&wakeup_hash, WAKEUP_HASH_SIZE);
 
 	event = tep_find_event_by_name(pevent, "sched", "sched_wakeup");
 	if (!event)
@@ -657,7 +657,7 @@ static void add_wakeup(unsigned int val, unsigned long long start)
 	struct wakeup_info *info;
 	struct trace_hash_item *item;
 
-	item = trace_hash_find(&wakeup_hash, key, NULL, NULL);
+	item = tracecmd_hash_find(&wakeup_hash, key, NULL, NULL);
 	if (item) {
 		info = container_of(item, struct wakeup_info, hash);
 		/* Hmm, double wakeup? */
@@ -670,7 +670,7 @@ static void add_wakeup(unsigned int val, unsigned long long start)
 		die("Failed to allocate wakeup info");
 	info->hash.key = key;
 	info->start = start;
-	trace_hash_add(&wakeup_hash, &info->hash);
+	tracecmd_hash_add(&wakeup_hash, &info->hash);
 }
 
 static unsigned long long max_lat = 0;
@@ -690,7 +690,7 @@ static void add_sched(unsigned int val, unsigned long long end, int rt)
 	struct wakeup_info *info;
 	unsigned long long cal;
 
-	item = trace_hash_find(&wakeup_hash, key, NULL, NULL);
+	item = tracecmd_hash_find(&wakeup_hash, key, NULL, NULL);
 	if (!item)
 		return;
 
@@ -817,7 +817,7 @@ static void finish_wakeup(void)
 		}
 	}
 
-	trace_hash_free(&wakeup_hash);
+	tracecmd_hash_free(&wakeup_hash);
 }
 
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a008cdfd..ac2a0c72 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3438,7 +3438,7 @@ static int connect_port(const char *host, unsigned int port, enum port_type type
 	int sfd;
 
 	if (type == USE_VSOCK)
-		return trace_vsock_open(atoi(host), port);
+		return tracecmd_vsock_open(atoi(host), port);
 
 	results = do_getaddrinfo(host, port, type);
 
@@ -3579,14 +3579,14 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 			fd = connect_addr(result);
 			freeaddrinfo(result);
 		} else
-			fd = trace_vsock_open(instance->cid, instance->client_ports[cpu]);
+			fd = tracecmd_vsock_open(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
 		flags = recorder_flags;
 		if (instance->use_fifos)
 			flags |= TRACECMD_RECORD_NOBRASS;
-		else if (!trace_vsock_can_splice_read())
+		else if (!tracecmd_vsock_can_splice_read())
 			flags |= TRACECMD_RECORD_NOSPLICE;
 		return tracecmd_create_recorder_virt(file, cpu, flags, fd, max_kb);
 	}
@@ -3842,7 +3842,7 @@ static int connect_vsock(char *vhost)
 	if (!port)
 		die("vsocket must have format of 'CID:PORT'");
 
-	sd = trace_vsock_open(atoi(cid), atoi(port));
+	sd = tracecmd_vsock_open(atoi(cid), atoi(port));
 
 	return sd;
 }
@@ -4102,7 +4102,7 @@ static int host_tsync(struct common_record_context *ctx,
 				  instance->port_type);
 	} else {
 		guest_id = instance->cid;
-		fd = trace_vsock_open(instance->cid, tsync_port);
+		fd = tracecmd_vsock_open(instance->cid, tsync_port);
 	}
 
 	if (is_proxy(instance)) {
@@ -4148,7 +4148,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 			role = TRACECMD_TIME_SYNC_ROLE_GUEST;
 		else
 			role = TRACECMD_TIME_SYNC_ROLE_HOST;
-		sd = trace_vsock_open(instance->cid, instance->port);
+		sd = tracecmd_vsock_open(instance->cid, instance->port);
 		if (sd < 0)
 			die("Failed to connect to vsocket @%u:%u",
 			    instance->cid, instance->port);
@@ -4189,7 +4189,7 @@ static void connect_to_agent(struct common_record_context *ctx,
 	if (ret < 0)
 		die("Failed to receive trace response %d", ret);
 	if (tsync_protos_reply && tsync_protos_reply[0]) {
-		if (tsync_proto_is_supported(tsync_protos_reply)) {
+		if (tracecmd_tsync_proto_is_supported(tsync_protos_reply)) {
 			printf("Negotiated %s time sync protocol with guest %s\n",
 				tsync_protos_reply,
 				instance->name);
@@ -6322,17 +6322,17 @@ static int get_tsc_nsec(int *shift, int *mult)
 		goto out;
 
 	supported = -1;
-	if (trace_perf_init(&perf, 1, 0, getpid()))
+	if (tracecmd_perf_init(&perf, 1, 0, getpid()))
 		return -1;
-	if (trace_perf_open(&perf))
+	if (tracecmd_perf_open(&perf))
 		return -1;
 	cpu_shift = perf.mmap->time_shift;
 	cpu_mult = perf.mmap->time_mult;
 	for (i = 1; i < cpus; i++) {
-		trace_perf_close(&perf);
-		if (trace_perf_init(&perf, 1, i, getpid()))
+		tracecmd_perf_close(&perf);
+		if (tracecmd_perf_init(&perf, 1, i, getpid()))
 			break;
-		if (trace_perf_open(&perf))
+		if (tracecmd_perf_open(&perf))
 			break;
 		if (perf.mmap->time_shift != cpu_shift ||
 		    perf.mmap->time_mult != cpu_mult) {
@@ -6341,7 +6341,7 @@ static int get_tsc_nsec(int *shift, int *mult)
 			break;
 		}
 	}
-	trace_perf_close(&perf);
+	tracecmd_perf_close(&perf);
 	if (i < cpus)
 		return -1;
 
@@ -7104,7 +7104,7 @@ static void set_tsync_params(struct common_record_context *ctx)
 	 * force using the x86-tsc clock for this host-guest tracing session
 	 * and store TSC to nsec multiplier and shift.
 	 */
-		if (tsync_proto_is_supported("kvm") &&
+		if (tracecmd_tsync_proto_is_supported("kvm") &&
 		    trace_have_guests_pid() &&
 		    clock_is_supported(NULL, TSC_CLOCK) &&
 		    !get_tsc_nsec(&shift, &mult) && mult) {
diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 960ed5d5..3122e22a 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -325,7 +325,7 @@ static void find_pid_by_cid(struct trace_guest *guest)
 	int fd;
 
 	instance = start_trace_connect();
-	fd = trace_vsock_open(guest->cid, -1);
+	fd = tracecmd_vsock_open(guest->cid, -1);
 	guest->pid = stop_trace_connect(instance);
 	/* Just in case! */
 	if (fd >= 0)
diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index df1a9800..4aa5182c 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -6,7 +6,7 @@
 
 #include "trace-cmd-private.h"
 
-int __hidden trace_vsock_open(unsigned int cid, unsigned int port)
+int __hidden tracecmd_vsock_open(unsigned int cid, unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -27,7 +27,7 @@ int __hidden trace_vsock_open(unsigned int cid, unsigned int port)
 	return sd;
 }
 
-int __hidden trace_vsock_make(unsigned int port)
+int __hidden tracecmd_vsock_make(unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -55,12 +55,12 @@ error:
 	return -errno;
 }
 
-int __hidden trace_vsock_make_any(void)
+int __hidden tracecmd_vsock_make_any(void)
 {
-	return trace_vsock_make(VMADDR_PORT_ANY);
+	return tracecmd_vsock_make(VMADDR_PORT_ANY);
 }
 
-int __hidden trace_vsock_get_port(int sd, unsigned int *port)
+int __hidden tracecmd_vsock_get_port(int sd, unsigned int *port)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
@@ -155,7 +155,7 @@ out_close_sd:
 	return ret;
 }
 
-bool __hidden trace_vsock_can_splice_read(void)
+bool __hidden tracecmd_vsock_can_splice_read(void)
 {
 	static bool initialized, res;
 
@@ -169,7 +169,7 @@ bool __hidden trace_vsock_can_splice_read(void)
 
 #define GET_LOCAL_CID	0x7b9
 
-int __hidden trace_vsock_local_cid(void)
+int __hidden tracecmd_vsock_local_cid(void)
 {
 	int cid;
 	int fd;

base-commit: bbea061f69dab3a55dc5c077bf89a02f8f08cb6a
-- 
2.34.1

