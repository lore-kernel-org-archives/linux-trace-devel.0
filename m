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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE63C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652EF6103B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhIMMtX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbhIMMtU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:49:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8F9C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:04 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 192-20020a1c04c9000000b002f7a4ab0a49so5193560wme.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wQuU+VBQA+pxntlhzZ0IXTS4Xd5fD7hyi8KSCr/r9I=;
        b=BZjJjtoWkHjWSbJzu8xOss8A3FYeDmWAc5LFuqJjxDNvQ+pABbCX88rFu94ZJZCNfb
         NrfsJqggn/EkEqkAw4w4ZuuIeLNBJW84nOBPn3/hzW2RCviXCPS5gdgTcjpT7cU8wDzp
         2rEIGdLxn3ccmqe+ibny8hnqfVaSBL17qe8TODpvFfSuGddAAOD11HLFWsPnAvS2NT6r
         GMdeYa3nNUuNN733sYNzxPk1JDPiZD6EbjH4q4LfBbJQbgnbB9ZVyhE4Af25EE2BpTgA
         c6bHNOgHShlT1EGnaSH4OMWAdX1FJBJLfHD2Ua7Qs8MI8VBNKz3oa3v8wu9IuLJW58Y8
         If1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wQuU+VBQA+pxntlhzZ0IXTS4Xd5fD7hyi8KSCr/r9I=;
        b=x0rjRppYiVMz/Ef7NNdD8+MLX8WMV5LA/ZgnbudLfm41PTVKRxDh/e96fSymFdPTov
         zaDZgoIYnuaSJmQaa9eZQ+X+QvIywGhoSc5/H+t27lCsDxJ67Z+N+froDJasRoojxF74
         EAFgIuKPz45aMLWdRX3W5AjRZMP4NQh9qQb7RoC4mMY8eM8mZ/YMzpyXQqRWck8SYwgh
         s48pVtBAOn2+RSGwzIg6ZQLj6rh0ecSaVI6C16/E9gaSawiAvA9tdUib0FcN3OVxhDHO
         w6TmJm7XD/Pcg42rzOLNUF2Bg6pynU/ZsRSc346AMgfzVAAquBbXfU+x/qeJZv7zFkyh
         1w4Q==
X-Gm-Message-State: AOAM531XlSyeXRKZpGsr3l8u1KuAy5LTWbuJ3vBSvhLeNZ3vrHr+mWBQ
        sNXsqJCvRRRlkm3w0RANadxYL9xiRGQ=
X-Google-Smtp-Source: ABdhPJzvypIrkdlBWKpjlCtCEmCGxrpMBieXEYFww6mlSYqTlNy+HIObnJh7IiZP9na62WpQUNB1TA==
X-Received: by 2002:a1c:cc16:: with SMTP id h22mr11131454wmb.117.1631537282679;
        Mon, 13 Sep 2021 05:48:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm7718077wmj.0.2021.09.13.05.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:48:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/8] trace-cmd library: Extend tracecmd_copy() API
Date:   Mon, 13 Sep 2021 15:47:53 +0300
Message-Id: <20210913124754.3679916-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
References: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
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
index 53bd0209..9bdb4547 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2505,14 +2505,23 @@ struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
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
 
@@ -2525,18 +2534,33 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
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

