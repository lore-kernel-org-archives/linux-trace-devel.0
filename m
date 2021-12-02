Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F567C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhLBMbA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240265AbhLBMa7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:30:59 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5560C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:27:35 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so115293130edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vUfyf6cf5gYXU/cqqxkspOFz8xaw+09/pJe/zuj59c=;
        b=YFfkD1t0RB10L3O1n0pBdCGFIQ5+k+b9tG8j9wiqAabycGcBLzbckKDNLXzREM6h8x
         67I/EF9kGaGyRMmRc1Tlv2DUYpwU9I7FCJ6iNPj952blhPX5A2ZPoOlBaM14zb90UQts
         01QirGqxTAEohYsRhbD9L1A9TK0D0E+K5WCv/rwp7cmUUElwUdEAF/usxsQB52OCOlMX
         VyXTAXNLCmQSipsz21kEgQrJ+nzpkNf4KOB/D/8FPcmxudzCCx946136T0HAs89OXj0u
         9WqKgyyvvH+qOjePJEJphh2ncJ9ytyvOtogrlvOyzQIAbNRTxSqZ+x8ihlUOJ3uk2hfF
         lP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vUfyf6cf5gYXU/cqqxkspOFz8xaw+09/pJe/zuj59c=;
        b=fuuvCd6iMErGKaSrZyNnm3yLW6++blOlwuN60MuXiAXhp/oUQY3GWwkg45XEpIDLMY
         ZlMQt6+p+SIJfvcAt/4USbA+AYZ5gn9DskmCqmtyrffYKJdwKUPw7kbq/A42gCiNF+56
         iGIsUaBe+hTT1NPjcTYuYVWeDWYxAUi519Mg7RB2PUjPbjFSV/hKMkzhKxOk+gTPq4hP
         kfdYlRFZlG/yfsTFpE1ZmHfBZ3ibVrwzcasw0Ez8R+v7CRIfkvGB2Z26NRZkoKOPUVA8
         4B2sfNcDrWahwUSKOLBMH5+dV4Fp3C2029ToSnc4KeqWEyu7lSfsOKOYTV/1+jXoRRxQ
         cy+w==
X-Gm-Message-State: AOAM53341Oz2snqKh/ZiL0MbS2GLDBam2ojbGBbEu/vhRIcjErhB1wMd
        nfedjyXtJxlBKBfkUNl+lslh9z6NHR7DuA==
X-Google-Smtp-Source: ABdhPJzeG+7ZtdQEX7WVRC/nLcghThRWNvxxh9GIodHMzWwGIJh73gdc5s77/bedu5cPnrzfTB7YfA==
X-Received: by 2002:a05:6402:1849:: with SMTP id v9mr17636064edy.335.1638448054445;
        Thu, 02 Dec 2021 04:27:34 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2073403edr.43.2021.12.02.04.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:27:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 7/8] trace-cmd library: Extend tracecmd_copy() API
Date:   Thu,  2 Dec 2021 14:27:25 +0200
Message-Id: <20211202122726.43775-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122726.43775-1-tz.stoyanov@gmail.com>
References: <20211202122726.43775-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy() API is used to copy data between trace files.
Extended it to support copying data between files from different
versions. Added also functionality to copy all sections between the
files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  5 ++-
 lib/trace-cmd/trace-output.c                  | 39 +++++++++++++++----
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-split.c                        |  2 +-
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0e0d631c..bd09cb48 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -328,8 +328,9 @@ int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
-struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
-				      const char *file);
+struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
+				      enum tracecmd_file_states state, int file_version,
+				      const char *compression);
 
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files, const char *buff_name);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1e1e16b7..8751e168 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2512,14 +2512,23 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
  * tracecmd_copy - copy the headers of one trace.dat file for another
  * @ihandle: input handle of the trace.dat file to copy
  * @file: the trace.dat file to create
+ * @state: what data will be copied from the source handle
+ * @file_version: version of the output file
+ * @compression: compression of the output file, can be one of:
+ *		 NULL - inherit compression from the input file
+ *		 "any" - compress the output file with the best available algorithm
+ *		 "none" - do not compress the output file
+ *		 algorithm_name - compress the output file with specified algorithm
  *
  * Reads the header information and creates a new trace data file
  * with the same characteristics (events and all) and returns
  * tracecmd_output handle to this new file.
  */
-struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
-				      const char *file)
+struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
+				      enum tracecmd_file_states state, int file_version,
+				      const char *compression)
 {
+	enum tracecmd_file_states fstate;
 	struct tracecmd_output *handle;
 
 	handle = tracecmd_output_create(file);
@@ -2528,18 +2537,32 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
-	output_write_init(handle);
 
-	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
+	if (file_version >= FILE_VERSION_MIN)
+		tracecmd_output_set_version(handle, file_version);
+	if (compression && tracecmd_output_set_compression(handle, compression))
 		goto out_free;
-
-	handle->file_state = tracecmd_get_file_state(ihandle);
-
+	output_write_init(handle);
+	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
+	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
+		goto out_free;
+	if (tracecmd_copy_buffer_descr(ihandle, handle) < 0)
+		goto out_free;
+	if (state >= TRACECMD_FILE_OPTIONS &&
+	    tracecmd_copy_options(ihandle, handle) < 0)
+		goto out_free;
+	if (state >= TRACECMD_FILE_CPU_LATENCY &&
+	    tracecmd_copy_trace_data(ihandle, handle) < 0)
+		goto out_free;
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
 	/* The file is all ready to have cpu data attached */
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+	unlink(file);
 	return NULL;
 }
 
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 23a7f4af..5bf29c52 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -147,7 +147,7 @@ void trace_restore (int argc, char **argv)
 		if (tracecmd_read_headers(ihandle, TRACECMD_FILE_CMD_LINES) < 0)
 			die("error reading file %s headers", input);
 
-		handle = tracecmd_copy(ihandle, output);
+		handle = tracecmd_copy(ihandle, output, TRACECMD_FILE_CMD_LINES, 0, NULL);
 		tracecmd_close(ihandle);
 	} else {
 		handle = tracecmd_output_create(output);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index e4a0c3b3..83c5402c 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -348,7 +348,7 @@ static double parse_file(struct tracecmd_input *handle,
 	dir = dirname(output);
 	base = basename(output);
 
-	ohandle = tracecmd_copy(handle, output_file);
+	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
 
 	cpus = tracecmd_cpus(handle);
 	cpu_data = malloc(sizeof(*cpu_data) * cpus);
-- 
2.33.1

