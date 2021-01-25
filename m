Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA5AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C7F22C9E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Jan 2021 14:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbhAYOIW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Jan 2021 09:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbhAYOGs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 09:06:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C999C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jan 2021 06:06:05 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a14so4160970edu.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jan 2021 06:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5yIZ2MIE0tXYpXI7qN7cgDXO6VyXmnhZg7hImuYeS0o=;
        b=kL1XGxs4OYOlxlfsWxfLeFeMDQoJ8QR4BB9k+sh8n0B2qHeuI+94p3ECtQWb7zSYxH
         dCoMY5nDz29cBFqDLs6w8uiBRr0x6GQO1PUu5UC109E+sZ+L93qRpKLV/qAffXBnpVWb
         oNRI1wPJOV2cZ8X4xBPOgZGiyPvqcOX8o9oR+U8AkVEksDKdNgOcXNAlwyHU2u145gVR
         i24edciXBx792tM9R9zwywDQDS41SwGsGzCl5cIVe+21a5eY27PcGapMNUCRxOcr9n7o
         B5rc9j2qrfXuxpNwf6YNGnsu7785VgQmNi+HKKknqtxKmNUsqN1wDRe87rF84J2nuH9H
         FZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5yIZ2MIE0tXYpXI7qN7cgDXO6VyXmnhZg7hImuYeS0o=;
        b=Xjswl60dDVaFUuSnGlG9I4ZIp1LXnZ0QlD3TEYtvUGuF95GtH78IWgrXNVI3C26+qD
         byPM21pCBaM5zfIkzWCMFhbb7sKQBkpQXk3EndY089z4GkcJ1pYtBGHq9+3/P8UhJxLi
         wH/1j8mqnbmUDWnMl9Oj3YUWB4ovCkpuJfmgKiJCMovNEPQF4j5MHsGBIVTtEd8OZHq7
         32nbjzv9Fdv+JC2DiDDvpP5QKFFaeD9kCL7xUS/1KxsZdqvjn/UuLYXgy0PYxSnnYZlv
         h0aaDU8X2poQSnYgNfjxUp6VJ71SMAkqxVTDSNlnCtUA46y+tDW80k1LLRl4x780Pmo0
         nZIw==
X-Gm-Message-State: AOAM530KGe4WBXQUJoyvc9BALresVku5nriVCAMJvEgg7K5QjffUaZFc
        LQLK8tyn9pwBpT7zLCWXDJU=
X-Google-Smtp-Source: ABdhPJxEiAhdwKIz91wUYCwe/ziZ4b47nyTgJd8mtglNK5Kxhm1ImJguUNPWreb5h3mMy0WzlnhbdA==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr601296edb.202.1611583564123;
        Mon, 25 Jan 2021 06:06:04 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.252])
        by smtp.gmail.com with ESMTPSA id g10sm8333484ejp.37.2021.01.25.06.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 06:06:03 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        FeRD <ferdnyc@gmail.com>
Subject: [PATCH 1/1] kernel-shark: Use mouse wheel to scroll the graphs
Date:   Mon, 25 Jan 2021 16:05:39 +0200
Message-Id: <20210125140539.1029915-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125140539.1029915-1-y.karadz@gmail.com>
References: <20210125140539.1029915-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current zoom-in/zoom-out function of the mouse wheel will be
performed only when rolling the mouse wheel and simultaneously
pressing "Ctrl", while just rolling the wheel will move you up or
down in the scroll area of the graphs without zooming.

We want to introduce the change because zoom via Ctrl+ScrollWheel
is a binding familiar from the Web Browsers.

Suggested-by: FeRD (Frank Dana) <ferdnyc@gmail.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsGLWidget.cpp   | 3 ++-
 kernel-shark/src/KsTraceGraph.hpp | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index 78ded33..404f0d0 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -266,7 +266,8 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 {
 	int zoomFocus;
 
-	if (isEmpty())
+	if (QApplication::keyboardModifiers() != Qt::ControlModifier ||
+	    isEmpty())
 		return;
 
 	if (_mState->activeMarker()._isSet &&
diff --git a/kernel-shark/src/KsTraceGraph.hpp b/kernel-shark/src/KsTraceGraph.hpp
index 0eeef14..15ade42 100644
--- a/kernel-shark/src/KsTraceGraph.hpp
+++ b/kernel-shark/src/KsTraceGraph.hpp
@@ -28,7 +28,10 @@ public:
 	 * Reimplemented handler for mouse wheel events. All mouse wheel
 	 * events will be ignored.
 	 */
-	void wheelEvent(QWheelEvent *evt) {evt->ignore();}
+	void wheelEvent(QWheelEvent *evt) {
+		if (QApplication::keyboardModifiers() != Qt::ControlModifier)
+			QScrollArea::wheelEvent(evt);
+	}
 };
 
 /**
-- 
2.25.1

