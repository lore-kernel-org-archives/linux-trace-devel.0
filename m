Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA228C4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B254960C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhG2FLX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhG2FLX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACE7C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y12so6393340edo.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v48F3F+r6Sfjv4Egks+xj7J/KD8GnfqPDTRoDi9ghUE=;
        b=HKj+lua4VhkKoSW7Fl3s+i7yNpz8fIn9B1btBykb8F+D47g1tK6UTThQ4MQ7yeOJdv
         9Y0+7xwuDOSuJbW18ZJqR9vBPxWUvKysa+8ogZajiNaqzsEKnRhHZ9N7WnXuViyBJ3mb
         eGw2Wf2Pt5KMCeGB8qPr+QCKlhVXrgE73kU4hi6yt7Pw5rph4iY8WNhb6SBIVu3uF2w5
         dbjM9Ux806yo9SF1w60DTpYa1MDfCm3b7lz7vtRWXXAAr7yzCcG7C3iATux37ae+9/3/
         RVlx75q+3vwYlVrUdZnSS6pnNPXmMtH1zyUaA4SV4QRHqEwHX0SUcjwZkoRYOEfp6PYY
         QE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v48F3F+r6Sfjv4Egks+xj7J/KD8GnfqPDTRoDi9ghUE=;
        b=h1SYhpK6XF7Ne3kxo5DbRDZ0sPctyNKa9WkJngISeGknrU724v/iG27D3FJmFClWdk
         BOn4dlJX47z5wrmX1brJKamYHq4sCwS857S0ZQoNCMt6eLu7izlgA2RfYWKSnHKEcy1o
         oIJ9glDBRmqh5QuzaCjFm4u/ssjnuecuS/iAaEPDvlVpZRhScofMOMKV6OAjUAis4vGp
         Q2gjqTYhOVjI/+cFPNtbftMGENiTF22U+r4kvWY6jY0X8zAhMDIcQXQUdjBKx2YbKJp6
         3+VvAVHp5lQkaujqo/8IY6FT0xq1w3egc41PP2rnNpEfr3AZo8KAybiVVCapOoeDunBk
         Y90g==
X-Gm-Message-State: AOAM531lv4DanSxWXk9eG3kqOCBk1qBTsAojkbhZ5kWqoinHMrbS/Gkp
        XU5NWtS8A99dkDzB23IdD4Q=
X-Google-Smtp-Source: ABdhPJy86mmzeil+UO0E+WD8Pf4rBWTQtnY81BeGKheOwCfwVh5wPfKST0I0x/5YOArnpnoWMy9n4Q==
X-Received: by 2002:a05:6402:10d7:: with SMTP id p23mr3978035edu.74.1627535478499;
        Wed, 28 Jul 2021 22:11:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 80/87] trace-cmd library: Extend tracecmd_copy() API
Date:   Thu, 29 Jul 2021 08:09:52 +0300
Message-Id: <20210729050959.12263-81-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy() API is used to copy data between trace files.
Extended it to support copying data bwteen files from different
versions. Added also functionality to copy all sections between the
files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  5 ++-
 lib/trace-cmd/trace-output.c                  | 38 +++++++++++++++----
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-split.c                        |  2 +-
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 3c3c98aa..fd7b17e1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -324,8 +324,9 @@ int tracecmd_write_options(struct tracecmd_output *handle);
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
index b718770d..e45369d3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2511,14 +2511,22 @@ struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
  * tracecmd_copy - copy the headers of one trace.dat file for another
  * @ihandle: input handle of the trace.dat file to copy
  * @file: the trace.dat file to create
+ * @state: what data will be copied from the source handle
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
 
@@ -2531,17 +2539,33 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 		goto out_free;
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
+	if (file_version >= FILE_VERSION_MIN)
+		tracecmd_output_set_version(handle, file_version);
+	if (compression && tracecmd_output_set_compression(handle, compression))
+		goto out_free;
 	tracecmd_output_write_init(handle);
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
+	if (handle->file_version >= 7)
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
index fbda42dd..eedf6b49 100644
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
index 0768329f..3759539c 100644
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

