Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BC7C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83602214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oy92QZ2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEHPX2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEHPX2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 11:23:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78E5C061A0C
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 08:23:27 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id j3so2073864ljg.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 08:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hrnnB6MN0NTDjJnvUCSUU9EAtiOKZnt8mbbgqwsDoYQ=;
        b=Oy92QZ2hdLsJ8E1Oas8ZAg5GT90NzJ08XhQqS47oXoambqFRu2fk8EhUa5nu5POrp5
         40RJXUWuAwAkQ6u21XKAsWTvOrwh1D/Zo0trvLnBLQs1cMHeLXjN66vzm7QKyKZ8Z+B5
         DrtX39vz1cvCvN+Exfwo1p3j45uGoI+eFWxKYdegE675Deuqq7q/nFIpp2RR3EpJNzOs
         F0mHSWqS0qELAIrjRTkgs8PoYZ/XxiB+tqV6JLHyRBEBjJAZxUZhRm168J+N1DtvGnU4
         tEP28BQzKyGVq42C4BkonmyVJrJCU62R8xcOLKyqL/dCcvP7CvVRo1wu4iN8s59kMARF
         w/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hrnnB6MN0NTDjJnvUCSUU9EAtiOKZnt8mbbgqwsDoYQ=;
        b=myqqqey863gNmBaJQdFoFlXPKHTnj1bCn4fw4lygmubQFm1u27AY/knr1vRXZoz1lH
         LW7vbQ14a2Egp5iXUBOnu7+lZMpG3U7MCAC/ZRTaNbK5EVcqa9zcXSv/F/dGLyXVe9V9
         Dkjnr31l3bypEvUEE7KrZx0QlJqDE3EokCqT+LyBsyJaGcO3Dl/VAkHsCicTSeaUaeD0
         cEE7by8pcT4P3ywopYHUf9mLzP4GnoRvq3XyekSZTkkkjStWxGyZANydd8iDyTytY0KU
         ihurEYoaYklQa83BbjMSRdeXb60Kwe2/DspMndmmZCVcrf+YlNX6NIQSFNfWrJaFjN9O
         vnNQ==
X-Gm-Message-State: AOAM531Hrcn9579cu0IbVR8bHG0GV0Nc82ATD4dcH9dr6vAJcqhCDcs1
        iS0zpNjVEuesbjCuxDDxL84=
X-Google-Smtp-Source: ABdhPJynB+vB97LIQeV92Mj4EOiIZStr0U2RPFY9bm5EIiH+/qHcpKrtl4CUq0roMjzi0dYVwTh0Rw==
X-Received: by 2002:a2e:700e:: with SMTP id l14mr2105045ljc.135.1588951406126;
        Fri, 08 May 2020 08:23:26 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id q20sm1466497lfm.35.2020.05.08.08.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:23:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH v3 3/3] kernel-shark: Set a maximum number of plots to be shown by default
Date:   Fri,  8 May 2020 18:23:02 +0300
Message-Id: <20200508152302.27843-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508152302.27843-1-y.karadz@gmail.com>
References: <20200508152302.27843-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Set a maximum number of CPU plots to be shown by default. No more than
16 CPU plots will be shown if no command line options, per-selecting
the plots, are provided. This will be useful when opening trace file
containing hundreds of CPU cores.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
---
 kernel-shark/src/KsGLWidget.cpp | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index e930006..78ded33 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -340,6 +340,11 @@ void KsGLWidget::keyReleaseEvent(QKeyEvent *event)
 	return;
 }
 
+/**
+ * The maximum number of CPU plots to be shown by default when the GUI starts.
+ */
+#define KS_MAX_START_PLOTS 16
+
 /**
  * @brief Load and show trace data.
  *
@@ -358,7 +363,6 @@ void KsGLWidget::loadData(KsDataStore *data)
 	 * One bin will correspond to one pixel.
 	 */
 	nBins = width() - _hMargin * 2;
-	nCPUs = tep_get_cpus(_data->tep());
 
 	_model.reset();
 
@@ -368,8 +372,13 @@ void KsGLWidget::loadData(KsDataStore *data)
 	ksmodel_set_bining(_model.histo(), nBins, tMin, tMax);
 	_model.fill(_data->rows(), _data->size());
 
-	/* Make a default CPU list. All CPUs will be plotted. */
+	/* Make a default CPU list. All CPUs (or the first N_max) will be plotted. */
 	_cpuList = {};
+
+	nCPUs = tep_get_cpus(_data->tep());
+	if (nCPUs > KS_MAX_START_PLOTS)
+		nCPUs = KS_MAX_START_PLOTS;
+
 	for (int i = 0; i < nCPUs; ++i)
 		_cpuList.append(i);
 
-- 
2.20.1

