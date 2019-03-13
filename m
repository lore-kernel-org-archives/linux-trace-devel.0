Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C6FC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 188F520643
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfCMPWo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:22:44 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:39093 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfCMPWn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:22:43 -0400
Received: by mail-wr1-f53.google.com with SMTP id p8so2459664wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tAy+oQFjElp8lTUo9eQdP4wxkzXgW5HUGplyxhZzWk=;
        b=QOVh956Omxu05S6T6nMnE4p9y2MyWyIyufCQU3wxq3fnt/uA457Z4yUUL7+4nuv1Na
         NTCcryPAIdx5dqK6d+YjhIvDiWMcefGfimlNTtIvZkZ5oURaBf910CkCFHActmLuPh2b
         cOy+CAN6L+hsgwIM1PGIgQsZ5NOADiZ6p9zKZtNJxdLYzSy1vrow2kHhrdP7WyKW7N/Z
         Q50Zk6INJf0AVORI+4CZcMAg6krjauWetWsOGY+DOTqy/ae+pJU+voQsSsoJC2CrEvFp
         1OyLxYpr2bNkfgnMq5O00oSeQL5NCJRsEcoAkMb2mQ06A2xIZ6AqCW2DuXvtS1n76gAy
         bjCA==
X-Gm-Message-State: APjAAAW5EJqTOIXCtrR8lud+tbF1YEENQogL5hXyvhrYzz/NxCqcMSAu
        +BYWi044EIGq0jJKjxfBbtg=
X-Google-Smtp-Source: APXvYqyp0TcD6zwLaJfN+v7zt99xyXvi8YDmhRNOc48zOMfjGllYEqRZyQ9yodBwF9hhToX+A8NEJA==
X-Received: by 2002:a5d:6a0b:: with SMTP id m11mr13572054wru.180.1552490562235;
        Wed, 13 Mar 2019 08:22:42 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id w10sm20775822wrn.32.2019.03.13.08.22.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:22:41 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/3]  Tuning the KernelShark build system
Date:   Wed, 13 Mar 2019 17:22:17 +0200
Message-Id: <20190313152220.22026-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch set combines few minor tweaks of the KernelShark build
system default configurations suggested by Steven.

Changes in v2:
  - The default location of the cached configuration is now
${HOME}.cache/kernelshark

  - KsMainWindow::lastSessionFile was made public, because we will
used it later when loading the Last Session directly from the command line.

Yordan Karadzhov (3):
  kernel-shark: Reorder the priority when searching for trace-cmd libs
  kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
  kernel-shark: Set the configuration cache directory via env. variable

 Makefile                              |  2 +-
 kernel-shark/CMakeLists.txt           | 13 ++++++++-----
 kernel-shark/build/FindTraceCmd.cmake | 16 +++++++++++++---
 kernel-shark/build/deff.h.cmake       |  4 ++--
 kernel-shark/src/KsMainWindow.cpp     | 20 +++++++++++++-------
 kernel-shark/src/KsMainWindow.hpp     |  2 ++
 6 files changed, 39 insertions(+), 18 deletions(-)

-- 
2.19.1

