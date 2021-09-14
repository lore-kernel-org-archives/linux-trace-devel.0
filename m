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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA1BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B91610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhINNOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhINNOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BEEC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w29so19367095wra.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0j1dgOlKG6MfWbaTr4bXRbYYtvn+fCKUl29MSaEewTs=;
        b=DP5JYN+wgFEUacgL0VmMAqJqLPY3okHKBfKHuhUj1cPFg4e7oMUNxE8XCJU+aU5lNo
         vKKj8sMMmVqPVoYMdfEo1KT4Q2tIVBo7q7E3qG+duRhvsqb+4LG8cTvrN+IlXX+kmBCb
         Wyv2eb6FGO1RU51W6QOZLHCjnvLIuZgSp7/XAnN0Lo46pu1FG+XsCojdJGPvOHf5URPU
         IRyf//a7FEgoYgANuO8DqyfozlMOG/8rlBu/0UhEGrq5EtfAkz01wgQqGiyCZ2r3nR0u
         iiTWwmGrQcHZTuRvidDuw6DvKHjun2cM9wDTdQO/yDV3V13iN2mUleTj92lROR6lMjsD
         2+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0j1dgOlKG6MfWbaTr4bXRbYYtvn+fCKUl29MSaEewTs=;
        b=M6wikIGlFRgWZMIR7MYLXK2emBdnr57DTAQ3oWX/D0W13zWgWrmhVv+CiNN1vOKc/B
         ZxQ2dLFT9XLDn3exH1AxgE8z1/zXww81STJnf62YEwLzfBMKJ8T8FZKx/YJxzh5leGvL
         /MYGBg0HSiVNcr9YRJOTKDbyM4Xgt7TzFxbMrU65qkSlfcZar5I9vpioPtl6RDpwuKh/
         XzVy3VVNowgWL+ktyA/W6cdvMYp4OYE3qgNErnp23xyUOFa91UNQperuS5DnvAJcfL2I
         DHjne8fKVnbWOULI3b2H84PKM0EP/P4O4TZjQnIcK9z6BOVIJekIM9E4u/wW6p1S9HRa
         s2xg==
X-Gm-Message-State: AOAM5305w9OneHLvLgmjCRjX5tWtWCD4bxsYedgyIOfTUcmhKmze52nH
        LthGP5DYSMZKaZP2ePhUo7To2UCwm+E=
X-Google-Smtp-Source: ABdhPJwJkWUDAn6ahNWWajqrc8/ObSNvh4egYLYmp4LK95HAszhgbdVq3eAvv/jvUobyX0bs4tJAdQ==
X-Received: by 2002:a5d:404b:: with SMTP id w11mr18876796wrp.437.1631625166278;
        Tue, 14 Sep 2021 06:12:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/21] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Tue, 14 Sep 2021 16:12:21 +0300
Message-Id: <20210914131232.3964615-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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
index 94fd8693..32358ce9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -645,7 +645,7 @@ out:
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -670,13 +670,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
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
@@ -703,39 +706,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
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

