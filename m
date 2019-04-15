Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A12C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 16:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E5B21900
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 16:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfDOQrr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 12:47:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39960 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfDOQrr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 12:47:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id z24so21483830wmi.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 09:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+htPNxTQ1v8eRuCNBbrGyzL1us6TG53t6WrMCRxtQGw=;
        b=LpeSFJ5QoyUSJbOUN+MuR/0EQHgPsbMJc8FFIW0ozcEkfty6K0WNm1ycNnZybXojnK
         gnet162kATAqmi5PfXGkLl/gxqQz/dKGeEGfJmmniM4Z4nrU5KYGfa6/RUcWdIL4yLFm
         LGtrGwW85lMUkhDzrI7zykDb2fmRKPrrR1F7lC6y+RtxABYYT/TotPqgHvUL9lsrV1RI
         m9OhvAIVXNKFGEp4yFwlXMyiOCdw73CaQbfpvKRMwt6p3O2RArDHk8F67G4KfVoEbZ7B
         PIoeaL3jsL3E3JtrtY4CL3nIMXBg1WGxdZ3n+DDNPebjTo2i9UjIyTUMdblS3BGmdS9c
         HuAg==
X-Gm-Message-State: APjAAAXM1/Pv2IncwPRFHCl9nXGUyQ/YfVfUtBRUsKZEz+zWXFpa9Ai4
        cJ0zX5PMhFCfSsWcyvmqqA==
X-Google-Smtp-Source: APXvYqyNFYMRGmzL2s7wLBZa4OrsGQOC/YdJFfhpdnYmQTAIXn/h+8jttYzjzLKWB3S0tlEwDdoajA==
X-Received: by 2002:a1c:d106:: with SMTP id i6mr21884642wmg.134.1555346865879;
        Mon, 15 Apr 2019 09:47:45 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id r30sm165941104wrr.46.2019.04.15.09.47.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 09:47:44 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v2 0/2] Optimize pid filters and add --no-filter option
Date:   Mon, 15 Apr 2019 19:47:37 +0300
Message-Id: <20190415164739.17223-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset optimizes how pid filters are expressed and makes it less likely
that we overflow ftrace filters' size limit of one page.

Changes since v1:

Add missing tags
Fix append_filter_pid_range() callers to pass valid range as [min,max]

Slavomir Kaslev (2):
  trace-cmd: Optimize how pid filters are expressed
  trace-cmd: Add --no-filter option to not filter recording processes

 tracecmd/trace-record.c | 129 +++++++++++++++++++++++++++-------------
 tracecmd/trace-usage.c  |   1 +
 2 files changed, 90 insertions(+), 40 deletions(-)

-- 
2.19.1

