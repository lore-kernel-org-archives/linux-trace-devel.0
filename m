Return-Path: <SRS0=eYsA=6L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5A6C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053D7206B6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="osrf1e95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgD0PmR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgD0PmQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 11:42:16 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72501C0610D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:14 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id b2so18051745ljp.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMpL/5wiubD35ePeDsAByoIRs4aCrO93vV85ojbUc3k=;
        b=osrf1e95ZxnhhPb4c+HBQsyk+XUT1KQnTrFAY18jFjDUknVqQaaiNLmu0sDBTeCzOO
         ieJm3KSu99aqSbOGnKh4BNk5VT97BJm6vJtwCsqhTZsvbnD1ngeB0/XgShh+B7LUUFng
         fXe4DwKQq9Z/cfDMLzI4e0ktHn60V3Gk6/qNUlz5wWKu7EZoUqWw/ccJX0G3GiRYMeIx
         H6CeGktR0g0sj9bY/zf9qe5Vi6sozhxECuZeP28hPV+VsxE2llvAEfMOh+rc/DDmWrBy
         OZ3PslnpykA7kBJ5U4htxhQdTqBAIEgFMZWCmDCebtb8lDePhnDmAYtT8BnSLysAY0+5
         kR3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eMpL/5wiubD35ePeDsAByoIRs4aCrO93vV85ojbUc3k=;
        b=bXBRMj/+KfnxgYyx9Qg+5BoQh/6mROSDbmij3uKQFMFd5fAw++qct0A10JmBg6994S
         dIx0aALY0xO1UIbljLQoYsHTAz0Y/hcjn37d7S7dnQScnT0WlV9TOiAVUAUK4m7gJ0SB
         b59cdDCMHFrz+rXty4S8NmYuHNaI07kNM46sttFNjrt1HNs5OyU0f9enuBngKr3rnrAx
         RUqMXn2ylbaZDFEgGMa7hDwSwpV5l+HqhabygxMc89Zk2IYGBxnLlz/ODHkijU0trE/U
         BacUuY0ofo4+yhb0+PnQSxGtC5l+FrqZu5+2EDD1v51j7BWpcBwnJUWyi94BIgLFdO4B
         M27w==
X-Gm-Message-State: AGi0PuYWWdTfRPls40OXG2Tib95hMyCtr+BAYZQ9vWP+7ztfPcw23B4S
        bQV7AKGZZxXaVyUReI8ncOQ=
X-Google-Smtp-Source: APiQypIXXxGJKyQzyJ40eSM5NaYOWMinA7vNi4IoKiY2tk3z7xiVYt0r3+YXB/wJCFdOfajRlbEAAw==
X-Received: by 2002:a2e:8017:: with SMTP id j23mr13560620ljg.22.1588002132713;
        Mon, 27 Apr 2020 08:42:12 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id s8sm11515524lfd.61.2020.04.27.08.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:42:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/3] kernel-shark: Command line options for selecting plots
Date:   Mon, 27 Apr 2020 18:41:49 +0300
Message-Id: <20200427154152.20592-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set implements new commandline options for KernelShark that
can be used to pre-select the CPU and Task plots to be shown, before
opening the GUI. The idea was suggested by Julia Lawall.

Changes is v2:
 - Fixing a bug in the parsing of the string representing the list of
   IDs, given to the command line options.

 - New Patch 3/3 that limits the number of CPU plots shown by default
   when KernelShark starts.


Yordan Karadzhov (VMware) (3):
  kernel-shark: Add methods for selecting the plots to be shown
  kernel-shark: Add command line options for selecting plots to be shown
  kernel-shark: Set a maximum number of plots to be shown by default

 kernel-shark/src/KsGLWidget.cpp   | 13 +++++++++--
 kernel-shark/src/KsMainWindow.cpp | 39 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 kernel-shark/src/KsUtils.cpp      | 24 +++++++++++++++++++
 kernel-shark/src/KsUtils.hpp      |  2 ++
 kernel-shark/src/kernelshark.cpp  | 34 ++++++++++++++++++++++++---
 6 files changed, 111 insertions(+), 5 deletions(-)

-- 
2.20.1

