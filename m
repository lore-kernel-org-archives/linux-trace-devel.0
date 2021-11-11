Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EBAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3C961108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhKKPMW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhKKPMT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:12:19 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7139BC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:30 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v11so25447109edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIxjXSlWZFxI3y+KKwdJz2YN7djHgx9BFml3J96UVs0=;
        b=F+NfjuLivrp0RNTchE6Wh3TMfq+yEWTeelsS9EFj9UfiZSJYpbfgr5DLM8xi1GRH+c
         neD7dGK2TifUAAmQwSgdGqhUn7X23OhvCQX45aTx6hQK8pCqh1GIlYRFrK4GI4PftHVq
         8GboKBqTSyjRW5z7fW9cTamlNZdmEGZT2Qj8UjoNlyuufsNw2MVy4sDyEvOh9AYpXY5L
         dXvxs8jAtKwn2mRqwMUGux2WwCWBG3lBqNg+X8D8COOtsbMtmvEMdwY9sapp0Fk8t3bA
         Qlj5S3UGdkN9Csjs5a1dowLYA5G534dWz+QMEjjzwcNxanJ2kjQ7TvbJM+JwJmS4Br/j
         NVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIxjXSlWZFxI3y+KKwdJz2YN7djHgx9BFml3J96UVs0=;
        b=ew4BpC1hYLeez1/TUw+QQ694+z1KAl7ZsNJKNNKcA8saCpL4+fcOFbsxeFNErkMP9Y
         7ZsppBqDmDZ6ls2NkN/DRnVSQ02vreqtv9YUpREIL1kKpjZBh2ngbVbTEu7y/F3RwLra
         RNjv0wsm/Bna4RZsSSi3u6BLG/Ym/7syT5oA2IyyFX41iWyRzXIfbIN1CbE1qDhQlvVe
         v2jew7IAeICD34PmzWhmVxCX6sLTH8JPWLCafOkGvhq4e3yVZdYTCWqUIvgfh/V793ld
         f0tFdNQOf4svYbLU11JV0MdRMNOJXt7MG5BqDv7zcCtMPMu71o+Tdp/L8poXgdq5vRf0
         vKqw==
X-Gm-Message-State: AOAM530oo5fckeFstVuW5qfn5HlgDbzMqM8fqz+PGV2YpO3eV6RFIPvV
        +xDPkAwSHTJKgzTo+nhmzfFG5Rshb/Enzg==
X-Google-Smtp-Source: ABdhPJylKoJYvB6M8D9wY6h7UEAeu/nlOWYEnBCZIeGxMDRxE3sT5y9PrORacD/WHpILxuv5GA3sAA==
X-Received: by 2002:a17:907:6d8d:: with SMTP id sb13mr10621663ejc.345.1636643368983;
        Thu, 11 Nov 2021 07:09:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s4sm1825869edd.32.2021.11.11.07.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:09:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/25] trace-cmd library: Move CPU flyrecord trace metadata into the buffer option, for trace file version 7
Date:   Thu, 11 Nov 2021 17:09:27 +0200
Message-Id: <20211111150927.86661-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 02fc78f9..1f846742 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1581,7 +1581,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 }
 
 static struct tracecmd_option *
-add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
+add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1631,8 +1631,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
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
@@ -1683,6 +1686,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
@@ -1759,8 +1854,8 @@ out:
 	return ret;
 }
 
-static int update_buffer_cpu_offset(struct tracecmd_output *handle,
-				    const char *name, tsize_t offset)
+static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
+				       const char *name, tsize_t offset)
 {
 	tsize_t b_offset;
 	tsize_t current;
@@ -1793,26 +1888,6 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
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
@@ -1836,7 +1911,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, "flyrecord", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
 	data_files = calloc(cpus, sizeof(*data_files));
@@ -1849,19 +1924,23 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1892,29 +1971,33 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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

