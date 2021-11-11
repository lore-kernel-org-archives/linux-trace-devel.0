Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4259BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3042E61268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhKKPQV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhKKPQV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C687CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r12so25446329edt.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zGNS6Fm4ikNF8FS7txR5obf0jQDuMyZGorzqwP4IfTk=;
        b=WhZMwKl6dIHh6vLz7EdXtMhvYZsfF9jXuupROg3txkN4K0648YjPozJ9RaA31ltm4R
         85a3ZOBxzYQIJsD5fxzRvUBeixchxCTx0yJLDqN6c6elCqg623YwEor6ryzaQO1Qw18s
         2NH8zkzaRcpXTThi08pUBSxS4VjuPyX+5V+Ov0nptOW9C8dpPQluvn1IH/ViAbckrbQq
         1IVHqUkfQY2EWguYN/R8vjDEHRt0hC2RDpp57EGfuH4zrZvkzPQonbJ0Ep+XkTJpra1y
         pozW77O2IqzNPvLVAJS+zkJ99UGpBi+b9Wdx2wqs+JKpdMw/NqHyw4y9zlteWk1ajLH3
         /TWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zGNS6Fm4ikNF8FS7txR5obf0jQDuMyZGorzqwP4IfTk=;
        b=JXLw4MYV+FaOD55wa4wJ+Ol1wZWFnA+wjlTWQrclvLFXYhc2Vjd+7dT+DvKy1t/+HT
         DQkdvWNH20RYmg8jqAckzAmQxJwexZGlDMvMa1VGQEf1ktc7eGj1gkFsr61zzv5jbRAl
         Xm+eU2g9BhFoKlQ93kAS5DN1uNX2E11y3TaBj2rvZ1k6y6DtXKIh8/kz/qFFDKMtDeRr
         /AsZcydukAX6ppdNrXbGuVMk7DREOmud4bI0vSCllxe2GLNB8AhW0BqXwYYayjZrCmZ3
         WoF/V5PmhdIKWFHeXr/VFgj1IAJNnxfEmxv5KuyDGAmr6A9vcq+B5QvefPXpNF0qSOTb
         +/Xw==
X-Gm-Message-State: AOAM531cP8FsUdb1f6Hk/KCO4ZHkIOsg6gkp5K9usmCPlzLJAX9Hi2dC
        aPUQurUUOsG67s9e6Npv+GPq23Wxr2CBHg==
X-Google-Smtp-Source: ABdhPJzlXL3vEbmZQN8aTx/VxogsjIPVqcUevKXa76Un6gpRKJQ9tSnp74J13DboCn/34N3f8tvRuw==
X-Received: by 2002:a17:906:9b95:: with SMTP id dd21mr10332244ejc.85.1636643610071;
        Thu, 11 Nov 2021 07:13:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg17sm1429686ejc.72.2021.11.11.07.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd library: Introduce buffer page size per instance
Date:   Thu, 11 Nov 2021 17:13:26 +0200
Message-Id: <20211111151326.87227-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151326.87227-1-tz.stoyanov@gmail.com>
References: <20211111151326.87227-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/trace-cmd-local.h |  4 +-
 lib/trace-cmd/trace-input.c             | 11 ++++-
 lib/trace-cmd/trace-output.c            | 60 +++++++++++++++++++------
 tracecmd/trace-dump.c                   |  9 +++-
 4 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 638b993c..aa958469 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -55,7 +55,7 @@ int out_save_options_offset(struct tracecmd_output *handle,
 			    unsigned long long start);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
-					unsigned long long *write_size);
+					unsigned long long *write_size, int page);
 void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
@@ -69,7 +69,7 @@ long long do_write_check(struct tracecmd_output *handle, const void *data, long
 struct tracecmd_option *
 out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 			 unsigned short id, unsigned long long data_offset,
-			 int cpus, struct data_file_write *cpu_data);
+			 int cpus, struct data_file_write *cpu_data, int page_size);
 
 struct cpu_data_source {
 	int fd;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 10f85031..68c5c75e 100644
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
@@ -3194,6 +3195,9 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 	if (*name == '\0' && !handle->trace_clock)
 		handle->trace_clock = strdup(buff->clock);
 	if (id == TRACECMD_OPTION_BUFFER) {
+		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+			return -1;
+		buff->page_size = tmp;
 		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
 			return -1;
 		buff->cpus = tmp;
@@ -5045,6 +5049,7 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 static int copy_trace_latency(struct tracecmd_input *in_handle,
 			      struct tracecmd_output *out_handle, const char *buf_name)
 {
+	int page_size = getpagesize();
 	unsigned long long wsize;
 	unsigned long long offset;
 	int fd;
@@ -5056,7 +5061,8 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	offset = tracecmd_get_out_file_offset(out_handle);
 
 	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
-	    !out_add_buffer_option_v7(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option_v7(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
+				      offset, 0, NULL, page_size))
 		return -1;
 
 	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
@@ -5067,7 +5073,7 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	else
 		fd = in_handle->fd;
 
-	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize))
+	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
 		return -1;
 	if (out_update_section_header(out_handle, offset))
 		return -1;
@@ -5382,6 +5388,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			goto error;
 		}
 	} else {
+		new_handle->page_size = handle->buffers[indx].page_size;
 		if (init_buffer_cpu_data(new_handle, buffer) < 0)
 			goto error;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 08fa485d..92ec3871 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -330,7 +330,8 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 #define PAGES_IN_CHUNK 10
 __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 						 int fd, unsigned long long max,
-						 unsigned long long *write_size)
+						 unsigned long long *write_size,
+						 int page)
 {
 	unsigned long long rsize = 0;
 	unsigned long long wsize = 0;
@@ -340,7 +341,7 @@ __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 	if (handle->compress) {
 		rsize = max;
 		ret = tracecmd_compress_copy_from(handle->compress, fd,
-						  PAGES_IN_CHUNK * handle->page_size,
+						  PAGES_IN_CHUNK * page,
 						  &rsize, &wsize);
 		if (ret < 0)
 			return 0;
@@ -369,7 +370,7 @@ static tsize_t copy_file_compress(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	ret = out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
 	if (!ret)
 		tracecmd_warning("Can't compress '%s'", file);
 
@@ -409,6 +410,26 @@ static char *get_tracing_file(struct tracecmd_output *handle, const char *name)
 	return file;
 }
 
+static char *get_tracing_instance_file(struct tracecmd_output *handle,
+				       const char *instance, const char *name)
+{
+	const char *tracing;
+	char *file;
+	int ret;
+
+	tracing = find_tracing_dir(handle);
+	if (!tracing)
+		return NULL;
+	if (instance && *instance != '\0')
+		ret = asprintf(&file, "%s/instances/%s/%s", tracing, instance, name);
+	else
+		ret = asprintf(&file, "%s/%s", tracing, name);
+	if (ret < 0)
+		return NULL;
+
+	return file;
+}
+
 static void put_tracing_file(char *file)
 {
 	free(file);
@@ -1189,7 +1210,7 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
-static int get_trace_page_size(struct tracecmd_output *handle)
+static int get_trace_page_size(struct tracecmd_output *handle, const char *instance)
 {
 	struct tep_handle *tep = NULL;
 	tsize_t psize, size;
@@ -1201,7 +1222,7 @@ static int get_trace_page_size(struct tracecmd_output *handle)
 	/* In case of an error, return user space page size */
 	psize = getpagesize();
 
-	path = get_tracing_file(handle, "events/header_page");
+	path = get_tracing_instance_file(handle, instance, "events/header_page");
 	if (!path)
 		goto out;
 	fd = open(path, O_RDONLY);
@@ -1263,7 +1284,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = get_trace_page_size(handle);
+	handle->page_size = get_trace_page_size(handle, NULL);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
@@ -2001,7 +2022,8 @@ static char *get_clock(struct tracecmd_output *handle)
 __hidden struct tracecmd_option *
 out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 			 unsigned short id, unsigned long long data_offset,
-			 int cpus, struct data_file_write *cpu_data)
+			 int cpus, struct data_file_write *cpu_data,
+			 int page_size)
 {
 	struct tracecmd_option *option;
 	int i, j = 0, k = 0;
@@ -2018,6 +2040,7 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	 *  - trace data offset in the file
 	 *  - buffer name
 	 *  - buffer clock
+	 *  - page size
 	 *  - CPU count
 	 *  - for each CPU:
 	 *    - CPU id
@@ -2048,6 +2071,8 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
 	vect[j].iov_base = (void *) clock;
 	vect[j++].iov_len = strlen(clock) + 1;
 	if (id == TRACECMD_OPTION_BUFFER) {
+		vect[j].iov_base = &page_size;
+		vect[j++].iov_len = 4;
 		vect[j].iov_base = (void *) &k;
 		vect[j++].iov_len = 4;
 		for (i = 0; i < cpus; i++) {
@@ -2127,7 +2152,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
+				      offset, 0, NULL, getpagesize()))
 		goto out_free;
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
@@ -2249,7 +2275,6 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
@@ -2258,6 +2283,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
+	int page_size;
 	char *clock;
 	char *str;
 	int ret;
@@ -2274,6 +2300,11 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2318,8 +2349,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
-		data_files[i].data_offset += handle->page_size - 1;
-		data_files[i].data_offset &= ~(handle->page_size - 1);
+		data_files[i].data_offset += page_size - 1;
+		data_files[i].data_offset &= ~(page_size - 1);
 
 		ret = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (ret == (off64_t)-1)
@@ -2333,7 +2364,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
 			read_size = out_copy_fd_compress(handle, data[i].fd,
-							 data[i].size, &data_files[i].write_size);
+							 data[i].size, &data_files[i].write_size,
+							 page_size);
 
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
@@ -2368,8 +2400,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option_v7(handle, buff_name,
-				      TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+	    !out_add_buffer_option_v7(handle, buff_name,  TRACECMD_OPTION_BUFFER,
+				      data_offs, cpus, data_files, page_size))
 		goto out_free;
 
 	free(data_files);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 9013f8b5..ea2d5116 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -455,6 +455,7 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 	unsigned short flags;
 	char clock[DUMP_SIZE];
 	char name[DUMP_SIZE];
+	int page_size;
 	int cpus = 0;
 	int id;
 	int i;
@@ -490,6 +491,10 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 		die("cannot read clock of the buffer option");
 	do_print(OPTIONS|FLYRECORD, "\"%s\" [clock]\n", clock);
 	if (option == TRACECMD_OPTION_BUFFER) {
+		if (read_file_number(fd, &page_size, 4))
+			die("cannot read the page size of the buffer option");
+		do_print(OPTIONS|FLYRECORD, "%d [Page size, bytes]\n", page_size);
+
 		if (read_file_number(fd, &cpus, 4))
 			die("cannot read the cpu count of the buffer option");
 
@@ -505,9 +510,9 @@ static void dump_option_buffer(int fd, unsigned short option, int size)
 			do_print(OPTIONS|FLYRECORD, "   %d %lld\t%lld\t[id, data offset and size]\n",
 				 id, offset, data_size);
 		}
-		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, "
+		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, %d page size"
 			 "%d cpus, %lld bytes flyrecord data]\n",
-			 name, clock, cpus, total_size);
+			 name, clock, page_size, cpus, total_size);
 	} else {
 		do_print(SUMMARY, "\t\[buffer \"%s\", \"%s\" clock, latency data]\n", name, clock);
 	}
-- 
2.33.1

