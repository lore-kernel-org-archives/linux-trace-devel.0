Return-Path: <SRS0=+uc8=UK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31658C4321A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EF8D212F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbfFKPVj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 11:21:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45787 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbfFKPVj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 11:21:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so13479136wre.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jun 2019 08:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7gZ/GopwkFpllvBMN1CQVB0hlWmhzY1dyJinxXWtTPE=;
        b=nqwLsZ2IxculU3l5uw0c9AHHk5N+5hYg177uPRVG56jc63VHtI4q85yDR3P8hbTqgs
         rotB12dKl5p/oVKYXY1cDosx15ldzLFMjCZ7mkLJcoRCFjHwNH+KHjOSTHGPHCffVshY
         cgJZahzELsdU7jgG691Gkk/iXcDWFMYaE6umJkUiHHPHhEh4o1PXYfAZqDHxT2rHWo9k
         6/eezvggbqIyuzvtIhubagrAeK63BWdapHS9Qz6oVdLWcLNtKxWY5hCt4Iah897Rpk/y
         TR8SHLAgZ51FkOepkljlRurxtQegU6Q59LCDMdz+04KfEjhUBve17H1RHR67GqkPvkqj
         Qzmw==
X-Gm-Message-State: APjAAAVClbLXhSA7AEZvnuBUbwqsHfm0lG3yo+uc54rbaD1qzdDdjPgT
        kMI0xRykO46cI4XWCEVRTmapr78n
X-Google-Smtp-Source: APXvYqytub42nSkcC41D8mR0u8QuRF2m8wm/yyQyZvnyxrTqmvIIEP5qBuHGkY2jKW92UH1wymla0g==
X-Received: by 2002:a5d:52c7:: with SMTP id r7mr49326313wrv.110.1560266498124;
        Tue, 11 Jun 2019 08:21:38 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r2sm2793821wma.26.2019.06.11.08.21.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:21:37 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/2] KernelShark build fixes for v1.0
Date:   Tue, 11 Jun 2019 18:20:41 +0300
Message-Id: <20190611152043.22572-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two patches addressing the problem of having the paths to the build
directory embedded in the final binaries. The problem was reported
by Troy Engel.

Yordan Karadzhov (2):
  kernel-shark: Avoid TRACECMD_BIN_DIR being set to the build path
  kernel-shark: Avoid debug build when CMAKE_BUILD_TYPE=Release

 kernel-shark/CMakeLists.txt           | 25 ++++++++++++++++---------
 kernel-shark/README                   |  4 ++--
 kernel-shark/build/FindTraceCmd.cmake | 14 +++++++++-----
 kernel-shark/build/deff.h.cmake       |  2 +-
 kernel-shark/src/KsCaptureDialog.cpp  | 13 ++++++++-----
 5 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.20.1

