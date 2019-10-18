Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAE6CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B478521897
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:47:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qBEGENIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407679AbfJRHrq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:47:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36037 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfJRHrq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 03:47:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so5081831wmc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2019 00:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7X2qsJ74vhvdXE1votE/9VV4vTFGcJWaoW5AMUPUXwk=;
        b=qBEGENIKjeqWlhaZ/EgvCx+dnfNpqlODiNXpv6Y0KzjsS8cwXfB5SBRwS0LXYv4ONa
         9Jg178j1P1/myr19D1q3oQE9BrZx9OMV4pocERZAwecIC7IQODkMf4IsC5p/jmA7HKBf
         7XHQFUhEbLLZ4h65AFgyX9bTrh8KcI7i9qXkbk5xyDYoMMTfZq1ilbPr5Jv9oaBfBPRb
         5SJvqXHidj9FlqtpDWCXChM0LTsYYLKPFDeH+vazmGS7jbDqZTujAkndTAtn5oKEAchi
         OYOfJ6m/+1GkReH1ZSNXgQM6gkjRSFFOHbLH2uHbLpDg1x0lUQnO+vD45y2oI1w6AqGR
         1Pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7X2qsJ74vhvdXE1votE/9VV4vTFGcJWaoW5AMUPUXwk=;
        b=n2S/+ZxqSU+SdhyRZrghMduGetmtcjpGt0zNPbrNouCsgRhrQ25J/34rgKono8OX+6
         NmPMr3xp/OHdncdyy933wspShZIhLa63c7LHngQzNosvebkaosNJxorms3OKyaUOrr8x
         ZlzaSfyMzpKPgwk3MJ4/dRGt0T5FSqrFP8o+LbygWdG9nZzOyJw1yWSre9dms6g4IWwb
         7mQ5IrNWWC0wOuE92uACO+xL/w7Kf0QhcEUJ4rEsYIQeqL3ou0we+MgoPHBQbfZHcnrI
         LPyAiyu+pbZK3J0TvoVpi4hnHXPCMS+ZJqPgee9ObHlh4IfFd3MXPa5Rvn6Ddp0T0PXf
         l/JQ==
X-Gm-Message-State: APjAAAWsN5INwMgkVXT6nrX2hCimk+JzmQuzV3IAmvu4E5/PDIRoVHqc
        Is3WGX43qa8UVsxYH0NSV3g=
X-Google-Smtp-Source: APXvYqxzstojMcKbSjt/8JKzi+tESkkG583YpZX8Ag8wfpmKbOYoU/NhGGZkWfAVhUCqRbBZ1WrHLg==
X-Received: by 2002:a05:600c:201:: with SMTP id 1mr3164157wmi.68.1571384863257;
        Fri, 18 Oct 2019 00:47:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm7740832wrg.8.2019.10.18.00.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 00:47:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Fix simple typo in the "File" menu.
Date:   Fri, 18 Oct 2019 10:47:20 +0300
Message-Id: <20191018074722.6976-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reported-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index a583f5f..3402764 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -45,7 +45,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _openAction("Open", this),
   _restoreSessionAction("Restore Last Session", this),
   _importSessionAction("Import Session", this),
-  _exportSessionAction("Export Sassion", this),
+  _exportSessionAction("Export Session", this),
   _quitAction("Quit", this),
   _importFilterAction("Import Filter", this),
   _exportFilterAction("Export Filter", this),
-- 
2.20.1

