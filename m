Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A7FC4727D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83056207C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXNEf0na"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgI2Nlt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgI2Nls (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2CAC0613D1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:48 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o5so5424983wrn.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eeL9+Op40oGL1HKIkFZLWMNTCV3TfmCCgzu1F/JGvz8=;
        b=HXNEf0naER3zyoJKcXDHSaV9uWWwkKAuvNaU4yvBg5KYz/WvfvMDkRGAxYG+1zAFqM
         h7wjABQ4ch2ABB2S+Rp8j8OxBpFydJ7wurpVBEWnItEYhb0FNiy5BAcQvzIw6nJTcYWQ
         UudL99Tvt/TOSQtxBVKFZxcuTLztutjqtuirXHqYM6LrS6wL34s82lb50Wr1Yifq2nof
         95WeaGFpqCB6SiBHlptUsjmagR/hzTYL2wsZSFwSLLxS7NvC2COJRMEO7ui+MWyPbSrN
         ESAWdh/HLG7xyqJoDSAzRl/08chaFtTIOPzeWU4WJ9QUkW5prl3xJS79XN4lk5qR1LH4
         +cFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eeL9+Op40oGL1HKIkFZLWMNTCV3TfmCCgzu1F/JGvz8=;
        b=g5cPA7hfD0DPKZOXYYdVhS6ZtcxJlYSZSj1lmrxXz5xzGSFocsQGaxIyC3TGdeDuPw
         tuFEa5jelB9wcz06qdZ4NdE05SK+ncbVt1uPlvjV22jOkoNDSTi2hrpju3huRZxZwVIg
         Vhf2PJRuFh0ep5aKNEuYgffEX7Itkq5cvLD6b9jCukU4PHzeFklEIyFPoFKUakIGr3xv
         IgsRLn6+X3Kiq8mCugJj8Bb8cn6/dc69XiSSa1mVqzTyAuAHuTsR2p+mdj7XDjdDlEgg
         bgCaHNbx4u+Hna3oVuqV8e7hmJfCd3dNzLy/1vWJOKZl3z7neN0hc13p5hVsnRORWEWc
         jG4A==
X-Gm-Message-State: AOAM531Y0iLzSUN6Yeb9iAduyDM9rjfeUQG3TTpgEZQi16/4Zn2tc096
        62RaYOmuAYIASPWoaZRV4dM=
X-Google-Smtp-Source: ABdhPJwYwzngJj/JTyX+mHnTZNuNzAcvECu9NR0JSDGBeV2WkE/t99kyEbveDAhH3f1fJSgIdVQXfA==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr4542384wrv.139.1601386907136;
        Tue, 29 Sep 2020 06:41:47 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:46 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 02/15] kernel-shark: Version 1.2.0
Date:   Tue, 29 Sep 2020 16:41:10 +0300
Message-Id: <20200929134123.178688-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1c9ac2e..c95249e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -6,7 +6,7 @@ project(kernel-shark)
 
 set(KS_APP_NAME "kernelshark")
 set(KS_VERSION_MAJOR 1)
-set(KS_VERSION_MINOR 1)
+set(KS_VERSION_MINOR 2)
 set(KS_VERSION_PATCH 0)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
-- 
2.25.1

