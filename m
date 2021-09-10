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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90605C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B64B611EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhIJNwc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhIJNwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6220C061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:19 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ho42so4370731ejc.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GW1OWu9L5V4EfWg9zRk4Y4LtNoUrhGA/Nd/NEicq6p4=;
        b=kgcMi5ehYvihtybqEalUItZBgN2YD9miBAhqQaDgIGJTgKW4ZSFtyMSGE10fkHu1jP
         3zTJ31+oKSXHyPOqBL56u5KhxhKP+lTHmqhS/V/TmK1mttKTDIWRgAXxFrS44QHqkL/8
         Qf45ZRdBEHwJddeGoKI5IWf/s8p0QJcowh1licQvTobd/5nG7EKCEa5y1E5X4YPUhTn7
         fRTcYKAeI5PpvGZNZS9luf0ZyeN2p0RUBhup8Suh/0UD0H+2c41AxHyZpz6cPwr/dbl2
         fXyc/1iGZm5Zx0PYyx3ABXg5JgAl4iddXqC8n7WR+xIjDPspagVlCqo9lTRtbHZ/27Xc
         BvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GW1OWu9L5V4EfWg9zRk4Y4LtNoUrhGA/Nd/NEicq6p4=;
        b=rxhcza4e+sJSHluahrJliiuvQvRJmpxp1sXlGkv3p+NnIQLxXyXNySsz4LjgjvAeDB
         Ekb75+Fwc5glTCo1QTPWT680C6X1WAAP2zA7KpupAHuYjFFulK9vXFXeqyNGMuYj9jok
         Jdady+/s8D8xQjhsS1q/U0ME77EpEy3ZrwnN99DCrFWQ7KnVlCJquJMYNLZX6hcnP6iW
         EUR63tTPJrsEfvpH7nEa9cCsXtiMzWs+DkqMa6xNmpTe+xsmEM+ql+j9tJ3h3D0fmWxq
         vnk2E3pR5eGvmXYItShibON94C4f5qf/VsPAQJlyOelW5TCoLo8tAK0wQXW5NuKNcw7F
         99xw==
X-Gm-Message-State: AOAM532VaCzt94Sg0prH7ubxjQS3HrB5P/qFF4rMhh03VBJYt3ie01o/
        RzwEdlewJkxEUtd96cVSwXSF7KBgscU=
X-Google-Smtp-Source: ABdhPJyE4gNNsAS+jrY60LmAnRMKUhQ9RhboY3o61zwR/GtlPVyu4PD7Toe/nR0ONHzvIPRs3HcrlA==
X-Received: by 2002:a17:906:6445:: with SMTP id l5mr9241534ejn.194.1631281878473;
        Fri, 10 Sep 2021 06:51:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Fri, 10 Sep 2021 16:50:52 +0300
Message-Id: <20210910135101.2865226-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index d6aa7c8e..6eabd04e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3285,21 +3285,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
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
@@ -3903,6 +3908,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3918,13 +3924,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
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

