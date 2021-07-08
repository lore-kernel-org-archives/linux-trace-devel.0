Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFA5C07E96
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850626143A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhGHNzj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 09:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhGHNzj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 09:55:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDA2C061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Jul 2021 06:52:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hr1so9795926ejc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Jul 2021 06:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Zb1qhrznH7WuSHnIOdYcLaQ153nnRZtlky08GBXv58=;
        b=N1KWnwbD0oe88HpvJi8iPhok/ilTWB7qoBEtKNO25bP2bTuCQUHdaSHcr55g0y7j3u
         JcXl9fdNt2WKk0xhODrh4AhDHPTCemCNbtDOsSxp8s2b6kSZT/xtGzQtN3RJp9mT6Z60
         +bcpZp75FopEnjRSIM5LRx0EN+TPnkeHKL5Fuq8lemynXL0wySaZ7uic3m0YhLiqkKCM
         00BkniZbGTUCXvE4PrIbCGuLVVeCDYCe35PkfqUWh+/bQOAqrjh6mIM4DPaDSmHAMXF8
         q7M+NxVdcEgXo7KxpUcUmvpTipbcFdUdmWHfB/cVpU1aVAExLU5E5EagY7NqZmJbsalE
         Dxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Zb1qhrznH7WuSHnIOdYcLaQ153nnRZtlky08GBXv58=;
        b=HwGxiwl7OB3RE5d8ORUIfmCR7nfOHrHT11O50QUYbaadhdPu1hqq1vRi9+M7ZPceLd
         U9kC7ej7/PUUCNojhRsNumWoJmd9/vTnXVA4FLKTBpWyYUytqwmISBDDoG1+qmm81RtB
         R+Ji+tzZG/iJQx2sOehv2fabzdB05cHaKX9F52F1bAkLp+Yc7b4XLv9K4EKRakMeCMeO
         1ulJ7q0uV/wlRjUMJh04bMj6IV9KfF3m+8uFFTw5AbhEvX1Guf+mhcxs0giZc0K4OLQC
         pTmQJIny5S0anitYkEWrqfTIw4DOmCVvbSR2m7WawFj1hYdYKXSRxbzVlSB0kiSKtFfH
         NBQQ==
X-Gm-Message-State: AOAM532bNKIrWC64GTZVYrCC4VIfb5LMqXMhYs1QS7DA6vAOuVSECFyM
        WDW/wqCANCNDI9wj/xSCAxVF55RrCoU=
X-Google-Smtp-Source: ABdhPJyWzFTH4fFjuX2fyk7bdvyIKpRj/RwCR8ueo+nmIvMnRSh2+o+4skqbo1N9Zyk3vmUWa7d9cQ==
X-Received: by 2002:a17:907:728f:: with SMTP id dt15mr31245716ejc.530.1625752375991;
        Thu, 08 Jul 2021 06:52:55 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.215])
        by smtp.gmail.com with ESMTPSA id hz7sm996487ejc.27.2021.07.08.06.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 06:52:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] trace-cruncher: Add Kprobes
Date:   Thu,  8 Jul 2021 16:52:40 +0300
Message-Id: <20210708135243.25229-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This adds to trace-cruncher a basic support for Kprobes.

Yordan Karadzhov (VMware) (3):
  trace-cruncher: Add support for Kprobes
  trace-cruncher: Add events to utils
  trace-cruncher: Add Kprobe example

 examples/kprobe_open.py               |  44 ++++
 src/ftracepy-utils.c                  | 366 ++++++++++++++++++++++++--
 src/ftracepy-utils.h                  |  30 +++
 src/ftracepy.c                        |  55 ++++
 tests/1_unit/test_01_ftracepy_unit.py |  56 ++++
 tracecruncher/ft_utils.py             | 182 +++++++++++++
 6 files changed, 715 insertions(+), 18 deletions(-)
 create mode 100755 examples/kprobe_open.py

-- 
2.27.0

