Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B251F19A
	for <linux-trace-devel@vger.kernel.org>; Sat, 14 Sep 2024 08:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726301487; cv=none; b=CFioYkRVTPMvABCmKXy/2hQE1HO7I2o3mTzUl8z1+/xr+WEIpI359tpsl78zfj2hLDXfcBlvVcQ+c27mQNGhEftRFkR40RukWw6wJYmuO845ANiHZoygtNUasDkuTjjRa8IAQcU7cl4IVgaps77dWE7+foZGsrFz9Hzuh+ZcsQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726301487; c=relaxed/simple;
	bh=lIUh6wVXDBzFe0CS9xRvNR/svufUlPKb532fabMMJf4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iP5NdJfAdzu9ois7Jeu4EaRzY8HXnYu/DD9KNw0a83NBEMgcDDRGs6+VwLxpqUUb0JmO6Qi7jPS/Sa3I17+e6lZlID5iX1aQbq4dX7V3uUm2ObMcMLWyKZA6WcakseuWeswlFpvrRN8GHIPHE9ermi0o1jeuxug45qAmNPxm32Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEE5C4CEC0;
	Sat, 14 Sep 2024 08:11:25 +0000 (UTC)
Date: Sat, 14 Sep 2024 04:11:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Subject: [PATCH] trace-cmd record: Fix compression when files are greater
 than 2GB
Message-ID: <20240914041120.264b289b@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Several file size references in the compression code is defined as "int",
but that can only be used for sizes less than 2GB. Convert them to size_t
and ssize_t. Also convert some long long and unsigned long long to use
ssize_t and size_t respectively for consistency.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219264

Reported-by: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       | 18 ++---
 lib/trace-cmd/include/trace-cmd-local.h       |  2 +-
 lib/trace-cmd/trace-compress.c                | 66 +++++++++----------
 lib/trace-cmd/trace-input.c                   |  9 ++-
 lib/trace-cmd/trace-output.c                  |  8 +--
 tracecmd/trace-record.c                       |  2 +-
 6 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index db1d5ee29dd4..e2f22315b57e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -179,8 +179,8 @@ struct tracecmd_ftrace {
 };
 
 struct tracecmd_proc_addr_map {
-	unsigned long long	start;
-	unsigned long long	end;
+	size_t			start;
+	size_t			end;
 	char			*lib_name;
 };
 
@@ -252,7 +252,7 @@ tracecmd_set_all_cpus_to_timestamp(struct tracecmd_input *handle,
 				   unsigned long long time);
 
 int tracecmd_set_cursor(struct tracecmd_input *handle,
-			int cpu, unsigned long long offset);
+			int cpu, size_t offset);
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
@@ -339,7 +339,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
-unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle);
+size_t tracecmd_get_out_file_offset(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
@@ -550,10 +550,10 @@ void tracecmd_compress_destroy(struct tracecmd_compression *handle);
 int tracecmd_compress_block(struct tracecmd_compression *handle);
 int tracecmd_uncompress_block(struct tracecmd_compression *handle);
 void tracecmd_compress_reset(struct tracecmd_compression *handle);
-int tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, int len);
-int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset);
+ssize_t tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, size_t len);
+ssize_t tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, size_t len, off_t offset);
 int tracecmd_compress_buffer_write(struct tracecmd_compression *handle,
-				   const void *data, unsigned long long size);
+				   const void *data, size_t size);
 off_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off_t offset, int whence);
 int tracecmd_compress_proto_get_name(struct tracecmd_compression *compress,
 				     const char **name, const char **version);
@@ -561,9 +561,9 @@ bool tracecmd_compress_is_supported(const char *name, const char *version);
 int tracecmd_compress_protos_get(char ***names, char ***versions);
 int tracecmd_compress_proto_register(struct tracecmd_compression_proto *proto);
 int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
-				unsigned long long *read_size, unsigned long long *write_size);
+				size_t *read_size, size_t *write_size);
 int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
-				unsigned long long *read_size, unsigned long long *write_size);
+				size_t *read_size, size_t *write_size);
 int tracecmd_uncompress_chunk(struct tracecmd_compression *handle,
 			      struct tracecmd_compress_chunk *chunk, char *data);
 int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ebd6f1526c6c..1a37e8173afa 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -93,7 +93,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 struct cpu_data_source {
 	int fd;
-	int size;
+	ssize_t size;
 	off_t offset;
 };
 
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 3ca0e21f863a..03215ad18334 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -30,9 +30,9 @@ static struct compress_proto *proto_list;
 
 struct tracecmd_compression {
 	int				fd;
-	unsigned int			capacity;
-	unsigned int			capacity_read;
-	unsigned int			pointer;
+	size_t				capacity;
+	size_t				capacity_read;
+	size_t				pointer;
 	char				*buffer;
 	struct compress_proto		*proto;
 	struct tep_handle		*tep;
@@ -40,10 +40,10 @@ struct tracecmd_compression {
 	void				*context;
 };
 
-static int read_fd(int fd, char *dst, int len)
+static ssize_t read_fd(int fd, char *dst, int len)
 {
 	size_t size = 0;
-	int r;
+	ssize_t r;
 
 	do {
 		r = read(fd, dst+size, len);
@@ -59,10 +59,10 @@ static int read_fd(int fd, char *dst, int len)
 	return size;
 }
 
-static long long write_fd(int fd, const void *data, size_t size)
+static ssize_t  write_fd(int fd, const void *data, size_t size)
 {
-	long long tot = 0;
-	long long w;
+	ssize_t  tot = 0;
+	ssize_t  w;
 
 	do {
 		w = write(fd, data + tot, size - tot);
@@ -77,8 +77,8 @@ static long long write_fd(int fd, const void *data, size_t size)
 	return tot;
 }
 
-static long long do_write(struct tracecmd_compression *handle,
-			  const void *data, unsigned long long size)
+static ssize_t  do_write(struct tracecmd_compression *handle,
+			  const void *data, size_t size)
 {
 	int ret;
 
@@ -91,9 +91,9 @@ static long long do_write(struct tracecmd_compression *handle,
 	return write_fd(handle->fd, data, size);
 }
 
-static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
+static inline int buffer_extend(struct tracecmd_compression *handle, size_t size)
 {
-	int extend;
+	ssize_t  extend;
 	char *buf;
 
 	if (size <= handle->capacity)
@@ -146,7 +146,7 @@ off_t tracecmd_compress_lseek(struct tracecmd_compression *handle, off_t offset,
 	return p;
 }
 
-static int compress_read(struct tracecmd_compression *handle, char *dst, int len)
+static ssize_t compress_read(struct tracecmd_compression *handle, char *dst, size_t len)
 {
 
 	if (handle->pointer > handle->capacity_read)
@@ -172,9 +172,9 @@ static int compress_read(struct tracecmd_compression *handle, char *dst, int len
  *
  * On success returns the number of bytes read, or -1 on failure.
  */
-int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int len, off_t offset)
+ssize_t tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, size_t len, off_t offset)
 {
-	int ret;
+	ssize_t ret;
 
 	if (!handle || !handle->buffer || offset > handle->capacity_read)
 		return -1;
@@ -195,9 +195,9 @@ int tracecmd_compress_pread(struct tracecmd_compression *handle, char *dst, int
  *
  * On success returns the number of bytes read, or -1 on failure.
  */
-int tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, int len)
+ssize_t tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, size_t len)
 {
-	int ret;
+	ssize_t ret;
 
 	if (!handle || !handle->buffer)
 		return -1;
@@ -363,7 +363,7 @@ out:
  * Returns 0 on success, or -1 on failure.
  */
 int tracecmd_compress_buffer_write(struct tracecmd_compression *handle,
-				   const void *data, unsigned long long size)
+				   const void *data, size_t size)
 {
 	if (!handle)
 		return -1;
@@ -667,16 +667,16 @@ error:
  * read and written data.
  */
 int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
-				unsigned long long *read_size, unsigned long long *write_size)
+				size_t *read_size, size_t *write_size)
 {
-	unsigned int rchunk = 0;
-	unsigned int chunks = 0;
-	unsigned int rsize = 0;
-	unsigned int rmax = 0;
-	unsigned int csize;
-	unsigned int size;
-	unsigned int all;
-	unsigned int r;
+	size_t rchunk = 0;
+	size_t chunks = 0;
+	size_t rsize = 0;
+	size_t rmax = 0;
+	size_t csize;
+	size_t size;
+	size_t all;
+	size_t r;
 	off_t end_offset;
 	off_t offset;
 	char *buf_from;
@@ -795,7 +795,7 @@ int tracecmd_load_chunks_info(struct tracecmd_compression *handle,
 			      struct tracecmd_compress_chunk **chunks_info)
 {
 	struct tracecmd_compress_chunk *chunks = NULL;
-	unsigned long long size = 0;
+	size_t size = 0;
 	unsigned int count = 0;
 	off_t offset;
 	int ret = -1;
@@ -913,12 +913,12 @@ out:
  * the size of read and written data.
  */
 int tracecmd_uncompress_copy_to(struct tracecmd_compression *handle, int fd,
-				unsigned long long *read_size, unsigned long long *write_size)
+				size_t *read_size, size_t *write_size)
 {
-	unsigned int s_uncompressed;
-	unsigned int s_compressed;
-	unsigned int rsize = 0;
-	unsigned int wsize = 0;
+	size_t s_uncompressed;
+	size_t s_compressed;
+	size_t rsize = 0;
+	size_t wsize = 0;
 	char *bytes_out = NULL;
 	char *bytes_in = NULL;
 	int size_out = 0;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 88ebc6186e4b..8b6e3d0cb44e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2342,8 +2342,7 @@ tracecmd_set_all_cpus_to_timestamp(struct tracecmd_input *handle,
  *  Now the next tracecmd_peek_data or tracecmd_read_data will return
  *  the original record.
  */
-int tracecmd_set_cursor(struct tracecmd_input *handle,
-			int cpu, unsigned long long offset)
+int tracecmd_set_cursor(struct tracecmd_input *handle, int cpu, size_t offset)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
 	unsigned long long page_offset;
@@ -3304,8 +3303,8 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 static int init_cpu_zfile(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data;
-	unsigned long long size;
 	off_t offset;
+	size_t size;
 
 	cpu_data = &handle->cpu_data[cpu];
 	offset = lseek(handle->fd, 0, SEEK_CUR);
@@ -3740,7 +3739,7 @@ static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
 		*line = '\0';
 		if (strlen(buf) > STR_PROCMAP_LINE_MAX)
 			break;
-		res = sscanf(buf, "%llx %llx %s", &maps->lib_maps[i].start,
+		res = sscanf(buf, "%zx %zx %s", &maps->lib_maps[i].start,
 			     &maps->lib_maps[i].end, mapname);
 		if (res != 3)
 			break;
@@ -4353,7 +4352,7 @@ static int init_cpu_data(struct tracecmd_input *handle)
 
 int init_latency_data(struct tracecmd_input *handle)
 {
-	unsigned long long wsize;
+	size_t wsize;
 	int ret;
 
 	if (!handle->cpu_compressed)
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 731f08dd3099..397e94eb96ab 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -391,9 +391,9 @@ __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 						 unsigned long long *write_size,
 						 int page)
 {
-	unsigned long long rsize = 0;
-	unsigned long long wsize = 0;
-	unsigned long long size;
+	size_t rsize = 0;
+	size_t wsize = 0;
+	size_t size;
 	int ret;
 
 	if (handle->compress) {
@@ -3019,7 +3019,7 @@ unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
 	return handle->file_version;
 }
 
-unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle)
+size_t tracecmd_get_out_file_offset(struct tracecmd_output *handle)
 {
 	return do_lseek(handle, 0, SEEK_CUR);
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6b88646a2b7f..0063d528aecc 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4407,7 +4407,7 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
 		trace_seq_printf(&s, "%x %x %s\n",
 				 maps->pid, maps->nr_lib_maps, maps->proc_name);
 		for (i = 0; i < maps->nr_lib_maps; i++)
-			trace_seq_printf(&s, "%llx %llx %s\n",
+			trace_seq_printf(&s, "%zx %zx %s\n",
 					maps->lib_maps[i].start,
 					maps->lib_maps[i].end,
 					maps->lib_maps[i].lib_name);
-- 
2.45.2

