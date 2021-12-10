Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F343FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhLJLLo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhLJLLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:11:43 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A63C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z5so29276614edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mekHVPakLVt6i/YfjNjq/VJuGFwNwTWeruU7KTGFVTU=;
        b=M6pX8hWj+omULAJPXzsbUoooA+Cgpy23yQufBEjvnzRTSJz3CiywV7lBYYB08aD0sL
         C2+JWo+Ki7SPSj5ce09j8fj7O0QExorFi2UTO7iUE4FiMZ6uk/NabogCaC3Mki2/S9OR
         EKSYOSKlgvedU0JDo2UmJX5UByfDlallpJPcuXA3KCeX6HfnTUaMBN/XuBSJnVjqRiah
         3AEbhWKOYYEhccrnKmM5WhGlI8v5Bwuep9ma06r5AzViv+68HgZh5KInnbNLooqW0fLA
         TNnwNWkEBsv+ErllHqsYDU6k+r0y8cdEK/KCz502DvqGuMaRkiPjquE5wmbNpkW5vivl
         iZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mekHVPakLVt6i/YfjNjq/VJuGFwNwTWeruU7KTGFVTU=;
        b=i6CuglKhoLKID9grDRok2CT06Bnn8HZxupEJqFMdMNaNqDFngcuPuiQE+os5o/LLUT
         VVPLvHmnqYg/FKC7eyPSj3FAG1BIAD+Zewy5dLrP4xQn1D79WYW/BvWuBfr9J2EaOTnt
         I9jC8SffiWhkkXQjS1hQYvLzNy0FE2WX8OzHwcrrxbhwuE3PnRwYfPGQtVAeyl/MiOyI
         jx01YyA5jSewg5pX8RrEKHPYD1lErnPC6fJ04Dh5FxdBEkWc0w98ktoIFxt+sxUED6nN
         5Q5eaiA+RRQ8yjNqddYAaCx4xm9liuBpVBtvkh1GAoU0mvAuhS35vPlt3PTMI1B2bZm3
         soHA==
X-Gm-Message-State: AOAM533+1gUEh1raQJklNxefuytV1Qt7odssZYAESzH8GvfBy6n+luxf
        e9mCU46WwC/koLT7xQx7/3trkQH4iWE=
X-Google-Smtp-Source: ABdhPJx+PnOzb9io9qTfKj+mvFjwY1E3zSdTVJjXl1q40S4myOZKSYHdGL+P+ND/PsASU5caq8MwCQ==
X-Received: by 2002:a17:907:3c7:: with SMTP id su7mr23516986ejb.87.1639134487231;
        Fri, 10 Dec 2021 03:08:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j14sm1287172edw.96.2021.12.10.03.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:08:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/2] trace-cmd library: Introduce buffer page size per instance
Date:   Fri, 10 Dec 2021 13:08:03 +0200
Message-Id: <20211210110803.99188-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110803.99188-1-tz.stoyanov@gmail.com>
References: <20211210110803.99188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently all ftrace instances have the same page buffer size and
trace-cmd logic is implemented according to this assumption. Future
changes in the kernel may introduce trace buffer page size per instance.
That change will affect the format of the trace file. Add support for
per instance trace page buffer size in the trace file format and logic.
Only the trace file version 7 is extended with this functionality.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  4 +--
 lib/trace-cmd/trace-input.c             | 11 +++++--
 lib/trace-cmd/trace-output.c            | 40 ++++++++++++++++---------
 tracecmd/trace-dump.c                   |  9 ++++--
 4 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 835c6c96..d9a9f34e 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -57,7 +57,7 @@ int out_save_options_offset(struct tracecmd_output *handle,
 			    unsigned long long start);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
-					unsigned long long *write_size);
+					unsigned long long *write_size, int page);
 void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
@@ -71,7 +71,7 @@ long long do_write_check(struct tracecmd_output *handle, const void *data, long
 struct tracecmd_option *
 out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 			 unsigned short id, unsigned long long data_offset,
-			 int cpus, struct data_file_write *cpu_data);
+			 int cpus, struct data_file_write *cpu_data, int page_size);
 
 struct cpu_data_source {
 	int fd;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af70272b..1ad7b708 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -107,6 +107,7 @@ struct input_buffer_instance {
 	size_t			offset;
 	char			*clock;
 	bool			latency;
+	int			page_size;
 	int			cpus;
 	struct cpu_file_data	*cpu_data;
 };
@@ -3204,6 +3205,9 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 	if (*name == '\0' && !handle->trace_clock)
 		handle->trace_clock = strdup(buff->clock);
 	if (id == TRACECMD_OPTION_BUFFER) {
+		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+			return -1;
+		buff->page_size = tmp;
 		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
 			return -1;
 		buff->cpus = tmp;
@@ -5113,6 +5117,7 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 static int copy_trace_latency(struct tracecmd_input *in_handle,
 			      struct tracecmd_output *out_handle, const char *buf_name)
 {
+	int page_size = getpagesize();
 	unsigned long long wsize;
 	unsigned long long offset;
 	int fd;
@@ -5124,7 +5129,8 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	offset = tracecmd_get_out_file_offset(out_handle);
 
 	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
-	    !out_add_buffer_option_v7(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option_v7(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
+				      offset, 0, NULL, page_size))
 		return -1;
 
 	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
@@ -5135,7 +5141,7 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	else
 		fd = in_handle->fd;
 
-	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize))
+	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
 		return -1;
 	if (out_update_section_header(out_handle, offset))
 		return -1;
@@ -5450,6 +5456,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			goto error;
 		}
 	} else {
+		new_handle->page_size = handle->buffers[indx].page_size;
 		if (init_buffer_cpu_data(new_handle, buffer) < 0)
 			goto error;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8b0e6823..cd668ff2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -364,7 +364,8 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 #define PAGES_IN_CHUNK 10
 __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 						 int fd, unsigned long long max,
-						 unsigned long long *write_size)
+						 unsigned long long *write_size,
+						 int page)
 {
 	unsigned long long rsize = 0;
 	unsigned long long wsize = 0;
@@ -374,7 +375,7 @@ __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 	if (handle->compress) {
 		rsize = max;
 		ret = tracecmd_compress_copy_from(handle->compress, fd,
-						  PAGES_IN_CHUNK * handle->page_size,
+						  PAGES_IN_CHUNK * page,
 						  &rsize, &wsize);
 		if (ret < 0)
 			return 0;
@@ -403,7 +404,7 @@ static tsize_t copy_file_compress(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	ret = out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
 	if (!ret)
 		tracecmd_warning("Can't compress '%s'", file);
 
@@ -1274,7 +1275,7 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
-static int get_trace_page_size(struct tracecmd_output *handle)
+static int get_trace_page_size(struct tracecmd_output *handle, const char *name)
 {
 	struct tracefs_instance *instance;
 	struct tep_handle *tep = NULL;
@@ -1284,7 +1285,7 @@ static int get_trace_page_size(struct tracecmd_output *handle)
 	/* In case of an error, return user space page size */
 	psize = getpagesize();
 
-	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), name);
 	if (!instance)
 		goto out;
 
@@ -1333,7 +1334,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = get_trace_page_size(handle);
+	handle->page_size = get_trace_page_size(handle, NULL);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
@@ -2091,7 +2092,8 @@ static char *get_clock(struct tracecmd_output *handle)
 __hidden struct tracecmd_option *
 out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 			 unsigned short id, unsigned long long data_offset,
-			 int cpus, struct data_file_write *cpu_data)
+			 int cpus, struct data_file_write *cpu_data,
+			 int page_size)
 {
 	struct tracecmd_option *option;
 	int i, j = 0, k = 0;
@@ -2108,6 +2110,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	 *  - trace data offset in the file
 	 *  - buffer name
 	 *  - buffer clock
+	 *  - page size
 	 *  - CPU count
 	 *  - for each CPU:
 	 *    - CPU id
@@ -2138,6 +2141,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	vect[j].iov_base = (void *) clock;
 	vect[j++].iov_len = strlen(clock) + 1;
 	if (id == TRACECMD_OPTION_BUFFER) {
+		vect[j].iov_base = &page_size;
+		vect[j++].iov_len = 4;
 		vect[j].iov_base = (void *) &k;
 		vect[j++].iov_len = 4;
 		for (i = 0; i < cpus; i++) {
@@ -2211,7 +2216,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
+				      offset, 0, NULL, getpagesize()))
 		goto out_free;
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
@@ -2331,7 +2337,6 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
@@ -2340,6 +2345,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
+	int page_size;
 	char *clock;
 	char *str;
 	int ret;
@@ -2356,6 +2362,11 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		goto out_free;
 	}
 
+	if (*buff_name == '\0')
+		page_size = handle->page_size;
+	else
+		page_size = get_trace_page_size(handle, buff_name);
+
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
@@ -2400,8 +2411,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
-		data_files[i].data_offset += handle->page_size - 1;
-		data_files[i].data_offset &= ~(handle->page_size - 1);
+		data_files[i].data_offset += page_size - 1;
+		data_files[i].data_offset &= ~(page_size - 1);
 
 		ret = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (ret == (off64_t)-1)
@@ -2415,7 +2426,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
 			read_size = out_copy_fd_compress(handle, data[i].fd,
-							 data[i].size, &data_files[i].write_size);
+							 data[i].size, &data_files[i].write_size,
+							 page_size);
 
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
@@ -2450,8 +2462,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option_v7(handle, buff_name,
-				      TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+	    !out_add_buffer_option_v7(handle, buff_name,  TRACECMD_OPTION_BUFFER,
+				      data_offs, cpus, data_files, page_size))
 		goto out_free;
 
 	free(data_files);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index dd627c4f..87603bf1 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -469,6 +469,7 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 	unsigned short flags;
 	char clock[DUMP_SIZE];
 	char name[DUMP_SIZE];
+	int page_size;
 	int cpus = 0;
 	int id;
 	int i;
@@ -504,6 +505,10 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 		die("cannot read clock of the buffer option");
 	do_print(OPTIONS|FLYRECORD, "\"%s\" [clock]\n", clock);
 	if (option == TRACECMD_OPTION_BUFFER) {
+		if (read_file_number(fd, &page_size, 4))
+			die("cannot read the page size of the buffer option");
+		do_print(OPTIONS|FLYRECORD, "%d [Page size, bytes]\n", page_size);
+
 		if (read_file_number(fd, &cpus, 4))
 			die("cannot read the cpu count of the buffer option");
 
@@ -519,9 +524,9 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 			do_print(OPTIONS|FLYRECORD, "   %d %lld\t%lld\t[id, data offset and size]\n",
 				 id, offset, data_size);
 		}
-		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, "
+		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, %d page size, "
 			 "%d cpus, %lld bytes flyrecord data]\n",
-			 name, clock, cpus, total_size);
+			 name, clock, page_size, cpus, total_size);
 	} else {
 		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, latency data]\n", name, clock);
 	}
-- 
2.33.1

