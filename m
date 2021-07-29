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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B79C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B2D61019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhG2FKm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E62C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id ga41so8408743ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptPZ/80MdhCrEcenl0jzvNbSbaGJq99hoNeDNg4hlMk=;
        b=s/7X9LruWAji4MlB7rO7zJxSl86LpDWMGnVys/5klgiWs3xFnqPVFrKArb238aV8ep
         PZBNm6jz8WEU9DQOi+iNmaRgC8YK8oDcoAwK4XRcyBp6HT6kfvlXhk+NSNuIEq2vvKdA
         DESZpDfazkplqaSeoqsPR2sMX3K1PJM9ovLtXn/nLPki1VipJwMnMpylt4VxNvMyQh6e
         g6hRKKBb3EMqMEEZyKHnm3TMIaNKne9CAnbJ7eDs3+wzKxS437OoUzWSbUXEX4qOX2e/
         DW3DWZ71EHkXg2KumsWQlumL3WAVdPWLpFXyAomYoqb23/JmNunQ+ClSELd0dNOMRX9Y
         y6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptPZ/80MdhCrEcenl0jzvNbSbaGJq99hoNeDNg4hlMk=;
        b=oWH9WEEzycRU13gQl+3JQnPoNYO79LRDgdzEDx7uaiUti16HyAiEscfhMbIEhlmB/o
         +RGTsH1KXddIqkorhd5fLln9RZf+UUciHEG+qMK+Ow8Tr1LfQYJnlPu/mfOFBl0qubDw
         XgurYIyrqTZR0/Cn9pjoZnPxOwPbBmIbjCp+41R13XF8zqs6pebHVHGGuUGOPwgnh6xB
         On5WXQDB/DYxPIkap1V7MVZhu+NJGvnL/wGwiMPWczokk3xUKEnJhArVeA9ZVf88OzRK
         RAU+hiMBSXrHwFJl5K+l5Tov6+fnYQnIjp1hjyl7Q8SjybzWskBVcaUW6184UEemJAPP
         0okw==
X-Gm-Message-State: AOAM533QUgj4M6DGA7kGmtzHy+m5OuwPKK81MDjJH9c8dXfAHwrpKvZZ
        ZINZp+QZ55wvjkwSXKnrMUjrbJ2zI1nSmA==
X-Google-Smtp-Source: ABdhPJxZ1Ywd8FKh4q5CVP+DMUwoYK8Upy3p3/5q5ibvr6XFit/OGViaU/VE9ZEuTxCChQJeMFUYJA==
X-Received: by 2002:a17:906:9246:: with SMTP id c6mr2783848ejx.78.1627535436927;
        Wed, 28 Jul 2021 22:10:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 36/87] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Thu, 29 Jul 2021 08:09:08 +0300
Message-Id: <20210729050959.12263-37-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index f5e13bbc..bf56c92a 100644
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

