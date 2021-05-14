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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DD3C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41EB86145B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhENMT4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhENMTx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:53 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907CCC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:40 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id di13so34474175edb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TTG39X9zxsef8MpXaTofsFoEUYLaTQ03yVrBJYfMqm4=;
        b=Gt3rul8FLp6GP6hsgpa4jFglKegqMCIsat1XhXDLjS+H7F5uupLHQ1pCKaGMFFSdB8
         AZGz9UyaGWgm2I5Q8W9fiT9YWuIWvtsU9jIO6H7qr2CLacG5U0wY+T/yIXY9bZljx0Qf
         +PJ3rp1PvkOIsUQ3QngcCAWm2e7QRDvTsLnRqubrG/i2Fz2/8lNf/1XOxPGdtSK+Vhzu
         9e/Tn0SgheyMne9ZNW4T7PlY6wxalmc7JleIv749RPqFlWfz8ndyomzZ5JqIj1w7CLOD
         wRkCLlBWwvXWz3oauh1Sv158oSF2qlfrtOoNXDltWJ86anw1EQwpIdDgr8isMqvOcunc
         w2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTG39X9zxsef8MpXaTofsFoEUYLaTQ03yVrBJYfMqm4=;
        b=W+Jbn8QiVqi5Wi14lS2KMb1cAQTAx1l1hwRddH+uHeeqEaBomXR8Ydhsq8VEqKYgCU
         8jaUsQbxdSVGYTr57LEw1Y+2L8AOpuKLVRHS8iJE+4r3b0Gi2uS7EzcfeCfYCQauwmkQ
         cDRCDHBHaV5VLM2IOI50v48fyzK+GDBacPY5+ECqMHX2wsrnnLjqo/OEMD6MgwnA3iNy
         cMuHPPjkgAy/Pix7dYXRpnALGwmcB8jrkLg/slnnyIe/Qca2bKNTDcBYdtsHxFkiFhv5
         CcZjRvLKSFDBdnE4p3O1qEMWU6Ez15am5NqE0dja1Rd3MwfVh3fwA0igaRK+gYOdLBX9
         Hxow==
X-Gm-Message-State: AOAM530++ADLSz3aNqiJivGMXNtRMEWwnQC+Iiv26DQnzHE+0+IKAzE4
        ioPU+SI8QhTe9KEN/ZGBTYV3UJhkKeI=
X-Google-Smtp-Source: ABdhPJz5Hke0mCSZ6FuC/R726as3QSk3tYkBBckIpZeWe1p5mBwSE/PpPZ8kZxziti8/khWKiacziQ==
X-Received: by 2002:a05:6402:30b0:: with SMTP id df16mr3091065edb.85.1620994719074;
        Fri, 14 May 2021 05:18:39 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/7] kernel-shark: Preserve open graphs when appending data
Date:   Fri, 14 May 2021 15:18:21 +0300
Message-Id: <20210514121826.161749-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the user has already made some selection of graphs to be displayed
by the GUI, those particular graphs are likely to be important for him,
so it is better to keep this configuration after the data file is
appended. The opposite can be annoying for the user.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsGLWidget.cpp   | 40 ++++++++++++++++++++++++++--------------
 src/KsGLWidget.hpp   |  4 +++-
 src/KsMainWindow.cpp |  7 ++++---
 src/KsTraceGraph.cpp | 10 +++++++---
 src/KsTraceGraph.hpp |  2 +-
 src/KsUtils.cpp      |  1 +
 6 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 9f8e43b..8aab7b3 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -409,25 +409,12 @@ void KsGLWidget::keyReleaseEvent(QKeyEvent *event)
  */
 #define KS_MAX_START_PLOTS 16
 
-/**
- * @brief Load and show trace data.
- *
- * @param data: Input location for the KsDataStore object.
- *	  KsDataStore::loadDataFile() must be called first.
- */
-void KsGLWidget::loadData(KsDataStore *data)
+void KsGLWidget::_defaultPlots(kshark_context *kshark_ctx)
 {
-	kshark_context *kshark_ctx(nullptr);
 	QVector<int> streamIds, plotVec;
 	uint64_t tMin, tMax;
 	int nCPUs, nBins;
 
-	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->n_streams)
-		return;
-
-	loadColors();
-
-	_data = data;
 	_model.reset();
 	_streamPlots.clear();
 
@@ -463,6 +450,31 @@ void KsGLWidget::loadData(KsDataStore *data)
 	tMin = _data->rows()[0]->ts;
 	tMax = _data->rows()[_data->size() - 1]->ts;
 	ksmodel_set_bining(_model.histo(), nBins, tMin, tMax);
+}
+
+/**
+ * @brief Load and show trace data.
+ *
+ * @param data: Input location for the KsDataStore object.
+ *		KsDataStore::loadDataFile() must be called first.
+ * @param resetPlots: If true, all existing graphs are closed
+ *		      and a default configuration of graphs is displayed
+ *		      (all CPU plots). If false, the current set of graphs
+ *		      is preserved.
+ */
+void KsGLWidget::loadData(KsDataStore *data, bool resetPlots)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->n_streams)
+		return;
+
+	loadColors();
+
+	_data = data;
+	if (resetPlots)
+		_defaultPlots(kshark_ctx);
+
 	_model.fill(_data);
 }
 
diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index 629ae37..6a72a35 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -101,7 +101,7 @@ public:
 
 	void keyReleaseEvent(QKeyEvent *event);
 
-	void loadData(KsDataStore *data);
+	void loadData(KsDataStore *data, bool resetPlots);
 
 	void loadColors();
 
@@ -326,6 +326,8 @@ private:
 	int _getLastCPU(struct kshark_trace_histo *histo,
 			int bin, int sd, int pid);
 
+	void _defaultPlots(kshark_context *kshark_ctx);
+
 	void _deselect();
 
 	int _bin0Offset() {return _labelSize + 2 * _hMargin;}
diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index fa893ce..1cbec55 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1283,7 +1283,8 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 	QApplication::processEvents();
 
 	_view.reset();
-	_graph.reset();
+	if (!append)
+		_graph.reset();
 
 	auto lamLoadJob = [&, this] () {
 		QVector<kshark_dpi *> v;
@@ -1333,7 +1334,7 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 	_view.loadData(&_data);
 	pb.setValue(175);
 
-	_graph.loadData(&_data);
+	_graph.loadData(&_data, !append);
 	pb.setValue(195);
 }
 
@@ -1454,7 +1455,7 @@ void KsMainWindow::loadSession(const QString &fileName)
 	_view.loadData(&_data);
 	pb.setValue(155);
 
-	_graph.loadData(&_data);
+	_graph.loadData(&_data, true);
 	_filterSyncCBoxUpdate(kshark_ctx);
 	pb.setValue(175);
 
diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index 1e976df..65e5a79 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -148,12 +148,16 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
  * @brief Load and show trace data.
  *
  * @param data: Input location for the KsDataStore object.
- *	  KsDataStore::loadDataFile() must be called first.
+ *	  	KsDataStore::loadDataFile() must be called first.
+ * @param resetPlots: If true, all existing graphs are closed
+ *		      and a default configuration of graphs is displayed
+ *		      (all CPU plots). If false, the current set of graphs
+ *		      is preserved.
  */
-void KsTraceGraph::loadData(KsDataStore *data)
+void KsTraceGraph::loadData(KsDataStore *data, bool resetPlots)
 {
 	_data = data;
-	_glWindow.loadData(data);
+	_glWindow.loadData(data, resetPlots);
 	updateGeom();
 }
 
diff --git a/src/KsTraceGraph.hpp b/src/KsTraceGraph.hpp
index 6e83f21..b1132e0 100644
--- a/src/KsTraceGraph.hpp
+++ b/src/KsTraceGraph.hpp
@@ -45,7 +45,7 @@ class KsTraceGraph : public KsWidgetsLib::KsDataWidget
 public:
 	explicit KsTraceGraph(QWidget *parent = nullptr);
 
-	void loadData(KsDataStore *data);
+	void loadData(KsDataStore *data, bool resetPlots);
 
 	void setMarkerSM(KsDualMarkerSM *m);
 
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index ec53267..757f49c 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -785,6 +785,7 @@ int KsDataStore::appendDataFile(const QString &file, int64_t offset)
 	_rows = mergedRows;
 
 	registerCPUCollections();
+	emit updateWidgets(this);
 
 	return sd;
 }
-- 
2.27.0

