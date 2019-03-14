Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F339C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B9E620811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfCNPKr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36554 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id n22so4047190pfa.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Txtt7FKO70HUFzakSy+vW/ZcFmSp1DjoFu8d/GD32Ug=;
        b=gosOTdz1QF9yaZBxlEZ/j3MmLlTtFkafl1wKcrHXyNt+WqaH3JNsd94eJmZf7mDlEP
         LwjWCvq+wHARxRUBwI+konMK99ofGLfnSb23kU5YZJzlY+NAE1NgfE89dvNJk5qrM44o
         YgZLOJrb/5RfhdKLJZ05MKJnf+QE2chobYihfDWWiuNBI9zqYrrXJwQd8I3fICslzW73
         BGcF/HnY6dyxnt4BBNYxkZIrPO7QSX05XJEfEb8QEzCrhEmY9d0llD3DABgT49JIEZ/o
         rz8BJK5cbqvJHZ9wkwQywelVzhCvOVUCYszRJcHW9qWvGoumSq9VXy5uxFHLlczVfcq9
         vWfw==
X-Gm-Message-State: APjAAAVtsI2jwH8llbuPmcnYu/i2P0pRgLbFPHAor9WQHSHlyScE+qfG
        D8IwXOVFQVN81TXj1qPZAd8nhm0H
X-Google-Smtp-Source: APXvYqwQVC4yGqERtGMgPAKUD6hJx5cfoKeqC2cgjlR3kEdIfKlt4bU3UajfbWS+0Wc2mglSjv0EoQ==
X-Received: by 2002:a63:5817:: with SMTP id m23mr13099648pgb.166.1552576247178;
        Thu, 14 Mar 2019 08:10:47 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:46 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/12] kernel-shark: Avoid the unnecessary calls of KsGLWidget::loadColors()
Date:   Thu, 14 Mar 2019 17:10:09 +0200
Message-Id: <20190314151012.905-10-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tables of colors used by the OpenGL widget have to be updated
only when we load a new trace data file.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.cpp | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index a2fcb8a..789514a 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -86,8 +86,6 @@ void KsGLWidget::paintGL()
 {
 	glClear(GL_COLOR_BUFFER_BIT);
 
-	loadColors();
-
 	/* Draw the time axis. */
 	if(_data)
 		_drawAxisX();
-- 
2.19.1

