Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F20C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6530205C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfDSTzZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:55:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52924 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfDSTzZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:55:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id a184so7218499wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:55:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZNMEF1KYiPNhGNgQpWFIlz1UvP9d/ZoA6jJIn/8gSM=;
        b=Ylp+sQVVf1YmyLt1I2D6PJ/ILmqh7FoBHGeP0ulCNngllmY5IBl7S4LPnP7rnpHYy9
         w9UyDdBqfy2TxzjocrMC+mATgAu70vqR+kbH/j3gEfpFtnRPAmvJiR22dFeriYF9/TVR
         k/5fm7pMa+uzad+1WOgUV2Ns1pmGZdN55FFkmsSQLixOyPK34KzuQyRmw6BBB2WYJrB9
         SKAjJ47JimgtSTjX818jl8sCIlvc5O+4v0BQ3ym0ppgr5PDF9FtpAAW1lLJKQU3Oclpq
         05EyTSEPufNpbOg3r2ekhTpRQwn5ppGTkZAzwsC1S9ajHesOraPvM5jDFHc/S+/NWx2s
         vviA==
X-Gm-Message-State: APjAAAUTBqRqC6XZbUsvf5iB5XHEy+Ed0DHqRSKkOQv0kd9Q6uTQ2XTJ
        CgDIPjoOZwuC0yDQVJCgVIswZHYD
X-Google-Smtp-Source: APXvYqzrULZz0Dys5KNf3nu+w7rXxNB9oAZwzRQiz1+i3z0p461PCrJNJE/olYk/Xakvr2mdPzplWQ==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr2894651wmj.31.1555681850681;
        Fri, 19 Apr 2019 06:50:50 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.50.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:50:49 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 0/8] Various modifications and fixes toward KS 1.0
Date:   Fri, 19 Apr 2019 16:50:28 +0300
Message-Id: <20190419135036.19340-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains reimplementation of patches that have been sent
already, but have been found to have various problems. The last two
patch are fixes of bugs that have been found recently.

Changes in v3:
 - Corrections from Slavomir (in patches 1/8 and 3/8)

Yordan Karadzhov (8):
  kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
  kernel-shark: Remove the definition of KS_CONF_DIR
  kernel-shark: Add logic for the initial path of Open-File dialogs
  kernel-shark: Add logic for the plugins search path
  kernel-shark: Rename KS_DIR to KS_SOURCE_DIR
  kernel-shark: Load Last Session from command line
  kernel-shark: Use proper searching condition when the dataset is small
  kernel-shark: Handle the case when the marker points to a filtered
    entry

 kernel-shark/CMakeLists.txt             | 37 +++++-------
 kernel-shark/build/deff.h.cmake         |  6 +-
 kernel-shark/src/CMakeLists.txt         | 10 ++--
 kernel-shark/src/KsCaptureDialog.cpp    |  6 +-
 kernel-shark/src/KsMainWindow.cpp       | 80 ++++++++++++++++++++-----
 kernel-shark/src/KsMainWindow.hpp       |  4 ++
 kernel-shark/src/KsTraceViewer.cpp      | 32 ++++++----
 kernel-shark/src/KsTraceViewer.hpp      |  2 +
 kernel-shark/src/KsUtils.cpp            | 35 +++++++----
 kernel-shark/src/KsUtils.hpp            | 16 +++++
 kernel-shark/src/kernelshark.cpp        |  9 ++-
 kernel-shark/src/plugins/CMakeLists.txt |  2 +-
 12 files changed, 168 insertions(+), 71 deletions(-)

-- 
2.20.1

