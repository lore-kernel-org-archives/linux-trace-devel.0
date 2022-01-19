Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DCCC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352395AbiASIZa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352400AbiASIZ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:27 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BFDC06173F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:26 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m11so7403551edi.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NX3ri/ZFqmLhlylTQASE48AM7fbXmIafPIVc+13EIEI=;
        b=KnW2S1UGhK3QS3zovY2zB0s1Wd9bI1eFTs04oMG03nky9yVZEk+PUGBx4d+zKwlCdS
         8fTP6AdqNKNAolDAB4o5JuMgaSA23nHKhEHQOwqNPwzcAzEEtGhKhIJDGCG7gC7rP4me
         pKIR1GofP2HB5xjNEc1SlPg2Gbajd2eaNvfPBxGNunnloyfK6qX6m5lIrk4I+6JLWWcb
         D/BNXiiefX5uM2nbqOmHX1KjVjj+hDYRMhIKGPupmTapj3CSAyrNZuSKoHLDwsx4vXZg
         9HXCx/rbehATUaxVQ5B1nhvQ4PCf8FMqwGqCAaeyC3l3kyy5LSqFNzIwdfaJl4wtuivL
         9gFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NX3ri/ZFqmLhlylTQASE48AM7fbXmIafPIVc+13EIEI=;
        b=KUNqAfStcfZm5Kh20z3Kf5QWfv9sjmj8zDGJYNyRrsRfGGi+9l6mqFG4qA0ROvEWCT
         odInf599wPXWmNnno5KvxpnTuARBMxGDKgnhTh3nXhjlufat3n4LvRWX/5jbxzV3hQcU
         le2AZ/9p3969qtBQjEXNQPqApPZD3O4idBFclRWGIlU0QuOGxvpK8UaAs35wm/Ori+93
         KgM5EdW2UA+1qVTHwhmuB432u3tv3uE7/d2j7k0MfIGkFzhbqnmQmBG/ORn0ZT5ibCyT
         TLAR6gBQQHpPo0attizHAZub4XZmC6z96zWCCGnYokZlSUVyTbtrAGnv4dCSLrnd/f9M
         p1wQ==
X-Gm-Message-State: AOAM5301Ci3tt6rnlcl4BIxG+Aq8wUHbwsIPqQSKbuNy4PbtJxSD3D21
        4nzap0s1iC1xuDHpKFpA1ay0+TxQu6g=
X-Google-Smtp-Source: ABdhPJyvfQhiqvtA6BeCP/P8hLcRoNtGbyYoiAj8KabsgljcgasOZLQQbyDr6NMbyj4qhuugLkQqkQ==
X-Received: by 2002:a17:906:3052:: with SMTP id d18mr23622327ejd.675.1642580725513;
        Wed, 19 Jan 2022 00:25:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 15/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Wed, 19 Jan 2022 10:24:57 +0200
Message-Id: <20220119082507.245600-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index e3ed2bbb..e8ece688 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3270,21 +3270,26 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
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
@@ -3888,6 +3893,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state)
 {
+	struct file_section *sec;
 	int ret;
 
 	if (!start_state)
@@ -3903,13 +3909,17 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
 
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
2.34.1

