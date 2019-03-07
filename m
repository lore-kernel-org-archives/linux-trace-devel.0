Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EF7C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF45320449
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfCGPFf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:05:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50630 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfCGPFf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:05:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id x7so9609143wmj.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FpcuDzWeDN/RpG7MPUx2El31rVvblSZuf5mYuykoFkk=;
        b=NKevhywh2S4OJiywTD4uUrUjm/eQgUUU7s64YtPskf1cWN5oFMq7uf3FgY/kpU5KdH
         OkXvDtyKdXq0xkX96sVFYU913unnOKK1cBJiZGsBfjpNU1Y8dkStSOlznEMpnIuvVHjI
         1nuA6z5cMjZn/6egljJUtVudeamiQPoC1kbdyLVV6o4hHsmqNZBxURuw8tp+DkeHJRVV
         j5WBsKMaBUxUSxNAFG7zS1u+8+wBEzfU/v8dE+lGCSQL+0sd5TcvwtfJfTdqM9nl7VnX
         HREbFqQ4oted/8b26WO/+ypX4oqTo3ZYh8TOgmmD26amKZAWsKW3nELwAdzOOHOY37jE
         RB2w==
X-Gm-Message-State: APjAAAXjD0dJFo/5h5w/sUa4JArwosqoSTNt9qYrt8SePWCYgQBuZ8ho
        QawvPjirNGm38G4i/PIQn7Y=
X-Google-Smtp-Source: APXvYqxD+1wuaxTLEpvSDCRbbIa6EhxpAigPH7zA13Z923Fil4nkrta8pQ2lDgNcTsnP5Xe5CHi9bA==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr6305492wmj.136.1551971133596;
        Thu, 07 Mar 2019 07:05:33 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d15sm10281274wrw.36.2019.03.07.07.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:05:33 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/4] Various minor modifications and fixes toward KS 1.0
Date:   Thu,  7 Mar 2019 17:05:07 +0200
Message-Id: <20190307150511.17246-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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

