Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304ECC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhLJK6k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbhLJK6k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348B6C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:05 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so29158539edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5p38FZqH0I5MrwjJZMrgkI8KbPjBmw2hrNp+1VUKmc=;
        b=Bi9wh+ZPR8sIcqRvpHevu0fF4TYdfwfizNwCvev9ZXoXP6YKVW79OMIH0sCc5mMsSJ
         +2ZRvYv71diNHjHYTqTQ9zWbhJ94pa/5iYxUrxB5eS5FIQJwtBv+t8qAJq1N2eo9D9Oz
         XhX6/+9ScZDIgizSqpx0ACbBVUYFo89QLtooorqfu0A/UdhrfpkYhkuzvG57A9B1MkiO
         9b0XEU6DJl1/oKOBcy0ge4KcIoBa8GSxaE7gum3m/FMgDIn6UGP9GOTxmm8yImyvrmsu
         2QjwfZJB2pG6nlCGw++sKyYyfBN5KzjX1lHnL318nmzVF1qTWIRpjdSsoj8MohpI0TPb
         RbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5p38FZqH0I5MrwjJZMrgkI8KbPjBmw2hrNp+1VUKmc=;
        b=dw0niba7zDZNAQ8TkgEh7u4fbnmyAXgkfgJorgeGJ8zY49ikrqWoiSC22RqlXeytO8
         oC8O+p5amuBgZ2ngFCtheTj7SqfE/nR6Eke8zRFMW4JzGFYw8iO6WD3I8ZaScysHoGMg
         DlPfAcqVrUIVJJUmSyT5TgAdmFPfMCxwdjRSd9AHrbxxC8kHFhgklkv/ipTF+IZFWDht
         AoXqfiW0LEpu54d16Sbtw4kkDE3g4EhTmRf5l+b8C320Rk2WOtnCi1c/wuvvX512bjZ2
         GArndbkHZ4Ds040gP2/KEO457EagqoINAK+PP6Y247GMY86DDQvglQyOPjVS9zBLStuF
         OZnA==
X-Gm-Message-State: AOAM531FiBADWEe99M4IVHQTjHKxA3wl8oKqaDiUxjRjIVek34EBRj7P
        vlIziJOJscUA+9AEtY7b3DSmIKhAOhM=
X-Google-Smtp-Source: ABdhPJxXXAwAaPUZ/tDRFNLlJ7lZ3ibnGPKBIrVHzvrnzzwHr1KfrytBNEUmALg1RyRATM139stMGw==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr37734740edb.225.1639133703747;
        Fri, 10 Dec 2021 02:55:03 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 15/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Fri, 10 Dec 2021 12:54:38 +0200
Message-Id: <20211210105448.97850-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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

