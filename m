Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165F4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbhLJLGi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJLGh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0E1C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:02 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r11so28251683edd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PqG+suBtp4hX4za5dHQ8K6yST9iNefq8NafwGukCdlw=;
        b=ZWQMCN6hi+3n0x+/HTD7ISFQ+QMUQhjSQpVw537T7Ke1twLvPde4zZuyp4hOTPPiLw
         Cg1RCx8wTYU5BmwlI12dW0qRh2OpB3/cZb1oP0G02/KCGzND+WxdcyFnvGRUtTRcBx6e
         1NyuZGuzVjZhTQtVV39JuZ5gwtnsy0SbE3F/o/BM+s2SmT7UoYU/FDAF2qebTS6N5D1n
         RhxYMhv6vzWis313fSHtoJbaB61kIC/b+lu3r5zxbNPqVXzYlaYSyLbUyxRyULAhmWIz
         tLKD2j+Djqa+t+ZwuZ0u8XbJoLRKUjkF0tG1I21lg2cImtcAMBXW+2VSMvYAljLCPB6R
         VXeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PqG+suBtp4hX4za5dHQ8K6yST9iNefq8NafwGukCdlw=;
        b=Kjdhk6XSHmZv9fC6uVww5S8BIUoq+6lm648wqTDk3OWsmW1xJ0u1tmRvuP+zdCWYtG
         7B3tVUZRVVOKXIf5Z3gFcrM34wpEI/Usj23YCm6SmANo1PZtAE9IQlXP7n5D9RjlRlmE
         exGC6G9zDipIvwplY3JESiV7qjx0n6lWlM2O97GE8lRy9vIyhFjH4Y6ShYXTN4M6F4do
         rvFP3uQwln//ANO8QZvNWT0sCMDDl0HNEXYpHG7V1iwWkXgC4R1pBYFF9wVCTEKsiA8p
         avXl5Etrm2LSUSISLdrgLx1dEalkHynM2N+yd3PwBHYjODI3e6Q5WTy34WnnKQT8fk44
         KfGw==
X-Gm-Message-State: AOAM531Nmvdqk5FwZQc5oW/A3Ir5IW+U6hQaU4buiGRRy4V5ekSUqN3W
        XiH3GnGpMVyLTDKGOx+r+vw+hOsF1Lc=
X-Google-Smtp-Source: ABdhPJykMzKNhfW6Jhfv7Z9eza2siBmZJultxRKepfKlF5fJqKRVDB41G4vGagm8uPbNWr4hQ7QH1Q==
X-Received: by 2002:a05:6402:1c01:: with SMTP id ck1mr37319703edb.262.1639134181262;
        Fri, 10 Dec 2021 03:03:01 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:03:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 8/9] trace-cmd library: Extend tracecmd_copy() API
Date:   Fri, 10 Dec 2021 13:02:48 +0200
Message-Id: <20211210110249.98583-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
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
index f2cfeb47..b3bb5908 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -330,8 +330,9 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle);
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
index 4f31f58b..544ee4fe 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2599,14 +2599,23 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
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
@@ -2615,18 +2624,32 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 
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

