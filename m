Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E299C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9C020811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfCNPKo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43484 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id l11so4166701pgq.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MerWo/Szyw4Ske9918mV64pxeqlf7o8QeUj4VVt6/pA=;
        b=oamIJjxZA3NAp+weceJM+k4VlYOJ1UPeFuMrChx8UOR3UcCENnF8R0foefy7t/ZsQu
         sCQtiKgBcYspqx3oHD3AAvVLgrFE2QbVOJoHfJj6fmFCymfMaJpTC3SmzT//1e83Oxlj
         yE/iIZ2EpKR3J0qljB1WFZQRBrxy/ZGUGapqednNxUv/QuBjwDHLm0rGHiWAoMxyoV4a
         mVDqrNhYE1wkb9ILStE1h++C0GZACZokIQw/5BsdroegSCKh/CELHorokBKFBte8puhh
         SRV8hyjI6IlXKSEOnt68ZAtYflJ84/hODtY94CuWU3rc2cXcNLIyplsbAUgUE8mMWoKI
         suEQ==
X-Gm-Message-State: APjAAAXHmaRi+Ze8SEz1PAYTUBV1m29fYYs1oLNkXdLR5RG03csZAjSW
        uY/fpYPQmCTSFK3ffJhu4laXFjYF
X-Google-Smtp-Source: APXvYqyI/onD/OnfS+GuucauzCZUw5bM9ExRIEhkQpMspte2hkcS++z2yvBryJPIH7s7eGO0AwSH4Q==
X-Received: by 2002:a65:6259:: with SMTP id q25mr45914596pgv.235.1552576243337;
        Thu, 14 Mar 2019 08:10:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:42 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/12] kernel-shark: Add destructor for KsGLWidget
Date:   Thu, 14 Mar 2019 17:10:07 +0200
Message-Id: <20190314151012.905-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Not sure how I missed to define this destructor before. The good
thing is that the GUI has only one GL widget, and this widget stays
alive for the whole duration of the program.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.cpp | 6 ++++++
 kernel-shark/src/KsGLWidget.hpp | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index 7a050c2..a2fcb8a 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -40,6 +40,12 @@ KsGLWidget::KsGLWidget(QWidget *parent)
 	connect(&_model, SIGNAL(modelReset()), this, SLOT(update()));
 }
 
+KsGLWidget::~KsGLWidget()
+{
+	for (auto &g: _graphs)
+		delete g;
+}
+
 /** Reimplemented function used to set up all required OpenGL resources. */
 void KsGLWidget::initializeGL()
 {
diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 95f307b..3bcecf9 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -31,6 +31,8 @@ class KsGLWidget : public QOpenGLWidget
 public:
 	explicit KsGLWidget(QWidget *parent = NULL);
 
+	~KsGLWidget();
+
 	void initializeGL() override;
 
 	void resizeGL(int w, int h) override;
-- 
2.19.1

