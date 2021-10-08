Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E926C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C8C60F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhJHERU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbhJHERR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:17:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629B9C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:15:22 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b8so31179080edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rn0mxZUf/r0znZB9xRa9srUG8kTvpIic8xAnRRN/dyQ=;
        b=T7+/32EjLg6sdx+HT/gm0OOVxnuQjbBBpneJM98P4TEZBDY4//tuMPQ/RU0r+GETVE
         FMuc2lOnt9P02gTU2sOY+Egmyp4jbGrm9vDrL7CB4DCblEsg3O9QVt98kUXG3cFAAQ2I
         UwiPH4VogNqOFM/Ee+PGBZ5VxyAFSLqBCjzzbEYYqZBvE/Reu2vg0R7SFnH7mjBLPuGd
         DZjMUwXro6dI1niNKzVeeh68VoqTLuRg1CuSqR6VIJJeOgxy6bH3g3d8UXjgqU/dver4
         KyJqFtpOHzgHaLyLPdvwLMoDf82tHdFAiZkfKd2Bgwsup0CH9yml6AH73mP2xLXLpg5V
         yvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rn0mxZUf/r0znZB9xRa9srUG8kTvpIic8xAnRRN/dyQ=;
        b=bOLKvzz4BOBbVrwONQUbAkLj2YsmUGKVVGTVxTBQErtLTbEGJjuxSNQ+m2y/2Y8/CW
         dzRbVyHyUA9brigqkisyp6PIeh3afdmNa72v4vZGjuzHltqmyrWnb+JoSPG2xXGr83j8
         0S6PRTkAJyGIffGMaO3m7AKa/oBjjV1ZdezCXrt4ReUGPnW9YuYvG7vUkC5gKMYCiUxh
         euKmcm7A5azDCvNDsMui02CRjJXI1AGGcvi8lwWDBol+pLgr43cJ/vub+E4MoPfqGof8
         nMkJRoBRp1MmBMNiQz5ExmOXRSh5OZoQ2Ol7IRUF1IPOk/G096cILftGEtahc+iFelqE
         bfvw==
X-Gm-Message-State: AOAM533OlGlLa8js/AX86I83+Y6yzEsE/SmNssBc4mcuZbB3nwE3SadY
        mCLZXgbG7qvNhSszt4vPSabkPcfuXpbqfA==
X-Google-Smtp-Source: ABdhPJwUTCEu2OfL2KGihQDAEQ/fKyoOBISM6a840oOKSC/DuYTUTmDpuHlgKk8Bayl8DFW3CweOAA==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr1240227ejg.548.1633666520951;
        Thu, 07 Oct 2021 21:15:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w15sm459614ejb.4.2021.10.07.21.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:15:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd library: Refactor the logic for writing trace data in the file
Date:   Fri,  8 Oct 2021 07:15:14 +0300
Message-Id: <20211008041514.974537-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041514.974537-1-tz.stoyanov@gmail.com>
References: <20211008041514.974537-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for upcoming trace file format changes and data compression.
The size and the offset of the trace data is saved in the file right
after the data is written. The old logic calculates the size and offset
in advance, but when the trace data is compressed it is hard to use
that approach.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   6 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 ++
 lib/trace-cmd/trace-output.c                  | 207 ++++++++++--------
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-record.c                       |   4 +-
 5 files changed, 137 insertions(+), 101 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ed41f937..97cd82f8 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -303,13 +303,11 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file);
 
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
-			    int cpus, char * const *cpu_data_files);
+			    int cpus, char * const *cpu_data_files, const char *buff_name);
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files);
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    struct tracecmd_option *option,
-				    int cpus, char * const *cpu_data_files);
-
+				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 
 /* --- Reading the Fly Recorder Trace --- */
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 7f3b45a8..a0d6f0a6 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -31,7 +31,26 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+struct data_file_write {
+	unsigned long long	file_size;
+	unsigned long long	write_size;
+	/* offset in the trace file, where write_size is stored */
+	unsigned long long	file_write_size;
+	unsigned long long	data_offset;
+	/* offset in the trace file, where data_offset is stored */
+	unsigned long long	file_data_offset;
+};
+
 bool check_file_state(unsigned long file_version, int current_state, int new_state);
 bool check_out_state(struct tracecmd_output *handle, int new_state);
 
+struct cpu_data_source {
+	int fd;
+	int size;
+	off64_t offset;
+};
+
+int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
+		       struct cpu_data_source *data, const char *buff_name);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 17607b93..248e633f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1555,17 +1555,14 @@ static char *get_clock(struct tracecmd_output *handle)
 	return handle->trace_clock;
 }
 
-int tracecmd_write_cpu_data(struct tracecmd_output *handle,
-			    int cpus, char * const *cpu_data_files)
+__hidden int out_write_cpu_data(struct tracecmd_output *handle,
+				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
-	off64_t *offsets = NULL;
-	unsigned long long *sizes = NULL;
-	off64_t offset;
+	struct data_file_write *data_files = NULL;
+	tsize_t data_offs, offset;
 	unsigned long long endian8;
-	char *clock = NULL;
-	off64_t check_size;
-	char *file;
-	struct stat st;
+	unsigned long long read_size;
+	char *clock;
 	int ret;
 	int i;
 
@@ -1580,97 +1577,142 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 	}
 
+	data_offs = lseek64(handle->fd, 0, SEEK_CUR);
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
-	offsets = malloc(sizeof(*offsets) * cpus);
-	if (!offsets)
-		goto out_free;
-	sizes = malloc(sizeof(*sizes) * cpus);
-	if (!sizes)
+	data_files = calloc(cpus, sizeof(*data_files));
+	if (!data_files)
 		goto out_free;
 
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	/* hold any extra data for data */
-	offset += cpus * (16);
-
-	/*
-	 * Unfortunately, the trace_clock data was placed after the
-	 * cpu data, and wasn't accounted for with the offsets.
-	 * We need to save room for the trace_clock file. This means
-	 * we need to find the size of it before we define the final
-	 * offsets.
-	 */
-	clock = get_clock(handle);
-	if (!clock)
-		goto out_free;
-	/* Save room for storing the size */
-	offset += 8;
-	offset += strlen(clock);
-	/* 2 bytes for [] around the clock */
-	offset += 2;
-
-	/* Page align offset */
-	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
-
 	for (i = 0; i < cpus; i++) {
-		file = cpu_data_files[i];
-		ret = stat(file, &st);
-		if (ret < 0) {
-			tracecmd_warning("can not stat '%s'", file);
-			goto out_free;
-		}
-		offsets[i] = offset;
-		sizes[i] = st.st_size;
-		offset += st.st_size;
-		offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
-
-		endian8 = convert_endian_8(handle, offsets[i]);
+		data_files[i].file_size = data[i].size;
+		/*
+		 * Place 0 for the data offset and size, and save the offsets to
+		 * updated them with the correct data later.
+		 */
+		endian8 = 0;
+		data_files[i].file_data_offset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		endian8 = convert_endian_8(handle, sizes[i]);
+		data_files[i].file_write_size = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
 
-	if (save_clock(handle, clock))
+	update_buffer_cpu_offset(handle, buff_name, data_offs);
+	clock = get_clock(handle);
+	if (clock && save_clock(handle, clock))
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
+		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		/* Page align offset */
+		data_files[i].data_offset += handle->page_size - 1;
+		data_files[i].data_offset &= !(handle->page_size - 1);
+
+		ret = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);
+		if (ret == (off64_t)-1)
+			goto out_free;
+
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
-				i, (unsigned long long) offsets[i]);
-		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
-		if (offset == (off64_t)-1) {
-			tracecmd_warning("could not seek to %lld\n", offsets[i]);
-			goto out_free;
+				i, (unsigned long long)data_files[i].data_offset);
+
+		if (data[i].size) {
+			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
+				goto out_free;
+			read_size = copy_file_fd(handle, data[i].fd);
+			if (read_size != data_files[i].file_size) {
+				errno = EINVAL;
+				tracecmd_warning("did not match size of %lld to %lld",
+						 read_size, data_files[i].file_size);
+				goto out_free;
+			}
+			data_files[i].write_size = read_size;
+		} else {
+			data_files[i].write_size = 0;
 		}
-		check_size = copy_file(handle, cpu_data_files[i]);
-		if (check_size != sizes[i]) {
-			errno = EINVAL;
-			tracecmd_warning("did not match size of %lld to %lld",
-					 check_size, sizes[i]);
+
+		/* Write the real CPU data offset in the file */
+		if (lseek64(handle->fd, data_files[i].file_data_offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
-		}
+		endian8 = convert_endian_8(handle, data_files[i].data_offset);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+
+		/* Write the real CPU data size in the file */
+		if (lseek64(handle->fd, data_files[i].file_write_size, SEEK_SET) == (off64_t)-1)
+			goto out_free;
+		endian8 = convert_endian_8(handle, data_files[i].write_size);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+
+		offset = data_files[i].data_offset + data_files[i].write_size;
+		if (lseek64(handle->fd, offset, SEEK_SET) == (off64_t)-1)
+			goto out_free;
+
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
-				(unsigned long long)check_size);
+				(unsigned long long)data_files[i].write_size);
 	}
 
-	free(offsets);
-	free(sizes);
+	free(data_files);
+	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
+		return -1;
 
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
 
  out_free:
-	free(offsets);
-	free(sizes);
+	lseek64(handle->fd, 0, SEEK_END);
+	free(data_files);
 	return -1;
 }
 
+int tracecmd_write_cpu_data(struct tracecmd_output *handle,
+			    int cpus, char * const *cpu_data_files, const char *buff_name)
+{
+	struct cpu_data_source *data;
+	struct stat st;
+	int size = 0;
+	int ret;
+	int i;
+
+	data = calloc(cpus, sizeof(struct cpu_data_source));
+	if (!data)
+		return -1;
+
+	for (i = 0; i < cpus; i++) {
+		ret = stat(cpu_data_files[i], &st);
+		if (ret < 0) {
+			tracecmd_warning("can not stat '%s'", cpu_data_files[i]);
+			break;
+		}
+		data[i].fd = open(cpu_data_files[i], O_RDONLY);
+		if (data[i].fd < 0) {
+			tracecmd_warning("Can't read '%s'", data[i].fd);
+			break;
+		}
+
+		data[i].size = st.st_size;
+		data[i].offset = 0;
+		size += st.st_size;
+	}
+
+	if (i < cpus)
+		ret = -1;
+	else
+		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+
+	for (i--; i >= 0; i--)
+		close(data[i].fd);
+
+	free(data);
+	return ret;
+}
+
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files)
 {
@@ -1686,36 +1728,13 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	if (ret)
 		return ret;
 
-	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
+	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files, NULL);
 }
 
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    struct tracecmd_option *option,
-				    int cpus, char * const *cpu_data_files)
+				    const char *name, int cpus, char * const *cpu_data_files)
 {
-	tsize_t offset;
-	stsize_t ret;
-
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	/* Go to the option data, where will write the offest */
-	ret = lseek64(handle->fd, option->offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", option->offset);
-		return -1;
-	}
-
-	if (do_write_check(handle, &offset, 8))
-		return -1;
-
-	/* Go back to end of file */
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", offset);
-		return -1;
-	}
-
-	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
+	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files, name);
 }
 
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 0cb70b7d..45ba1211 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -610,7 +610,7 @@ static int put_together_file(int cpus, int ofd, const char *node,
 		if (ret)
 			goto out;
 	}
-	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
+	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, NULL);
 
 out:
 	tracecmd_output_close(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c96dcda0..3a84e116 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4196,7 +4196,7 @@ static void append_buffer(struct tracecmd_output *handle,
 			touch_file(temp_files[i]);
 	}
 
-	tracecmd_append_buffer_cpu_data(handle, NULL,
+	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
 					cpu_count, temp_files);
 
 	for (i = 0; i < instance->cpu_count; i++) {
@@ -4446,7 +4446,7 @@ static void write_guest_file(struct buffer_instance *instance)
 			die("failed to allocate memory");
 	}
 
-	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
+	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, NULL) < 0)
 		die("failed to write CPU data");
 	tracecmd_output_close(handle);
 
-- 
2.31.1

