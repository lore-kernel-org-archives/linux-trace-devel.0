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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44183C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 213B4611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhIJNtZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbhIJNtW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B628C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 9so2565253edx.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e1RNnaRfZCZmIhrSH5IKcSWViz8K0liPeRb68rbq7h0=;
        b=Nv0hMLGMzec6rZZQdQd4hSt+znsrJoQY3r7nC9ZNApijxzA5Ww+gWG6+3O6+xuc9qz
         8NZT2gAW67Qt6A3rn6s6Ed+6zP7lXRs/urJWoxOyxWo+a0GWOAbrTeBju2NeQGltQpK8
         18sTsjXKsVCG9SMiFaV6x1iOy2Sxo5IxfZDRuRHSwMrQ7POo8FWJNsPIvamSiGqk6q7u
         tMi9nbvQv+MTyOoNS7nuqzhvdTTNAcezSCJTtVbBjROOGmOPw963NrXaTBBzKRG8lldf
         3pZP5jnpaqEs4Vc3URNy3nGw3DQnQmuO4Al5rETxIJ/okgYanBPaHi54u/T0CSnmW4oo
         6Jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1RNnaRfZCZmIhrSH5IKcSWViz8K0liPeRb68rbq7h0=;
        b=kYdh0x1uecshzziQ1izM//pVy4ZIB1T7GA1ISP47hV8ssFCOXaQruLVR2vpcbkw5XH
         aSyX7kt8V7Rv/6VWp2BrpKEttjTE4Srz7RqIZLZEZmUpqBaUVOBs5r7z5ShUGuzmf00H
         CtTGCfdH3GlB2hlaYqyCjv2NhRjSmhCVmCiX+pF5eCs7blqQ2pK2xRcMjsqHETAnYTTd
         A11+gAVVvOulLZVPLRxt+0oG8zs4enlyseZ9hVabe1lRJqMRjBkcsytyHZ53sIFAkS5N
         9OmudIXwoUFSs8HC6ejPceFFyRsRekXNZJ8taYRBVHogsy09gOzdz3IAVu6qbdskypvm
         erbQ==
X-Gm-Message-State: AOAM530BCwxBZ4bgn/04njfV/VytG5ft0mjrlh4u5p4FoTA6OnYl4DzP
        QOpDc0NpEuXEq5Z0Jq9lAhTLniYe98Y=
X-Google-Smtp-Source: ABdhPJxVL+d0gToKcoHGvRvEorYn1II/vnDSUw/uRNYGAZU7vQVjzqLJWBIgIB9F1Msg23AkShPYbQ==
X-Received: by 2002:a05:6402:2695:: with SMTP id w21mr1244982edd.182.1631281690200;
        Fri, 10 Sep 2021 06:48:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/21] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Fri, 10 Sep 2021 16:47:46 +0300
Message-Id: <20210910134757.2863982-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
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
index f933acc6..9eeb7427 100644
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

