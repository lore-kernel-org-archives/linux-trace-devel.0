Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B23C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3285361019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhG1NdU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236648AbhG1NdT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:19 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4782C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:16 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id oz16so4626252ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7eGoJv2/n5lyjdn2ZhXX0ZZ+CJ/XTo0Lh80addD9KgI=;
        b=b1b1kxXr4gpVQu7V6iCKH7Xe/46Bq1vZ3NFT6yRDvIqb4iqjhAPgg4fyrOPc6odABi
         TBUwNG3QLlArBWJZmlBkzCwf5lRKPkLoB8UtIuP4LMAc2zsRHctKrhLpjgVqExCMknu9
         cWfAk85AKxpy8lHcH4XtNJ/T9wxITCCiEtcEDqO6ax4/e+aT8WM/eOPPtrNAuENJJi1S
         czJqzW7R6Hbslk9cxW+cyMdzQ+1WdZS4cX+wFBz4Ac1mIGyCoB2Hly9hiy2WKemQ4ToT
         ejkMvjNP0cwIP99v1CzzyIVTp6tkNN7pGchmfN1B51xell6U2UGBT+2nrAzoc7qCHr99
         mj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7eGoJv2/n5lyjdn2ZhXX0ZZ+CJ/XTo0Lh80addD9KgI=;
        b=o41WnmSSazObJIAZ/iVQcSjbs/+aKmunk5NZK8JAGNyHN/bZ5eIil4i4AIZMbb+bX5
         1Yugk4fU3o9wOaxh9Ne5q82cUJvI0Ix2dgl7lLHKa/7weX7emfNrQONIsM82CoRz0Oz/
         3QdO/ZDaqMMTwlOGbvnWktedtrjRAs44NqmTQGiDrRHJCMQwJYanosBACuWNO+eiAnxB
         DymCcz/eZgF23b9bvaZTX+a8eKmPYxofPDiWINjedoF6hjxX89c2iQatbOA45d2a1AJl
         UG0ARe/TH+3Dm7m5/0YBdtLLHtsOlidd5eKDdDBUTwT6OqXhzfFfISdtd2I+tEZQpSEj
         gXgw==
X-Gm-Message-State: AOAM533cUtq1m/YHxLHZ2z6f1tEZILR+x1XUKFoZVR4zbHR5WL12LbF7
        38441NZrJsRodKuTZNnL4nl8npI9C/gElA==
X-Google-Smtp-Source: ABdhPJz+HQPxtZfxxaEHVrMhEbqRZsxjJhTuC7UNAOgIpQ+UgpZM30+UNNPuDhFPaa2pW/b0jYo0Mw==
X-Received: by 2002:a17:906:4d94:: with SMTP id s20mr15917328eju.152.1627479195202;
        Wed, 28 Jul 2021 06:33:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 23/87] trace-cmd library: Refactor the logic for writing trace data in the file
Date:   Wed, 28 Jul 2021 16:31:46 +0300
Message-Id: <20210728133250.234140-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trace buffer data are written in the trace file, the buffer
option in the file metadata is updated with the file offset of the
tracing data. Hide this logic into the trace-cmd library.
Added new APIs:
 tracecmd_add_buffer_info()
 tracecmd_write_buffer_info()
Changed APIs:
 tracecmd_append_buffer_cpu_data()
Removed APIs:
 tracecmd_add_buffer_option()

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for adding trace data compression. The size and the offset
of the trace data is saved in the file right after the data is written.
The old logic calculates the size and offset in advance, but when the
trace data is compressed it is hard to use that approach.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  10 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  16 +
 lib/trace-cmd/trace-output.c                  | 314 ++++++++++++------
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-record.c                       |  18 +-
 5 files changed, 240 insertions(+), 120 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index b193d6de..4e718c40 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -305,8 +305,8 @@ struct tracecmd_option *
 tracecmd_add_option_v(struct tracecmd_output *handle,
 		      unsigned short id, const struct iovec *vector, int count);
 
-struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
-						   const char *name, int cpus);
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus);
+int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
@@ -318,13 +318,11 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
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
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 6b2350f9..0474a81d 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -24,6 +24,14 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+struct data_file_write {
+	unsigned long long	file_size;
+	unsigned long long	write_size;
+	unsigned long long	soffset;
+	unsigned long long	data_offset;
+	unsigned long long	doffset;
+};
+
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
@@ -47,6 +55,14 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 			 char *description, enum tracecmd_section_flags flags, bool option);
 int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
+struct cpu_data_source {
+	int fd;
+	int size;
+	off64_t offset;
+};
+
+int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
+		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
 
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ff937c99..d0090790 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -39,6 +39,14 @@ struct tracecmd_option {
 	struct list_head list;
 };
 
+struct tracecmd_buffer {
+	int				cpus;
+	void				*name;
+	tsize_t				offset;
+	struct tracecmd_option		*option;
+	struct list_head		list;
+};
+
 enum {
 	OUTPUT_FL_SEND_META	= (1 << 0),
 };
@@ -61,6 +69,7 @@ struct tracecmd_output {
 	struct tracecmd_compression *compress;
 
 	struct list_head	options;
+	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
 };
@@ -201,6 +210,7 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle)
 void tracecmd_output_free(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *option;
+	struct tracecmd_buffer *buffer;
 
 	if (!handle)
 		return;
@@ -211,6 +221,13 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 	if (handle->pevent)
 		tep_unref(handle->pevent);
 
+	while (!list_empty(&handle->buffers)) {
+		buffer = container_of(handle->buffers.next,
+				      struct tracecmd_buffer, list);
+		list_del(&buffer->list);
+		free(buffer->name);
+		free(buffer);
+	}
 	while (!list_empty(&handle->options)) {
 		option = container_of(handle->options.next,
 				      struct tracecmd_option, list);
@@ -1157,6 +1174,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 		handle->big_endian = false;
 
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	handle->file_state = TRACECMD_FILE_ALLOCATED;
 
@@ -1657,15 +1675,14 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
-struct tracecmd_option *
-tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
-			   int cpus)
+static struct tracecmd_option *
+add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
 	int size = 8 + strlen(name) + 1;
 
-	buf = malloc(size);
+	buf = calloc(1, size);
 	if (!buf) {
 		tracecmd_warning("Failed to malloc buffer");
 		return NULL;
@@ -1687,6 +1704,52 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	return option;
 }
 
+int tracecmd_add_buffer_info(struct tracecmd_output *handle, const char *name, int cpus)
+{
+	struct tracecmd_buffer *buf;
+
+	buf = calloc(1, sizeof(struct tracecmd_buffer));
+	if (!buf)
+		return -1;
+	buf->name = strdup(name);
+	buf->cpus = cpus;
+	if (!buf->name) {
+		free(buf);
+		return -1;
+	}
+	list_add_tail(&buf->list, &handle->buffers);
+	return 0;
+}
+
+int tracecmd_write_buffer_info(struct tracecmd_output *handle)
+{
+	struct tracecmd_option *option;
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		option = add_buffer_option(handle, buf->name, buf->cpus);
+		if (!option)
+			return -1;
+		buf->option = option;
+	}
+
+	return 0;
+}
+
+static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
+{
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		if (strlen(name) == strlen(buf->name) && !strcmp(name, buf->name)) {
+			if (!buf->option)
+				break;
+			return buf->option->offset;
+		}
+	}
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	enum tracecmd_section_flags flags = 0;
@@ -1804,6 +1867,37 @@ out:
 	return ret;
 }
 
+static int update_buffer_cpu_offset(struct tracecmd_output *handle,
+				       const char *name, tsize_t offset)
+{
+	tsize_t b_offset;
+	tsize_t current;
+
+	b_offset = get_buffer_file_offset(handle, name);
+	if (!b_offset) {
+		tracecmd_warning("Cannot find description for buffer %s\n", name);
+		return -1;
+	}
+	current = do_lseek(handle, 0, SEEK_CUR);
+
+	/* Go to the option data, where will write the offest */
+	if (do_lseek(handle, b_offset, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", b_offset);
+		return -1;
+	}
+
+	if (do_write_check(handle, &offset, 8))
+		return -1;
+
+	/* Go back to end of file */
+	if (do_lseek(handle, current, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", offset);
+		return -1;
+	}
+	return 0;
+}
+
+
 static char *get_clock(struct tracecmd_output *handle)
 {
 	struct tracefs_instance *inst;
@@ -1823,120 +1917,158 @@ static char *get_clock(struct tracecmd_output *handle)
 	return handle->trace_clock;
 }
 
-int tracecmd_write_cpu_data(struct tracecmd_output *handle,
-			    int cpus, char * const *cpu_data_files)
+
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
 
 	/* This can be called multiple times (when recording instances) */
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
-		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
+				    check_file_state(handle->file_version,
+						     handle->file_state,
+						     TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
 		tracecmd_warning("Cannot write trace data into the file, unexpected state 0x%X",
 				 handle->file_state);
 		goto out_free;
 	}
 
+	data_offs = do_lseek(handle, 0, SEEK_CUR);
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
-	offsets = malloc(sizeof(*offsets) * cpus);
-	if (!offsets)
+	data_files = calloc(cpus, sizeof(struct data_file_write));
+	if (!data_files)
 		goto out_free;
-	sizes = malloc(sizeof(*sizes) * cpus);
-	if (!sizes)
-		goto out_free;
-
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* hold any extra data for data */
-	offset += cpus * (16);
+	for (i = 0; i < cpus; i++) {
+		data_files[i].file_size = data[i].size;
+		/* Write 0 for trace data offset and size and store offsets of these fields */
+		if (handle->file_version < 7) {
+			endian8 = 0;
+			data_files[i].doffset = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			data_files[i].soffset = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+		}
+	}
 
-	/*
-	 * Unfortunately, the trace_clock data was placed after the
-	 * cpu data, and wasn't accounted for with the offsets.
-	 * We need to save room for the trace_clock file. This means
-	 * we need to find the size of it before we define the final
-	 * offsets.
-	 */
+	update_buffer_cpu_offset(handle, buff_name, data_offs);
 	clock = get_clock(handle);
-	if (!clock)
+	if (clock && save_clock(handle, clock))
 		goto out_free;
-	/* Save room for storing the size */
-	offset += 8;
-	offset += strlen(clock);
-	/* 2 bytes for [] around the clock */
-	offset += 2;
-
-	/* Page align offset */
-	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
 
 	for (i = 0; i < cpus; i++) {
-		file = cpu_data_files[i];
-		ret = stat(file, &st);
-		if (ret < 0) {
-			tracecmd_warning("can not stat '%s'", file);
+		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
+		/* Page align offset */
+		data_files[i].data_offset = (data_files[i].data_offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
+		data_files[i].data_offset = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
+		if (data_files[i].data_offset == (off64_t)-1)
+			goto out_free;
+		if (!tracecmd_get_quiet(handle))
+			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
+				i, (unsigned long long) data_files[i].data_offset);
+		if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
+		if (data[i].size) {
+			read_size = copy_file_fd(handle, data[i].fd);
+			if (read_size != data_files[i].file_size) {
+				errno = EINVAL;
+				tracecmd_warning("did not match size of %lld to %lld",
+						 read_size, data_files[i].file_size);
+				goto out_free;
+			}
+		} else {
+			data_files[i].write_size = 0;
 		}
-		offsets[i] = offset;
-		sizes[i] = st.st_size;
-		offset += st.st_size;
-		offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
 
-		endian8 = convert_endian_8(handle, offsets[i]);
-		if (do_write_check(handle, &endian8, 8))
+		/* Write the real CPU data offset in the file */
+		if (do_lseek(handle, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
-		endian8 = convert_endian_8(handle, sizes[i]);
+		endian8 = convert_endian_8(handle, data_files[i].data_offset);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-	}
-
-	if (save_clock(handle, clock))
-		goto out_free;
-
-	for (i = 0; i < cpus; i++) {
-		if (!tracecmd_get_quiet(handle))
-			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
-				i, (unsigned long long) offsets[i]);
-		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
-		if (offset == (off64_t)-1) {
-			tracecmd_warning("could not seek to %lld\n", offsets[i]);
+		/* Write the real CPU data size in the file */
+		if (do_lseek(handle, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
-		}
-		check_size = copy_file(handle, cpu_data_files[i]);
-		if (check_size != sizes[i]) {
-			errno = EINVAL;
-			tracecmd_warning("did not match size of %lld to %lld",
-					 check_size, sizes[i]);
+		endian8 = convert_endian_8(handle, data_files[i].write_size);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+		offset = data_files[i].data_offset + data_files[i].write_size;
+		if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
-		}
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
-				(unsigned long long)check_size);
+				(unsigned long long)data_files[i].write_size);
 	}
 
-	free(offsets);
-	free(sizes);
+	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
+		goto out_free;
 
+	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
 
  out_free:
-	free(offsets);
-	free(sizes);
+	do_lseek(handle, 0, SEEK_END);
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
+	for (i = 0; i < cpus; i++)
+		data[i].fd = -1;
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
+	for (i = 0; i < cpus; i++) {
+		if (data[i].fd >= 0)
+			close(data[i].fd);
+	}
+	free(data);
+	return ret;
+}
+
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files)
 {
@@ -1945,41 +2077,20 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
-
+	ret = tracecmd_write_buffer_info(handle);
+	if (ret)
+		return ret;
 	ret = tracecmd_write_options(handle);
 	if (ret)
 		return ret;
 
-	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
+	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files, "");
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
@@ -2025,6 +2136,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
+	list_head_init(&handle->buffers);
 
 	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
 		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 0cb70b7d..d812145b 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -610,7 +610,7 @@ static int put_together_file(int cpus, int ofd, const char *node,
 		if (ret)
 			goto out;
 	}
-	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
+	ret = tracecmd_write_cpu_data(handle, cpus, temp_files, "");
 
 out:
 	tracecmd_output_close(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 295fe633..350d2811 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4187,7 +4187,6 @@ static void touch_file(const char *file)
 }
 
 static void append_buffer(struct tracecmd_output *handle,
-			  struct tracecmd_option *buffer_option,
 			  struct buffer_instance *instance,
 			  char **temp_files)
 {
@@ -4215,7 +4214,7 @@ static void append_buffer(struct tracecmd_output *handle,
 			touch_file(temp_files[i]);
 	}
 
-	tracecmd_append_buffer_cpu_data(handle, buffer_option,
+	tracecmd_append_buffer_cpu_data(handle, tracefs_instance_get_name(instance->tracefs),
 					cpu_count, temp_files);
 
 	for (i = 0; i < instance->cpu_count; i++) {
@@ -4465,7 +4464,7 @@ static void write_guest_file(struct buffer_instance *instance)
 			die("failed to allocate memory");
 	}
 
-	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
+	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
 		die("failed to write CPU data");
 	tracecmd_output_close(handle);
 
@@ -4508,7 +4507,6 @@ error:
 
 static void record_data(struct common_record_context *ctx)
 {
-	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
 	bool local = false;
@@ -4578,9 +4576,6 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		if (buffers) {
-			buffer_options = malloc(sizeof(*buffer_options) * buffers);
-			if (!buffer_options)
-				die("Failed to allocate buffer options");
 			i = 0;
 			for_each_instance(instance) {
 				int cpus = instance->cpu_count != local_cpu_count ?
@@ -4588,10 +4583,9 @@ static void record_data(struct common_record_context *ctx)
 
 				if (instance->msg_handle)
 					continue;
-
-				buffer_options[i++] = tracecmd_add_buffer_option(handle,
-										 tracefs_instance_get_name(instance->tracefs),
-										 cpus);
+				tracecmd_add_buffer_info(handle,
+							tracefs_instance_get_name(instance->tracefs),
+							cpus);
 				add_buffer_stat(handle, instance);
 			}
 		}
@@ -4626,7 +4620,7 @@ static void record_data(struct common_record_context *ctx)
 				if (instance->msg_handle)
 					continue;
 				print_stat(instance);
-				append_buffer(handle, buffer_options[i++], instance, temp_files);
+				append_buffer(handle, instance, temp_files);
 			}
 		}
 
-- 
2.31.1

