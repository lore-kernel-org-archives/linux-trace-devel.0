Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C94FC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55EB2312F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAFQMQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFQMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:15 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2346CC06134D
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:35 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 6so5756475ejz.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SbK6HhLV07lmMvG+ix4iYVtD0LdlCFmGPo7OSX6Wbgs=;
        b=t1E6RNV22ZkCorW9GelzlSTijYe2TpZsQfaCA4LXr0zLw7pj1FdOGW3hpofxNpBqzA
         VAmcNUTgYIcrderr3+tA3eRzu/M7FMYEm6O5Xw0IzPN/uGtlTcNTrz+OuTBPj5RBC9xd
         Udk7R0WHadPCfs2pkR10z2oXC2k5/2ayHL053mz/TEe5kcTSeVwgCkhsYOsAJiT4Jv9A
         B6lvAxzXrW1KY5fAJuNRzJBgtIPPSuNliBif/SKhxM4WtqBESofdBsGucG3bluJT/UIe
         DVZpoAiyk58fPOwoA9uF9ErFEpIx0nnvU+i5V+Q3Xzh+XQJ6VJgnz89g/ape9cYGRuZG
         QVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SbK6HhLV07lmMvG+ix4iYVtD0LdlCFmGPo7OSX6Wbgs=;
        b=b2DFoPbUDdecU4c4hiruGbXl6QVAa1IY2yCPpXHQxTDZnz7Fgv12suC/7o6CXW2aRQ
         xgOgonkXyNFZk7S7cSADvP3TBgmNl5Mei39k/ZOX6SosC+B+VQJbOziWH6y/xzvf4LXo
         EQIdBxosIPfgtfx4uxQNuqy9YwO4KNpDBGDcP2/O/rxBQT50lPcNVqHU1xfOwzbsPf95
         RKvsKOEbegwKX4KKgyyLsuWDRjoAKdqA4zPfyIIuju1xWF3N1/Dks4IdOqszt9tAn+gE
         m/9hmXciJHl8p/LnfN8UjB8EuqF4S+pE4Dv60dwfCZgjRUxz1ixbDqyxQH9pqubXNgLO
         QdAw==
X-Gm-Message-State: AOAM530toLRUNwh8BVUOEqI/KIPkoWiRMIXrRpYjREohRN0w1QUb4i7J
        kpehZf3JtsdQgbYQA2gCtoV4z/d3Vah2rg==
X-Google-Smtp-Source: ABdhPJykrd7FREbyadlGVrSw39yyHtFmbqEWV1RVlu9ok1N6vNrJfLnhamkNM15ytl/P5Tf+J7kWbQ==
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr3316989ejb.11.1609949493967;
        Wed, 06 Jan 2021 08:11:33 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/6] kernel-shark: Visualization plugin tools
Date:   Wed,  6 Jan 2021 18:11:14 +0200
Message-Id: <20210106161120.119085-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We implement a general purpose instruments, that can be used to
implement efficient (fast) visualization plugins. We also use
the new instrumentation to optimize the sched_events plugin.

Yordan Karadzhov (VMware) (6):
  kernel-shark: Add KS_DOUBLE_SIZE macro
  kernel-shark: Add kshark_data_container to libkshark
  kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
  kernel-shark: Start using C++17
  kernel-shark: Add plotting methods to KsPlugins
  kernel-shark: Speed-up the sched_events plugin

 CMakeLists.txt              |   8 +-
 src/CMakeLists.txt          |   5 +-
 src/KsPlugins.cpp           | 416 ++++++++++++++++++++++++++++++++++++
 src/KsPlugins.hpp           |  48 +++++
 src/libkshark-plugin.h      |  58 +++++
 src/libkshark-tepdata.c     |  34 +++
 src/libkshark-tepdata.h     |   7 +
 src/libkshark.c             | 162 +++++++++++++-
 src/libkshark.h             |  43 ++++
 src/plugins/CMakeLists.txt  |  11 +-
 src/plugins/SchedEvents.cpp | 310 +++++++--------------------
 src/plugins/sched_events.c  | 393 +++++++++++-----------------------
 src/plugins/sched_events.h  |  50 ++---
 tests/libkshark-tests.cpp   |  66 ++++++
 14 files changed, 1052 insertions(+), 559 deletions(-)
 create mode 100644 src/KsPlugins.cpp

-- 
2.25.1

