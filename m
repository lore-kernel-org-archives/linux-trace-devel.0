Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DD3C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352476AbiASI24 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352474AbiASI24 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:28:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD7C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:55 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id 30so7652100edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDJSb8MRP6co3jzQCZt+goaBuZC7HlL1kb0Ev+6PAbc=;
        b=JA/dI1tKl401qd1y2IRPHIrEHumJf1IgtZ7iKBi5s2MQisY3lylmkm1UV9aSt0qeFj
         6//Xhu255ssgpdLIg+cuvlLKQ3PgNfIpIUIv8GvzRyS7b62kAfnRLF+gB3zmcJ4n1L4C
         w0lL1Rr669ajCN4w1L80SR677HhbhU/uRTK0vseTLhFeVjnIdnIcFTo/DndBcUVf4Fyq
         kWQCC2cbfj9mN8ATaklDDOEb2je6E1KfNG/PCFe5Dpl5dsIyFYeeQPmhfrX8HIPE6yRg
         O1kLILW7Oxez94skiEXJHNcc2ts5XeOBNRXqO4PlcqAfNytjT9EsSRw+R/kOymcWnwuj
         EwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDJSb8MRP6co3jzQCZt+goaBuZC7HlL1kb0Ev+6PAbc=;
        b=LocKiGc8CAuA8jDFC02/WBkF3Fxks0NJu5LuN2HR9hrQ2eZM1mJqTjaaPLAhzwv8Dq
         olBWxYctjEbKhtFj5CEAJkCCW4Pn/gj1m5AbBIUxGSSqRLKhEPt4Ani0Ue2xqcE3sqSv
         U2AYzyj2xc1VAQkAcH81gVg23ORAQD8yn02EdliX+2/HaFFEjRKmDhvxmjjzIEJydRAX
         cziu3n7nZhbNUJuASodSr+u0Sqh8tMphoK3clSZuZ8Kk9sWIQ/vPIbYOzZMFfBaoq9HC
         k9R6ivIpPWRc8SV9f3gNewzNHarOGgj149fJ53O35taySXVgMUtlUDSTSGnMWAI3yiNN
         wQBw==
X-Gm-Message-State: AOAM530b6neGAYoEropMQoJCZepjQ4tc60stTXyAu3/5ssKeGTdHahIU
        rU9x1qJMnMRivXgmrNpgP/Bw0JRioM0=
X-Google-Smtp-Source: ABdhPJwxa/U/eqSZH89kHlgxrP2P2fBAFeg/NBRYjI2F4IVNFGqIq7EwGOTt1Sxy7csw1VZsKGTsbA==
X-Received: by 2002:a05:6402:268a:: with SMTP id w10mr29755935edd.10.1642580934172;
        Wed, 19 Jan 2022 00:28:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm860838edq.24.2022.01.19.00.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:28:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 8/9] trace-cmd library: Extend tracecmd_copy() API
Date:   Wed, 19 Jan 2022 10:28:44 +0200
Message-Id: <20220119082845.245993-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082845.245993-1-tz.stoyanov@gmail.com>
References: <20220119082845.245993-1-tz.stoyanov@gmail.com>
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
index 00d5a41a..37c5d2c4 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -335,8 +335,9 @@ int tracecmd_write_meta_strings(struct tracecmd_output *handle);
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
index 78232bc9..0323da75 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2615,14 +2615,23 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
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
@@ -2631,18 +2640,32 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 
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
2.34.1

