Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10151C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358030AbhLBMZn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhLBMZb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:31 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C851C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:09 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so115336027edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5p38FZqH0I5MrwjJZMrgkI8KbPjBmw2hrNp+1VUKmc=;
        b=jR9gE+KH5uc6ibL25Q3wsfZd0gwzavk7dquHoNIubP4S+6Q1cbbJ8nJp97G0aNLSJk
         hzdpXybUpo6XtOxEcDoCKSsOjZcC9c/Akjo3lAVPzJwenVaUwGd3YwjBA+PYlsLcW7Dx
         bKgSzTgVT8J/h4TOILeY964zVPWH5CUVWO/cJaVB81uwkCgSj9X1oQuAPCtLrPcitEtw
         seC5gLBkutGTy3kQZHBMSmG+JvoVAWt8W9BCGXCUf0jvOLIIKRlMWu+wCgodXSdi4k++
         KH5Dp2YZOZC6VZwZDSv3EF0sfdv/vi2HlTtVFMs8qNglfBmPp6F5SuqjlBR1zCcJcgwq
         3fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5p38FZqH0I5MrwjJZMrgkI8KbPjBmw2hrNp+1VUKmc=;
        b=pzjDtwuQ6QiU+Px7A1oY0wvlG7VFXziSVBxh3N7hU/pgug/YVVoYWMphB7spwQtQ3D
         Y8OMcOyLJ6LZXaaafZ/rndxVS/DsZHIZhwRxYE3kwnFYqg0t585aTUFuwHR2jMkmPe4e
         6iLqUrNptfpXH3him7LCBkk3L0VkdWVe45qjCfJT/9ZwqBEqGJz+94km/KO6dcwIpi5d
         HE5sQDXOtjhwujX3NdgOakBizSuQN2d/gK3AA/YMOcrs7psmW42wYVEwUuLDKaxhtHjG
         tbRupzd2l6e+UZvmKZ8n4q6HXT1tsFCiL4KSr3FEBqeiwGNk2aNp/nAH2zof3/OLtwDT
         mfmw==
X-Gm-Message-State: AOAM533UvEoCES3Qbz4TDpL2q3YiiAvDsTA4XL+/0V/rNtarOfZpDNmu
        +QfozN7IO2CYiyelwG+1cyuXqo0a397HKQ==
X-Google-Smtp-Source: ABdhPJx1mFNh6f9XuQJ662lx7+ZYXB+F12NFOdz/n/QKV8vZWGD+qfUhmB6exB2QNlzK5gJvoQkgBQ==
X-Received: by 2002:aa7:d546:: with SMTP id u6mr17604997edr.311.1638447727937;
        Thu, 02 Dec 2021 04:22:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 14/23] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Thu,  2 Dec 2021 14:21:43 +0200
Message-Id: <20211202122152.43275-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 7f24d2e2..8f95bf3b 100644
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

