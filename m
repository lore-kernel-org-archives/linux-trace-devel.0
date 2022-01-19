Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E1CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352528AbiASIeU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352527AbiASIeT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:34:19 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5956C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j23so2532252edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHL57SfyKhE44zqcmag8w02Q6GFFosxWpQaOh/J+3cI=;
        b=KE6TV8+v19tqNdu2Zm7ZfGlFmzrULcObVf7wtBai228daVH2Dlie7ap/DNCf9izJVO
         a5MtbKLe0Vl60peS7aQErHztoGlzQuTOwg8ne5vkxs8sS9SHH2zcITjKJ54yjlG/FWaq
         pui/YZzgd97IH09R5rkHQR5DVhb97+xoZN3IMFmp6g8RUC8fhc6hLcLirstpMkj+MKkF
         6EsaMMnc0EiEp+mjZLs6gfnCU3yYo4DnLMRl7q7AZvjiVWGcU2bID9KIvDiD3W65SMeO
         lmSNZE5vdcZYG9+ussiToEWvLXz6+YHuuQAVijduwdMPpUY9SYJFlwOK+Isu+MRIn9mb
         ee4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHL57SfyKhE44zqcmag8w02Q6GFFosxWpQaOh/J+3cI=;
        b=fDlOcIUVegTY003T643H9cEHGZmbdGdK/tZ+CzZfqNNQ62IQ6E3iXXtmWwtlRGptwn
         5QZGPfuNMTajfataXNJDmkM2Q3dEgutIAVHzRX4qUzabocQ1dYaS2pGjNP5kN0sPWyTs
         NufjGdnI5uVbeFAp8aQXL485m1TuYyT1yBSqBM6GY2TNJuPlCDiN0uR14m/ScJykKrYl
         PRoNwOKGBbVIgKBfNIUGEltZ5UjWWBCzCiWnLHxcubtilhjQ5qWBk//t3oaY/fP+f1lc
         NjMi0fP3OADPMiJcROe1t5BXi7cFKdoZphT+vg05iz31yRo4wJoaoniEiECms3M6y2sL
         ySZQ==
X-Gm-Message-State: AOAM533eNdeVMm9uaZjtck720a4+VYbQDuTLsqmGA2a8UGwhZqufx2SW
        tQxhTCXhQvBmCLzKyztum9/1iL18psU=
X-Google-Smtp-Source: ABdhPJwWok+5m+1Qvuuldmm2AubOMYUy2uwF3iDftrBNhTxkN1t9TYMTsSwIFZn4Wz2RDmd/yx1NsA==
X-Received: by 2002:a17:906:4d50:: with SMTP id b16mr2245030ejv.251.1642581257374;
        Wed, 19 Jan 2022 00:34:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 10sm6177380ejy.174.2022.01.19.00.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:34:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 2/2] trace-cmd library: Introduce buffer page size per instance
Date:   Wed, 19 Jan 2022 10:34:13 +0200
Message-Id: <20220119083413.246539-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083413.246539-1-tz.stoyanov@gmail.com>
References: <20220119083413.246539-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                   | 11 ++++-
 lib/trace-cmd/trace-output.c                  | 43 ++++++++++++-------
 tracecmd/trace-dump.c                         |  9 +++-
 5 files changed, 46 insertions(+), 22 deletions(-)

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
index 5056702a..e8d46bc2 100644
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
@@ -3214,6 +3215,9 @@ static int handle_buffer_option(struct tracecmd_input *handle,
 		handle->trace_clock = strdup(buff->clock);
 
 	if (id == TRACECMD_OPTION_BUFFER) {
+		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
+			return -1;
+		buff->page_size = tmp;
 		if (save_read_number(handle->pevent, data, &size, &rsize, 4, &tmp))
 			return -1;
 		buff->cpus = tmp;
@@ -5124,6 +5128,7 @@ int tracecmd_copy_options(struct tracecmd_input *in_handle,
 static int copy_trace_latency(struct tracecmd_input *in_handle,
 			      struct tracecmd_output *out_handle, const char *buf_name)
 {
+	int page_size = getpagesize();
 	unsigned long long wsize;
 	unsigned long long offset;
 	int fd;
@@ -5135,7 +5140,8 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	offset = tracecmd_get_out_file_offset(out_handle);
 
 	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS &&
-	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option(out_handle, buf_name, TRACECMD_OPTION_BUFFER_TEXT,
+				   offset, 0, NULL, page_size))
 		return -1;
 
 	offset = out_write_section_header(out_handle, TRACECMD_OPTION_BUFFER_TEXT,
@@ -5146,7 +5152,7 @@ static int copy_trace_latency(struct tracecmd_input *in_handle,
 	else
 		fd = in_handle->fd;
 
-	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize))
+	if (!out_copy_fd_compress(out_handle, fd, 0, &wsize, page_size))
 		return -1;
 	if (out_update_section_header(out_handle, offset))
 		return -1;
@@ -5462,6 +5468,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			goto error;
 		}
 	} else {
+		new_handle->page_size = handle->buffers[indx].page_size;
 		if (init_buffer_cpu_data(new_handle, buffer) < 0)
 			goto error;
 	}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d901c32e..8bccd1f0 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -369,7 +369,8 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 #define PAGES_IN_CHUNK 10
 __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 						 int fd, unsigned long long max,
-						 unsigned long long *write_size)
+						 unsigned long long *write_size,
+						 int page)
 {
 	unsigned long long rsize = 0;
 	unsigned long long wsize = 0;
@@ -379,7 +380,7 @@ __hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 	if (handle->compress) {
 		rsize = max;
 		ret = tracecmd_compress_copy_from(handle->compress, fd,
-						  PAGES_IN_CHUNK * handle->page_size,
+						  PAGES_IN_CHUNK * page,
 						  &rsize, &wsize);
 		if (ret < 0)
 			return 0;
@@ -408,7 +409,7 @@ static tsize_t copy_file_compress(struct tracecmd_output *handle,
 		return 0;
 	}
 
-	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	ret = out_copy_fd_compress(handle, fd, 0, write_size, getpagesize());
 	if (!ret)
 		tracecmd_warning("Can't compress '%s'", file);
 
@@ -1279,7 +1280,7 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
-static int get_trace_page_size(struct tracecmd_output *handle)
+static int get_trace_page_size(struct tracecmd_output *handle, const char *name)
 {
 	struct tracefs_instance *instance;
 	struct tep_handle *tep = NULL;
@@ -1289,7 +1290,7 @@ static int get_trace_page_size(struct tracecmd_output *handle)
 	/* In case of an error, return user space page size */
 	psize = getpagesize();
 
-	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), name);
 	if (!instance)
 		goto out;
 
@@ -1338,7 +1339,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = get_trace_page_size(handle);
+	handle->page_size = get_trace_page_size(handle, NULL);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
@@ -2103,7 +2104,7 @@ static char *get_clock(struct tracecmd_output *handle)
 __hidden struct tracecmd_option *
 out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		      unsigned short id, unsigned long long data_offset,
-		      int cpus, struct data_file_write *cpu_data)
+		      int cpus, struct data_file_write *cpu_data, int page_size)
 {
 	struct tracecmd_option *option;
 	int i, j = 0, k = 0;
@@ -2121,6 +2122,7 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	 *  - trace data offset in the file
 	 *  - buffer name
 	 *  - buffer clock
+	 *  - page size
 	 *  - CPU count
 	 *  - for each CPU:
 	 *    - CPU id
@@ -2136,10 +2138,10 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
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
@@ -2156,6 +2158,8 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 	vect[j].iov_base = (void *) clock;
 	vect[j++].iov_len = strlen(clock) + 1;
 	if (id == TRACECMD_OPTION_BUFFER) {
+		vect[j].iov_base = &page_size;
+		vect[j++].iov_len = 4;
 		vect[j].iov_base = (void *) &k;
 		vect[j++].iov_len = 4;
 		for (i = 0; i < cpus; i++) {
@@ -2229,7 +2233,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	offset = do_lseek(handle, 0, SEEK_CUR);
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
+	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT,
+				   offset, 0, NULL, getpagesize()))
 		goto out_free;
 	if (handle->compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
@@ -2347,7 +2352,6 @@ __hidden int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus)
 	return 0;
 }
 
-
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
@@ -2356,6 +2360,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
+	int page_size;
 	char *clock;
 	char *str;
 	int ret;
@@ -2372,6 +2377,11 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2416,8 +2426,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
-		data_files[i].data_offset += handle->page_size - 1;
-		data_files[i].data_offset &= ~(handle->page_size - 1);
+		data_files[i].data_offset += page_size - 1;
+		data_files[i].data_offset &= ~(page_size - 1);
 
 		ret = do_lseek(handle, data_files[i].data_offset, SEEK_SET);
 		if (ret == (off64_t)-1)
@@ -2431,7 +2441,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
 			read_size = out_copy_fd_compress(handle, data[i].fd,
-							 data[i].size, &data_files[i].write_size);
+							 data[i].size, &data_files[i].write_size,
+							 page_size);
 
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
@@ -2466,8 +2477,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	if (HAS_SECTIONS(handle) &&
-	    !out_add_buffer_option(handle, buff_name,
-				   TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+	    !out_add_buffer_option(handle, buff_name,  TRACECMD_OPTION_BUFFER,
+				   data_offs, cpus, data_files, page_size))
 		goto out_free;
 
 	free(data_files);
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 70adb816..f2d8b5e9 100644
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
2.34.1

