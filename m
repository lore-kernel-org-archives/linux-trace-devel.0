Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598F6C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 298C020652
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfCGPnh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:43:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33993 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfCGPng (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:43:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id f14so17977331wrg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PxdSfyzKjbQKSKS5H8pb9XEI4my8WN5KT2FdrFepxOc=;
        b=HC2mBE/aA8qMOOO68LlHAVEnoid9FSdCfEMxKasyab8x7rAdsOfXXhES9IUTv6sqz7
         d333lT3UHDs5lITc92L9tu4IOS/k8/D+uZvH67P0YKS3EupkGgTbCCs2OSE1/+jbo0LO
         Rbg2ZkfRyx2XaneuoMpM0TdrcR6MNeQMLlUn8Ool2K2nqOwsP/cRxhHsi59OmRoeoeYy
         PDab2BgNfN4wOJqJM6Bpv7I1I9QEEnZ8m0WE6VIXLsfZ3/kDDZcYTzo06LbJ65TEXcMx
         qUzpRBkKxbOKNB4FudHdgnEZB3cY0RocHbH1GrUlZ5S/ZetMqhx6ETU4wlijdrA+Wfgm
         ieAw==
X-Gm-Message-State: APjAAAUyKhWUuvy4xc3hmcxxCgCdSaflseTcZFqKFwas/Zc6r9bK1ClL
        KYo4cxoWJmM+nvTikqcrFJ+fNg7N1HY=
X-Google-Smtp-Source: APXvYqxd896GWDh4I0lig55yvmAbp0QNbyEbGETagZk+tPcxWP+M8HCb2Q8qAFSLS6Y13vm/HWAU7A==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr7170909wrw.244.1551973415251;
        Thu, 07 Mar 2019 07:43:35 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id h9sm10081463wrv.11.2019.03.07.07.43.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:43:34 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/4] Various minor modifications and fixes toward KS 1.0
Date:   Thu,  7 Mar 2019 17:43:12 +0200
Message-Id: <20190307154316.19194-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Please ignor the prevoius version of this patch set.
In particular patch [2/4] which has a sintax error.

I am sorry for the SPAM!
Yordan

Yordan Karadzhov (4):
  kernel-shark: Specify the OpenGL interface used by KernelShark
  kernel-shark: Fix a bug in ksmodel_zoom
  kernel-shark: Fix Doxygen warning from sched_events
  kernel-shark: Fix a bug in KsPluginManager

 kernel-shark/CMakeLists.txt             | 1 +
 kernel-shark/src/KsUtils.cpp            | 4 ++--
 kernel-shark/src/libkshark-model.c      | 4 ++--
 kernel-shark/src/plugins/sched_events.c | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.19.1

