Return-Path: <SRS0=eYsA=6L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD178C54FCB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CF4206B6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 15:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2cipviU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgD0PmX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbgD0PmX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 11:42:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF79EC0610D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:22 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so18043342ljg.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 08:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hrnnB6MN0NTDjJnvUCSUU9EAtiOKZnt8mbbgqwsDoYQ=;
        b=V2cipviU4cyqxz3WP1TK6r6wZ3R10PBJIwym8DHgbpohIbsQ9RLg0nogtAqVVteu6a
         3VhGU1Cflx7getZ1/hvsFuqQB7pb62kZCsNqN9dQe2RVGmZwCTF3cFswzx4vDw7GYQcM
         pHgcvASZYdP1cXcyZ+QLgoJyMWc0SEb2risbfMAS0+vOEoS1js66ojs63rcRBwe7jv13
         iv2//VcF71Dt/xrDer+9NnjkKGZW4zW3qUXttA9FS/jCLt0KrzgjB/01q2KDZNq2cqsk
         M648CAdZLPI5h9jztnju+kpYKmWehaAp8epdX75mVwaj7xyeWL3OfYLTf2PuyXCk2qiU
         bs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hrnnB6MN0NTDjJnvUCSUU9EAtiOKZnt8mbbgqwsDoYQ=;
        b=q8K+8+A5ctDd7GpQD+eeDqCo0HAIOt8c8p1Xe9uHCW4AflAhWgHeROMJ/TlwgWiBeG
         BKlk9yRjXWF9Bmbd+C4XtwsZSfHOzkknjDt1impbdRRCjgP1tFHZs0pnOp/PqUBEWaeo
         J3pagS/Z4LLqvEnUhGVED2EOp7ur3JRZxupvVgltC+TzkK0RicEvRrrHYO3laxttki3f
         ohB0YryCNQVP4R4RQ86t302fzuv/m/2gXCL3Ncz0ct+V9FcCETbHl1gLFgtM6Lhhbi0c
         1bzAz61HFKEWF8hRfma8WmJRvYTzcqoMoR9wnSdlfS8p0oAI0VziTmIszqF90p1JcugQ
         htUg==
X-Gm-Message-State: AGi0PuYN64TLBdt0S34vTdF/1XESm9uRCdrKkNWrF2pj/OOTsbFXtCpw
        SEbg7loJ5Qz6TYqueW7bhig=
X-Google-Smtp-Source: APiQypLFdiwhztwneomR35LhTeq0GkXKfT0O55wn3UoXfBWTKw3AIjjtwhBIO6wEf5r7fiVdHFlSoA==
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr13613780ljp.209.1588002141060;
        Mon, 27 Apr 2020 08:42:21 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id s8sm11515524lfd.61.2020.04.27.08.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:42:20 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, julia.lawall@inria.fr,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: Set a maximum number of plots to be shown by default
Date:   Mon, 27 Apr 2020 18:41:52 +0300
Message-Id: <20200427154152.20592-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427154152.20592-1-y.karadz@gmail.com>
References: <20200427154152.20592-1-y.karadz@gmail.com>
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

