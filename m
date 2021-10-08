Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E8DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE6A61090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJHE1Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhJHE1P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:27:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3D0C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:25:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so15500123edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+5CUZeamCXqpmaZHxN8Q4ulDwTkUSetSa2T5NeLp1s=;
        b=gneXPO6g4Y4vGfmaZMwR0kpyeS7zOrSAbn421Bs7LBp8lNPfI6g6b1K869QdnlxNlQ
         X6Zex7LSSSCrtVtAskMiCxMRPSKW6wQWvgJCsswlmVVpFrVxuB0QHrwaswTB+vVBcd9A
         Voxp5xtEUS90yE8RS36uqMwtBhmaxnASXQ9L/Rpm7pprWzTDHddbvQJsszRsvhtnBwQ2
         5K7MjdDjEGBbmKnsUB5wThkz5TqlPd/nxrAwACaigbohf3edsufmnlLWocA5sumvXB//
         8PqNlf8l9xIrXfsvsHxPAL1YHCfBBZ1CH3mltRFShYWcSryEHcWeik3kiw1QmxZgeg9Z
         +lMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+5CUZeamCXqpmaZHxN8Q4ulDwTkUSetSa2T5NeLp1s=;
        b=Wp9YWI+ekI81cLg0cAAg+SCFoBZjDLkn5W003kbMw0XMpDuP6/Q4TaVp/WnLndFM84
         tbgcDbDYkDblER6pagXanQnBTCo6lNCopaXwzX5kuX9RvmBq8iSFr2qtqfLJMLWWIS8J
         1idsbLlrmudOhx04ty6BMIKBoi3nB5FHKURVwdF2MwMNPLuEvUbkUFGpY2HXNOIsetfq
         amcV0L6ilClRC/93At4RvfnnaJKcdiEwBm4foummRgYNgY4FJR/VFAphXN9M24f4XQHO
         Wg1+58XNVRbgTWFaM+hfE+53vKJePcyf+KxqdAw9BwXhIVO238WBUGNbgPDQKnERLZTi
         zP1A==
X-Gm-Message-State: AOAM531OEEbNK9IOQuohGvbunWaE+R09Oy6p8husriG8urQOa9VFYscn
        LngqNfm5Hs1OZJ9xSf4QV0IQxzqmZGI99w==
X-Google-Smtp-Source: ABdhPJwkm+D0NfvvtyEtma4FPmfMhmjqlz/loWqXnJ0cCVSvoAQQqMl68eo8DEXAtFPULN0A1xYC9A==
X-Received: by 2002:a17:906:d182:: with SMTP id c2mr1256512ejz.47.1633667119553;
        Thu, 07 Oct 2021 21:25:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm506320edz.95.2021.10.07.21.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:25:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 7/8] trace-cmd library: Extend tracecmd_copy() API
Date:   Fri,  8 Oct 2021 07:25:09 +0300
Message-Id: <20211008042510.978362-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042510.978362-1-tz.stoyanov@gmail.com>
References: <20211008042510.978362-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 40 +++++++++++++++----
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-split.c                        |  2 +-
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2c373030..39ac7f6f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -330,8 +330,9 @@ int tracecmd_write_options(struct tracecmd_output *handle);
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
index 49104527..d060712b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2508,14 +2508,23 @@ struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
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
 	int fd;
 
@@ -2528,18 +2537,33 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 		goto out_free;
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
+	if (file_version >= FILE_VERSION_MIN)
+		tracecmd_output_set_version(handle, file_version);
+	if (compression && tracecmd_output_set_compression(handle, compression))
+		goto out_free;
 	tracecmd_output_write_init(handle);
-
-	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
+	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
+	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
-
-	handle->file_state = tracecmd_get_file_state(ihandle);
-
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
+	else
+		close(fd);
+	unlink(file);
 	return NULL;
 }
 
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index a903c21a..1e416496 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -153,7 +153,7 @@ void trace_restore (int argc, char **argv)
 		if (tracecmd_read_headers(ihandle, TRACECMD_FILE_CMD_LINES) < 0)
 			die("error reading file %s headers", input);
 
-		handle = tracecmd_copy(ihandle, output);
+		handle = tracecmd_copy(ihandle, output, TRACECMD_FILE_CMD_LINES, 0, NULL);
 		tracecmd_close(ihandle);
 	} else
 		handle = tracecmd_create_init_file(output);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 671d6e9f..06a1c82b 100644
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
2.31.1

