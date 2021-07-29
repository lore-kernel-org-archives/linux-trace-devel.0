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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17296C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03A261019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhG2FKo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA09AC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:40 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jg2so8551390ejc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pDnYY4z8ou6AlEibYEdl+zWXg6GB0ES5kQANFrPKjFc=;
        b=Eu/6tqgh1vhmmTfECywQqm2QsC6pOzb3E09bsbaSo6jo45lwp8Ays8NGWfvOItLPMq
         DH8Nk7SfugNuWs5aRrCV8O4f44ncAxoxmWonz2gZUlpgBm6ThG9j3q6FNNN/oISKeQaA
         TzpTVFxKHap7XcKvm0+xeTjNmCveW1Iojk4IWzunxTHvSVtNQ/T8HzS/k+5mcuaa5Ezq
         SbwxzuxtY6wDvlmCyXuUABg35FxR9E65DL/1WXi+GM9jepIu/hnl58zBhAImlUDLriX9
         K3K3a1CTTgBt7bjr7mdSrWlJx0o7lg7ttY61BVH3H1qCHpvbBRLX6UHKVlJjJ11bNsfd
         cr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pDnYY4z8ou6AlEibYEdl+zWXg6GB0ES5kQANFrPKjFc=;
        b=Rgz01r3fie3+bi5kYRnCSdH1i+JrrSdOexwp6n86Dn6ayOYat8nH9PdC/Nq5dI5Kt1
         i65csPKiHCIc96C5dk4vQYmcdWmHqpc/Ildv+pvQ+prXL3r0zXZIGQG/MwZCALFeyNYg
         QVxUVrWTkKLsmTIwYJlX9jvb6NnPK5LLPdFF64fDr2zelEgaIxrouoTFOwlRU8T78v6t
         /43/HbVllzTr0kPbbhJljsUFvujMAn2J/EbD9f7QkfhkjZol3XY/YX0a9uFCpJ06zgB9
         YepwzNtmtO7PincPodnSazpNpTYNEXpzEsbxi6bH0A7JQz1DG+x9J7j/H2KmkyGS6g96
         Zrlg==
X-Gm-Message-State: AOAM530E3N+q9tjaF9QqCVbhGsKhmp0OzEc7x+fViGc8Yu/+AGyErkFj
        PT8hxIbdnhucop84VHqylYU=
X-Google-Smtp-Source: ABdhPJwl+oijJBrMR7PwKEgpv5oFcY3Pk2Twsc8cQrXPapAe/rn6hZ9D9AID7sS13aEWNbBk+4KeRQ==
X-Received: by 2002:a17:906:c1d0:: with SMTP id bw16mr2964397ejb.146.1627535439617;
        Wed, 28 Jul 2021 22:10:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 39/87] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Thu, 29 Jul 2021 08:09:11 +0300
Message-Id: <20210729050959.12263-40-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index b36df98b..e2e12014 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -747,7 +747,7 @@ out:
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -776,13 +776,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
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
@@ -809,39 +812,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
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

