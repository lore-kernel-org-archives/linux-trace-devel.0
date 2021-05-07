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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC9DC43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C66C6145E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhEGJxB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhEGJxB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:53:01 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75570C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:52:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f24so12668087ejc.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t8mZamA7Bnek0iK9NRrA0q/dqLXDBSoCFFvEAuE8qMU=;
        b=pseqpOTiJBXNzh4JiFX+1wtLk3u7sWJideLzNZ/P2oNZKB+2Xu+E2kPs5c0GWnnih5
         AgQiZSXYfoht3sJ2G5d09BsIlRNjw1AiTKkCrAlFNCXG343L0eQC2BX8OCUxHkAcv/LY
         oz2eyXUEyEp45LepAy4UtHi7EayjLq8XjoRUCMjg1bifrmQd4d2rlvfIuvjlIRHXV+pe
         l3o4gU229gS31M0qzCUhATMxLDDPlFikxbyz++SVjvvsI+fxbIt+H1foFaljSC11jDtn
         1jEXLD3KTKkzkg1aMiCMUmiJkgONLKbnIcmM4XqXmE1ce1nPcYjD0dy/jY0RfzZG/+hs
         qKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t8mZamA7Bnek0iK9NRrA0q/dqLXDBSoCFFvEAuE8qMU=;
        b=ORZCWQutX6V8N7d7eJMY9Ju+dzb+ij5IO+Ic++MRLP2LzYLANTvkhImeBSc0LIF/SS
         XWLzbq+x4bPMg90oxBgwwlKZIgaGHtRBrn4eqjit7AhHQwmByNy2lMSUmMdxY3/yQQR2
         ectDcwD5igd/jleRWYYniHeUZ5q7rPG4L4dgBMOk5FzeendBnlyKCnEqjgBkp0+etQyT
         Gm9uJBFcfNpb2oVcaiVUlRjGCeJEcDViMsxEsCcR9B9HgEMXsK5iw3fW5H/6/XHIuJnQ
         EbqOuCQu2ceOazWSp74NiYiVh1Ju8as4ew9EqX9p+v5ndYJRjiTqJfwDLqWJuN/erjm7
         mXsg==
X-Gm-Message-State: AOAM530h0x2IKAhIFiTe1ZaBEKFM70+deK6U6mso9HNUJ097j/xLVYQW
        g7MWMc74M3C9BE9EOxTYwIQ=
X-Google-Smtp-Source: ABdhPJycT7ytUnvnPJ1AISTC/Rnn6AZMSnYnjqMmSqbg+506C0iGVC7Z54zdggctHz17oIU/dCmCjA==
X-Received: by 2002:a17:906:2a46:: with SMTP id k6mr8755898eje.406.1620381120153;
        Fri, 07 May 2021 02:52:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eb9sm3130893ejc.96.2021.05.07.02.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:51:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] libtracefs: Remove dummy tep_vwarning() from unit tests
Date:   Fri,  7 May 2021 12:51:54 +0300
Message-Id: <20210507095154.1080202-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
References: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the trace libraries have log levels, there is no need to implement a
dummy log function in order to silence the libraries logs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/trace-utest.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index ee11826..58d4d4e 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -19,11 +19,6 @@ enum unit_tests {
 	RUN_ALL		= 0xFFFF
 };
 
-int tep_vwarning(const char *name, const char *fmt, va_list ap)
-{
-	return 0;
-}
-
 static void print_help(char **argv)
 {
 	printf("Usage: %s [OPTIONS]\n", basename(argv[0]));
-- 
2.31.1

