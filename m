Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72403C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbhLJK6f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbhLJK6f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:35 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E337C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:00 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so28178484edd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgkPKjgR+Z6Agw/uvav8Vr102S2nw02tOU8vL9Rb1+c=;
        b=X0YadSO6LiSUV5geYdDLQLrfe7FZttz9b0aFJDFrhpxr89QWwW0siHQvQJFGKVD6jL
         Qbag4l4TT3aYDBQF5dFIMDazcG39b4JkuJAHDlvJC4TLmqK+g1UoPwuGB2xaeiVBJeig
         X7l7fOlR/o+N7FQH9yM1acVFfqKCGkPuRwZHMYhGvZ3YmsCX6sKoACLBz6XIxdljr1MC
         iU1Si46a1OV3wFqEicUYJgt/gdsf9WHo6hXFdY2a6l76HvVQS0o70Nxmj/oNCNQarg2w
         wQoIWPJKqlN1TC+r6UhDmon+W+seU7DKOTtRrdZgUXY2CbvHSfux00r0+OTb8Qdf+Dtl
         ntzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgkPKjgR+Z6Agw/uvav8Vr102S2nw02tOU8vL9Rb1+c=;
        b=gaocXLt1naeGYCRkzB4kraACbJr55LfEyv/HL3O4rh66yMaBLsaSe2ntH16WH1DqeN
         j7IbI/vVioGIOYyB5TdKP0axPzVkiXaSl7yladQmStnqCft7D0zaPeryeJ3rIiS0WvGi
         X6wi6e2iZRukhooQp84VFdP3MORNmWq0DEk0Q6f+fr8ouyYwdF17djANog241Eg1HTZI
         2PXDzGVgqaDcIHbZm4MXIBK5H9wGVset3fCc14Pw3HrodQvqzuYT31uIDsJ3A3fkqKa/
         8ZnA+RJ1occZfJrYO0HykjDGBuPqiOTkdDwIUxfopD1BX1Uw3jRfgdq0CFaqM9CYVzRz
         jn4Q==
X-Gm-Message-State: AOAM533THE2R3+/bjpqbK6SRmEweaSfFUgTjAe0IfEckAi5QLBppJHEQ
        Bw1FV6jJIN+oc6n/nIOPSJGVcWiupvM=
X-Google-Smtp-Source: ABdhPJwhkEjdzwOi42LSVlz5U8M2NY9TP3ja47ZvbIz0Ohl0xEbZakjKN0l7pJeqV1oMDWYsM03xyQ==
X-Received: by 2002:a17:907:60c9:: with SMTP id hv9mr22421302ejc.482.1639133698686;
        Fri, 10 Dec 2021 02:54:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 09/25] trace-cmd library: Move CPU flyrecord trace metadata into the buffer option, for trace file version 7
Date:   Fri, 10 Dec 2021 12:54:32 +0200
Message-Id: <20211210105448.97850-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extended the BUFFER trace option in trace file version 7 with CPU
flyrecord trace metadata. In the version 6 of the trace file, this metadata
is located at several places in the file. Part of the metadata is only for
the top trace instance, thus limiting per-instance configuration. Moving
all CPU trace related metadata in the BUFFER option simplifies the parsing
and makes per-instance configuration more flexible. In the new file
structure, the top instance is treated as any other instances.
The format of the extended BUFFER option is:
 - offset of the buffer in the trace file
 - name of the buffer
 - trace clock, used in this buffer for events timestamps
 - count of CPUs with trace data
 - array, describing each CPU with trace data:
   - CPU id
   - offset of CPU trace data in the trace file
   - size of the recorded CPU trace data

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 191 +++++++++++++++++++++++++----------
 1 file changed, 137 insertions(+), 54 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 59093be2..6e40c929 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1675,7 +1675,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 }
 
 static struct tracecmd_option *
-add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
+add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1725,8 +1725,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
 	struct tracecmd_option *option;
 	struct tracecmd_buffer *buf;
 
+	if (HAS_SECTIONS(handle))
+		return 0;
+
 	list_for_each_entry(buf, &handle->buffers, list) {
-		option = add_buffer_option(handle, buf->name, buf->cpus);
+		option = add_buffer_option_v6(handle, buf->name, buf->cpus);
 		if (!option)
 			return -1;
 		buf->option = option;
@@ -1777,6 +1780,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return 0;
 }
 
+static char *get_clock(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *inst;
+
+	if (handle->trace_clock)
+		return handle->trace_clock;
+
+	/*
+	 * If no clock is set on this handle, get the trace clock of
+	 * the top instance in the handle's tracing dir
+	 */
+	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
+	if (!inst)
+		return NULL;
+	handle->trace_clock = tracefs_get_clock(inst);
+	tracefs_instance_free(inst);
+	return handle->trace_clock;
+}
+
+__hidden struct tracecmd_option *
+out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
+			 unsigned short id, unsigned long long data_offset,
+			 int cpus, struct data_file_write *cpu_data)
+{
+	struct tracecmd_option *option;
+	int i, j = 0, k = 0;
+	int *cpu_ids = NULL;
+	struct iovec *vect;
+	char *clock;
+
+	if (!HAS_SECTIONS(handle))
+		return NULL;
+
+	clock = get_clock(handle);
+
+	/* Buffer flyrecord option, v7:
+	 *  - trace data offset in the file
+	 *  - buffer name
+	 *  - buffer clock
+	 *  - CPU count
+	 *  - for each CPU:
+	 *    - CPU id
+	 *    - CPU trace data offset in the file
+	 *    - CPU trace data size
+	 */
+
+	/* Buffer latency option, v7:
+	 *  - trace data offset in the file
+	 *  - buffer name
+	 *  - buffer clock
+	 */
+
+	vect = calloc(5 + (cpus * 3), sizeof(struct iovec));
+	if (!vect)
+		return NULL;
+	if (cpus) {
+		cpu_ids = calloc(cpus, sizeof(int));
+		if (!cpu_ids) {
+			free(vect);
+			return NULL;
+		}
+	}
+	vect[j].iov_base = (void *) &data_offset;
+	vect[j++].iov_len = 8;
+	vect[j].iov_base = (void *) name;
+	vect[j++].iov_len = strlen(name) + 1;
+	vect[j].iov_base = (void *) clock;
+	vect[j++].iov_len = strlen(clock) + 1;
+	if (id == TRACECMD_OPTION_BUFFER) {
+		vect[j].iov_base = (void *) &k;
+		vect[j++].iov_len = 4;
+		for (i = 0; i < cpus; i++) {
+			if (!cpu_data[i].file_size)
+				continue;
+			cpu_ids[i] = i;
+			vect[j].iov_base = &cpu_ids[i];
+			vect[j++].iov_len = 4;
+			vect[j].iov_base = &cpu_data[i].data_offset;
+			vect[j++].iov_len = 8;
+			vect[j].iov_base = &cpu_data[i].write_size;
+			vect[j++].iov_len = 8;
+			k++;
+		}
+	}
+
+	option = tracecmd_add_option_v(handle, id, vect, j);
+	free(vect);
+	free(cpu_ids);
+
+	return option;
+}
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
 {
 	struct tracecmd_output *handle;
@@ -1847,8 +1942,8 @@ out:
 	return ret;
 }
 
-static int update_buffer_cpu_offset(struct tracecmd_output *handle,
-				    const char *name, tsize_t offset)
+static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
+				       const char *name, tsize_t offset)
 {
 	tsize_t b_offset;
 	tsize_t current;
@@ -1881,26 +1976,6 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
 	return 0;
 }
 
-
-static char *get_clock(struct tracecmd_output *handle)
-{
-	struct tracefs_instance *inst;
-
-	if (handle->trace_clock)
-		return handle->trace_clock;
-
-	/*
-	 * If no clock is set on this handle, get the trace clock of
-	 * the top instance in the handle's tracing dir
-	 */
-	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
-	if (!inst)
-		return NULL;
-	handle->trace_clock = tracefs_get_clock(inst);
-	tracefs_instance_free(inst);
-	return handle->trace_clock;
-}
-
 __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
@@ -1924,7 +1999,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, "flyrecord", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
 	data_files = calloc(cpus, sizeof(*data_files));
@@ -1937,19 +2012,23 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		 * Place 0 for the data offset and size, and save the offsets to
 		 * updated them with the correct data later.
 		 */
-		endian8 = 0;
-		data_files[i].file_data_offset = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-		data_files[i].file_write_size = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
+		if (!HAS_SECTIONS(handle)) {
+			endian8 = 0;
+			data_files[i].file_data_offset = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			data_files[i].file_write_size = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+		}
 	}
 
-	update_buffer_cpu_offset(handle, buff_name, data_offs);
-	clock = get_clock(handle);
-	if (clock && save_clock(handle, clock))
-		goto out_free;
+	if (!HAS_SECTIONS(handle)) {
+		update_buffer_cpu_offset_v6(handle, buff_name, data_offs);
+		clock = get_clock(handle);
+		if (clock && save_clock(handle, clock))
+			goto out_free;
+	}
 
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
@@ -1980,29 +2059,33 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			data_files[i].write_size = 0;
 		}
 
-		/* Write the real CPU data offset in the file */
-		if (do_lseek(handle, data_files[i].file_data_offset, SEEK_SET) == (off64_t)-1)
-			goto out_free;
-		endian8 = convert_endian_8(handle, data_files[i].data_offset);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-
-		/* Write the real CPU data size in the file */
-		if (do_lseek(handle, data_files[i].file_write_size, SEEK_SET) == (off64_t)-1)
-			goto out_free;
-		endian8 = convert_endian_8(handle, data_files[i].write_size);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-
-		offset = data_files[i].data_offset + data_files[i].write_size;
-		if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
-			goto out_free;
-
+		if (!HAS_SECTIONS(handle)) {
+			/* Write the real CPU data offset in the file */
+			if (do_lseek(handle, data_files[i].file_data_offset, SEEK_SET) == (off64_t)-1)
+				goto out_free;
+			endian8 = convert_endian_8(handle, data_files[i].data_offset);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			/* Write the real CPU data size in the file */
+			if (do_lseek(handle, data_files[i].file_write_size, SEEK_SET) == (off64_t)-1)
+				goto out_free;
+			endian8 = convert_endian_8(handle, data_files[i].write_size);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			offset = data_files[i].data_offset + data_files[i].write_size;
+			if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
+				goto out_free;
+		}
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)data_files[i].write_size);
 	}
 
+	if (HAS_SECTIONS(handle) &&
+	    !out_add_buffer_option_v7(handle, buff_name,
+				      TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+		goto out_free;
+
 	free(data_files);
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
-- 
2.33.1

