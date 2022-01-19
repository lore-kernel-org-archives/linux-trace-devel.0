Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD40C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352390AbiASIZV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:21 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A823BC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:20 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id j23so2428598edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TS4JGZ/yPon2sVLY8ZFd6tAPvQZwFyppW805WNo7k0o=;
        b=aMZXBaFTeOio+8GDMeETX0fyGToP/NncFErMlLt63cWC/NsAaI8tUlC6rpSrlfZ451
         ByH60M7DDp1AK+dchso9gUKZ0j54S9E/30pmzSMTU/OA9JcU+76xX/Mt59IhcL45aE8x
         2txnHtJU0FkznsITYbjC8nqD49r9+Gaahuqr3NfEkJe3KqSrQVad819z0SnKfqfDn3w7
         indqynmXAj48sv6L35E8XWhJvyU/e5nA/Txxvfymnf30nOx+vLPm0NSJZZq3BT3BbZ+u
         09Psg7JPsYumgdGwSadVxMBRKZCx4QYwBEXUV6nfV2K1LgbFDzo3eN5rjniNSemYY2l+
         lvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TS4JGZ/yPon2sVLY8ZFd6tAPvQZwFyppW805WNo7k0o=;
        b=VXKeNpC0uqUivpNE8C0xN7k77K676eA42n3nwkIIkvS+L8TP61R1E5ZZwvwS7BA8hi
         FhNSyRVv4BjsU5nS5Dzb8i6YFBzS8QmqBMURV970OCJEitRUOlExqFRj3swuiD/E/Apb
         kKp+vUHVfYG4dVuheJTlWvX3sN9Z/Sg41sdEgYrBoRm9YmkLJaJKB/RhTypMOGVWFIQ8
         S7hvSK4Mfb2TWS+nPofybEk+T2xhFe0QWeg/xQGjzVJM9yBivxv33oPWyHbLsCTW3HZ4
         CBtlRg6XdN0OGWVSM2Ja4cHZajIvLgtFWCCiV+i7u/jPOlMHOdfaOuOZHa0MLzjoW3Fn
         ldtw==
X-Gm-Message-State: AOAM531lRhgm1hjTyrI4fcAvIzj2pscuGI9tetO8fL1KwomUJg7RiqoW
        cFopGB3t19cQ7qm0ivF3Nwjgzg0SLSk=
X-Google-Smtp-Source: ABdhPJxazv1ef+SnrM/jmJcVuCUT4YYrfjhGBVuA527a+EKEq65nq6L0RmsK5pZsdj+diK+bdHyfew==
X-Received: by 2002:a17:907:2da6:: with SMTP id gt38mr22541028ejc.601.1642580719241;
        Wed, 19 Jan 2022 00:25:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 09/25] trace-cmd library: Move CPU flyrecord trace metadata into the buffer option, for trace file version 7
Date:   Wed, 19 Jan 2022 10:24:51 +0200
Message-Id: <20220119082507.245600-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 202 +++++++++++++++++++++++++----------
 1 file changed, 148 insertions(+), 54 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c075ab6d..a7329d84 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1682,7 +1682,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 }
 
 static struct tracecmd_option *
-add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
+add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1732,8 +1732,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
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
@@ -1784,6 +1787,109 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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
+	if (!handle->tracing_dir) {
+		handle->trace_clock = tracefs_get_clock(NULL);
+		return handle->trace_clock;
+	}
+
+	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
+	if (!inst)
+		return NULL;
+	handle->trace_clock = tracefs_get_clock(inst);
+	tracefs_instance_free(inst);
+	return handle->trace_clock;
+}
+
+__hidden struct tracecmd_option *
+out_add_buffer_option(struct tracecmd_output *handle, const char *name,
+		      unsigned short id, unsigned long long data_offset,
+		      int cpus, struct data_file_write *cpu_data)
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
+	/*
+	 * Buffer flyrecord option:
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
+	/*
+	 * Buffer latency option:
+	 *  - trace data offset in the file
+	 *  - buffer name
+	 *  - buffer clock
+	 */
+
+	/*
+	 * 4 : offset, name, clock, count
+	 * 3 : cpu offset, name, clock
+	 */
+	vect = calloc(4 + (cpus * 3), sizeof(struct iovec));
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
@@ -1854,8 +1960,8 @@ out:
 	return ret;
 }
 
-static int update_buffer_cpu_offset(struct tracecmd_output *handle,
-				    const char *name, tsize_t offset)
+static int update_buffer_cpu_offset_v6(struct tracecmd_output *handle,
+				       const char *name, tsize_t offset)
 {
 	tsize_t b_offset;
 	tsize_t current;
@@ -1888,26 +1994,6 @@ static int update_buffer_cpu_offset(struct tracecmd_output *handle,
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
@@ -1931,7 +2017,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	}
 
 	data_offs = do_lseek(handle, 0, SEEK_CUR);
-	if (do_write_check(handle, "flyrecord", 10))
+	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
 	data_files = calloc(cpus, sizeof(*data_files));
@@ -1944,19 +2030,23 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1987,29 +2077,33 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
+	    !out_add_buffer_option(handle, buff_name,
+				   TRACECMD_OPTION_BUFFER, data_offs, cpus, data_files))
+		goto out_free;
+
 	free(data_files);
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
-- 
2.34.1

