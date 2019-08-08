Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A94BC433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 08:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681DB21880
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 08:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsWJtsla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfHHIWS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:22:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34426 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731281AbfHHIWR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 04:22:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so3122124wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Aug 2019 01:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qgVDRwsdSdFn5RNR28lGs7lZNJdp58igmIW78MHBmhM=;
        b=SsWJtslaGUcoIdWrbmFt+jlXGb9exP/Pg42WmDwY/yvndOFdwM274acpoLW3kKD8JG
         LChNOEALH4U6+MRJNGCmKBky/WrebHZyTDgImQhZjzGJi4jFjCFA/alzlXKjdlpmVxPQ
         nL3p5rWH1RAXYklfdH2oDUthC1byRhyrbYcvwl71232lztMMamRjIyKyGVE3xUNX8T4o
         T3e1RtT5B456hm7lYvWxWAWTk4GT/CQM11o33hgsuc1QZSz1aDAVdL279ar+1vYqU7xh
         t5+fsB3JSNmy/UJfkuNZ6Slxu/ADRKm6wLO3OSfTf22CrA0MEXErY+9czkc6RRtYnI0T
         v9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qgVDRwsdSdFn5RNR28lGs7lZNJdp58igmIW78MHBmhM=;
        b=LR1AoK0WzAJsXAAfk5WAz3toL576nCjzwv+16iLY90i4Cqbed8ignsSZKTdulLCskg
         8KTZinfdVswPQZDHqPEwNg00JuELxhwEM32iQsVtwuCfBVLfHPEP52SQdEqkqcTXPMyF
         GU/Ny2fcxCR7KYz9/J5Nzmb7naXwJi5h6oM44yzz9hx+eEzUO/dOC/dx/gJ1PnpbPY84
         Bg2JxZ5M+9DlulPlhGA7Ps/Tz1pZGfnUZp5ce20AOXlZaRSdrUZ0+5jg5dUTaywUPWUd
         SaTwK1vF9GsP76asBhH76Y8xMlLbr9X2oIXYQfnV2Jn7g9K7ErKzQVKdvg0i/VVF+znd
         7lFw==
X-Gm-Message-State: APjAAAUQ8VAzJmxc2LWbNMynDyxyF1/SeAmXbAG8BQwDtTExhkOfw4Zt
        qWuE+9+1apIRj6yGTEKqp9c=
X-Google-Smtp-Source: APXvYqwdEip+/sjyONHyrN0aRjUyGlq4B1WRV9/VYw0Oek4/4Y1ohT71FFFxfIsM+bSPnJzpig5YTg==
X-Received: by 2002:a1c:1d08:: with SMTP id d8mr2808449wmd.22.1565252535893;
        Thu, 08 Aug 2019 01:22:15 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o17sm2770103wrx.60.2019.08.08.01.22.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 01:22:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Jake Edge <jake@edge2.net>
Subject: [PATCH] kernel-shark-qt: Fix the broken Color scheme slider
Date:   Thu,  8 Aug 2019 11:22:01 +0300
Message-Id: <20190808082201.10560-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A previous commit removed the unnecessary calls of loadColors() in
KsGLWidget::paintGL(), however this has the side effect of making
the Color scheme slider nonfunctional. We have to explicitly reload
the color tables of the GL widget every time when the slider is moved.

The bug was reported by Jake Edge in his article about KernelShark on
LWN.net. Thanks Jake!

Reported-by: Jake Edge <jake@edge2.net>
Fixing: 3a50d107e9 ("kernel-shark: Avoid the unnecessary calls of KsGLWidget::loadColors()")
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 6f86b91..6439265 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -904,6 +904,7 @@ void KsMainWindow::_record()
 void KsMainWindow::_setColorPhase(int f)
 {
 	KsPlot::Color::setRainbowFrequency(f / 100.);
+	_graph.glPtr()->loadColors();
 	_graph.glPtr()->model()->update();
 }
 
-- 
2.20.1

