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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACFFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3EE610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhINNOH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhINNOH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:07 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55DDC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:49 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 140so5813004wma.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WIhyREvMq7bERJU6rUAI/8YHOuVEpU7iUhUrHTuHcqg=;
        b=KR3hCJQN2tFcV1Nv7cPMJxnkXu/z/maJumAbU6SLji2q+815uthvsfFdCkW1be8UWG
         opCgh8hkTUwkeH7pym1mJrlFBblNSA17kIanInHr9FgJ0CoqGPHKU5qO1Js+NJ9uqXc7
         ikZS1p+tIXZt1gvffApZ4+zqRrL3pG0VLDCMgZRvL5VCijdglSOlbKv9KPaI4C+OUDxB
         QSnYwTh8WebJa3fmE8/CDgwjVBiuVfoKCp2UrfhCVnQsHlAl4Ups74rN01RwdpZDgb+P
         LkqnII2IB0I8N7uMRY2vfkckiBeeOWzsWhahur3Ja5LryFxxXehChFLfynZVGxJNsG48
         G7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WIhyREvMq7bERJU6rUAI/8YHOuVEpU7iUhUrHTuHcqg=;
        b=sOw05uIwk8Psrv5D+kPt3ztoIj1mscrkEX6K0oDKaz/x5pRU+asqici69ze2gLeywo
         jNCKdJ63fZpOsAMEep423HOiuAdJhCrM0DQejAzqH/qbES8U9xx0+DgT3D5c9VIZ4zvW
         CqOBb0lE7locVfpBklGBx2GuUkNGK1QP3c5KOpj7Wf9K/EU9m77UYdx1rocZrgE/VO9c
         i2tB8diXuqWnsAdkFvFjf/5Ak0h2yVdJgVMKy8VCp3G5lG7IIQr9VsTgHjiWFjgTEhQd
         /KjfLw3ULjJaZnh/KLsPlOhjbc3uxh2KJsvQhTubcABXo33CJ5ccb943Q75sjgVWaLk3
         Gx2w==
X-Gm-Message-State: AOAM532RxvSDXfEzPC7guLvJbXDJVbEN4nTXSxNDtTHWMd0JAWBSU2ey
        Xfnc0FzFSvEXsbHAlHrjYm5keYMjVVQ=
X-Google-Smtp-Source: ABdhPJwug5rc0mqERhpImotorUcCYwoarihXx0+lTRqFD5FEjppQ8ddkDBhGsw40808a0Mef2r9UJA==
X-Received: by 2002:a1c:4406:: with SMTP id r6mr2152401wma.150.1631625168530;
        Tue, 14 Sep 2021 06:12:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 12/21] trace-cmd library: Fix possible memory leak in read_ftrace_printk()
Date:   Tue, 14 Sep 2021 16:12:23 +0300
Message-Id: <20210914131232.3964615-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_printk() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9b23063e..60d75d47 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -777,33 +777,39 @@ out:
 static int read_ftrace_printk(struct tracecmd_input *handle)
 {
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_PRINTK)
 		return 0;
 
-	if (read4(handle, &size) < 0)
-		return -1;
-	if (!size)
-		return 0; /* OK? */
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_PRINTK;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size + 1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)) {
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
 	buf[size] = 0;
 
 	tep_parse_printk_formats(handle->pevent, buf);
 
-	free(buf);
-
 	handle->file_state = TRACECMD_FILE_PRINTK;
+	ret = 0;
 
-	return 0;
+out:
+	free(buf);
+	return ret;
 }
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
-- 
2.31.1

