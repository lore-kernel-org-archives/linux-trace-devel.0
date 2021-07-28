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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B23C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E0060D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhG1Ndh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbhG1Ndh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14641C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x90so3223620ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5SeDlZZJ28Q3bVAIca8zRC8x5oKQ/h7pAD38Pw4cMwA=;
        b=eUaYmmYF7XkHvToDDeYs1oEGoD/vhEwEE/ELYkEP7W+JBiszMx+dXn+cGK8qil9qIo
         NGGvucu1VkegscwnLO3OHyV3oiUE/5PQwENbUzunHmW/VlhO1WBkSjXaD9SJryzK26hM
         cam+ErrkglzfNBpHzZyBA6zuQ6mm+5PqxWYUVFs4tbbms/G/q/T2Ft3xI/MN/7KEKHoe
         QESxsN3eQpNgfwqdhk+gV8tCFhE57okdC1zG/fKvaLQ/fI5nde60wN7wWpwqWuswDwNc
         8ZSsamImTfzbnR3W2BqUfNR3OnSYu8UkYwE8hfz30jZk+LKVO8U5I0CbF1+KXUc2V3EH
         SwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5SeDlZZJ28Q3bVAIca8zRC8x5oKQ/h7pAD38Pw4cMwA=;
        b=mSs+NMOlBTi68cSoBx0ygJaU99268KN2Z2xTjcgk9vsUjyFF4uXBktkTul2mRh8guT
         zPw9/QP7sHXGXGLPe3/ikPp1M5ciPA0A4luvyJ8CKANd5YuwY7BXtOiMKZxm75myQ4bR
         pcDFozTRigueL75uUNYOszZA7FEXVa+6/n+7PTkfzL/V4QvV0nP//RvLEVN7eJ6thUGn
         TD6DGHb3yKc1ixODkRjhQyA8hH9eX5PFXQBi76jTA+alNujzi9fi6eWdXD6F4Dd6LP2K
         +8jeZFvefHgzgcCB/46+9RysCj2m0SpRSN7OhDUZUBJYBmNZG2o3G2S+6QQ/6LXYuNvI
         Mrbw==
X-Gm-Message-State: AOAM533D+5YbmNrlCzr5wfnTDcWrQG3LORe4TOlU1X3exzVo7LsAVDTN
        GIl46L3DBH+26sfHsXG7Sy8=
X-Google-Smtp-Source: ABdhPJzNLafBqcMWYrjLmgt4DHbQgp1ZMMj48P/HAu2TCpQ5x5tnM6DqYbq5mL/dom3n4j/YfrhX7g==
X-Received: by 2002:a05:6402:550:: with SMTP id i16mr18500360edx.177.1627479213729;
        Wed, 28 Jul 2021 06:33:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 41/87] trace-cmd library: Fix possible memory leak in read_ftrace_printk()
Date:   Wed, 28 Jul 2021 16:32:04 +0300
Message-Id: <20210728133250.234140-42-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_printk() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 14052a11..5eaf030e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -888,7 +888,8 @@ out:
 static int read_ftrace_printk(struct tracecmd_input *handle)
 {
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
@@ -897,29 +898,33 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_PRINTK, 0, 0,
 			    lseek64(handle->fd, 0, SEEK_CUR));
 
-
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

