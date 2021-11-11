Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BBBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236ED610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhKKPOK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbhKKPOK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:10 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70AFC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:20 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o8so25323358edc.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I09wudgEnThqsxiNXmxXrtQhMmFMUsD5LAbnumUjoP8=;
        b=XndKcvv4QCXFzEPktCio1nvB3xe/+A6XFhHLlRRJ4ljEoGGhoiVESyTz79yFalESQ0
         XX1O2rYHCWykl9Ghs+iJ6jPPgC0mnKnlSL1XJsY3CfBoSQzj8nPdu1PjnPguEV9IgIys
         ZBykNrQyY9EAG/zSVj8aC99uL1qx5hAO5dBf4QXMUCfld0uTC2Uxiuq3diARFyiXpi/k
         WMVQqJdoFEv3Om31jNVQ/FMj93wIh0tGITYxx1W3kqKtJUUasX1dP4aZzD1uXVXaD7ON
         0GJC0ZNdfAwWJhjAr/SQY4e5KPuJbznkpq/ndeEgbxssA4GACB+VvtMx6O/0m5GIUrPN
         qYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I09wudgEnThqsxiNXmxXrtQhMmFMUsD5LAbnumUjoP8=;
        b=az5MqHUQymZo9JDH10hP8kcmCcriYT7HipH0qSwsTOkNfx8oJh6LAKPJVqCM0znFV4
         I0u51pBRaEjF/PD1xiZX4Tg43rI9VZSkm4d/pA6BTp+4oYzkPOQ5OjUpBFdaR8q90Gt9
         bFnRpOeI96N8voFtaPZxYT8M2NIz8kz1W+oWZI33UW1pNnhXjLTNRKUgH562dnwZRXbu
         y80SK7t56fxc/RBECAD59Nh0t8LlLPctq9yahMujqxjXRbSvMuNqD2BLEGfSbf67/8dw
         sD2zJYLWyR/ooUcfcE+CmHFwIUxEMRDqR3+D7YNUprDXIKYQpjeBqEbCVqrrdETk73UF
         jshQ==
X-Gm-Message-State: AOAM532L4tOu0fQPl619yksRyzpQL867JEd6kzCpwfUal+/Tf2xTMz7j
        NqSMSkDTD5oMtF0tasaXmNDcWh93Ql4Nzw==
X-Google-Smtp-Source: ABdhPJw0efyOedUtnYl4FkrgyPrbC2WI+6CsUpXlbyj3ij9Klp5a0p0OSATgtN8L5zAZC5jTLD4/nw==
X-Received: by 2002:a17:906:c155:: with SMTP id dp21mr10014180ejc.325.1636643479525;
        Thu, 11 Nov 2021 07:11:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 16/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Thu, 11 Nov 2021 17:11:09 +0200
Message-Id: <20211111151112.86751-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151112.86751-1-tz.stoyanov@gmail.com>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Utilize the internal database with file sections, when reading parts
of a trace file. This logic unifies the way trace file version 6 and 7
are processed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 75cc083c..03b044dd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3268,21 +3268,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
  */
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex)
 {
-	int ret;
+	struct file_section *sec;
 
 	if (!regex)
 		regex = ".*";
 
-	if (!handle->ftrace_files_start) {
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+	sec = section_open(handle, TRACECMD_OPTION_HEADER_INFO);
+	if (sec) {
 		read_header_files(handle);
+		section_close(handle, sec);
+	}
+	sec = section_open(handle, TRACECMD_OPTION_FTRACE_EVENTS);
+	if (sec) {
+		read_ftrace_files(handle, regex);
+		section_close(handle, sec);
+	}
+	sec = section_open(handle, TRACECMD_OPTION_EVENT_FORMATS);
+	if (sec) {
+		read_event_files(handle, regex);
+		section_close(handle, sec);
 	}
-	ret = read_ftrace_files(handle, regex);
-	if (ret < 0)
-		return;
-
-	read_event_files(handle, regex);
-	return;
 }
 
 /* Show the cpu data stats */
@@ -3886,6 +3891,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3901,13 +3907,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
 	if (handle->file_state >= start_state) {
 		/* Set the handle to just before the start state */
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+		sec = section_open(handle, TRACECMD_OPTION_HEADER_INFO);
+		if (!sec)
+			return -1;
 		/* Now that the file handle has moved, change its state */
 		handle->file_state = TRACECMD_FILE_INIT;
 	}
 
 	/* Try to bring the input up to the start state - 1 */
 	ret = tracecmd_read_headers(handle, start_state - 1);
+	if (sec)
+		section_close(handle, sec);
 	if (ret < 0)
 		goto out;
 
-- 
2.33.1

