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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EBDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACF2611EE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhIJNt0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbhIJNtZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0BFC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:13 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g21so2586408edw.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wFujmNtaKcVQR8iZfxSNAYpKjlkZd/57MjShJqqz/UU=;
        b=GEB6OtbsnQ8UZZ+H04I1RV7En5zW5mdy3f5nPKWALzoDN8Qrc3K9I1LtsJdEmt13I8
         Gel0Lb1e5vQr3aE3M7xbh4NZoJWIyWJ6zosJUEiDZp/lDkJskYp6hWcp01lRGkXOcqxz
         78kbFhTHHdpeCbWI9PJO1s+prjSOyG4Fl4FuciZKNHgq4WUKralvMfBXtwkmEvPbIUhy
         d59DVaiMk+UU/D1zLj8zkpo2PjOE+bU/KxPnl9EgRDLFM1zKEccV46X74quw/er2dokx
         LYlgBMGpmLus7jo812qSYquYblo08OY6/p92GwgTOha/BnPUALWDt92THO7avWHEl8Ms
         aH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFujmNtaKcVQR8iZfxSNAYpKjlkZd/57MjShJqqz/UU=;
        b=DwicB1leCToxN6GZd5vQxUrhlfOIN/rMnCFNc5k5BC0p9tqvkhCQQYYL6LepsCPqkw
         st/qsf3UKE/tdP8gHRERJ9JTTr+rOHwT6F+9YZyIy6ICwsGNvw0HMdGcJzHAId28/d+h
         dmPBERyMp3ugN9aETfn6jRwoWeougiN+A6gaOCJJMxgQcJjryk65UBa73YXC0AQrodXR
         H4S1E8EVpYJVtX2bLUWPxxNvOoBFapvw6amchPp1a39aDlPxkdqz7sfaA2bI11HlMZvu
         Q2luTlJdG0leMWQ/iOTDDSFS/mNSDYLEdhGb4DzG1LySf8I5Kg0sU+kV8lGSQpFI/zHD
         2xIw==
X-Gm-Message-State: AOAM5332KPclv8MJAp+4nLaZK68POskfG5FgfRIlL5J+LPBCm3+den82
        hNa5N9hR+ysXzyh/UN8ZVCrq3VF2fqY=
X-Google-Smtp-Source: ABdhPJz8Ne3bn/VAIbKZEyDrzaJ1vhEDzIS/DAIQKPjY2AYi5EkYh+xXtGVqeTQ1OcXr6CZTk7h2dA==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr9223137edt.18.1631281692529;
        Fri, 10 Sep 2021 06:48:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/21] trace-cmd library: Fix possible memory leak in read_ftrace_printk()
Date:   Fri, 10 Sep 2021 16:47:48 +0300
Message-Id: <20210910134757.2863982-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
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
index 99c332c8..fd7690c6 100644
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

