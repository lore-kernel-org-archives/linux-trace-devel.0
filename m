Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E9BC28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B551D2596C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE3NOq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:14:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35741 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfE3NOq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:14:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so2560984plo.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 06:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuNlSdw6G4G6M4Yh2V829DxBPXibJXxLWcxejISrcUo=;
        b=kG5uHiYZWHmFiD0hNn2k/JrSFErtcGJDS3FMGB0MZ7irSZmi4ftZ0AZp3lyEhO1iV6
         +f1SraupY6IiS7kFciFLehTorGSZzLYX0fIG/svplAzEzsIAuPDIG935XqhdIIy8WqnK
         3lK6VS6vawDwaIPN29alz6sD1ue08dn1awdm0+0bB17nFGlcbbBo4DGZZ0Jx9tftDO7i
         yXnjKIzlVeIvYiAJzpw1Mx9e0cCUC3wY/AzcQwJxl9IT/2IbxrZQMHw1sbIBblIRY6ED
         Amm2g/d1g6goa+mHnRI9o43MhKVzkb2DyYL1FOXROptFZ0ThjRG5z29XNEGmwLV53eDE
         cqhg==
X-Gm-Message-State: APjAAAWj3jqBk56c/Tg44O8bY19HMsFmQVThBQCQVEB8aUXrve5vkdll
        y7IN6WsOvYk7CU4P5NG/cmM=
X-Google-Smtp-Source: APXvYqzuG0RsLDfIIuXjA8MJqzU8fVfKv6F4x0x1qR3VSOkEYxmYcjTfpGhMa9qZOFiOT27fvzE4ZQ==
X-Received: by 2002:a17:902:aa93:: with SMTP id d19mr3479540plr.341.1559222085461;
        Thu, 30 May 2019 06:14:45 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d19sm2419627pjs.22.2019.05.30.06.14.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:14:44 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/2] To be included in KS 1.0
Date:   Thu, 30 May 2019 16:13:28 +0300
Message-Id: <20190530131330.21701-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains modifications motivated by the attempt to
implement a standalone version of the NumPy data interface. Those
changes do improve the code but strictly speaking are not compulsory
for KS 1.0. Nevertheless, I would prefer to get those patches upstream
a.s.a.p. Versions of the two patches have been send already several
times as part of different other patch-sets.

Yordan Karadzhov (2):
  kernel-shark: Add new dataloading method to be used by the NumPu
    interface
  kernel-shark: Use full paths for non-standard library headers

 include/trace-cmd/trace-cmd.h         |   2 +-
 include/traceevent/event-parse.h      |   2 +-
 kernel-shark/CMakeLists.txt           |   3 +-
 kernel-shark/build/FindTraceCmd.cmake |  44 ++++----
 kernel-shark/src/libkshark-plugin.h   |   2 +-
 kernel-shark/src/libkshark.c          | 139 ++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h          |  16 ++-
 7 files changed, 172 insertions(+), 36 deletions(-)

-- 
2.20.1

