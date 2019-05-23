Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C82C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D17E20856
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfEWPKF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:10:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43362 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730672AbfEWPKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:10:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id t7so6383870wrr.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gi7GVk1HqwO6+Be3ftO4ZXNXJHlwD24wE0aCW1RAME4=;
        b=Bk/QCTNwVm3aYf5CStGWg/7MWwGdRjjgCYALvvD+SSSG1iNhmVlhJjPhc+eQBlzMiy
         Wi8US0GtdES2dkN3RkYVw7ZYmlE+bmZ60Drfq6Hidfa2JUGwcXfCCJ8mLq/cGoOfHlAf
         QeMXcSdvPgIbim11L+1zK67jCgq7qf8uoh6XyKVvm4c2dAncKWCdop2GKMw0cSksnFvL
         bs5K9c9Jc0UjhBNqpV7GWGMoTcVvdgwN2k+rUmt1/nXDkJr5pnjGQLwx+QAik2J4lx15
         cfXHNQ2s/GppD4dNvdmMu0Bap262+fexT9Obj3kVV7YLKt+7/flsQ0Wn6MSRd9SKVbrZ
         USfA==
X-Gm-Message-State: APjAAAWF7q2BwuhKFSPF2oKCagkgd87yH4jqtzSCoFAZzIORB2Wg2YZX
        qP6HSIQ5wc+YKwXBhzWZ+nM=
X-Google-Smtp-Source: APXvYqwygODwgAu1ZA1e7SNBpuFFVWpZUXWCXfX37H34G0HURO0LM76en5y8YTaMU3BjYhR4kr/ixw==
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr59544533wru.212.1558624203730;
        Thu, 23 May 2019 08:10:03 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k63sm10721996wmf.35.2019.05.23.08.10.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:10:03 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/3] kernel-shark: Add Doxygen documentation for KsGLWidget::update()
Date:   Thu, 23 May 2019 18:09:44 +0300
Message-Id: <20190523150946.30769-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523150946.30769-1-ykaradzhov@vmware.com>
References: <20190523150946.30769-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

No functional changes in this patch.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.hpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 82831cf..e141b0a 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -41,6 +41,7 @@ public:
 
 	void reset();
 
+	/** Reprocess all graphs. */
 	void update() {resizeGL(width(), height());}
 
 	void mousePressEvent(QMouseEvent *event);
-- 
2.20.1

