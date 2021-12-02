Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52940C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357749AbhLBMXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357803AbhLBMXU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E10AC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:58 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so115211652edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PYHpN426HY8AISwWnRcKSH+Ej4BAwii8AeVBbTbVlcw=;
        b=qeHpIHj42TxpJRrtKbuTVXRzc5QfSJY9iYnX2g24MGEuuwbqtK00CwYkxGRdz74myZ
         Cke5OQbBV26LID7srMXCgd1AaDk2RdMYgPyifWNCTq4kjj7YPaya3SddqIKdo/H6GEHM
         68L47YCyWKwyWp3rxAki56JvSl/C0XwoJtYphq1TJr2YwPJmLxGBcY+mJVDdWRox0RZY
         zD0jtXccQulQ44NKdoiboeHjIXL+LSx7X+0aAh9hzsz9+AsP0+CpChOnd37ugqcKp7++
         tSrRiYGFnpFqzHbztf5IOY/3hMikanh4rWtP/mXhWvkbwekVCYTSAnSC6FIZIn4JNpLp
         FURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PYHpN426HY8AISwWnRcKSH+Ej4BAwii8AeVBbTbVlcw=;
        b=ZdyRKbE5CX6/CcokY7W1g8BGpOrS5R1wbDd1GVgd5ERcBR4HEkERsewF6LPUrSfnUw
         dTlw+5FdhFpl2wgmm377iEo9JywMZYClOE2HwJQT2AcNhxWhZCukj84UlXXmEK9SZtni
         K+v3RfNTUvtdju4+qLNp5kUKdRvXyr80X8S4xovqlLnasz9zro4NHMGxaHpNPPccbxHO
         WpMPYqsC9xTZ5S5C1lLFje68XemuavlOlGaVlZ2lFO1apezDvVP52oAL/gCmIk4sGEeQ
         oceRWApmBJ35pekfBO30++imloit/JcZfUxnL1URBuEbrgzYulHLB0PhILUqwFC+CIBm
         qQZA==
X-Gm-Message-State: AOAM531+bHjKIWO++1FOSbZMB3PfQ4KVgtt/GlMpC5/qwciagFsrzRcS
        8rUwoLJvrVQ0ILcmsE/LowKRdGA+8eA+5w==
X-Google-Smtp-Source: ABdhPJygSbJajpYMPk5TFmj3eMwJZa3gKjpSIjZjZVgmITsiKYterUuuRavwaVkxAUX1Xpt3qo1CxA==
X-Received: by 2002:a17:907:6ea1:: with SMTP id sh33mr15220033ejc.150.1638447596299;
        Thu, 02 Dec 2021 04:19:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] trace-cmd library: Make tracecmd_output_write_init static
Date:   Thu,  2 Dec 2021 14:19:49 +0200
Message-Id: <20211202121949.43084-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202121949.43084-1-tz.stoyanov@gmail.com>
References: <20211202121949.43084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

That function is used only inside the library, it should not be exposed
as library API:
 tracecmd_output_write_init()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  1 -
 lib/trace-cmd/trace-output.c                     | 16 ++++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 069283c7..a26076de 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -274,7 +274,6 @@ int tracecmd_output_set_msg(struct tracecmd_output *handle,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracecmd_input *ihandle);
-int tracecmd_output_write_init(struct tracecmd_output *handle);
 int tracecmd_output_write_headers(struct tracecmd_output *handle,
 				  struct tracecmd_event_list *list);
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a20e42df..f5e2574c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -942,7 +942,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
  * instead of writing to a file.
  *
  * This must be called after the handle file version is set and before calling
- * tracecmd_output_write_init().
+ * tracecmd_output_write_headers().
  *
  * Returns 0 on success, or -1 if the output file handle is not allocated or not
  * in the expected state.
@@ -966,7 +966,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handle, struct tracecmd_msg_
  * (@tracing_dir), to be used when creating the trace file instead of using the
  * system default tracig directory.
  *
- * Must be called before tracecmd_output_write_init().
+ * Must be called before tracecmd_output_write_headers().
  *
  * Returns 0 on success, or -1 if the output file handle is not allocated or not
  * in the expected state.
@@ -995,7 +995,7 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handle, const char *tr
  * Have the output file handle (@handle) use a custom kernel symbols file instead
  * of the default /proc/kallsyms.
  *
- * Must be called before tracecmd_output_write_init().
+ * Must be called before tracecmd_output_write_headers().
  *
  * Returns 0 on success, or -1 if the output file handle is not allocated or
  * not in the expected state.
@@ -1031,7 +1031,7 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handle, const char *kal
  *  - file version
  *  - file compression protocol
  *
- * Must be called before tracecmd_output_write_init().
+ * Must be called before tracecmd_output_write_headers().
  *
  * Returns 0 on success, or -1 if the output file handle is not allocated or
  * not in expected state.
@@ -1053,7 +1053,7 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
 }
 
 /**
- * tracecmd_output_write_init - Write the initial data into the trace file
+ * output_write_init - Write the initial data into the trace file
  * @handle: output handle to a trace file.
  *
  * Must be called after tracecmd_output_set_*() functions and before writing
@@ -1070,7 +1070,7 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handle, struct tracec
  * Returns 0 on success, or -1 if the output file handle is not allocated or
  * not in the expected state.
  */
-int tracecmd_output_write_init(struct tracecmd_output *handle)
+static int output_write_init(struct tracecmd_output *handle)
 {
 	char buf[BUFSIZ];
 	int endian4;
@@ -1131,7 +1131,7 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 		return -1;
 
 	/* Write init data, if not written yet */
-	if (handle->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handle))
+	if (handle->file_state < TRACECMD_FILE_INIT && output_write_init(handle))
 		return -1;
 	if (read_header_files(handle))
 		return -1;
@@ -1848,7 +1848,7 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 
 	if (tracecmd_output_set_from_input(handle, ihandle))
 		goto out_free;
-	tracecmd_output_write_init(handle);
+	output_write_init(handle);
 
 	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
-- 
2.33.1

