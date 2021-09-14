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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5071C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A18E5610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhINNOC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNOB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5A3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:44 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k5-20020a05600c1c8500b002f76c42214bso2045285wms.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHbl/58swxEP+2R4EUL7BmGjrykf7sAqFNSgdDuIakQ=;
        b=doqr6TRSwiVHgH658Wfr4RomKxpOLz3txqSsYxTMmSGGzxpvPyqFNVd3wb4eT/PDym
         p1A9L+P9vgFZHRDCwYBSwge9rPtaFBd5ewCFSsXvDCIzXiJZNnZecOWCQ2UTPMQHomGu
         77d1rkwBkGyAgq1w8wmMkuNosUN1bqUOGIBMG74Dola8HYSn/ty9gYQV5FHUXIU3lruS
         T2r36stBzC+MXw0cixYFTeXlthz/yUHwSEIxnB3pGxUip5Q3gkZKO1Ah9z6iSeOxTbrL
         iJVsqn4fX5B/hppdrvpliHon9CFmNKycFyAfKHMOYylgJ1JNdoP7OSSIZ+3stwOQUJKC
         I+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHbl/58swxEP+2R4EUL7BmGjrykf7sAqFNSgdDuIakQ=;
        b=GLViIEgv3/CUIvTxIjV6HvR7NPU8/3KrqVcr38bORHSro5B1FfGF9iN3Evg6MQloJ0
         kr47Nrw7qvaxYgg4WPbwd7tPgY8kQQjgXf5zf7azi9Uv4/lAQy2qxPs02EwdvCJ0cv6S
         EXsmEMvcyPwMmg49zLoQx98KhQZFOGI/prs2JZMNCTYYsqluhFj5ZWfYZRhHJhv1fKin
         EFmCRtXRpTVXp3EINf7rdAsd0AinHGpDO31ENBMLubAyKrkAfvHOXgOFgluo9z6mntS4
         RVNBu+3bNUALvy1streG/OkEyOm1AEEKILfMpm4O3UtLmaoMil4bW37vYC16AFAekpd7
         bvyw==
X-Gm-Message-State: AOAM532t+gBjPWJBz87PtKlAxRgDFIFuna6yQnr97NA1TlRkjxOWTZiV
        HCH9mVKz9O60yHlMSJEfm87d23rhpz8=
X-Google-Smtp-Source: ABdhPJzya+kmjW98fi3HWPT04KfeoUfG9Hg0hhgAmOf9amIEPLzIiAD9WvEVScu4ui0yxyjBm7psXQ==
X-Received: by 2002:a7b:c767:: with SMTP id x7mr2207554wmk.62.1631625162919;
        Tue, 14 Sep 2021 06:12:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/21] trace-cmd library: Do not use local variables when reading CPU stat option
Date:   Tue, 14 Sep 2021 16:12:18 +0300
Message-Id: <20210914131232.3964615-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a local variable to read all CPUSTAT options assumes that all of
them are in a single option section. While this is true for the current
trace file version format, this assumption limits the design of a more
flexible format with multiple options sections. Use input handler context
instead of the local variable.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3d7f1c48..d020cfae 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -138,6 +138,7 @@ struct tracecmd_input {
 
 	struct host_trace_info	host;
 	double			ts2secs;
+	unsigned int		cpustats_size;
 	char *			cpustats;
 	char *			uname;
 	char *			version;
@@ -2658,7 +2659,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2738,12 +2738,16 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
+			if (!cpustats) {
+				ret = -ENOMEM;
+				return ret;
+			}
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
@@ -2813,8 +2817,6 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
-
 	return 0;
 }
 
-- 
2.31.1

