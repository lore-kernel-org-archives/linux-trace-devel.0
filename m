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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFF7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F91610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhINNQV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbhINNQT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:19 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DE4C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:01 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l7-20020a1c2507000000b002e6be5d86b3so2507526wml.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37H7EkMF0fOQE7e1qQRM4zym8Bfjvfnp/V1oDS0mO3Y=;
        b=cOug94CY5wbSxPPLojsQq5eXfCZihLvnGFR/ZDj0fYs4Gxlx7kbuQbctlnbmD3r/eu
         HUgLycfijxcH4xx5IUDZ4SayPz0hn3ZUe72z6MuAyet3FW8Yevj8DdE8pR9Kp/RmUypb
         EvBOSIRmRb2UWWq1q6BgwRNaugOgOXBLnKTOI04OCAQ712FT7EttQqMpJAPz5zE5knEd
         MhqC+nFsGDn37KRi8EQZKtXP8F7zoZkw2jgTA1u8AxmHkQh+11BwkSYlHI7xD0TPIBy/
         yEyeO/3kR7iOo9DfZ4Kana9LreAm74rpt4JS4ilAc+LeVTJ5rvIReGAjjttDqHfUNdAm
         F5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37H7EkMF0fOQE7e1qQRM4zym8Bfjvfnp/V1oDS0mO3Y=;
        b=TwTdvpckcNn56njOqoh2NJaJn0LbwxYdZjAUOW5G9nTNH8pBnpSz2YXbiJwEzVWAZX
         qWctLTj9GwkRgqwC/UEgpDTEi5h5neZb/Ly0YOYGd60YhvH55DdV11Ul1lOwBECInnSp
         DeAVQg+lqhvyb6YnWYPRtBE2FRQvDevnqgGVF4/TVGh9y2XBjFHT+JK/o2kHm/2XuOq8
         QHvYBu4UmAw/g/CChcxBXx7utFSUsB8561VsZV6sp14B+J9DQrB6HbBbUGpOjWNjUiM7
         sQmRTZvHBma1adJzDYPCqFHyoX4VC+drAu1snWC7bgvBJZZm7th79yDQntZI2p+dqsNx
         hAnw==
X-Gm-Message-State: AOAM5336XD8MtBBF2rLZTv4EhCpcmfeYPtHTH6PBauvs7qoC9fmC7E26
        1sSl2hxm0KlGeMQfvic5QsqGhODZs7M=
X-Google-Smtp-Source: ABdhPJyZhdRKZIeFJ6ObcT1j8V+WwofUBwmIfoOMSgSp3+J3NKcDGcp1xYANWjZvKdUHYehfk9+kkg==
X-Received: by 2002:a05:600c:4f53:: with SMTP id m19mr2187553wmq.2.1631625300527;
        Tue, 14 Sep 2021 06:15:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 16/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Tue, 14 Sep 2021 16:14:29 +0300
Message-Id: <20210914131438.3965484-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index bc3bc5d2..785a1b93 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3283,21 +3283,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
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
@@ -3901,6 +3906,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3916,13 +3922,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
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

