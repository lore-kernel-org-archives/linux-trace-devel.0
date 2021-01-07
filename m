Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21C4C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E4B22EBF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbhAGQQo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQQo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:16:44 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB904C0612F4
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:03 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r5so8211012eda.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CnoBpyfdHVbVHw08UCAjFGBza1rJbVtZeSTdEdyvR2w=;
        b=qw3h9fcT0yn3K+xXWn6JZgJ1tHt4DAowrotynjfB+OcgD4zgnjRw/woLxZYdUdBlHS
         VJq4WlZGbk+1525dYRc9DOVtyGYvupMq3vzwpjl32W8KDtnqzveuDS7MLO3Z5u3Xrmwg
         b4HFr7j4psiVsa1h+nJfjCY6zn9sQMyxTs5O1Hp5h3SpNflOMbI8n/JcLF6Ar5FrI2oG
         n0xNJcJv0Z6Je2MP+e4z0Zev3iR0LOZrFi0MTZZwPgWUEEixgDgeaBu+lA8SpAi5xn7i
         Lv8KIkb4U1L5V5jeZqZFQXBDxMLRSL1O8qUTTK38ZtLjOfPOfR/IRu58/m+fxTVdKZ+T
         bSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CnoBpyfdHVbVHw08UCAjFGBza1rJbVtZeSTdEdyvR2w=;
        b=iEzQCv7A0fBMdaV0M1U7R0v7YxD1wBOkZpWJk/Gs24nlh3/WGJEbmp5XuBJqEroCHT
         foRbe5OUdp8TPAePRdg0LzsuyezxSu9U+687iYWTppIIzgJzTtxd2y8LSr2z/EFG8fq0
         EZodVrUhZMnLe498y4rNXZu/iOlUwgVJVt2i/cqbefRg+Yc+riCqhHdD3WqAuPfDUkSq
         QVHSKmmdTJIn2kVh9G3XZN2TkcM15moUDXlDMa4M1M94s11CTR3vSkE+XG9LtbN4VYtU
         H4vjU6eeRjQhxHy2jwvWsuVeU+fAcO6rTZgtYJ+WayZeMiiZGiwVHzTMEalKOcjCPNzS
         kKrQ==
X-Gm-Message-State: AOAM532zzRKG6j6mGyoja+v91m40l3Bxg9Dq9FS+BjUDP03hUZeu1fyE
        485JGsECGO3FDhoan2zdmcZ7kw/Pjaw3Vw==
X-Google-Smtp-Source: ABdhPJy5InrmKWVwHnnM16A/6AEGfZyp8Q3CMydU4AHqAE57PNV1Y1aUnfNEusmagtBx4qNlULfTFg==
X-Received: by 2002:a50:f089:: with SMTP id v9mr2264476edl.353.1610036162505;
        Thu, 07 Jan 2021 08:16:02 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:02 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/6] kernel-shark: Visualization plugin tools
Date:   Thu,  7 Jan 2021 18:15:41 +0200
Message-Id: <20210107161547.207270-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We implement a general purpose instruments, that can be used to
implement efficient (fast) visualization plugins. We also use
the new instrumentation to optimize the sched_events plugin.

Changes in v2:
 * KS_DOUBLE_SIZE macro was simplified, based on the suggestion made by
   Steven in his review. A dedicated test case for the macro has been added.
 * Bug fix in kshark_free_data_container().
 * Bug fix in kshark_data_container_append().


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
 src/libkshark-plugin.h      |  59 +++++
 src/libkshark-tepdata.c     |  34 +++
 src/libkshark-tepdata.h     |   7 +
 src/libkshark.c             | 158 +++++++++++++-
 src/libkshark.h             |  43 ++++
 src/plugins/CMakeLists.txt  |  11 +-
 src/plugins/SchedEvents.cpp | 310 +++++++--------------------
 src/plugins/sched_events.c  | 393 +++++++++++-----------------------
 src/plugins/sched_events.h  |  50 ++---
 tests/libkshark-tests.cpp   |  89 ++++++++
 14 files changed, 1071 insertions(+), 560 deletions(-)
 create mode 100644 src/KsPlugins.cpp

-- 
2.25.1

