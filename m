Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9B8C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97C18205F4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfDDO4Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:56:16 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44780 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfDDO4Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:56:16 -0400
Received: by mail-wr1-f41.google.com with SMTP id y7so4150707wrn.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Apr 2019 07:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zz8QCmjZn/CIMa+TMSKgkuleifWOrA0Y99HNqjABz84=;
        b=Rpkrr5broJoLY0i7rLWr/9S8tJKrYVXy2J+q34Q3YNz8oQmbik+YSFaswkS4s+QgUz
         K21EYTuhM/gHX653IK98P2vc8m1P6N+9h3+FDmCIVyUafgTPPneuD/S+4KsYpJS4w5Eg
         a80Yw9Lg0B/JYw09JTMmuPkl3cbOxcTVbQ5/vBujb6oqMEHzQ187B2WMp/TiV5uYVTbl
         BuOLcfebW1TgmMdhcbMKzlJ1HaZ5+v+RcUmYbKFbnmmLNLwyuwTxWbQe/y3QjdUPGMNu
         1RQMWJW4kUO9iUyovkxih4faaf+TQmy1FmRNqd4DURUyywcpxzPX703xTF/H9+9Q9njv
         oPEA==
X-Gm-Message-State: APjAAAWWNHs/SGcdNyc0IF307SNS4fl4FwLqwxIjr6mVmW2026iHJWi9
        wditIa2KfJqsnBWlOs4Zw86MQKFesQs=
X-Google-Smtp-Source: APXvYqy88r7MYFwqxSJ+UFB7QbxZQJNvBypAzZvDszLNy0v798lJVzLNtFmdLCJIfPlpRmOgQ7buuw==
X-Received: by 2002:adf:d848:: with SMTP id k8mr4574383wrl.185.1554389774334;
        Thu, 04 Apr 2019 07:56:14 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m13sm21919883wmg.42.2019.04.04.07.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 07:56:13 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Various modifications and fixes toward KS 1.0
Date:   Thu,  4 Apr 2019 17:55:59 +0300
Message-Id: <20190404145603.13592-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains 3 patches (1-3) that have been sent already,
but have been found to have various problems. The last patch is new
but it implements something that has been suggested by Steven in his
review of the previous version of patch 1/4.

Yordan Karadzhov (4):
  kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
  kernel-shark: Set the configuration cache directory via env. variable
  kernel-shark: Load Last Session from command line
  kernel-shark: Configuration file directory to be created by the
    executable

 Makefile                          |  5 ++++-
 kernel-shark/CMakeLists.txt       | 11 ++++++-----
 kernel-shark/README               |  8 +++++++-
 kernel-shark/build/deff.h.cmake   |  4 ++--
 kernel-shark/src/KsMainWindow.cpp | 22 ++++++++++++++++------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 kernel-shark/src/kernelshark.cpp  |  9 ++++++++-
 7 files changed, 45 insertions(+), 16 deletions(-)

-- 
2.19.1

