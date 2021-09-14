Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53BEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B173D610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhINNQI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4950BC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:50 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 192-20020a1c04c9000000b002f7a4ab0a49so1978441wme.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uYbzqfK8SdLpGcCUm8lVEKofe44vQ9EzJmzia4J/yVs=;
        b=BX8UjLZpDbobENtr3ULCLQ/zBt1yfD8xCa7xD4v6xwCJSltbRRj5GseHCqfszpvmVL
         SyHedSadKsydlvXbXZ4ep8rMS3xB0AloA42GB4EJk2sCREWRnfFXNFghUd2RJZQcvxaI
         t3TvHFUXLOnYBB1o2ckyeaMS9UL1psZnaMp0FnqQ9Q2Gyg6uswhTDn+p+h37NOeVya23
         6G//YdR8znzvm/ZdxX+lpE2xVCc5CJvY/F4js9RfY6aTjKhO9ZqwLrP1zzWeb9x8vifs
         55CBikiNiMrVAe9MZ6fEqS0+FVts4XL+1GF1aiWPiDC/FQc/d5oz3/IjhGurw2hPMt7y
         DNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uYbzqfK8SdLpGcCUm8lVEKofe44vQ9EzJmzia4J/yVs=;
        b=mHm4CDanabfxuDym0uajkzHxuZZ4KnE4oNlYNIxQKhQtjo3hybB79ozsMCUsT01eJr
         3CFpFW5gMpj3ZEYCXStoUM+nu2UIh4lk9QEIiArZr/3N8H9cPrHHgv/9ZP0bJLczUOza
         xjPEmX9yGQUGR60wC8r6wUdYs2AshrG1+Kv32xlr5jkn7w7LRbQEi0mZpY19IZqko/gU
         oy9Usg9vJXaBvOPtd66qozfIUjhTQQ7lwQ7xEnUvy88XIXh27ErQYjJQU86T/gvRJVvc
         KG1sZGC6bM/qkoNyj9qB+urcYMwN5yywBrgewvCskl/4j4SGSPV92Trm6OfQdmk0Vufa
         5qWA==
X-Gm-Message-State: AOAM5320UhR/GWtT4MAHpmncSeCNQGcIw4jP5tOV/Y2uPvvbyr6HI9cE
        kM/SE6WRB5Eo3onhOIDwwhDgdTkqz3c=
X-Google-Smtp-Source: ABdhPJxNnP20g/ySdq8CUx8VKSD7unM3p+3uaPTMsyajMQ7XgS/+9bjNy4tUuUbxGn47r6Qs7vaorQ==
X-Received: by 2002:a1c:1fd3:: with SMTP id f202mr2161490wmf.44.1631625288905;
        Tue, 14 Sep 2021 06:14:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/25] trace-cmd library: Move CPU flyrecord trace metadata into the buffer option, for trace file version 7
Date:   Tue, 14 Sep 2021 16:14:21 +0300
Message-Id: <20210914131438.3965484-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 187 +++++++++++++++++++++++++----------
 1 file changed, 137 insertions(+), 50 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8bc995c7..e2d03f1c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1589,7 +1589,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 }
 
 static struct tracecmd_option *
-add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
+add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1639,8 +1639,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
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
@@ -1691,6 +1694,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
@@ -1767,8 +1862,8 @@ out:
 	return ret;
 }
 
-static int update_buffer_cpu_offset(struct tracecmd_output *handle,
-				    const char *name, tsize_t offset)
+static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
+				       const char *name, tsize_t offset)
 {
 	tsize_t b_offset;
 	tsize_t current;
@@ -1797,26 +1892,6 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
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
@@ -1840,7 +1915,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, "flyrecord", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
 	data_files = calloc(cpus, sizeof(struct data_file_write));
@@ -1850,19 +1925,24 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	for (i = 0; i < cpus; i++) {
 		data_files[i].file_size = data[i].size;
 		/* Write 0 for trace data offset and size and store offsets of these fields */
-		endian8 = 0;
-		data_files[i].doffset = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-		data_files[i].soffset = do_lseek(handle, 0, SEEK_CUR);
-		if (do_write_check(handle, &endian8, 8))
+		if (!HAS_SECTIONS(handle)) {
+			endian8 = 0;
+			data_files[i].doffset = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			data_files[i].soffset = do_lseek(handle, 0, SEEK_CUR);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+		}
+	}
+
+	if (!HAS_SECTIONS(handle)) {
+		update_buffer_cpu_offset_v6(handle, buff_name, data_offs);
+		clock = get_clock(handle);
+		if (clock && save_clock(handle, clock))
 			goto out_free;
 	}
 
-	update_buffer_cpu_offset(handle, buff_name, data_offs);
-	clock = get_clock(handle);
-	if (clock && save_clock(handle, clock))
-		goto out_free;
 	for (i = 0; i < cpus; i++) {
 		data_files[i].data_offset = do_lseek(handle, 0, SEEK_CUR);
 		/* Page align offset */
@@ -1888,26 +1968,33 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			data_files[i].write_size = 0;
 		}
 
-		/* Write the real CPU data offset in the file */
-		if (do_lseek(handle, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
-			goto out_free;
-		endian8 = convert_endian_8(handle, data_files[i].data_offset);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-		/* Write the real CPU data size in the file */
-		if (do_lseek(handle, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
-			goto out_free;
-		endian8 = convert_endian_8(handle, data_files[i].write_size);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-		offset = data_files[i].data_offset + data_files[i].write_size;
-		if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
-			goto out_free;
+		if (!HAS_SECTIONS(handle)) {
+			/* Write the real CPU data offset in the file */
+			if (do_lseek(handle, data_files[i].doffset, SEEK_SET) == (off64_t)-1)
+				goto out_free;
+			endian8 = convert_endian_8(handle, data_files[i].data_offset);
+			if (do_write_check(handle, &endian8, 8))
+				goto out_free;
+			/* Write the real CPU data size in the file */
+			if (do_lseek(handle, data_files[i].soffset, SEEK_SET) == (off64_t)-1)
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
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		goto out_free;
 
-- 
2.31.1

