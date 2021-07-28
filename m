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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B609C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786886101D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhG1Ndb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhG1Ndb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8091FC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:29 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h8so3257134ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2Auh+LOVFv6OoXZ0DQZHIUY4iaiaMUS8YGNH2TK4CY=;
        b=CdvWyMVhAE+yUjaVqX6Nm8ZM/ShlRl8BO9mfKFluzA56f2oDaR3WO1sP1KKAANd8U/
         jtYgGJFLIRbJH1bOrAEs5mGQMCS8jgsZMIIfphycpx19p2J9BixJ6j3656/Eida/OHC8
         2wt1LJcGSmwUs6b489tUPne/LCww7OfgTuc0/RJl3Lgb1lxLPOJWp0gJvajXuVexaLsF
         V5V9MPOPmcFqFzToC4OGWlVCN3KJk7oHL9KOgSYXylvJPtzJAS667zCgzLyCPKZG4Lpq
         A2XIu/4qq6eh0IvrfyAe1pHzr2GFeyo5ANa47l3OkDri4n+1gSVfvpkz8TJ7DTyJXLow
         19uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2Auh+LOVFv6OoXZ0DQZHIUY4iaiaMUS8YGNH2TK4CY=;
        b=Uv6HNvizCzHOe4nu4qF1EfAJgivw3kPlj7qMSXwqhe++IFk6u/D5Bf4VWrBX+i/+gS
         p+TqhbzjzumPoq/h0wQqu9vfRwxwkFm8UzQPpjuQ/w6/LX/SXqqwl7iw4LyPR7XLkFk5
         tSsTf87y2UaWEO19hOvgIBzVmwCOd4uagulIcGX8jggQ5awk2unIoc+yFBxmyXeH/09l
         4horwp5b2fDicEXJivIgeZU8YhlvLlJSs+zJckzMPSPGOKGMJKb6o9yCPklEl72Epzbo
         bjYMamfes768xZeqU+Hxm5NqNt1U+/6mbXpDdcMxcPkxx5O72MPH83+rB86MWvg5kI6r
         IGZg==
X-Gm-Message-State: AOAM532nq8t1blZVl8CmoFJOEYy/v3/JohD5Xjl8jSbk929BnjmkiGEF
        r6V/CZzMhTpMYKudfnlkyY8=
X-Google-Smtp-Source: ABdhPJxObfurXAwd43HxnBxiPN3Uk2IyiaHhlwomRiZeUHRu8yykrOSunXdNEjT9EJnzbRQAJtx2PQ==
X-Received: by 2002:a05:6402:7d3:: with SMTP id u19mr17306298edy.188.1627479208163;
        Wed, 28 Jul 2021 06:33:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 36/87] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Wed, 28 Jul 2021 16:31:59 +0300
Message-Id: <20210728133250.234140-37-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index cdc7379a..b96f6d1b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -163,8 +163,6 @@ struct tracecmd_input {
 	struct pid_addr_maps	*pid_maps;
 	/* file information */
 	struct file_section	*sections;
-	size_t			header_files_start;
-	size_t			ftrace_files_start;
 	size_t			options_start;
 	size_t			total_file_size;
 
@@ -3301,21 +3299,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
  */
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex)
 {
-	int ret;
+	struct file_section *sec;
 
 	if (!regex)
 		regex = ".*";
 
-	if (!handle->ftrace_files_start) {
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+	sec = open_section(handle, TRACECMD_OPTION_HEADER_INFO);
+	if (sec) {
 		read_header_files(handle);
+		close_section(handle, sec);
+	}
+	sec = open_section(handle, TRACECMD_OPTION_FTRACE_EVENTS);
+	if (sec) {
+		read_ftrace_files(handle, regex);
+		close_section(handle, sec);
+	}
+	sec = open_section(handle, TRACECMD_OPTION_EVENT_FORMATS);
+	if (sec) {
+		read_event_files(handle, regex);
+		close_section(handle, sec);
 	}
-	ret = read_ftrace_files(handle, regex);
-	if (ret < 0)
-		return;
-
-	read_event_files(handle, regex);
-	return;
 }
 
 /* Show the cpu data stats */
@@ -3905,6 +3908,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3920,13 +3924,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
 	if (handle->file_state >= start_state) {
 		/* Set the handle to just before the start state */
-		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+		sec = open_section(handle, TRACECMD_OPTION_HEADER_INFO);
+		if (!sec)
+			return -1;
 		/* Now that the file handle has moved, change its state */
 		handle->file_state = TRACECMD_FILE_INIT;
 	}
-
 	/* Try to bring the input up to the start state - 1 */
 	ret = tracecmd_read_headers(handle, start_state - 1);
+	if (sec)
+		close_section(handle, sec);
+
 	if (ret < 0)
 		goto out;
 
-- 
2.31.1

