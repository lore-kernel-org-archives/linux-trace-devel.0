Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A048C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4098B61073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhJHEWO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJHEWN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40E9C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b8so31213540edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eod2N2vuxA3mLCSP8JVbmuy7oNypo7J60hdg1Vmvvg4=;
        b=kt+VhI7itxqNVbmZo2b1ez5qzRW7Z0M6jzV2ZJJrFvt4rT1wSiH9+t4g1+RR35RzpD
         lpBycY85SfEv1MFXMZAiqEqn+SYJi6TbgJxyduOG/r9P00LgWOdaW/qG8g1FuVyhrHdH
         Q9VU2mvQ9W6+ioYUwDNBPsWGk2BPp6LAqLWtbAubryIrdiCbuI9vClmLmVooNlLL4add
         PGMR3BtikWXSJHAT2mFa7ZSZyXtEtAw55KfNKEk2H8Mk8ClljruMo55OqZEKVHvJebDJ
         7uYJ7e5+r+8VcVRE2ucVw5IK6D/Iyy4rwKefexv7W/46nBH7IyxyYnOzzuQZUuwj0OkH
         ecPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eod2N2vuxA3mLCSP8JVbmuy7oNypo7J60hdg1Vmvvg4=;
        b=UeONVe02JEoEFD3YqLlAJ/SJfnf4Ke7D9zUEcX/jmmFYSmsbNd8vouCx4BiQ3ZYvcn
         z0TZw1a/1wFuBZPTjEyFxPi1Is7H0knsKfZDY0RL98jWAYPcK1Cfws+TdSgdKvjlVC5B
         zCeQDcaDJepQFmZGyqeG9IYW/twmhXilOaknDs0QInyMqoYIThGfuGgC5KDP1Aa+w16y
         P+pQYExLYQ7jQRz6QSk0fOgM/STmJb3LUBxW2CQHP8ZdkGd0ap78KMaHWpS40FxTZiDa
         2Krv2ZmeqlLNVHXGcIS1upJeejW/Qt4jsn7uyo7evrmnq45JveiNn/7J6Je/oNrldyhh
         YJvA==
X-Gm-Message-State: AOAM532wcdWwoasEk+n8zjUJg+zPf9IHST8Uq6X+/77oyMAeFOdj9YW4
        /g7E5HuxPouwxz/ZvqjAjpmRrEtuaNPpgw==
X-Google-Smtp-Source: ABdhPJwjAREE3SxNxPETMK8g58g6+EyYHZFZVcKDnW1M/rhr5A4t3ushxuiuT7/sdnjUIRI22RdRmA==
X-Received: by 2002:a50:cf87:: with SMTP id h7mr11967547edk.324.1633666817335;
        Thu, 07 Oct 2021 21:20:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 16/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Fri,  8 Oct 2021 07:19:49 +0300
Message-Id: <20211008041958.976309-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 9e14de4d..7386f407 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3269,21 +3269,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
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
@@ -3887,6 +3892,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3902,13 +3908,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
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
2.31.1

