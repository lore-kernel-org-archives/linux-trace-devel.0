Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3364C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB81620881
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfEOTJr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:09:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34305 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfEOTJr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:09:47 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so261647pgt.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZETe9vlrQUmZZNKwCaSUhoKxDUXi+dQoCBKUz1DhtI=;
        b=exUctXXSJ9EBWmyLB1lMNigfJU2ptXLodzAdamtEBNSmH0SiCdlQB79v7DbGy+zri5
         bbXSgEqGXtFNzMqQz9Dc4KXUdNWOYvrvuhJYk+Ji26lHy/EvBc1aeDOg3S0HF3B/1bxK
         bM9pDRatsbT7utNvahOy4ZQ22Alo6+Zd4YpRsUnDwVVh2yLyDG1pDpw+gV8mMVpVFQ6X
         NR/y5my8ktQtDSCOzvPT1cxg984OslaXr/zuhZEroQrl8n8XbuzNnN1oJHCPEqtGsL7x
         85U5R00dolQ/cqVipdNl6bE93EJ09pYfVFNdY/F4I8hvQhdFQECGHmEqgm+vBxNSFtUS
         ChhA==
X-Gm-Message-State: APjAAAWL2ved2ZWwxKP9ziMANeY/ZVwhxX8XjvmWswo+RyK8g1t12bqB
        IObV1idl7a+aune3TsQVlHg=
X-Google-Smtp-Source: APXvYqzmibvVy3RtxfKsrjdw80f2WbJ2WBziX1tb8VF4zxZD4ouDEpRysVqx3R9B1Gi2z5SZaseGOA==
X-Received: by 2002:a65:5c4c:: with SMTP id v12mr1644825pgr.283.1557947386539;
        Wed, 15 May 2019 12:09:46 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.09.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:09:45 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/6] Various modifications and fixes toward KS 1.0
Date:   Wed, 15 May 2019 12:09:05 -0700
Message-Id: <20190515190911.20755-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains patches that have been sent already,
but have not been pushed due to various reasons. The last
two patch are fixes of bugs that have been found recently.


Yordan Karadzhov (6):
  kernel-shark: Remove hard-coded install paths
  kernel-shark: Use XDG compliant path when saving cached data
  kernel-shark: Enforce update of the OpenGL widget when loading new
    session
  kernel-shark: Add "Report bug" button to "Help"
  kernel-shark: Improve the appearance on high screen resolution
  kernel-shark: Handle the case when the marker points to a filtered
    entry

 kernel-shark/CMakeLists.txt             |  8 ++++--
 kernel-shark/build/deff.h.cmake         |  3 ++
 kernel-shark/build/ks.desktop.cmake     |  4 +--
 kernel-shark/src/CMakeLists.txt         | 19 +++++++------
 kernel-shark/src/KsDualMarker.cpp       |  9 ++++++
 kernel-shark/src/KsGLWidget.cpp         | 24 +++++++++-------
 kernel-shark/src/KsGLWidget.hpp         |  5 +++-
 kernel-shark/src/KsMainWindow.cpp       | 22 ++++++++++++---
 kernel-shark/src/KsMainWindow.hpp       |  4 +++
 kernel-shark/src/KsPlotTools.cpp        | 37 +++++++++++++++++++++++--
 kernel-shark/src/KsPlotTools.hpp        | 11 +++++++-
 kernel-shark/src/KsTraceGraph.cpp       |  2 ++
 kernel-shark/src/KsTraceViewer.cpp      | 22 +++++++++------
 kernel-shark/src/KsUtils.cpp            |  4 +--
 kernel-shark/src/plugins/CMakeLists.txt |  3 +-
 15 files changed, 134 insertions(+), 43 deletions(-)

-- 
2.20.1

