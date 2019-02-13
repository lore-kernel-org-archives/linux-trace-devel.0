Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17631C282CE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5BA021904
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404338AbfBMQM7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:12:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43774 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbfBMQM7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:12:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id r2so3127790wrv.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iAZcpqX2XPsyR0EA0E+q40Ns0bCdALJhd58oyra0IoE=;
        b=U6M0XlOI6JHF8UrM4wGDWHif0HANmOt9jtJmMKZNgxaUdBs9bSmdGNYpVosOzm8IDA
         RE48Vd1j7R04mti9SpyMAL0jgGtAdNEKnMihLaEXIKNHj2Io3kcZjsM0Wd0ekrx0OBnt
         OFkNz2R6PqEaKglW5QL/53ASBNntYoSNiBp4osJWWVgWLjQXB/IoaomICsrup+Z1SJA3
         X2HNKe8UezRDlt0dHn5vqLKVQrT4DMGF//4ZectFgKE2oqy3fj3VGrKFA5SDns6ee20t
         jY2mqNNod9c/saC+ZfMj1V3G04/FMaJTDBIQUDL6P7laE1zSSaJxdaqzS//wwTwxdl6N
         JsdA==
X-Gm-Message-State: AHQUAubt6zfLfpOdajnIaZu+Xo1V5Sg1qp6hHACsNMvwygnLbJtLJpPp
        5PhV9DZt6boA9WxvSeDskZU=
X-Google-Smtp-Source: AHgI3IZTZxPhzU9wyYLH8vehCMX8QQYaG42jbVa4tnWFH6Np0PVqavCCUxRwzjM/CnLvs1pq8744+A==
X-Received: by 2002:a5d:5042:: with SMTP id h2mr1049842wrt.12.1550074377413;
        Wed, 13 Feb 2019 08:12:57 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:56 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/8] kernel-shark: Don't use Data collection when checking if the bin is empty
Date:   Wed, 13 Feb 2019 18:12:12 +0200
Message-Id: <20190213161216.14438-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When plotting a task graph and no data from the Task is found in the bin,
we check the CPU, previously used by the task, searching for data from
another task running on the same CPU. However this search will always
fail if we use the Data collection of the plotted task.

Fixes: ba206aaa45 ("kernel-shark-qt: Add C++ API for drawing of Graphs")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsPlotTools.cpp | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index f97c6e4..d07f414 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -929,13 +929,15 @@ void Graph::fillTaskGraph(int pid)
 		} else {
 			/*
 			 * No data from the Task in this bin. Check the CPU,
-			 * previously used by the task.
+			 * previously used by the task. We are looking for
+			 * data from another task running on the same CPU,
+			 * hence we cannot use the collection of this task.
 			 */
 			int cpuPid = ksmodel_get_pid_back(_histoPtr,
 							  bin,
 							  lastCpu,
 							  false,
-							  _collectionPtr,
+							  nullptr, // No collection
 							  nullptr);
 
 			if (cpuPid != KS_EMPTY_BIN) {
-- 
2.17.1

