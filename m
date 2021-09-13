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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2788FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F65760F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhIMM3b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbhIMM3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:30 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6627C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u19-20020a7bc053000000b002f8d045b2caso6474895wmc.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WIhyREvMq7bERJU6rUAI/8YHOuVEpU7iUhUrHTuHcqg=;
        b=beCExSmvZqiUyFdodSTeB1Hqy5cVSJAzQV/lAoxGcdq3GK8n9scu3cz77M+9NMpYGg
         qBssfrMHQE8VYiMZLrjvAWSZNcd57jloGNcuOJV5QOnEorSHn4aC7xoQSuXGhzSRGo3Z
         2bbAXrgduGJ5m7DCnoxP7ZBRY5dxzFVArueRZEFZrzx7qM6cesqxh3rYBsKf4Ohv6j8u
         gmhjxy5Ib3egaPzctS87kLg3Gv0hM19a6FpI+vf6JrD4vrtTflk6l8GaFcy165qQAtAU
         3ht0EwzpjmB4je9+IG3URqBx3jCtl01pJ2z0KtzO+mch/PPdfM4RvviOtGluK0XrOd1E
         tZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WIhyREvMq7bERJU6rUAI/8YHOuVEpU7iUhUrHTuHcqg=;
        b=euytKNUFxNti/05eRw5ZqV1AKKOpSiONK8hd/vZFC4+B89qyGEsLR+SdHvWFwJ6iCS
         VJeUlfxty681C0lh0ZzOCo/OqB6jaECWIEShOGdgWv0HhGz8dAXeTompTbu/lNHovZGV
         wKUu9LIyp64WE/Rnpo8sK9f91yxwksm9IsbBn1DA9yBk4WD8lQ1qqR+idcKTV3Jq0uiL
         bLPrV6BHBS30Q8vED+jF8NlSJ7D8D17bq/uOCfvVEyO8FjO8XQnwPX6lf0ozbWh1HmrZ
         4+PnkjHdJHNeJF2FAoD/nfOT/NxnPJvOYWQDBQgH05UbUQyc/FpkEOb5CWuqTv9dbx+X
         +Mkg==
X-Gm-Message-State: AOAM531nwF/825/XDF6CjhpCN7CBDRLtZIyhPU9DOK/mkfTl0Dg6X32/
        lwlwTp0xV/KEvMZqka9nGO6vhWTMUGQ=
X-Google-Smtp-Source: ABdhPJwpbdU6XsHWRoaH1FFeu4HqCPLvjEHWof9q6IH5UDGAyYYZXHKm4BRCUWX8csJuM0yG3FPRbw==
X-Received: by 2002:a7b:c0d1:: with SMTP id s17mr11192065wmh.139.1631536093459;
        Mon, 13 Sep 2021 05:28:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/21] trace-cmd library: Fix possible memory leak in read_ftrace_printk()
Date:   Mon, 13 Sep 2021 15:27:50 +0300
Message-Id: <20210913122759.3672494-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

