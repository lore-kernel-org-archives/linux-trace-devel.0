Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84485C282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6264C20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404329AbfBMQM6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:12:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35063 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbfBMQM5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:12:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so3044555wmt.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WcE7P/MHFpIoLQiFeu/x9vQG07Pw8oDGNgsupsIbd0I=;
        b=jfB/YipwpKlwC+sPYxwY1pneV5dWrsakTQfMEy3bEDwZlTihUbd/QhzHS2VdSIhRN+
         7lfG6mhHV++wjbFwHuARNauaBThcJO5tUpsyJ1qXPyCsuTmyJDBmYyddUtjGnADwzstQ
         JhaVahsxbCYTLhXrBS7G+Zu69xUgwdV9XUlrY3xLktnkLcweFD2JefWA5sQ0o+DlTGFV
         oPUkTWCqTyFKQxJAnahMP4Bl+q1x5W9BhrhDNIRoaS5veBMrWIUw6y32ff8JL/n7T9Zk
         tYBQXLitzfQPs/HZtH6khC9Fzfh5RqwaIbhpIs6Eh07+gjSz/Slc96duNGq7NANkF0b3
         0ywQ==
X-Gm-Message-State: AHQUAuaDlLJ8g2SQLIEaUKMOAarwqq4sOOf6tGg1rGnks7mFFQDVXUzI
        mfknuL0UIeAbs7FEUg15YCk=
X-Google-Smtp-Source: AHgI3Iaa9bjL+3NPRJAZrxJItWBKXDlUAz1szKiP7JXup9E6WJDhGEJiODHwmzdQ+JkhwtFV4OEzRA==
X-Received: by 2002:a1c:a58c:: with SMTP id o134mr866669wme.79.1550074375681;
        Wed, 13 Feb 2019 08:12:55 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:55 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/8] kernel-shark: Check bin 0 for sched_switch event when plotting task graphs
Date:   Wed, 13 Feb 2019 18:12:11 +0200
Message-Id: <20190213161216.14438-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Handle the case when task is active in the Lower Overflow bin and the
sched_switch event that close the task graph happens to be in bin 0.

Fixes: ba206aaa45 ("kernel-shark-qt: Add C++ API for drawing of Graphs")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsPlotTools.cpp | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index 816fa56..f97c6e4 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -1020,16 +1020,26 @@ void Graph::fillTaskGraph(int pid)
 		if (cpuFront >= 0) {
 			/*
 			 * The Lower Overflow Bin contains data from this Task.
-			 * Now look again in the Lower Overflow Bin and find
-			 * the Pid of the last active task on the same CPU.
+			 * Now look again in the Lower Overflow Bin and Bim 0
+			 * and find the Pid of the last active task on the same
+			 * CPU.
 			 */
-			int pidCpu = ksmodel_get_pid_back(_histoPtr,
-							  LOWER_OVERFLOW_BIN,
-							  cpuFront,
-							  false,
-							  _collectionPtr,
-							  nullptr);
-			if (pidCpu == pid) {
+			int pidCpu0, pidCpuLOB;
+
+			pidCpu0 = ksmodel_get_pid_back(_histoPtr,
+						       0,
+						       cpuFront,
+						       false,
+						       _collectionPtr,
+						       nullptr);
+
+			pidCpuLOB = ksmodel_get_pid_back(_histoPtr,
+							 LOWER_OVERFLOW_BIN,
+							 cpuFront,
+							 false,
+							 _collectionPtr,
+							 nullptr);
+			if (pidCpu0 < 0 && pidCpuLOB == pid) {
 				/*
 				 * The Task is the last one running on this
 				 * CPU. Set the Pid of the bin. In this case
-- 
2.17.1

