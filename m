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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413C4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D22E60F6C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhIMM33 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMM32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:28 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57EAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:12 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 140so3098968wma.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0j1dgOlKG6MfWbaTr4bXRbYYtvn+fCKUl29MSaEewTs=;
        b=qQoJeDPJPj07xrnYfzYVWHxfDxzE1tEKZn1mUqu1jyu/5uDAXrZ+P57KvnsVJ76pFf
         PUDcVJOhxZJAluObM5apMEwHKRQUnJXjaai1vvFECIWWyFWFKwVFaFBxTUvcxWQWRjNe
         wedlDyXekrPu1hrOcNKoIdr3VR2HVMNyrBpNYLvOrSjpluiz5L4J6tOA6athXde4ZpdT
         CtVXmePxYF7NvtKkmW8rqv0EUDrH437SM5dGEKdoopvr9TZP4+hlEPkqzNNXSXIOyGLt
         qyWAU22iiOA7D4nvnu/XsaKJtu8NbPUx1st1+Dr3gMTzkSTxTdVR6BEsdnaHQiQSMQZS
         IxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0j1dgOlKG6MfWbaTr4bXRbYYtvn+fCKUl29MSaEewTs=;
        b=UWnaWYwRxm004yuStCG/ymdD9adozZE82QyBwNLbSTa3yQy4gyiqPZoKR5zPXDjg1p
         r1j75Nv5Y/IQMrftAfeKPZ/ANwqWQlNDVCOZz3+V68lSH1wodETBBdxfi2ngRQgtxy2L
         /bEpYlSxmLcoUnC3RXiwxNjWpiS4XlYvhpVX6KC99ltYFe+/rpB/kbN7evW4xEKRW4A7
         hsKoRHrI5I4F81NFfkAf2BhZaxERkm+38VBsWjjtwVLswM2daFl8vxYFNrpD4wrPScFW
         /M3IF1B4KKQ28fvnoTZNoMflp1Ybheu3Wo4iBvR2O8tljNNqpEA1hmp3NesJw6Pcke09
         rAYQ==
X-Gm-Message-State: AOAM530bQM01DRNlJtDZOpImT9S+q5l/wHu9+nUhwlL8SCe4HN9NivY/
        tLkvEtQ6libkiFQyjmZnxeTZD4jkf9o=
X-Google-Smtp-Source: ABdhPJxlXwqh5E7ZLIwjg7+HewldN0yZQdHDi7J60DpxZx4gKCVhIkOs9Sq/RDtjYQkDtF9t4MoTDA==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr10517856wmc.85.1631536091522;
        Mon, 13 Sep 2021 05:28:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/21] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Mon, 13 Sep 2021 15:27:48 +0300
Message-Id: <20210913122759.3672494-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

