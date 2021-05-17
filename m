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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56742C43616
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C2C601FC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhEQPAS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbhEQO6E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F4C08E867
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:52 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i13so7115603edb.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tWHaLh8Y1OoaJH08nDsN3cdWdbiB3d7cAvX8lo3wDXc=;
        b=dmE5niiEiYv1LDZVw37GZFCwuNXFlINDTGPJ3zaDxWzjeiD/Rin8zrjD3EcTCi0Enk
         Ga3mnEOhWiYfhRqzpynory8VGLd0r+/U5tDEnpR4HgJ9YUmOV/WXVlyYb8hrRm9VGchy
         ke4zECLvKKXbOzStfXYljBAqcruL+T0fTyc+44T5JB9CGaQk8C9N+6pAFmuDzNX1qab+
         LTu82E84AYa7MH4vMUAMzYqNiEHg4e+bcPuSHOSmJRaKGDeq34j/I5iKhpvHq7+idrQA
         sYkAfLpIjlYOOZgTGwxOn+Ejqvp/Ac3XCirJKWwddjoPVnEdiKFHEz4uefsR1/fqjoK4
         visg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tWHaLh8Y1OoaJH08nDsN3cdWdbiB3d7cAvX8lo3wDXc=;
        b=piiAiPtTtjxxZrJLM6Z8Tj0dbb3+VPglbKoIgvYLj3nhmeTRkkHtmD+M3U/5rauZX4
         x4sgIFzw6zED9FJhuhuXyZHeKE1RiUVUIIVFRE9iisKdPD3rnQIXn30d3ZFECxn0unbp
         tR31V/zI5IT/cHdiXoL1l1bOmCvlzSeMpZu87K7W3GtNzLWLMzTprKNd/xzWtmtp1XGd
         TQqvOVXsJ9MXNuqwJJ6cCyAvs8f2XLobieWJcPj+Whn8NSEDmkQXE82rUUHde5giP7+7
         yzDZKqSj6SJJRTQIliwHajhbKokEM/69did9BGb11WAqTopXsDWzLtQVkEuTDXQmPWm2
         eliQ==
X-Gm-Message-State: AOAM530hTQ73ETuDah4VvTufFKIC7BTV+Dkk8+zfXvEzrgEFbsL0ahVH
        VUzgIwWA7C5WZEg30GyQ/2BTZ4zjjPU=
X-Google-Smtp-Source: ABdhPJwRb3RARyd6GWZjXFemiQQa9h++0ISYfnV4O+fDrinYt3cgcik92uT5gL92gVUE0a57Q5kvPA==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr355787eds.78.1621261311081;
        Mon, 17 May 2021 07:21:51 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/7] kernel-shark: Preserve open graphs when appending data
Date:   Mon, 17 May 2021 17:21:35 +0300
Message-Id: <20210517142140.286153-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
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
 src/KsMainWindow.cpp | 10 +++++++---
 src/KsTraceGraph.cpp | 10 +++++++---
 src/KsTraceGraph.hpp |  2 +-
 src/KsUtils.cpp      |  1 +
 6 files changed, 45 insertions(+), 22 deletions(-)

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
index fa893ce..da1c0af 100644
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
@@ -1333,7 +1334,10 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 	_view.loadData(&_data);
 	pb.setValue(175);
 
-	_graph.loadData(&_data);
+	_graph.loadData(&_data, !append);
+	if (append)
+		_graph.cpuReDraw(sd, KsUtils::getCPUList(sd));
+
 	pb.setValue(195);
 }
 
@@ -1454,7 +1458,7 @@ void KsMainWindow::loadSession(const QString &fileName)
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

