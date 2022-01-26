Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D716DC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiAZJwK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiAZJwK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:52:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0763C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:09 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id h7so37742966ejf.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tCAmBfN+hSY4foKzWF2G25qnQqbe3j5CHe/tPygwmno=;
        b=cUuxSaXFuiL3W+3KTLERBcIdyBFL+Ky5SydlKKG86bColuIo16OdD/KxZHZGEU5ZFc
         tAsOuoJcjAuZSo47nIPCtBGBRPwEkBH8TFsxO0X9bQBbFbNVGCOD+JTPZzeaGlpNgTxS
         QnS4k6T36dGsXuLPnyr1uqviHk/eXxK3YxBFD7KMPM87WRxW8qOzAHTXNeJvSKhyxhWX
         UkS3hGPDYEmWysUz4Xv9Ba7224U6K2vZ5W1BbbuU/F/BU/l4ocJM52nDCqoLRYAUPqjf
         AeXpgDu2WhBecWQXVFDUZj+s56OrlJLwnVprtub95SneJ4yAqqFjUSZl6vS+sFR8phQd
         K/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tCAmBfN+hSY4foKzWF2G25qnQqbe3j5CHe/tPygwmno=;
        b=rnMJ1/WMzo1rTUJN+rGssh1jG6YtJ4OpaAJOr1VdbjBBI8dxyYJDJmCH7vc6jjsh5h
         iGoxxN1gzce1Hnug3uZXv9Q6bcWXmMn2TXVCNyyKms4f5HrnpVR2eMM2hCe66uUJi+op
         fM/dmBVuDD795D7E74JDMRVGrIGsjAV7k4R5QSiN167rwpsNvVMaowgqV/0cgnzuqnxY
         Fd+b21bjuEyv9+i4bv4XXA55WwDU8v9XXPCSHOR3XJxBFpUI33N87rc1m1m9NBKOtDoS
         0ji01zz8fCrv9JY49ofL6+OAQQWpXABlCqSCzTdSy2UQBFjenZqLQN3m/r3SP9yQXmIZ
         FvIA==
X-Gm-Message-State: AOAM533pPNLs0UrhSVNom0kRDmRTo8ekcqFc2DOTgmLwX6QrYKJuQq+/
        9xCzWFpgo9WGMdWr5CpRq3/59dOHjEs=
X-Google-Smtp-Source: ABdhPJxfLRrHBvxK23DYGqlAGs4hJ5sMMXwP8XM0vyuAnWnvBTiv8Rsqlheusf+nBgRqArM69O9cXw==
X-Received: by 2002:a17:906:38ce:: with SMTP id r14mr19241525ejd.468.1643190728222;
        Wed, 26 Jan 2022 01:52:08 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:52:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 8/9] trace-cmd library: Extend tracecmd_copy() API
Date:   Wed, 26 Jan 2022 11:51:53 +0200
Message-Id: <20220126095154.570700-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095154.570700-1-tz.stoyanov@gmail.com>
References: <20220126095154.570700-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  | 41 ++++++++++++++++---
 tracecmd/trace-restore.c                      |  2 +-
 tracecmd/trace-split.c                        |  2 +-
 4 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 32957305..d229b264 100644
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
index c1ba8a52..e7915aa6 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2642,14 +2642,23 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
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
@@ -2658,18 +2667,40 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
+
+	if (file_version >= FILE_VERSION_MIN)
+		tracecmd_output_set_version(handle, file_version);
+
+	if (compression && tracecmd_output_set_compression(handle, compression))
+		goto out_free;
+
 	output_write_init(handle);
+	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
+	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
+		goto out_free;
 
-	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
+	if (tracecmd_copy_buffer_descr(ihandle, handle) < 0)
 		goto out_free;
 
-	handle->file_state = tracecmd_get_file_state(ihandle);
+	if (state >= TRACECMD_FILE_OPTIONS &&
+	    tracecmd_copy_options(ihandle, handle) < 0)
+		goto out_free;
+
+	if (state >= TRACECMD_FILE_CPU_LATENCY &&
+	    tracecmd_copy_trace_data(ihandle, handle) < 0)
+		goto out_free;
+
+	if (HAS_SECTIONS(handle))
+		tracecmd_write_options(handle);
 
 	/* The file is all ready to have cpu data attached */
 	return handle;
 
 out_free:
-	tracecmd_output_close(handle);
+	if (handle)
+		tracecmd_output_close(handle);
+
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

