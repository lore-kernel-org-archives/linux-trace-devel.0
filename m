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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DE0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E6F60F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhIMMbX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:22 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374EDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:07 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso6817023wms.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37H7EkMF0fOQE7e1qQRM4zym8Bfjvfnp/V1oDS0mO3Y=;
        b=k28YOyfaJ6fWNT795Y4Qy/oX2ifcQx2fY9s/Ne9/ekBvbtygq+6rbNwLhIOYoPTIQ0
         qcilgJgDGh9v9oqiTvR/U3yY3NADPYBh8CDREH5GLqD/WcBkNupbTXrx1zh/SxkiUm/9
         30vXwcXWZ4gluqB3VSmGcZ6FBRlruwfX4wfpJT6uRbjdXQ7F6SXICci5bm9RPEnHy48z
         41odOUN+vBGm1GiGa+JLdC2+iaAK8CPpjwkOVeY6PTXhgxgUyPRAmdsblntriDZbVKKB
         XOpFBJReGkDB4jXB8bwFLJbj9fiznyZ9hPeze6/i9jfRiJgVGBL41cd+SegMQ78gx9S7
         PC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37H7EkMF0fOQE7e1qQRM4zym8Bfjvfnp/V1oDS0mO3Y=;
        b=jIvS+QTH7/61tcennlXCJxiXTteV59JrTVQiVyju77owDaQTaKgt/gymtvE2mOx4n6
         jDpErvQr+X028ltS96YRqJNknc5jjbDPuVMGqkQ+zOHCwFXSYTFC0Bv5adflMWXaCpLA
         R48erKs63/eC/N6NW+1ahh9KO+PMabzElIgaPYljNifWeuNh0eVjQqNqNMtQfvYpHesJ
         UeMinEpvRs1i+MEMkoulAP1nU7FJYJCeIqUPA0op+JXNO84Ho90FwrYjpRgXsTDKW1PO
         +qoLzzlbyoKbVsB9wcMxAH2w2Ii49qNQveCIFHPPY4T35l6aP4qUUSXibIIR23Vdy96O
         KoLw==
X-Gm-Message-State: AOAM531dL9+rODQigXxRPSDtqjlux3iuI4AAs4gNcofp1obTuHngtXWy
        EBlC/0poVyq+3CY4jNKkQzyRSjKU4rw=
X-Google-Smtp-Source: ABdhPJxTRNRQOY1A2fvml+6WVbpUrZkbD56qRw3jiDWH7VFaH2dQjdLdV2oLcEbwQPkF38F7iVylhw==
X-Received: by 2002:a1c:cc03:: with SMTP id h3mr10771027wmb.73.1631536205881;
        Mon, 13 Sep 2021 05:30:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 16/25] trace-cmd library: Use sections database when reading parts of the trace file
Date:   Mon, 13 Sep 2021 15:29:38 +0300
Message-Id: <20210913122947.3673239-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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

