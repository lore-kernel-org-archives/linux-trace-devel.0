Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8A0C47423
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1B9207C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLdm3dyK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgI2Nlt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730808AbgI2Nlm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8CC061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a9so4879089wmm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WkmPc/onGTB6qkaM+YKPQ9+i86aq66xuy/356H0X24I=;
        b=dLdm3dyKuNqgekTjh32PUKtg0GJXpK3riFThpla3H2s2X8TGrfjMi7xMM6EGxJi5dy
         dfg9Vsqezm5dlEYdnyqcgwGS9ZAiQqxDYdjXBlWyULqBYMnm5+6PNtlDCHoNpxzKyjKI
         xy1vRbUrzupBGgF5wKzcKYFMDFhjCDmuXeEnxGgDJzdyp4uh7PzH+bqYcVh6YBoKnQBK
         XKo29Pw4Wlh8rPhTkU2GteclCJyzOSVbkm7ZQ8Vx6m2uDpOQkMAOb1U77Az6hw7Fy9uI
         F/XNoRA++GZRZETxTuMWCNPrajQfrOLSGDODKjdvzEVLDCRsUO49gaCmO5RLwXsAeW56
         P0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WkmPc/onGTB6qkaM+YKPQ9+i86aq66xuy/356H0X24I=;
        b=h29dI8A0WRRoJYu80BseOSLR6TV/t+7wMNLU4IYZjg9riIA/tFo3VViuMoOFwCShWv
         WEw6ZA54sReVoKoe0bnCN0DQBL0X2WkoYtMwY3hvteYptInBpd1zbNpqZqkSHzJbiacs
         kVAGIdAmpg+TFk0Ah4W5p4jCyeG8T67ssj4iQwSFWCEZgr+Uy2+5PudZVKb2YiaUZV9A
         TRS6xbItQSUjD0W3OZc/dNPYa3XKOlZz6XoLdungqqlyh7ewJ5MbKX8c9NZhBerripie
         ucRmQu1Sb1HFR9S5M0xieAFucAF2GmVUPhcUdDcHN325jJT4/h9xTYPuKQM4nSyNbUmR
         WX8w==
X-Gm-Message-State: AOAM532ZeOYlNwwAts5p4kMQ6bKDba4anCgdd70q9C7aoWXkmVeJa7KL
        hQqwqLIgyqojt9y08/bopj0=
X-Google-Smtp-Source: ABdhPJyoOsWJtA2MedfBFqAt6VMG+ltsViyoXvx0FiO4rDHJnJdXKheLgLU7OfepurMfkAdpgmM6Yg==
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr4904063wmi.40.1601386900574;
        Tue, 29 Sep 2020 06:41:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 00/15] Start KernelShark v2 transformation
Date:   Tue, 29 Sep 2020 16:41:08 +0300
Message-Id: <20200929134123.178688-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In this patch-set we are starting the introduction of the changes
in the C API of libkshark. The goal of this transformation is to
turn KernelShark into a general purpose toolkit for analysis of
tracing data that is no longer strongly coupled to the Ftrace/trace-cmd
data format. At the end of the transformation KernelShark will be able
to merge and simultaneously visualize data from different tracers,
recorded in different data formats. It will also significantly extend
the possibilities for user customization.

This  patch-set transforms the way KernelShark processes the raw tracing
data. Later, in a consecutive patch-sets we will introduce the changes
in the visualization instruments and in the KernelShark GUI itself.


Yordan Karadzhov (VMware) (15):
  kernel-shark: split kernel-shark from trace-cmd repo
  kernel-shark: Version 1.2.0
  kernel-shark: Start introducing KernelShark 2.0
  kernel-shark: Use only signed types in kshark_entry
  kernel-shark: Introduce libkshark-hash
  kernel-shark: Introduce Data streams
  kernel-shark: Add stream_id to kshark_entry
  kernel-shark: Integrate the stream definitions with the C API
  kernel-shark: Provide merging of multiple data streams
  kernel-shark: Integrate the stream definitions with data model
  kernel-shark: Use only signed types for model defs
  kernel-shark: Add ksmodel_get_bin()
  kernel-shark: Protect ksmodel_set_in_range_bining()
  kernel-shark: Add methods for time calibration
  kernel-shark: Integrate streams with libkshark-configio

 CMakeLists.txt             |   12 +-
 build/FindTraceCmd.cmake   |    8 +-
 build/deff.h.cmake         |   14 +-
 examples/CMakeLists.txt    |   34 +-
 examples/configio.c        |   20 +-
 examples/datafilter.c      |   67 +-
 examples/datahisto.c       |   38 +-
 examples/dataload.c        |   22 +-
 examples/multibufferload.c |   60 +
 src/CMakeLists.txt         |    6 +-
 src/libkshark-collection.c |  121 +-
 src/libkshark-configio.c   | 1175 +++++++++++++++---
 src/libkshark-hash.c       |  213 ++++
 src/libkshark-model.c      |  154 ++-
 src/libkshark-model.h      |   55 +-
 src/libkshark-plugin.c     |  597 ++++++++--
 src/libkshark-plugin.h     |  279 +++--
 src/libkshark-tepdata.c    | 1754 +++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  100 ++
 src/libkshark.c            | 2314 ++++++++++++++++--------------------
 src/libkshark.h            |  795 +++++++++++--
 21 files changed, 5890 insertions(+), 1948 deletions(-)
 create mode 100644 examples/multibufferload.c
 create mode 100644 src/libkshark-hash.c
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

-- 
2.25.1

