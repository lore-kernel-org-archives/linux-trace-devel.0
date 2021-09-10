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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D53C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66308611EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhIJNtZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbhIJNtX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D470C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g21so2586315edw.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iv3Lw+Gw67afDFbw6jxgNvIwogJ7PlWL0EnjJLTvFKE=;
        b=plpPCOAmef6sv1uBLwtAeTK9VgH3FzFCh+Mo4IAZ7DSloEgLkqlDkZuf9P3mZDrTSh
         EUgjR2Olu9AHgULE+MTp91eRiGcYE9ccKbylTnhCJ89TK+tJr2MH7XdHtw2wACw9CdZu
         7AY2urP5LfrugSXT2EFyTEuTxM9CsLgXRmiehuo0SS+bWojc4gxiB7yhkKFNty+PyI7t
         /XiXrthAfOA4SQcBDj9COPsbpw+FY00XiNGeGZ7jJ+G4xBt09LswufINiyfzqPXzuCPH
         R9KPLjzCcjeYxmPfOx7UdrknbapqMbrsEcU8pY+yaiFodozBMYc6CLxzZuHQgtp7aEde
         98Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iv3Lw+Gw67afDFbw6jxgNvIwogJ7PlWL0EnjJLTvFKE=;
        b=1gshfQsvT5Q0Ld/YmpAt5z5mZAAt0h/Lw3hnxIgottVJON+CvFhoSwDkMaB/jXBYWF
         Rfypu/p7HhfaQiMM7m4MrbvphcZse8wjDqwpVSSzh4hK55Bg4a1qX8+aOibIiJ0z+sBO
         4mQT9kZQSDSiCcpeYuxaZAwpw7DpOkYknLd61hCFBQ+lT76MzIAnm8vSNtNcbpSqLIxd
         FCsc1BBof5Nh/xf7wX9vUDuWF3c0C4qhOotHWdI38RpwbZFZcY2F65doESfhW04F8zPz
         uY1go3leZtKC4vaRpqZiYplFGC+r2Cts6AqqVq3PjfV3VDhIruhErj945G3MrhWI76rK
         Lihw==
X-Gm-Message-State: AOAM532HWuMJRVmX/f6nHvs8bGMTzk4Gjp3Dhzyyt9ze+Zj2c9uVQsJJ
        r5ys1MUxjIsq2AfRlE01Po3/JHiO5vU=
X-Google-Smtp-Source: ABdhPJwEX31pHtzwY5/qVnHT5zuIiqgk/QRxydTw98Esk4XWdjXvw/0SkYfLCyCkKrASzarjOwv37g==
X-Received: by 2002:aa7:c988:: with SMTP id c8mr9323073edt.351.1631281691228;
        Fri, 10 Sep 2021 06:48:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/21] trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
Date:   Fri, 10 Sep 2021 16:47:47 +0300
Message-Id: <20210910134757.2863982-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_proc_kallsyms() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 39 +++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9eeb7427..99c332c8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -739,34 +739,39 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
 		return 0;
 
-	if (read4(handle, &size) < 0)
-		return -1;
-	if (!size)
-		return 0; /* OK? */
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size+1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)){
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
-	buf[size] = 0;
-
-	tep_parse_kallsyms(pevent, buf);
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
-	free(buf);
+	buf[size] = 0;
+	tep_parse_kallsyms(tep, buf);
 
 	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	ret = 0;
+out:
+	free(buf);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_input *handle)
-- 
2.31.1

