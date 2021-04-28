Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC59C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75EFB613C8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhD1Ns1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhD1Ns1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDCEC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z5so37804179edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qRYhjz5nKOXmmjyOUcCyZQHjwsb0+RwFM92vG/mi0M=;
        b=KdvSidi19ay62ftj/+4a1uweIMJEwQQ278Y6WJuQtPLSsNwGaxw5elrtORGkaPMTQQ
         eEyg+qmO2cP+fp/ad5Prgo698fj37cP/WZnC23Ws0MysfLNn89Co6dSaB6AAQU7E+wSp
         JS6aprAVeXi7wLUnEsQMH33PIlxCCtGLDZIKphgyoxmlhdQ5NtkB0vb6FPRhygh57S3j
         O5WluLT9CaLirxlZBapo1qy+aGyRkF8Z2OVRan9bxtrpLehxRSqwSiTb9gjx19AffUgL
         kolzNuHWww9CHONe7cX7epA0ciZzDN23f3gY+9UJ6bL2avEwY4xw+nmFqtnasuY6IHQE
         l1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qRYhjz5nKOXmmjyOUcCyZQHjwsb0+RwFM92vG/mi0M=;
        b=gkBD8ElWgmLs/oKulZ3A5+pHrxCKA+fwiEnyQ/HUNBf9wt5idrh4uqRsEvgqjBHSRT
         mo1/Vx9zqC/dHtuHFsIu1Qa6BnU9O5CYstfSrvisgWWyPl/6jJcJw17qTD0FIYTTxjaT
         za96muuB34jY+Iwcl7mfvpeJUqHGSruYOt0bYVF8RZby2yeLzv8aN3gNXEfPWsITNbiF
         jtkSZYTXm7rfVPNo47X4gZZaDUo6jtrpmUcQpy8FQMpbjz8HB9zeRiK9TpWIkU+WFH6B
         CD7ZsKLcHTM6V4kpWPvvAIjaXcTSsoctWh/2SURh3y0ULZ/V3JU2y6T9l9u5Ina36b91
         yaaA==
X-Gm-Message-State: AOAM530lvcVEQyJvFJ5QrlF54kC3WZPbzpbxU8QfGSeUOEcjN0mKDAVP
        rHA0mXCEILngaKDM2pi66SXvmenudWE=
X-Google-Smtp-Source: ABdhPJzWyp/XNRBh4L34EUHXPU2a08Gypya5aLLLaUX+pPuxKfvFvnsFZOcGBiy+UZXoxSaFJiDp/w==
X-Received: by 2002:a05:6402:5244:: with SMTP id t4mr11650523edd.355.1619617660685;
        Wed, 28 Apr 2021 06:47:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/9] (Not so) Minor fixes toward KS 2.0
Date:   Wed, 28 Apr 2021 16:47:21 +0300
Message-Id: <20210428134730.187533-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (9):
  kernel-shark: Fix the build for 32b systems
  kernel-shark: Add "cron" job to workflows
  kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
  kernel-shark: Add cleanup of all plugin contexts
  kernel-shark: Fix memory leak in "sched events" plugin.
  kernel-shark: Disable the pop-up offset dialog
  kernel-shark: Remove kvm_combo from the list of default plugins
  kernel-shark: Remove debugging print out from plugins
  kernel-shark: Hide all plugin internals

 .github/workflows/main.yml   |  5 +++-
 src/KsMainWindow.cpp         | 11 +--------
 src/KsSession.cpp            |  2 +-
 src/libkshark-configio.c     |  2 +-
 src/libkshark-plugin.c       | 10 ++++++++
 src/libkshark-plugin.h       | 47 ++++++++++++++++++++++++++----------
 src/libkshark-tepdata.c      |  3 +--
 src/libkshark.h              |  2 +-
 src/plugins/MissedEvents.cpp |  2 +-
 src/plugins/SchedEvents.cpp  |  5 ++--
 src/plugins/missed_events.c  |  2 --
 src/plugins/sched_events.c   | 47 +++++++++++++++++++++---------------
 src/plugins/sched_events.h   |  3 +--
 tests/libkshark-tests.cpp    |  2 +-
 14 files changed, 87 insertions(+), 56 deletions(-)

-- 
2.27.0

