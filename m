Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D54C282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0189220700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403764AbfBMQMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:12:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42580 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbfBMQMp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:12:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so3133550wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rs39aN17APpbv/PFVlu7C7CKIHsogQ1wKwlaVfnCrXc=;
        b=uO0RBP5i2NEjnhQpOZpWVwhMPdG2Xxo5BEGBNIenIYq/ITU2vjxoNM6zFAvbs0EApt
         yXyrtRFHfUboJ+xXE2txEKZR0XA83QXo+7ExSBMcr9uJS4FL81gVE400nP2E9/O41/Hi
         R3kJyipwLNVnu4WLkViPV9J5KEQrGbxZTCItVEdDMBD6D3HrYDw1vAhNevMilPhlS7wt
         fsSb2qwV76JMTcfRuQdpxE8KB0rzzCsw6KqwS7H9q+q+8mJfvQyGrZCFkhBmEdntZQI9
         xIgmLM4bic+JTvBBHR4SHO/TSFo3cBMNbbFJprYTqFUtLMDiNVRFDx/0LgskJ6qlvAsJ
         VJOg==
X-Gm-Message-State: AHQUAuaqnxJh7hrCN/RGPVKD5cB2OkPqw8xI4igRKUxJxHC4Gz40WLbN
        Xyjzy+kGi6m852BH8wdIi2o=
X-Google-Smtp-Source: AHgI3Iamo7P/gPaMtczEpwXWe6yZvxd6qSlWNL7PjjB5Bv5gAjtjfZ34/8vVCSv9uf/STp76gahU4w==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr1002282wrq.31.1550074363866;
        Wed, 13 Feb 2019 08:12:43 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:43 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/8] Various modifications toward KS 1.0
Date:   Wed, 13 Feb 2019 18:12:08 +0200
Message-Id: <20190213161216.14438-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This series of patches contains various independent modifications and
bug fixes.

Steven,

Do not apply the last patch if you are not sure that KS v1.0 is ready
to be release.

Thanks!
Yordan

Yordan Karadzhov (8):
  kernel-shark: Add more sanity checks for model misbehavior detection
  kernel-shark: Do not copy the Upper Overflow bin when shifting forward
  kernel-shark: Check bin 0 for sched_switch event when plotting task
    graphs
  kernel-shark: Don't use Data collection when checking if the bin is
    empty
  kernel-shark: Make the time labels of the marker more readable
  kernel-shark: Fix the compile warnings about _GNU_SOURCE being
    redefined
  trace-cmd: Fix the printout of the KernelShark executable path
  kernel-shark: Version 1.0.0

 Makefile                              |  4 +--
 kernel-shark/CMakeLists.txt           |  6 ++--
 kernel-shark/src/KsDualMarker.cpp     | 42 +++++++++++++++++----------
 kernel-shark/src/KsPlotTools.cpp      | 34 +++++++++++++++-------
 kernel-shark/src/libkshark-configio.c |  4 +++
 kernel-shark/src/libkshark-model.c    | 38 ++++++++++++++----------
 kernel-shark/src/libkshark-plugin.c   |  5 ++++
 kernel-shark/src/libkshark.c          |  7 ++++-
 8 files changed, 92 insertions(+), 48 deletions(-)

-- 
2.17.1

