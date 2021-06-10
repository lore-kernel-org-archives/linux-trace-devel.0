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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B113C47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11465613FF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFJLgf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLge (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:34 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCEFC061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l9so5982107wms.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cp2xjlaw4uvJnn+MOUAkFZQ+eOSnxvlwG7WEJsSGUdQ=;
        b=ia+PU4Jl/xaJBPkueBMLwIqAcAEbJ+97n3rNhWOqBU9iII/w9dPmBTvEc1jmS/Orp2
         bvdndHomUW2zc+WUWffTrUYgHFhqK6VtP2zw4l/7Kgtku3gR+WEWNw+BmFlsP2/7R91n
         p+TLYRphGWt9sBF7xQL06vqIQigRyNQhqOGiK8qzVMh23gVGua14U1Y+r0dTWCkLrmRj
         gYAVBRouYzlihkQk62EOxtIXp7TYKU6ZCXEhjyYW9Pad4uwh6EtNdTGMUcqQ10ZjI2Vk
         BwZhmEghaSen3T76j7e6/mqs82rIw0Cr+JILcEhi6r8ALkVgUUcdc4EenTvZpt4BBdnE
         CzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cp2xjlaw4uvJnn+MOUAkFZQ+eOSnxvlwG7WEJsSGUdQ=;
        b=MXdIZ2QRETOZFQL1zp8kGd1hNErRl6rFZkvQN9lvuwzMZEWIKv+XPiUgtQjkCy6Xei
         k0sFEaT2hnc74dtUfjQaDbsuFOrsxQ0be/tf0zkyR83t2DotSLzmJlSSXyNNEtR5tuti
         sS++JBGh6dpXd3HfItRCVdbHRLy34uGkGF75LnsACRwULcOmjIS2mw4tNRz/ihKpfAIw
         LsOIKwD4Htz4uaBqU1vyrJ+FTywFhZL60KsO64ZikpSMc3qOS9F3d7PixGRNbSKgoWew
         l7Ec6/m7494bWmQrRpVKHY7Tv6o/c91eIduYhNNrPIn4wt+UUpQcKN2nOCs1q5xnzxQ2
         CttA==
X-Gm-Message-State: AOAM533etQCSv1v9NxYF45/polO4TAjVEJiweaIvxiGKGq8LF8FIRRFy
        saj/VzQ6n1cj459l+tUgTlI=
X-Google-Smtp-Source: ABdhPJytbUnYMNmkNoLBbB6gNuoGWZRRMMSufvGg8PRKpXEtnsIhz85WfLZcW3CqEE3zl1Wz6634JA==
X-Received: by 2002:a05:600c:4b88:: with SMTP id e8mr4484355wmp.107.1623324877496;
        Thu, 10 Jun 2021 04:34:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 09/40] trace-cmd library: Bump the trace file version to 7
Date:   Thu, 10 Jun 2021 14:33:55 +0300
Message-Id: <20210610113426.257931-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding a compression of the trace.dat file will change its structure.
These changes are not backward compatible, the old trace-cmd binaries
will not be able to read compressed trace files. Bumping the version to
7 will prevent old trace-cmd to read such files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 041582c6..3332572b 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -15,7 +15,7 @@ void tracecmd_critical(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
 
 /* trace.dat file format version */
-#define FILE_VERSION 6
+#define FILE_VERSION 7
 
 #define _STR(x)	#x
 #define STR(x)	_STR(x)
-- 
2.31.1

