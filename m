Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45768C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D0F20821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbfDRPWT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34927 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPWT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so133058wrn.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JtSYvbjoVh6UklgdPE562FaBI74oeMYyqS0+p2dTmOE=;
        b=H769d3ksI+oZRSml2Sfl9lcxjCJy/Zw2ey+dD58p3qCLlI7BAHcBGqzdU6rsfeybeN
         mmvHG3SY6NbTuIxG8pbCUg1PNk7c2QVCMk/bVXU51VsatDsouVVNUqEIzDiJAnhoBO21
         wDIoHESTw2+7DTpNXWqOpJ8XjlezxfYJBglAMClJ/Hlq5yFvsZjYjDSJPrgijUT0FfH2
         hj4Rj7xqYPCohr2DoWyEUahQ/ep+mnVFhN4SoSCiXAg1a4SguJ89LApRrWZ4nKoBgcWR
         5ChBZkhNCaiJvWfPkkNWQ5MeL84y18mq2IGewfApWgH33bmVB3mwvoxHpE0z0s9SOOBt
         LwjA==
X-Gm-Message-State: APjAAAWU1xPDcay1uz71M9/etZ+AkYJAa+ykwTCmiM8FIkCRyUiq9OpN
        CNpUZQZprEU/l3wG9JdEcPE0BLcq
X-Google-Smtp-Source: APXvYqwAFJZIesOAaqSTDl+gapwlucNn8X9fyIS1JD6rETIVNweisvS2McLGVmIL/ueVkH/c2h3Bzw==
X-Received: by 2002:a5d:5346:: with SMTP id t6mr2595021wrv.59.1555600938058;
        Thu, 18 Apr 2019 08:22:18 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:17 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/8] Various modifications and fixes toward KS 1.0
Date:   Thu, 18 Apr 2019 18:21:38 +0300
Message-Id: <20190418152146.27232-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains reimplementation of patches that have been sent
already, but have been found to have various problems. The last two
patch are fixes of bugs that have been found recently.

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
2.19.1

