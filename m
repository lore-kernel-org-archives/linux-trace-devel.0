Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDBCC2D0EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3581B20732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qoe8PGbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgC3QHL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34875 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgC3QHL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id k21so18732445ljh.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OiJ1FrhYA1BTreXshFxczroC12HBJEArDmgEdPJQyy8=;
        b=Qoe8PGbEic5vWhX14+g2Vu2U6xHHvbDDto6egDdOQDKFV+0EkpJyXGjcLp5j3zPpNu
         gj+X6Df2aYXcmlx7MOSxur+Em7LJuqyGqTG3Y5F6dMI0FTSkpMq/ybqC67+ZJVDTWQdb
         pk7pl9YYdEM5ZHzvn7RhiwAiQnALY7uHoUyXCt7OuYrG2TZhKIyr0tsxc1E01o/CrH8G
         pLGotok/1VWdTS5v4t03srePdybHCEJ6XxBjMdgwR/IDKrm9RKsqfB/dRkIGEIuLI42k
         NU0a1fB2CrCR0uKUwLWN0ZSllbbTM6bsB1xWtL8eeelK32zQRnsE6MaMmg+23RN5iCIE
         Xj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OiJ1FrhYA1BTreXshFxczroC12HBJEArDmgEdPJQyy8=;
        b=SoN1oYWC5uFpUnrlFtVPWI/aaQi0syi+RWMED39uvKUTd21Q6EHcdvf+x1juAolCKR
         BFvPDVzj74Ws7dGH0LMkRMs0XUklPo6xQqkq9KuQBekIbkVIquOWtLMZuZJIIYnsLB4+
         n1s0+3Tbaq8ROJ23XJ2LCjPh3nr8i51TrC6XUTZLYIpDlKgmnh1dTGtfmVkJzs0aVDcU
         6Yd+6F0Eba7Yfy1NDf5N/hpfd+nE+LDxd4YbIahpdPUIfyt7kycgD8Nct+JJ/wxsZoEm
         fLghIWCSA4YPkZiIO1sKaFpbU+o+Qac9scHv/Afdx/TztRYTZnNeuQUI+eyLjE+fn5+Z
         HEgw==
X-Gm-Message-State: AGi0Pua8B0cW7CCvi8MDfvj+M9bXfGVz44m6lhy7aXkN4qNQh1ers3PU
        8RkqdjRgi2Z45c1kF8lU/fI=
X-Google-Smtp-Source: APiQypKs7/670c0crIHOe/fiNw7og+K2HP5k+E1a+KcdMYkHzLP/MYK57zyadqULMRgak6bIavsWjQ==
X-Received: by 2002:a2e:7513:: with SMTP id q19mr7569682ljc.221.1585584429018;
        Mon, 30 Mar 2020 09:07:09 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:07 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/6] kernel-shark: Optimize the logic of the filtering menus
Date:   Mon, 30 Mar 2020 19:06:46 +0300
Message-Id: <20200330160652.28424-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The original motivation for this change was to fix the problem that all
negative ID filters which are set using the Quick Context menu of
KernelSharlk are not visible when you open the main Filtering menus.
The logic of the main menus is optimized to use both type of filtering
and to automatically decide whether is more efficient to set positive
(show only) or negative (do not show) filter. The patch-set also includes
one very simple bug fix (patch 2/5) that was found during the development
of the new filtering logic.

v2 changes:
 - Patch [4/6] is new. It adds a simple inline method to the
   KsCheckBoxWidget class for retrieving all Ids (can be PID
   CPU Ids etc.) managed by this widget.
 - The inplementation of the new logic of the filtering menus
   is improved in order to avoid having duplicated code.


Yordan Karadzhov (VMware) (6):
  kernel-shark: Add method for checking if a given ID filter is set
  kernel-shark: Fix bug in bool kshark_export_all_cpu_filters()
  kernel-shark: Add two helper methods to KsUtils
  kernel-shark: Add getIds() to class KsCheckBoxWidget
  kernel-shark: Remove unused methods from KsMainWindow class
  kernel-shark: Optimize the logic of the filtering menus

 kernel-shark/src/KsCaptureDialog.cpp  |   6 +-
 kernel-shark/src/KsMainWindow.cpp     | 248 +++++++++++++-------------
 kernel-shark/src/KsMainWindow.hpp     |  13 +-
 kernel-shark/src/KsUtils.cpp          |  38 ++++
 kernel-shark/src/KsUtils.hpp          |   4 +
 kernel-shark/src/KsWidgetsLib.hpp     |   6 +
 kernel-shark/src/libkshark-configio.c |  17 +-
 kernel-shark/src/libkshark.c          |  21 ++-
 kernel-shark/src/libkshark.h          |   2 +
 9 files changed, 208 insertions(+), 147 deletions(-)

-- 
2.20.1

