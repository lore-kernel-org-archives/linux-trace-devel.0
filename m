Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A14C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6464922BEF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAEPzr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbhAEPzq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:55:46 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7B8C061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cw27so629261edb.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wjIV92cyrgK76rXpKchPDuSBSwsICGjuIf/J/mHJmCA=;
        b=TrxjMGG+M7RTbmeRkLxFruMKg0aCHhln9CDzNCZ1qLJzhAyerbkq8xUn65Cw5zgGNT
         msjq53ShAX+lyapqCm64Pigw2zxnY8DNhhV/QQ4ONuR2xv/55bLbk/dKNiDtONS30mW6
         gFNRcYZWUrzQmFS0yPEarpmOhqlrouyywghZPaeiSYTzQufVzwVrJKiX4k3L9kIYF11A
         eMoecP1eebDrZOFlArNS+L8nju1vddbfiljWXhZ5KO7ozv2J0n2v9ZxD8eT88GgrQr4K
         AABeVgjlZMXCdymyW7IiUJwidmemp8bk+lAXmgEdQiaBJ72FYg9EBLFEU4iFVrTXiTPS
         OARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wjIV92cyrgK76rXpKchPDuSBSwsICGjuIf/J/mHJmCA=;
        b=X9ehP8xUzhxaZp0heR0svtr5L3flExGRF/rjlNcDc0fvMpUlaxjlWvfHj4KF74HTAq
         iZ03hrLP871Oo1sKbY7+GOWqP6nUDpugAY3nA/dvDCxIAwvOhIO+AsKQCU/QJEEFVJYJ
         ZPD/dl8O66TxMtzWRGMfiBUQ36EhGs8i9NUY0GxKZkmy4CcP2mSRTtzTG38vQBtT2bQr
         89d0j5RKNsA3rXD2rZI18OEOfxodk5v00GBfS5dzWoSe3hNsvt4lMuVmxhaxkq9MaJrq
         7TVbFzdACurqsDqEukrHDocrigt8FniVGQZVhDJxinkEezZl2gvjOECTXqiXS+L3lzmw
         cr4A==
X-Gm-Message-State: AOAM5316ReC18sgyIv/PjzhF+3ju7oJjqGnxCekPHvnCVfKUJJF7e6lN
        +oXkB8fV7R5PdQkr19Qj79imwiUNKekkXg==
X-Google-Smtp-Source: ABdhPJwS/7Y7z7t5FsItyilSascVG1T0iqthDHk45TCx2eOCZqD6mAV/NLdnK84Poy0rAOYOR2UD2g==
X-Received: by 2002:a05:6402:4c1:: with SMTP id n1mr419321edw.66.1609862105088;
        Tue, 05 Jan 2021 07:55:05 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] kernel-shark: Improve the build system
Date:   Tue,  5 Jan 2021 17:54:48 +0200
Message-Id: <20210105155453.41228-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All changes and fixes from v8 of the "Start KernelShark v2 transformation"
patch-set that did not managed to go upstream.

Yordan Karadzhov (1):
  kernel-shark: Fix "github Actions" workflow

Yordan Karadzhov (VMware) (4):
  kernel-shark: Start using libtracecmd
  kernel-shark: Add missing SPDX license identifiers
  kernel-shark: Change default libraries install location
  kernel-shark: Split the installation in two components

 .github/workflows/main.yml       |   2 +
 CMakeLists.txt                   |  30 ++++++---
 build/FindTraceCmd.cmake         | 101 ++++++++++++++++++-------------
 build/FindTraceEvent.cmake       |   1 +
 build/FindTraceFS.cmake          |   1 +
 build/cmake_uninstall.sh         |  23 +++++--
 build/install_gui.sh             |   1 +
 build/install_libkshark-devel.sh |   1 +
 src/CMakeLists.txt               |  55 +++++++++++++----
 src/libkshark-tepdata.c          |  18 +++---
 src/plugins/CMakeLists.txt       |   3 +-
 11 files changed, 161 insertions(+), 75 deletions(-)
 create mode 100755 build/install_gui.sh
 create mode 100755 build/install_libkshark-devel.sh

-- 
2.25.1

