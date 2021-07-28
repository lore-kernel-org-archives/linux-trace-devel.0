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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB089C43214
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9411960FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbhG1Ndg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD54CC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x90so3223446ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8fraYLkViCjDtoS94b5SOg3GdLRutkM2yqEppBmJufs=;
        b=LDC5Ujww6miIO4tjjOeTRe1Sfc7gCfe5vQV1BxVW9IASAH9hCyw0/dXX/MdzA7MB8G
         Xkoi9kY1h3YqHvmANzNdOD2qEv6Ksju8WZrerbOk+CPW3eCxj8npXi8mKmD0xZgK6bCE
         mJ0zDjbgaW4sijkXzoZPujLvUP9qW2MM6kAQ9IBwwz0Vp5xS9rxiJ1xXmObSkU4Nyfwh
         1o1NV9adxuQ9rSYdCvO6/TnvGK0WKcyV5AjiRopMAuym+N6vZXlJPcPPgyUYMlDtqKTP
         Q0v86rbqgdnlwLEdID7xx/Oc9dXmIfOnvGEKDSu/YnGNBLwBKsllxKx30uKdBAswbuGA
         qpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8fraYLkViCjDtoS94b5SOg3GdLRutkM2yqEppBmJufs=;
        b=LbgVwKb9FfDT0xnVcYwfPolc11FVbE5IexYbGFjieGJ0zFjP6tqIrqWPElsamJ1anf
         /3fJ/6fjRyqN4vdMtVa8N2zjmvR8ZPiwaSXnhgEngEopnN3y/KGIaY0vN4YLCO//4xBS
         1MJZ+fDcmiN++CXuB2k0gWM3ud+r1pCic62fTt0ys1/YOykKe8u8c7ePEOWSjGY0R+tT
         DfLGk3enQXHmWXuj+AJz8DLNFCOCps2Tw6Q6YkZPwCZzntSDTrOkU7hhC66hlMj+sjzd
         ICtdPb08S5oTixdDGT5V0J2pJj0x7xK/jtq2FL052yznkIgXgrHQteNHP1kS7ZKeQ0F9
         sJKA==
X-Gm-Message-State: AOAM531STPsqic6JCVOt41ypXaxLBBol2jJQJcsVio74lYQWSkiO0u8x
        hGgZzP+b2IjJ6UC4Vyy6EjCiCT15RXm1/g==
X-Google-Smtp-Source: ABdhPJy3ceni/Yc/vTTJOAJi4fTpneU5MGnw1fUlb1QRVNh7Blf6Heh6R/4dysC/nJ6d9f5F9tU1IA==
X-Received: by 2002:a05:6402:8cf:: with SMTP id d15mr15937903edz.8.1627479211606;
        Wed, 28 Jul 2021 06:33:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 39/87] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Wed, 28 Jul 2021 16:32:02 +0300
Message-Id: <20210728133250.234140-40-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_event_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 39 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index de1f0399..ec717296 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -748,7 +748,7 @@ out:
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -777,13 +777,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	if (read4(handle, &systems) < 0)
-		return -1;
+	ret = read4(handle, &systems);
+	if (ret < 0)
+		goto out;
 
 	for (i = 0; i < systems; i++) {
 		system = read_string(handle);
-		if (!system)
-			return -1;
+		if (!system) {
+			ret = -1;
+			goto out;
+		}
 
 		sys_printed = 0;
 		print_all = 0;
@@ -810,39 +813,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			}
 		}
 
-		if (read4(handle, &count) < 0)
-			goto failed;
+		ret = read4(handle, &count);
+		if (ret < 0)
+			goto out;
 
 		for (x=0; x < count; x++) {
-			if (read8(handle, &size) < 0)
-				goto failed;
+			ret = read8(handle, &size);
+			if (ret < 0)
+				goto out;
 
 			ret = read_event_file(handle, system, size,
 					      print_all, &sys_printed,
 					      reg);
 			if (ret < 0)
-				goto failed;
+				goto out;
 		}
 		free(system);
-	}
-
-	if (sreg) {
-		regfree(sreg);
-		regfree(ereg);
+		system = NULL;
 	}
 
 	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-
-	return 0;
-
- failed:
+	ret = 0;
+ out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
 	free(system);
-	return -1;
+	return ret;
 }
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
-- 
2.31.1

