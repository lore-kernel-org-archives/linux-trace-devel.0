Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EABB2EDD53
	for <linux-trace-devel@vger.kernel.org>; Thu, 15 Oct 2026 04:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037828; cv=none; b=r4czj4XEKpKLIvhjWNAuR9dxJNRRgoHNTzbJU8rT62YffbtFc9kcSsDXE6d16CDamRLIs+Y/ucbMR+B6XoBZHxbSahKZvN2uweENKmPWGB8bstYuAQTXG7J729uoIVy1rhBwC/Jbns9CfjSbr6JOEVDMhJLGhC7pBT62o6bh6Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037828; c=relaxed/simple;
	bh=wx3hcE7Pex9jvH0tSMV8sRBXofjtbiyt3EMi6W/owwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qf701QOTVt+Nh6RAWe+birpgbEx0QDxWsugWl3r/JGYGE4K7+BmvK215jYP1iMfMWNCf0zE/scjmNpwllB5OX8sQewEu+TRGs/JckxoW5aShhGilzrwbf6ERUqbJE/dOoMSyR/kY9ZfUJF14OKF406+vgStix+jJT9REtV/pz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eoh9A50w; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eoh9A50w"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15168a20b47so3219355c88.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Oct 2026 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792037825; x=1792642625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/g4ewq8/lDPE5XXyv4LtjumcGnZkHAcYz+0q43x0tqE=;
        b=Eoh9A50wZgcI4dJoQ+qgbmH8y/rCUSLiQ2qd4cIGEDkhUbB6R2mhT3QhqWkv385dXN
         FZWHJyQhFDZQAcAyKyQZWXvY1X8/GkoWQXcMDNcmF+wCubfRyZPWtwHMs+hjgDHEtYXP
         UMRm16iq2pDhjWvmPvIuA9AcLJO2MB/NhVNKBq/t5frPGFpyiZQgnbg6f01CXpYKNOIw
         wdawP8KGShnD1lDdUnW6d+cHbx3JxE7JiZ5YXTYrtBYfheiXEukyvHqK7Ei1BTPptRt5
         JfPcB7wCLAMeDXCMkOYUJJUjc6P1ss2+NW/gMLghfgzzq7S8lF6Zw7pHsZw8rA4cV3oL
         R1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792037825; x=1792642625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/g4ewq8/lDPE5XXyv4LtjumcGnZkHAcYz+0q43x0tqE=;
        b=jiwwrfpckhztIv4B6OOpe51dCui2hIm1m56R+srt+w9kLsUe24e1OiUo3JYjBFFNDS
         y9SR2v1En6F3XBNEAzWwg6p7QODLjTBCw7fMLaA4bLJHeMM+PbROkQAKgzOC95BP//dZ
         3JGjzIifImdI+UIscSpv6SNv2eMkhloqXmNbV9dFqW+Vtqt9y9+1jtaXplVQgXYiNO/u
         j4/wOSWuJVCBYQLB8azuFhI+bOrUJlihU942Ofxji7BKGWG4lJ3j/sMBraImo5jZv+3K
         hVhkzbK+bVGx1ZtxTp2zFx72bgRjAVrmzE4/CWMdTKpbJ90gI8rsbqNyF+SWJA7lG5WD
         +F3g==
X-Gm-Message-State: AFq9FYJpSkMmW51L/sj8whzLONED2PGYJ8fwlgmAmTivn7D+3xaBW3Fx
	ysWijzvIMwuMZ2nMng14YNi0XcrKqahuHbQpAOzvTrVN1G49Af5S4w434VWu8Q==
X-Gm-Gg: AYBFou0QeoUTxisBvaE4Yr5bin5wAM1Nsp8n4i8Ez2MT0YFFC0i3mD+uKx9HvFe6zQo
	ZELS9d6uqZ1PfDhGQRQB3UJZl67ERiEey8gM+oJUoDOgLYRFBJmmxXp+ckGuu999hfQWx29v0wL
	EPeRMYisjqkpaAVO6Tl2v3G1RAzrpAFT6sfVUJ1Z3/+GxFqWTphikmOyfB7R6bEA/3vy53s981i
	7fhAUspKdZkG6m1I+oDZfthckcG6fa7DH4xSdytAFsxIggKXFsrVKbmrueHfQaRfxz0mP7kZiU3
	CiQSNjRfuF0j4Nb3R/8rTIQBoXq8B60UfgoPECMFYS5vjMz5NeY5Vr2masS5JWjlgH19a0Ulzsh
	ksPgANhnmBqO+T09+cfjCJ7qN+OiFr6I5EQz2pPqi4ewZFhQasL3nWT3z4XhGy2/Dai47X2SpQ4
	Jks+JneJHlx5qpz+f8d3rS/c+b7lzs871+KYbW1HY19J/iFGWtOyBJVUQH2cuGUu95/AOzQ4nSL
	05sImD8Jt5Bqtt1i+E8o0+howHSXqZGC8g24OUa
X-Received: by 2002:a05:7022:ea8a:b0:13e:6efa:78f7 with SMTP id a92af1059eb24-16a5dc00e99mr22217577c88.15.1792037824884;
        Wed, 14 Oct 2026 21:17:04 -0700 (PDT)
Received: from lipengfei28-ThinkStation-P368.mioffice.cn ([2408:8607:1b00:8:2ac1:5cc4:64e6:db5a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16997c21ff3sm51405213c88.2.2026.10.14.21.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 21:17:03 -0700 (PDT)
From: Li Pengfei <ljdlns1987@gmail.com>
X-Google-Original-From: Li Pengfei <lipengfei28@xiaomi.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	lipengfei28@xiaomi.com
Subject: [PATCH 1/1] trace-cmd: add streaming CPU compression
Date: Thu, 15 Oct 2026 12:16:45 +0800
Message-Id: <20261015041645.3725172-2-lipengfei28@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015041645.3725172-1-lipengfei28@xiaomi.com>
References: <20261015041645.3725172-1-lipengfei28@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "trace-cmd record --stream-compression", which compresses the per
CPU data as it is recorded instead of keeping the raw ring buffer data
on disk and compressing it at the end. This lowers the temporary disk
space needed by long recordings.

The per CPU temporary file holds a chunk count followed by the chunks,
each prefixed with its compressed and uncompressed size. The count is
only known when the recorder exits, so it is reserved up front and
filled in afterwards, which requires a seekable output. Network, guest,
agent and FIFO recorders along with the maximum buffer mode are
rejected for that reason.

The reader indexes into a decompressed chunk in units of the sub buffer
size, so a chunk holds a whole number of sub buffers rather than of
system pages. Otherwise --subbuf-size would cut chunks in the middle of
a sub buffer.

The compressor owns the output file descriptor, so the data is read
into a buffer instead of spliced, the sub buffer padding is dropped as
the chunk framing already carries the sizes, and the partial sub buffer
left behind by tracefs_cpu_write() is read out with tracefs_cpu_flush()
and fed to the compressor.

The recorder runs in its own process and the writer only sees the files
it leaves behind, so a recorder that cannot finish its stream marks the
CPU file as failed. The writer only checks how much it copied against
the file size, so without the marker it would store the compressed
bytes as raw ring buffer pages.

Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
---
 .../include/private/trace-cmd-private.h       |   7 +
 lib/trace-cmd/include/trace-cmd-local.h       |   3 +-
 lib/trace-cmd/trace-compress.c                |  67 +++++
 lib/trace-cmd/trace-output.c                  |  71 ++++-
 lib/trace-cmd/trace-recorder.c                | 281 +++++++++++++++++-
 tracecmd/trace-record.c                       |  76 ++++-
 tracecmd/trace-usage.c                        |   1 +
 7 files changed, 480 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 33fa2f80..71fef54c 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -37,6 +37,8 @@ int *tracecmd_add_id(int *list, int id, int len);
 
 #define FILE_VERSION_SECTIONS		7
 #define FILE_VERSION_COMPRESSION	7
+#define TRACE_CMD_RAW_SIZE_SUFFIX	".rawsize"
+#define TRACE_CMD_REC_ERROR_SUFFIX	".error"
 
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
@@ -364,6 +366,8 @@ struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int c
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance, int maxkb);
+int tracecmd_recorder_set_compression(struct tracecmd_recorder *recorder,
+				      const char *compression);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 int tracecmd_stop_recording(struct tracecmd_recorder *recorder);
@@ -553,6 +557,9 @@ struct tracecmd_compression *tracecmd_compress_alloc(const char *name, const cha
 						     struct tracecmd_msg_handle *msg_handle);
 void tracecmd_compress_destroy(struct tracecmd_compression *handle);
 int tracecmd_compress_block(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_start(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_block(struct tracecmd_compression *handle);
+int tracecmd_compress_stream_end(struct tracecmd_compression *handle);
 int tracecmd_uncompress_block(struct tracecmd_compression *handle);
 void tracecmd_compress_reset(struct tracecmd_compression *handle);
 ssize_t tracecmd_compress_buffer_read(struct tracecmd_compression *handle, char *dst, size_t len);
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c75055ec..c5e8491d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -10,7 +10,6 @@
 #include "trace-cmd-private.h"
 
 #define FILE_VERSION_DEFAULT		7
-
 /* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
 void tracecmd_critical(const char *fmt, ...);
@@ -94,6 +93,8 @@ struct cpu_data_source {
 	int fd;
 	ssize_t size;
 	off_t offset;
+	unsigned long long raw_size;
+	bool precompressed;
 };
 
 int tcmd_out_write_cpu_data(struct tracecmd_output *handle, int cpus,
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index fe4ab84a..588eb6a7 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -39,6 +39,8 @@ struct tracecmd_compression {
 	struct tep_handle		*tep;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+	off_t				stream_offset;
+	unsigned int			stream_chunks;
 };
 
 static ssize_t read_fd(int fd, char *dst, int len)
@@ -393,6 +395,71 @@ void *tracecmd_uncompress_buffer(struct tracecmd_compression *handle, size_t *si
 	return buffer;
 }
 
+/*
+ * A trace-cmd CPU data stream is a chunked compression block:
+ *
+ *   u32 chunk_count
+ *   repeated { u32 compressed_size, u32 uncompressed_size, data }
+ *
+ * The normal file writer can seek back after reading a complete temporary
+ * file and fill in chunk_count.  Recorders cannot do that at every read, so
+ * these helpers reserve the count and update it when the recorder exits.
+ */
+int tracecmd_compress_stream_start(struct tracecmd_compression *handle)
+{
+	unsigned int zero = 0;
+	int endian4;
+
+	if (!handle || handle->msg_handle || handle->fd < 0)
+		return -1;
+
+	handle->stream_offset = lseek(handle->fd, 0, SEEK_CUR);
+	if (handle->stream_offset == (off_t)-1)
+		return -1;
+
+	endian4 = tep_read_number(handle->tep, &zero, sizeof(zero));
+	if (write_fd(handle->fd, &endian4, sizeof(endian4)) != sizeof(endian4))
+		return -1;
+
+	handle->stream_chunks = 0;
+	return 0;
+}
+
+int tracecmd_compress_stream_block(struct tracecmd_compression *handle)
+{
+	if (!handle || !handle->pointer)
+		return -1;
+
+	if (tracecmd_compress_block(handle))
+		return -1;
+
+	handle->stream_chunks++;
+	return 0;
+}
+
+int tracecmd_compress_stream_end(struct tracecmd_compression *handle)
+{
+	unsigned int chunks;
+	off_t end;
+	int endian4;
+
+	if (!handle || handle->msg_handle || handle->fd < 0)
+		return -1;
+
+	end = lseek(handle->fd, 0, SEEK_CUR);
+	if (end == (off_t)-1 ||
+	    lseek(handle->fd, handle->stream_offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	chunks = handle->stream_chunks;
+	endian4 = tep_read_number(handle->tep, &chunks, sizeof(chunks));
+	if (write_fd(handle->fd, &endian4, sizeof(endian4)) != sizeof(endian4) ||
+	    lseek(handle->fd, end, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return 0;
+}
+
 /**
  * tracecmd_compress_buffer_write - write() to compression buffer
  * @handle: compression handle
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3ef6db6b..f83af9b1 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2746,7 +2746,8 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
-		data_files[i].file_size = data[i].size;
+		data_files[i].file_size = data[i].precompressed ?
+			data[i].raw_size : data[i].size;
 		/*
 		 * Place 0 for the data offset and size, and save the offsets to
 		 * updated them with the correct data later.
@@ -2786,11 +2787,19 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek(data[i].fd, data[i].offset, SEEK_SET) == (off_t)-1)
 				goto out_free;
-			read_size = tcmd_out_copy_fd_compress(handle, data[i].fd,
-							      data[i].size, &data_files[i].write_size,
-							      page_size);
+			if (data[i].precompressed) {
+				read_size = copy_file_fd(handle, data[i].fd,
+							 data[i].size);
+				data_files[i].write_size = read_size;
+			} else {
+				read_size = tcmd_out_copy_fd_compress(handle, data[i].fd,
+								      data[i].size,
+								      &data_files[i].write_size,
+								      page_size);
+			}
 
-			if (read_size != data_files[i].file_size) {
+			if (read_size != (data[i].precompressed ?
+					  data[i].size : data_files[i].file_size)) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %llu to %llu",
 						 read_size, data_files[i].file_size);
@@ -2818,12 +2827,14 @@ __hidden int tcmd_out_write_cpu_data(struct tracecmd_output *handle,
 				goto out_free;
 		}
 		if (!tracecmd_get_quiet(handle)) {
-			fprintf(stderr, "    %llu bytes in size",
-				(unsigned long long)data_files[i].write_size);
-			if (handle->compress)
-				fprintf(stderr, " (%llu uncompressed)",
+			if (handle->compress) {
+				fprintf(stderr, "    %llu bytes stored (%llu uncompressed)\n",
+					(unsigned long long)data_files[i].write_size,
 					(unsigned long long)data_files[i].file_size);
-			fprintf(stderr, "\n");
+			} else {
+				fprintf(stderr, "    %llu bytes in size\n",
+					(unsigned long long)data_files[i].write_size);
+			}
 		}
 	}
 
@@ -2869,6 +2880,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		return -1;
 
 	for (i = 0; i < cpus; i++) {
+		char *raw_size_file;
+		int raw_fd;
+		unsigned long long raw_size;
+
 		ret = stat(cpu_data_files[i], &st);
 		if (ret < 0) {
 			tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
@@ -2882,6 +2897,42 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 		data[i].size = st.st_size;
 		data[i].offset = 0;
+		data[i].precompressed = false;
+		data[i].raw_size = 0;
+		if (asprintf(&raw_size_file, "%s%s", cpu_data_files[i],
+			     TRACE_CMD_RAW_SIZE_SUFFIX) >= 0) {
+			char *error_file;
+
+			/*
+			 * A recorder that failed to finish its compressed
+			 * stream leaves this marker behind.  The data cannot be
+			 * used, and reading it as raw ring buffer pages would
+			 * pass the size check below and store garbage.
+			 */
+			if (asprintf(&error_file, "%s%s", raw_size_file,
+				     TRACE_CMD_REC_ERROR_SUFFIX) >= 0) {
+				bool failed = !access(error_file, F_OK);
+
+				free(error_file);
+				if (failed) {
+					tracecmd_warning("CPU%d compressed recording failed", i);
+					free(raw_size_file);
+					close(data[i].fd);
+					errno = EIO;
+					break;
+				}
+			}
+			raw_fd = open(raw_size_file, O_RDONLY);
+			free(raw_size_file);
+			if (raw_fd >= 0 &&
+			    read(raw_fd, &raw_size, sizeof(raw_size)) ==
+			    sizeof(raw_size)) {
+				data[i].precompressed = true;
+				data[i].raw_size = raw_size;
+			}
+			if (raw_fd >= 0)
+				close(raw_fd);
+		}
 		size += st.st_size;
 	}
 
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 6f146bb6..afcdc0d7 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -10,6 +10,8 @@
 #include <poll.h>
 #include <unistd.h>
 #include <errno.h>
+#include <stdint.h>
+#include <string.h>
 
 #include "tracefs.h"
 #include "trace-cmd-private.h"
@@ -43,8 +45,18 @@ struct tracecmd_recorder {
 	int		pages;
 	int		count;
 	unsigned	flags;
+	char		*buf;
+	struct tracecmd_compression *compress;
+	struct tep_handle *compress_tep;
+	size_t		compress_block_size;
+	size_t		compress_pending;
+	unsigned long long	raw_size;
+	char		*raw_size_file;
+	bool		stream_compression;
 };
 
+#define TRACE_RECORD_COMPRESS_PAGES	10
+
 static int append_file(int size, int dst, int src)
 {
 	char buf[size];
@@ -64,8 +76,30 @@ static int append_file(int size, int dst, int src)
 	return 0;
 }
 
+/*
+ * Leave a marker telling the writer that this CPU file is not usable.  The
+ * recorder runs in its own process and the writer only sees the files it
+ * leaves behind, so the failure has to be recorded on disk.
+ */
+static void mark_stream_error(struct tracecmd_recorder *recorder)
+{
+	char *file;
+	int fd;
+
+	if (asprintf(&file, "%s%s", recorder->raw_size_file,
+		     TRACE_CMD_REC_ERROR_SUFFIX) < 0)
+		return;
+
+	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (fd >= 0)
+		close(fd);
+	free(file);
+}
+
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 {
+	bool stream_failed = false;
+
 	if (!recorder)
 		return;
 
@@ -89,7 +123,49 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 		}
 		append_file(recorder->page_size, recorder->fd1, recorder->fd2);
 	}
+	if (recorder->compress) {
+		if (recorder->compress_pending &&
+		    tracecmd_compress_stream_block(recorder->compress))
+			stream_failed = true;
+		if (tracecmd_compress_stream_end(recorder->compress))
+			stream_failed = true;
+		tracecmd_compress_destroy(recorder->compress);
+	}
+	/*
+	 * The marker file tells the writer that this CPU file holds compressed
+	 * chunks and how much raw data went into them.  Without it the writer
+	 * would read the compressed bytes as raw ring buffer pages, so a
+	 * failure to produce it has to be reported explicitly.  The writer only
+	 * compares how much it copied against the file size, which a truncated
+	 * compressed file would still pass.
+	 */
+	if (recorder->stream_compression && recorder->raw_size_file) {
+		int fd = -1;
+
+		if (!stream_failed) {
+			fd = open(recorder->raw_size_file,
+				  O_WRONLY | O_CREAT | O_TRUNC, 0644);
+			if (fd >= 0) {
+				uint64_t size = recorder->raw_size;
+
+				if (write(fd, &size, sizeof(size)) !=
+				    sizeof(size)) {
+					unlink(recorder->raw_size_file);
+					stream_failed = true;
+				}
+				close(fd);
+			} else {
+				stream_failed = true;
+			}
+		}
+		if (stream_failed)
+			mark_stream_error(recorder);
+	}
+	if (recorder->compress_tep)
+		tep_free(recorder->compress_tep);
+	free(recorder->raw_size_file);
  close:
+	free(recorder->buf);
 	tracefs_cpu_close(recorder->tcpu);
 
 	if (recorder->fd1 >= 0)
@@ -101,6 +177,69 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	free(recorder);
 }
 
+int tracecmd_recorder_set_compression(struct tracecmd_recorder *recorder,
+				      const char *compression)
+{
+	const char *name = compression;
+
+	if (!recorder || recorder->compress) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (recorder->max) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (!name || !strcmp(name, "any"))
+		name = NULL;
+	if (!name || strcmp(name, "none")) {
+		recorder->compress_tep = tep_alloc();
+		if (!recorder->compress_tep) {
+			errno = ENOMEM;
+			return -1;
+		}
+		tep_set_file_bigendian(recorder->compress_tep,
+				       tracecmd_host_bigendian());
+		recorder->compress = tracecmd_compress_alloc(
+			name, NULL, recorder->fd, recorder->compress_tep, NULL);
+		if (!recorder->compress) {
+			errno = ENOTSUP;
+			goto fail;
+		}
+		/*
+		 * The reader indexes into a decompressed chunk in units of
+		 * the sub buffer size, so chunks must be a whole number of
+		 * sub buffers.  Using the system page size here would cut
+		 * chunks in the middle of a sub buffer whenever the tracing
+		 * sub buffer is larger (see "trace-cmd record --subbuf-size").
+		 */
+		recorder->compress_block_size =
+			TRACE_RECORD_COMPRESS_PAGES * recorder->subbuf_size;
+		/* Not every failure path of the helper sets errno */
+		errno = 0;
+		if (tracecmd_compress_stream_start(recorder->compress)) {
+			if (!errno)
+				errno = EIO;
+			goto fail;
+		}
+		/*
+		 * The compressor owns the output file descriptor, so the data
+		 * has to be read into a buffer before it can be compressed.
+		 * Splicing it straight into the file would bypass the
+		 * compressor and corrupt the stream.
+		 */
+		recorder->flags |= TRACECMD_RECORD_NOSPLICE;
+		recorder->stream_compression = true;
+	}
+	return 0;
+fail:
+	tracecmd_compress_destroy(recorder->compress);
+	recorder->compress = NULL;
+	tep_free(recorder->compress_tep);
+	recorder->compress_tep = NULL;
+	return -1;
+}
+
 static int set_nonblock(struct tracecmd_recorder *recorder)
 {
 	return tracefs_cpu_stop(recorder->tcpu);
@@ -113,7 +252,7 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	struct tracecmd_recorder *recorder;
 	bool nonblock = false;
 
-	recorder = malloc(sizeof(*recorder));
+	recorder = calloc(1, sizeof(*recorder));
 	if (!recorder)
 		return NULL;
 
@@ -153,6 +292,16 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		goto out_free;
 
 	recorder->subbuf_size = tracefs_cpu_read_size(recorder->tcpu);
+
+	/*
+	 * The sub buffer size is set by the kernel and can be megabytes with
+	 * "trace-cmd record --subbuf-size".  Keep it off the stack, as the
+	 * read and the flush paths would otherwise nest several of them.
+	 */
+	recorder->buf = malloc(recorder->subbuf_size);
+	if (!recorder->buf)
+		goto out_free;
+
 	return recorder;
 
  out_free:
@@ -212,6 +361,28 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 		if (fd2 != -1)
 			close(fd2);
 	}
+	if (recorder) {
+		if (asprintf(&recorder->raw_size_file, "%s%s", file,
+			     TRACE_CMD_RAW_SIZE_SUFFIX) < 0) {
+			tracecmd_free_recorder(recorder);
+			recorder = NULL;
+		} else {
+			char *error_file;
+
+			/*
+			 * Stale markers from an interrupted streaming run must
+			 * never make a later raw recording look precompressed,
+			 * nor make it look like it failed.
+			 */
+			unlink(recorder->raw_size_file);
+			if (asprintf(&error_file, "%s%s",
+				     recorder->raw_size_file,
+				     TRACE_CMD_REC_ERROR_SUFFIX) >= 0) {
+				unlink(error_file);
+				free(error_file);
+			}
+		}
+	}
 
 	if (fd2 != -1) {
 		/* Unlink file2, we need to add everything to file at the end */
@@ -343,10 +514,51 @@ static inline void update_fd(struct tracecmd_recorder *recorder, int size)
  * Returns -1 on error.
  *          or bytes of data read.
  */
+static long compress_data(struct tracecmd_recorder *recorder, const char *buf, long r)
+{
+	size_t done = 0;
+
+	while (done < (size_t)r) {
+		size_t space = recorder->compress_block_size -
+			recorder->compress_pending;
+		size_t size = (size_t)r - done;
+
+		if (size > space)
+			size = space;
+		/*
+		 * The compression helpers do not set errno on every failure
+		 * path.  The callers check errno to decide whether a negative
+		 * return is retryable, so clear it first.  A leftover EINTR
+		 * would make the caller retry a read that cannot be repeated,
+		 * as the data is already out of the ring buffer.
+		 */
+		errno = 0;
+		if (tracecmd_compress_buffer_write(recorder->compress,
+						   buf + done, size))
+			goto fail;
+		done += size;
+		recorder->compress_pending += size;
+		recorder->raw_size += size;
+		if (recorder->compress_pending ==
+		    recorder->compress_block_size) {
+			errno = 0;
+			if (tracecmd_compress_stream_block(recorder->compress))
+				goto fail;
+			recorder->compress_pending = 0;
+		}
+	}
+
+	return r;
+fail:
+	if (!errno)
+		errno = EIO;
+	return -1;
+}
+
 static long read_data(struct tracecmd_recorder *recorder)
 {
 	bool nonblock = recorder->stop;
-	char buf[recorder->subbuf_size];
+	char *buf = recorder->buf;
 	long left;
 	long r, w;
 
@@ -354,6 +566,9 @@ static long read_data(struct tracecmd_recorder *recorder)
 	if (r < 0)
 		return r;
 
+	if (recorder->compress)
+		return compress_data(recorder, buf, r);
+
 	left = r;
 	do {
 		w = write(recorder->fd, buf + (r - left), left);
@@ -396,9 +611,34 @@ static long move_data(struct tracecmd_recorder *recorder)
 	return ret;
 }
 
+/*
+ * Read out the remaining data of the ring buffer.
+ *
+ * tracefs_cpu_write() splices whole sub buffers only and leaves a partial
+ * tail behind, which is why flushing has to go through tracefs_cpu_flush().
+ *
+ * Returns the number of bytes flushed, or negative on error.
+ */
+static long flush_data(struct tracecmd_recorder *recorder)
+{
+	long ret;
+
+	if (!recorder->compress)
+		return tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+
+	/*
+	 * A streaming compressor owns the output fd, so the data cannot be
+	 * written to it directly.  Read it out and feed the compressor.
+	 */
+	ret = tracefs_cpu_flush(recorder->tcpu, recorder->buf);
+	if (ret <= 0)
+		return ret;
+
+	return compress_data(recorder, recorder->buf, ret);
+}
+
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish)
 {
-	char buf[recorder->subbuf_size];
 	long total = 0;
 	long wrote = 0;
 	long ret;
@@ -407,24 +647,43 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder, bool finish)
 		return 0;
 
 	if (!finish)
-		return tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+		return flush_data(recorder);
 
 	set_nonblock(recorder);
 
 	do {
-		ret = tracefs_cpu_flush_write(recorder->tcpu, recorder->fd);
+		ret = flush_data(recorder);
 		if (ret > 0)
 			wrote += ret;
 	} while (ret > 0);
 
-	/* Make sure we finish off with a page size boundary */
-	wrote &= recorder->subbuf_size - 1;
-	if (wrote) {
-		memset(buf, 0, recorder->subbuf_size);
-		write(recorder->fd, buf, recorder->subbuf_size - wrote);
-		total += recorder->subbuf_size;
+	/*
+	 * The sub buffer padding is part of the raw recording format.  With a
+	 * streaming compressor the recorded bytes are already in its input
+	 * buffer and the chunk framing keeps track of the sizes, so writing
+	 * padding here is both unnecessary and would corrupt the stream.
+	 */
+	if (!recorder->compress) {
+		int err = errno;
+
+		wrote &= recorder->subbuf_size - 1;
+		if (wrote) {
+			memset(recorder->buf, 0, recorder->subbuf_size);
+			write(recorder->fd, recorder->buf,
+			      recorder->subbuf_size - wrote);
+			total += recorder->subbuf_size;
+		}
+		/* The padding write must not hide why the flush failed */
+		errno = err;
 	}
 
+	/*
+	 * Report the failure only after the recording has been padded, so that
+	 * the output is left in the same state as after a successful flush.
+	 */
+	if (ret < 0)
+		return ret;
+
 	return total;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e7bb2f58..73cdd3bc 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -140,6 +140,9 @@ struct event_list {
 
 struct tracecmd_event_list *listed_events;
 
+static bool stream_compression;
+static const char *recorder_compression;
+
 struct events {
 	struct events *sibling;
 	struct events *children;
@@ -207,6 +210,7 @@ struct common_record_context {
 	char *user;
 	const char *clock;
 	const char *compression;
+	bool stream_compression;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -608,6 +612,17 @@ static void delete_temp_file(struct buffer_instance *instance, int cpu)
 	else
 		snprintf(file, PATH_MAX, "%s.cpu%d", output_file, cpu);
 	unlink(file);
+	{
+		char raw_size_file[PATH_MAX];
+		char error_file[PATH_MAX];
+
+		snprintf(raw_size_file, sizeof(raw_size_file), "%s%s",
+			 file, TRACE_CMD_RAW_SIZE_SUFFIX);
+		snprintf(error_file, sizeof(error_file), "%s%s",
+			 raw_size_file, TRACE_CMD_REC_ERROR_SUFFIX);
+		unlink(raw_size_file);
+		unlink(error_file);
+	}
 }
 
 static int kill_thread_instance(int start, struct buffer_instance *instance)
@@ -3589,6 +3604,8 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 			die("Failed to connect to agent");
 
 		flags = recorder_flags;
+		if (stream_compression)
+			flags |= TRACECMD_RECORD_NOSPLICE;
 		if (instance->use_fifos)
 			flags |= TRACECMD_RECORD_NOBRASS;
 		else if (!tcmd_vsock_can_splice_read())
@@ -3599,11 +3616,20 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	if (brass)
 		return create_recorder_instance_pipe(instance, cpu, brass);
 
-	if (!tracefs_instance_get_name(instance->tracefs))
-		return tracecmd_create_recorder_maxkb(file, cpu, recorder_flags, max_kb);
+	if (!tracefs_instance_get_name(instance->tracefs)) {
+		unsigned flags = recorder_flags;
+		if (stream_compression)
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		return tracecmd_create_recorder_maxkb(file, cpu, flags, max_kb);
+	}
 
-	record = tracecmd_create_buffer_recorder_maxkb(file, cpu, recorder_flags,
+	{
+		unsigned flags = recorder_flags;
+		if (stream_compression)
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		record = tracecmd_create_buffer_recorder_maxkb(file, cpu, flags,
 						       instance->tracefs, max_kb);
+	}
 	return record;
 }
 
@@ -3644,6 +3670,8 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	if ((instance->client_ports && !is_guest(instance)) || is_agent(instance)) {
 		unsigned int flags = recorder_flags;
 		int fd;
+		if (stream_compression)
+			flags |= TRACECMD_RECORD_NOSPLICE;
 
 		if (is_agent(instance)) {
 			if (instance->use_fifos)
@@ -3677,6 +3705,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 
 	if (!recorder)
 		die ("can't create recorder");
+	if (stream_compression &&
+	    tracecmd_recorder_set_compression(recorder, recorder_compression))
+		die("can't enable streaming compression");
 
 	if (type == TRACE_TYPE_EXTRACT) {
 		ret = tracecmd_flush_recording(recorder, true);
@@ -4291,6 +4322,31 @@ static void start_threads(enum trace_type type, struct common_record_context *ct
 	int i = 0;
 	int ret;
 
+	if (ctx->stream_compression) {
+		if (ctx->compression && !strcmp(ctx->compression, "none"))
+			die("--stream-compression requires compression support");
+		if (ctx->file_version && ctx->file_version < FILE_VERSION_COMPRESSION)
+			die("--stream-compression requires file version %d or newer",
+			    FILE_VERSION_COMPRESSION);
+		if (max_kb)
+			die("--stream-compression cannot be used with -m");
+		if (!ctx->compression)
+			ctx->compression = "any";
+		/*
+		 * The recorder reserves and later patches the chunk count in each
+		 * CPU temporary file.  Network, guest, agent and FIFO recorders
+		 * are not seekable, so silently enabling this mode there would
+		 * create an invalid compressed stream.
+		*/
+		for_all_instances(instance) {
+			if (host || is_guest(instance) || is_agent(instance) ||
+			    instance->client_ports || instance->use_fifos)
+				die("--stream-compression is supported only for local "
+				    "seekable CPU files");
+		}
+	}
+	stream_compression = ctx->stream_compression;
+	recorder_compression = ctx->compression;
 	for_all_instances(instance) {
 		/* Start the connection now to find out how many CPUs we need */
 		if (is_guest(instance))
@@ -4824,7 +4880,8 @@ static void record_data(struct common_record_context *ctx)
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
-		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
+		if (tracecmd_append_cpu_data(handle, local_cpu_count, temp_files) < 0)
+			die("Writing CPU data");
 
 		for (i = 0; i < max_cpu_count; i++)
 			put_temp_file(temp_files[i]);
@@ -6033,6 +6090,7 @@ enum {
 	OPT_notimeout		= LONG_OPT(26),
 	OPT_daemonize		= LONG_OPT(27),
 	OPT_subbuf		= LONG_OPT(28),
+	OPT_stream_compression	= LONG_OPT(29),
 };
 
 void trace_stop(int argc, char **argv)
@@ -6506,6 +6564,7 @@ static void parse_record_options(int argc,
 			{"temp", required_argument, NULL, OPT_temp},
 			{"subbuf-size", required_argument, NULL, OPT_subbuf},
 			{"daemonize", no_argument, NULL, OPT_daemonize},
+			{"stream-compression", no_argument, NULL, OPT_stream_compression},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -7019,6 +7078,15 @@ static void parse_record_options(int argc,
 				die("Compression algorithm  %s is not supported", optarg);
 			ctx->compression = strdup(optarg);
 			break;
+		case OPT_stream_compression:
+			cmd_check_die(ctx, CMD_extract, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_stream, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_profile, *(argv+1), "--stream-compression");
+			cmd_check_die(ctx, CMD_record_agent, *(argv+1), "--stream-compression");
+			ctx->stream_compression = true;
+			break;
 		case OPT_file_ver:
 			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)
 				die("--file_version has no effect with the command %s\n",
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index e7b32f80..6cfd330d 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -81,6 +81,7 @@ static struct usage_help usage_help[] = {
 		"                            none - do not compress the trace file\n"
 		"                            name - the name of the desired compression algorithms\n"
 		"                        available algorithms can be listed with trace-cmd list -c\n"
+		"          --stream-compression compress each CPU trace block while recording\n"
 		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
 		"              but will send the proxy connection to the agent.\n"
 		"          --daemonize run trace-cmd in the background as a daemon after recording has started.\n"
-- 
2.34.1

