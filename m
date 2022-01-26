Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94778C63684
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiAZJ5t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbiAZJ5m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:57:42 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3550C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:41 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ah7so37561305ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kejNHqTPLY+NKtjA8t1yDbSDaKGqltHhVZubgl6k7sM=;
        b=Nz5ubB8E8UCmAlwOhjMPTsvEhhsNEXPL3l3qbuB/dpT3AHP/xObO1mf90cz/V0Ey2S
         6/6zBHavABClusCQZA/g11MjGTcPeUwIu2Zivh+bjjG3ACdgmhWx3xEqlDix/y6K0vQU
         DGCq7jVL+ligBUspBFgFLPtaBGNowFwP5z+vWvBbF8RgFGOikhyQC+NlQbUI7P9HLj9D
         L9rXaMj/Y4TDF2GvC+i0r+AQJubngGx+s+Jjc1WET3H7oV7Fti1hTIwE5uUw3CYnTFXO
         WQw1isBKCtWNnScmpp3jnyEWFnIxcyOyydUXBodyKPizmjENXRGqDmIVHXd1MwZSsUSM
         Qr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kejNHqTPLY+NKtjA8t1yDbSDaKGqltHhVZubgl6k7sM=;
        b=eZv31UCep7Tfdb32zyFjUJtEjsNAhVbNYG0OAqbpM0TENhr/0GGFlYxiyuLgyG97T2
         /l9vjVFEkuRGzabSjsn509AZw/U4MXmMEY0261WAaCaVSWzOJZOS3/s+wjY2VF7wYg+L
         bYIrXzhgMCU8RJWkpN5yJULCtoYFaiB6FgvC7u3wAmPmK19sNzrITju0wMUcVwFSOW2f
         F2PoUmeUWOfXktWDyvN8n4gWYg2QMeljOOXQeJTg/9fa7ZtnENLKBpY9M6gQyRR0fTHM
         AJWFnQw7Pk9PL3icEsoPTDyfvzGVdkMxP0jPen3HMITT2YW6iv0/Lji9PedTER+yuCzb
         FBeA==
X-Gm-Message-State: AOAM532g7xiXVbW/3dasjStnmA5ne/RkjPtVf1Lm9glVvBTP3OWg28tI
        Mgs1qbDuK0FoYozXERo6+HD2sa82A5M=
X-Google-Smtp-Source: ABdhPJwzPOb7yo8cjjKWHENUfnE8iic8BKW1UczhKImfIK3pcndn1KzJUu8Zy2er0fqYq27TNC1tHw==
X-Received: by 2002:a17:907:3e15:: with SMTP id hp21mr18607563ejc.628.1643191060315;
        Wed, 26 Jan 2022 01:57:40 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id j20sm7145299eje.81.2022.01.26.01.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:57:39 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 2/2] trace-cmd library: Introduce buffer page size per instance
Date:   Wed, 26 Jan 2022 11:57:35 +0200
Message-Id: <20220126095735.571222-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095735.571222-1-tz.stoyanov@gmail.com>
References: <20220126095735.571222-1-tz.stoyanov@gmail.com>
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
 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 +-
 lib/trace-cmd/trace-input.c                   | 12 +++++-
 lib/trace-cmd/trace-output.c                  | 43 ++++++++++++-------
 tracecmd/trace-dump.c                         |  9 +++-
 5 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index 1b556bba..e5bcac76 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -147,6 +147,7 @@ OPTIONS SECTION
       is saved as name of the top instance.
       <string> a null terminated ASCII string, trace clock used for events timestamps in
       this trace instance.
+      <4 bytes> unsigned integer, size of the trace buffer page.
       <4 bytes> unsigned integer, count of the CPUs with trace data.
       For each CPU of the above count:
          <4 bytes> unsigned integer, ID of the CPU.
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 48f179d6..5b25719b 100644
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
 out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		      unsigned short id, unsigned long long data_offset,
-		      int cpus, struct data_file_write *cpu_data);
+		      int cpus, struct data_file_write *cpu_data, int page_size);
 
 struct cpu_data_source {
 	int fd;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60ac839c..c582860e 100644
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
@@ -3235,6 +3236,10 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 		handle->trace_clock = strdup(buff->clock);
 
 	if (id == TRACECMD_OPTION_BUFFER) {
+		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+			return -1;
+		buff->page_size = tmp;
+
 		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
 			return -1;
 		buff->cpus = tmp;
@@ -5184,6 +5189,7 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 static int copy_trace_latency(struct tracecmd_input *in_handle,
 			      struct tracecmd_output *out_handle, const char *buf_name)
 {
+	int page_size = getpagesize();
 	unsigned long long wsize;
 	unsigned long long offset;
 	int fd;
@@ -5195,7 +5201,8 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	offset = tracecmd_get_out_file_offset(out_handle);
 
 	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
-	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
+				   offset, 0, NULL, page_size))
 		return -1;
 
 	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
@@ -5206,7 +5213,7 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	else
 		fd = in_handle->fd;
 
-	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize))
+	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
 		return -1;
 
 	if (out_update_section_header(out_handle, offset))
@@ -5527,6 +5534,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			goto error;
 		}
 	} else {
+		new_handle->page_size = handle->buffers[indx].page_size;
 		if (init_buffer_cpu_data(new_handle, buffer) < 0)
 			goto error;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index cd40d312..2a961788 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -380,7 +380,8 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 #define PAGES_IN_CHUNK 10
 __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 						 int fd, unsigned long long max,
-						 unsigned long long *write_size)
+						 unsigned long long *write_size,
+						 int page)
 {
 	unsigned long long rsize = 0;
 	unsigned long long wsize = 0;
@@ -390,7 +391,7 @@ __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 	if (handle->compress) {
 		rsize = max;
 		ret = tracecmd_compress_copy_from(handle->compress, fd,
-						  PAGES_IN_CHUNK * handle->page_size,
+						  PAGES_IN_CHUNK * page,
 						  &rsize, &wsize);
 		if (ret < 0)
 			return 0;
@@ -419,7 +420,7 @@ static tsize_t copy_file_compress(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	ret = out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
 	if (!ret)
 		tracecmd_warning("Can't compress '%s'", file);
 
@@ -1299,7 +1300,7 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
-static int get_trace_page_size(struct tracecmd_output *handle)
+static int get_trace_page_size(struct tracecmd_output *handle, const char *name)
 {
 	struct tracefs_instance *instance;
 	struct tep_handle *tep = NULL;
@@ -1309,7 +1310,7 @@ static int get_trace_page_size(struct tracecmd_output *handle)
 	/* In case of an error, return user space page size */
 	psize = getpagesize();
 
-	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), name);
 	if (!instance)
 		goto out;
 
@@ -1358,7 +1359,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = get_trace_page_size(handle);
+	handle->page_size = get_trace_page_size(handle, NULL);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
@@ -2126,7 +2127,7 @@ static char *get_clock(struct tracecmd_output *handle)
 __hidden struct tracecmd_option *
 out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		      unsigned short id, unsigned long long data_offset,
-		      int cpus, struct data_file_write *cpu_data)
+		      int cpus, struct data_file_write *cpu_data, int page_size)
 {
 	struct tracecmd_option *option;
 	int i, j = 0, k = 0;
@@ -2144,6 +2145,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	 *  - trace data offset in the file
 	 *  - buffer name
 	 *  - buffer clock
+	 *  - page size
 	 *  - CPU count
 	 *  - for each CPU:
 	 *    - CPU id
@@ -2159,10 +2161,10 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	 */
 
 	/*
-	 * 4 : offset, name, clock, count
+	 * 5 : offset, name, clock, page size, count
 	 * 3 : cpu offset, name, clock
 	 */
-	vect = calloc(4 + (cpus * 3), sizeof(struct iovec));
+	vect = calloc(5 + (cpus * 3), sizeof(struct iovec));
 	if (!vect)
 		return NULL;
 	if (cpus) {
@@ -2179,6 +2181,8 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	vect[j].iov_base = (void *) clock;
 	vect[j++].iov_len = strlen(clock) + 1;
 	if (id == TRACECMD_OPTION_BUFFER) {
+		vect[j].iov_base = &page_size;
+		vect[j++].iov_len = 4;
 		vect[j].iov_base = (void *) &k;
 		vect[j++].iov_len = 4;
 		for (i = 0; i < cpus; i++) {
@@ -2254,7 +2258,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
+				   offset, 0, NULL, getpagesize()))
 		goto out_free;
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
@@ -2374,7 +2379,6 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
@@ -2383,6 +2387,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
+	int page_size;
 	char *clock;
 	char *str;
 	int ret;
@@ -2399,6 +2404,11 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2443,8 +2453,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
-		data_files[i].data_offset += handle->page_size - 1;
-		data_files[i].data_offset &= ~(handle->page_size - 1);
+		data_files[i].data_offset += page_size - 1;
+		data_files[i].data_offset &= ~(page_size - 1);
 
 		ret = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (ret == (off64_t)-1)
@@ -2458,7 +2468,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
 			read_size = out_copy_fd_compress(handle, data[i].fd,
-							 data[i].size, &data_files[i].write_size);
+							 data[i].size, &data_files[i].write_size,
+							 page_size);
 
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
@@ -2493,8 +2504,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, buff_name,
-				   TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+	    !out_add_buffer_option(handle, buff_name,  TRACECMD_OPTION_BUFFER,
+				   data_offs, cpus, data_files, page_size))
 		goto out_free;
 
 	free(data_files);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 7ed86f61..22e3d871 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -479,6 +479,7 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 	unsigned short flags;
 	char clock[DUMP_SIZE];
 	char name[DUMP_SIZE];
+	int page_size;
 	int cpus = 0;
 	int id;
 	int i;
@@ -517,6 +518,10 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 
 	do_print(OPTIONS|FLYRECORD, "\"%s\" [clock]\n", clock);
 	if (option == TRACECMD_OPTION_BUFFER) {
+		if (read_file_number(fd, &page_size, 4))
+			die("cannot read the page size of the buffer option");
+		do_print(OPTIONS|FLYRECORD, "%d [Page size, bytes]\n", page_size);
+
 		if (read_file_number(fd, &cpus, 4))
 			die("cannot read the cpu count of the buffer option");
 
@@ -535,9 +540,9 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
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
2.34.1

