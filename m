Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69E8C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F08208E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpFfqeV0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgIPGum (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgIPGul (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 02:50:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB668C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so1708120wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1O4oy929EsjdKBRqEYo9j4n/1OGlYV9VezHHXlxYp4o=;
        b=XpFfqeV08Xs9JIqL7/toysfDcPKKYUbwG+nvI6XkvrNMjSWi+ZEkAbq5PhtHuc9kAi
         qN6C/elU1EY5V4ivgL8+KK1KpLAXxrjiLSkiv9j7+gyVmHnprTAJDSA3Yp07DIl9tDlF
         GxNoP90WNg78urMrfTICNCB11k5p3PAHapFdurTYstCG5rZWJdP2CWQlEXwA8sJMhNbO
         32bRplEU6uOnEWqnwbiAKZqjFSf7k6sINJ50BusH/4WnwuYlhiUz0mnCYtZxHf1Cs8he
         17yiXfcnBSADZYi4+xknWpFRJxsg/eviYlUhQRXMRfLxOM5Ut5iY4bhvxbmZHXxUO9iH
         HsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1O4oy929EsjdKBRqEYo9j4n/1OGlYV9VezHHXlxYp4o=;
        b=oIh9L4r9gBThqwg8LQElMG2g80LZwdhiOvrLzRhSniMeZ5Nr8oGy/LlQjTNY7v9apW
         bO9t05QtwzTxLwtPvCtS/FSZma2BDE4xwS2ID6Kc1ravtDe1L7R56jcuwAj+AjMUVKvj
         RpQL7OBzo/+yaNZHcopxoiBIYrSRX7w4+W8a8x1kUD/jM9a1VXbQqX8Zn3Ih2pM2XVwF
         cOQbOaN89K0RdvO9Ry5hgd2R9yNik1Ep6+X/C7F5kqPj7mZFCx5abkIn9cDXPuAbcL8n
         CbvBrsuYG5B2BTX9nEbOKI5IDpK415qGkcW3O3smf2YloE74pjzRC3iOsl5T/U7GecqD
         qWXw==
X-Gm-Message-State: AOAM532jVSoo8zdJmFHYyHa3oPX7itsRZprmiHBlbnXrzMDRnry/TwqO
        gD6eJ/ny6AnjWhAlmWuvSB9za5w2q30=
X-Google-Smtp-Source: ABdhPJwnn/sAQjhdpa4LoyXrgTZNXR/7BtMEBZy8skU3csqr66ys9QqrbmdxP2lCl8cEgLlR7iXhlg==
X-Received: by 2002:a1c:9885:: with SMTP id a127mr3012464wme.8.1600239039342;
        Tue, 15 Sep 2020 23:50:39 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id u126sm4229028wmu.9.2020.09.15.23.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 23:50:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Have correct screen geometry on high-resolution screens
Date:   Wed, 16 Sep 2020 09:50:05 +0300
Message-Id: <20200916065007.9755-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916065007.9755-1-y.karadz@gmail.com>
References: <20200916065007.9755-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A scale factor (also called "Device Pixel Ratio") is often applied in
the display settings when running on laptops having high-resolution
screens. Take this scale factor into consideration when calculating
the screen size.

Note that the size of some widget is set to be a fractions of the total
size of the screen.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsUtils.hpp | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 2772b84..a07af1a 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -25,10 +25,18 @@
 #include "KsPlotTools.hpp"
 
 /** Macro providing the height of the screen in pixels. */
-#define SCREEN_HEIGHT  QGuiApplication::screens()[0]->geometry().height()
+#define SCREEN_HEIGHT \
+	( \
+	QGuiApplication::screens()[0]->geometry().height() / \
+	QApplication::desktop()->devicePixelRatio() \
+	)
 
 /** Macro providing the width of the screen in pixels. */
-#define SCREEN_WIDTH   QGuiApplication::screens()[0]->geometry().width()
+#define SCREEN_WIDTH \
+	( \
+	QGuiApplication::screens()[0]->geometry().width() / \
+	QApplication::desktop()->devicePixelRatio() \
+	)
 
 //! @cond Doxygen_Suppress
 
-- 
2.26.2

