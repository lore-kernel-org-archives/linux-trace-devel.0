Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EEC1E863
	for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710099213; cv=none; b=BRvv1xF5FFfpu9QehzlrAR41CtNacxh3u21sRrBHAd8CQyJ8T//rVG3/MVpifPGzb7cUxEAJ85CeMoTHXmqYKKCgdJB86Ml+ar8bra0U0oP0LLzkN73nqMH/mAuEIMendR7kA2hXruPon/Hn9ubVzNpuueu0nr0P3aUX3rW9Vk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710099213; c=relaxed/simple;
	bh=XzRquLDPU7GKzQMt3c/dXgBbeoSCdDmGxN4wIaCyZ8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGFFsfCLsJuruIhxpTWzoihtY+g0QOKEPno5d+tMJm32jjrhaD7/HHyjXNRgkuHhULRmnK3zBXugkXhL/CV7uhUcF8h76hE+17Vm/ACbZ6h+uHssAMUahcI/8V+y9qMbUMaiGSGFM6ZmDF2tfHsOr/ehx5/9UNZE+Of/ewfnDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PhU6TWzV; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhU6TWzV"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41328aea25aso2104695e9.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Mar 2024 12:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710099209; x=1710704009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoJos/hlbBG9wropO8iKJ0uSXxKsJgFNouzWkdridDg=;
        b=PhU6TWzVYeLtTYY81zGqyozNEtKM8bRs/uYl7ZvNKGIAhva6DqRpR3AevC4YlHzIj3
         n9xjUsRivB7ex6022VqkO1sH5cP7W0wdJeH8BHaZ/wScyKagcUItYgJSndEXv+nfKpof
         NB2a5TWOQjI1xZy9M9JK6iDdtQOsW6CsDQ68fK/Ei1GCA+FbF6WL+DDjAewI0ewuJy73
         dRVuvgc43CxwcxR210LpsPrKugtS4bL4RQaou7VdqAcTc3LwrO8fKztKvZmGZX10Dcri
         bgL/O2RELykZzG0doHJ1x86abWxHYqLTS1uUAtdUQF//VxdEjfsQ8SRUH10noqm4QFLQ
         GWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710099209; x=1710704009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoJos/hlbBG9wropO8iKJ0uSXxKsJgFNouzWkdridDg=;
        b=TR/7sIbMseSYDQCZd0lOeSn9m4JGQdQcZrOyyijXw19r6Tpqr00fKPJZ0q+MPvgpxZ
         3Ez0qEP02EbDf6O1AZ50N3EUuIV399usKYrBBpOVxe1FdkrHHwP0AhTyC7XsA/I+1RVB
         12zEbdP0cPtc7ZcZKH2CPSDI0T+9GtShOFtyAEBgomjXUyyEK9QccGXmjJ/x8g/Hw8MS
         4MUCVUDmxlBfsiQiiC18RdPbBPkKmt/46NZf9lR7SSU+ryK/aVCPHn0CMI0KHZxX8ZNI
         N7oE5AUPA9VNsX1oF8xdMNomvd8UfgCLduvL2T0a69EbHSaVp4wvVWSScbBf5Kum2HYw
         4SOA==
X-Gm-Message-State: AOJu0YwGebv1SgSmSfsT8eBgokzZ4Fctah57vSOrd1MZYq4tVrlgczKm
	uKB42iM6VLiV1GdWDC8ud6KVhFaT+1hDL+syZHLrNRwtMfS6WjqjcpMyuRWS
X-Google-Smtp-Source: AGHT+IFXJPVg6TSWI+dDwGb5FwpGe+RQN1dZ2XQ4+3Tm8m5WQtBlDAELtJ2QKU9tcC70AFoCAmDbwA==
X-Received: by 2002:a05:600c:4e43:b0:413:2868:e91e with SMTP id e3-20020a05600c4e4300b004132868e91emr1404260wmq.18.1710099208831;
        Sun, 10 Mar 2024 12:33:28 -0700 (PDT)
Received: from belmeken.. (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id ay5-20020a05600c1e0500b0041327ac5dbesm2422768wmb.48.2024.03.10.12.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 12:33:28 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: dev@benjarobin.fr,
	Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernelshark: Mute all "unused parameter" warnings
Date: Sun, 10 Mar 2024 21:32:57 +0200
Message-ID: <20240310193258.50899-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240310193258.50899-1-y.karadz@gmail.com>
References: <20240310193258.50899-1-y.karadz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Non of this warnings is an actual bug.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 src/KsMainWindow.cpp              |  5 +++--
 src/KsModels.cpp                  |  4 ++--
 src/KsModels.hpp                  |  3 ++-
 src/KsPlotTools.cpp               |  8 +++++---
 src/KsPlugins.cpp                 |  5 +++--
 src/KsSearchFSM.cpp               |  3 ++-
 src/KsTraceGraph.cpp              |  2 +-
 src/KsTraceViewer.cpp             | 10 +++++-----
 src/KsUtils.cpp                   |  2 +-
 src/KsWidgetsLib.cpp              |  4 ++--
 src/KsWidgetsLib.hpp              |  2 +-
 src/libkshark-model.c             |  4 ++--
 src/libkshark-tepdata.c           |  6 +++---
 src/libkshark.c                   | 10 +++++-----
 src/plugins/EventFieldDialog.cpp  |  2 +-
 src/plugins/LatencyPlotDialog.cpp |  2 +-
 tests/test-input.c                | 16 ++++++++--------
 tests/test-input_ctrl.c           | 18 +++++++++---------
 tests/test-plugin_dpi.c           |  4 ++--
 tests/test-plugin_dpi_ctrl.c      |  6 +++---
 tests/test-plugin_dpi_err.c       |  4 ++--
 21 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index 72f4280..d817469 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1544,7 +1544,7 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		_captureErrorMessage(capture);
 }
 
-void KsMainWindow::_captureError(QProcess::ProcessError error)
+void KsMainWindow::_captureError([[maybe_unused]] QProcess::ProcessError error)
 {
 	QProcess *capture = static_cast<QProcess*>(sender());
 	_captureErrorMessage(capture);
@@ -1595,7 +1595,8 @@ void KsMainWindow::_readSocket()
 	loadDataFile(fileName);
 }
 
-void KsMainWindow::_splitterMoved(int pos, int index)
+void KsMainWindow::_splitterMoved([[maybe_unused]] int pos,
+				  [[maybe_unused]] int index)
 {
 	_session.saveSplitterSize(_splitter);
 }
diff --git a/src/KsModels.cpp b/src/KsModels.cpp
index e10f411..c8a6ba3 100644
--- a/src/KsModels.cpp
+++ b/src/KsModels.cpp
@@ -23,11 +23,11 @@ KsFilterProxyModel::KsFilterProxyModel(QObject *parent)
 
 /**
  * Returns False if the item in the row indicated by the sourceRow and
- * sourceParentshould be filtered out. Otherwise returns True.
+ * sourceParent should be filtered out. Otherwise returns True.
  */
 bool
 KsFilterProxyModel::filterAcceptsRow(int sourceRow,
-				     const QModelIndex &sourceParent) const
+				     [[maybe_unused]] const QModelIndex &sourceParent) const
 {
 	if (_data[sourceRow]->visible & KS_TEXT_VIEW_FILTER_MASK)
 		return true;
diff --git a/src/KsModels.hpp b/src/KsModels.hpp
index b95c6c1..4e89602 100644
--- a/src/KsModels.hpp
+++ b/src/KsModels.hpp
@@ -279,7 +279,8 @@ public:
 	 * This dummy function is an implementation of the pure
 	 * virtual method of the abstract model class.
 	 */
-	QVariant data(const QModelIndex &index, int role) const override
+	QVariant data([[maybe_unused]] const QModelIndex &index,
+		      [[maybe_unused]] int role) const override
 	{
 		return {};
 	}
diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index f362eaa..8c702e6 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -261,7 +261,8 @@ Color getColor(const ColorTable *colors, int id)
  * @param x: The X coordinate of the click.
  * @param y: The Y coordinate of the click.
  */
-double PlotObject::distance(int x, int y) const
+double PlotObject::distance([[maybe_unused]] int x,
+			    [[maybe_unused]] int y) const
 {
 	return std::numeric_limits<double>::max();
 }
@@ -652,7 +653,7 @@ void TextBox::setBoxAppearance(const Color &col, int l, int h)
 	_box.setPoint(3, _box.pointX(0) + l,	_box.pointY(0));
 }
 
-void TextBox::_draw(const Color &col, float size) const
+void TextBox::_draw(const Color &col, [[maybe_unused]]float size) const
 {
 	_box.draw();
 	if (!_font || _text.empty())
@@ -1518,7 +1519,8 @@ void Graph::draw(float size)
 	}
 }
 
-void VirtGap::_draw(const Color &col, float size) const
+void VirtGap::_draw([[maybe_unused]]const Color &col,
+		    [[maybe_unused]] float size) const
 {
 	if (_entryPoint.x() - _exitPoint.x() < 4)
 		return;
diff --git a/src/KsPlugins.cpp b/src/KsPlugins.cpp
index f4fc35e..eda2f5c 100644
--- a/src/KsPlugins.cpp
+++ b/src/KsPlugins.cpp
@@ -125,8 +125,9 @@ getLastInBinEvents(kshark_trace_histo *histo, kshark_data_container *data,
 	 * Do not resolve. This means that only the very last (in time)
 	 * appearance of the event in the bin will be visualized.
 	 */
-	resolveFunc resolve = [] (kshark_data_container *data, ssize_t i,
-				  PlotPointList *list) {};
+	resolveFunc resolve = [] ([[maybe_unused]] kshark_data_container *data,
+				  [[maybe_unused]] ssize_t i,
+				  [[maybe_unused]] PlotPointList *list) {};
 
 	return getInBinEvents(histo, data, isApplicable, push, resolve);
 }
diff --git a/src/KsSearchFSM.cpp b/src/KsSearchFSM.cpp
index a5f3682..b9bd6b7 100644
--- a/src/KsSearchFSM.cpp
+++ b/src/KsSearchFSM.cpp
@@ -30,7 +30,8 @@ static bool matchCond(const QString &searchText, const QString &itemText)
 	return (itemText.compare(searchText, Qt::CaseInsensitive) == 0);
 }
 
-static bool noCond(const QString &searchText, const QString &itemText)
+static bool noCond([[maybe_unused]] const QString &searchText,
+		   [[maybe_unused]] const QString &itemText)
 {
 	return false;
 }
diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index 4599a12..6b21591 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -620,7 +620,7 @@ void KsTraceGraph::updateGeom()
  * Reimplemented event handler used to update the geometry of the widget on
  * resize events.
  */
-void KsTraceGraph::resizeEvent(QResizeEvent* event)
+void KsTraceGraph::resizeEvent([[maybe_unused]] QResizeEvent* event)
 {
 	updateGeom();
 }
diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 93535a4..d4bf5f1 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -23,8 +23,8 @@
  * Reimplemented handler for creating delegate widget.
  */
 QWidget *KsTableItemDelegate::createEditor(QWidget *parent,
-					   const QStyleOptionViewItem &option,
-					   const QModelIndex &index) const {
+					   [[maybe_unused]] const QStyleOptionViewItem &option,
+					   [[maybe_unused]] const QModelIndex &index) const {
 	QTextEdit *edit = new QTextEdit(parent);
 	edit->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
 	edit->setReadOnly(true);
@@ -295,12 +295,12 @@ void KsTraceViewer::_onCustomContextMenu(const QPoint &point)
 	}
 }
 
-void KsTraceViewer::_searchEdit(int index)
+void KsTraceViewer::_searchEdit([[maybe_unused]] int index)
 {
 	_searchReset(); // The search has been modified.
 }
 
-void KsTraceViewer::_searchEditText(const QString &text)
+void KsTraceViewer::_searchEditText([[maybe_unused]] const QString &text)
 {
 	_searchReset(); // The search has been modified.
 }
@@ -550,7 +550,7 @@ void KsTraceViewer::markSwitch()
  * Reimplemented event handler used to update the geometry of the widget on
  * resize events.
  */
-void KsTraceViewer::resizeEvent(QResizeEvent* event)
+void KsTraceViewer::resizeEvent([[maybe_unused]] QResizeEvent* event)
 {
 	int nColumns = _model.header().count();
 	int tableSize(0), viewSize, freeSpace;
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 792678d..1f4068b 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -324,7 +324,7 @@ QCheckBox *addCheckBoxToMenu(QMenu *menu, QString name)
  * @returns True if the CPU of the entry matches the value of "cpu" and
  * 	    the entry is visibility in Graph. Otherwise false.
  */
-bool matchCPUVisible(struct kshark_context *kshark_ctx,
+bool matchCPUVisible([[maybe_unused]] struct kshark_context *kshark_ctx,
 		     struct kshark_entry *e, int sd, int *cpu)
 {
 	return (e->cpu == *cpu &&
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index 5191c9f..95402f7 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -621,7 +621,7 @@ void KsCheckBoxTable::mousePressEvent(QMouseEvent *event)
 	QTableWidget::mousePressEvent(event);
 }
 
-void KsCheckBoxTable::_doubleClicked(int row, int col)
+void KsCheckBoxTable::_doubleClicked(int row, [[maybe_unused]] int col)
 {
 	emit changeState(row);
 	for (auto &i: selectedItems())
@@ -854,7 +854,7 @@ void KsCheckBoxTreeWidget::_adjustSize()
 			_topLayout.contentsMargins().right());
 }
 
-void KsCheckBoxTreeWidget::_update(QTreeWidgetItem *item, int column)
+void KsCheckBoxTreeWidget::_update(QTreeWidgetItem *item, [[maybe_unused]] int column)
 {
 	/* Get the new state of the item. */
 	Qt::CheckState state = item->checkState(0);
diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index 48108cd..68c9f79 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -263,7 +263,7 @@ protected:
 	 * Reimplemented event handler used to update the geometry of the widget on
 	 * resize events.
 	 */
-	void resizeEvent(QResizeEvent* event) override
+	void resizeEvent([[maybe_unused]] QResizeEvent* event) override
 	{
 		KsUtils::setElidedText(&_streamLabel, _streamName,
 				       Qt::ElideLeft, width());
diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index 4cd9f6a..e872784 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -1274,14 +1274,14 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 	return true;
 }
 
-static bool match_cpu_missed_events(struct kshark_context *kshark_ctx,
+static bool match_cpu_missed_events(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 				    struct kshark_entry *e, int sd, int *cpu)
 {
 	return e->event_id == KS_EVENT_OVERFLOW &&
 	       e->cpu == *cpu && e->stream_id == sd;
 }
 
-static bool match_pid_missed_events(struct kshark_context *kshark_ctx,
+static bool match_pid_missed_events(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 				    struct kshark_entry *e, int sd, int *pid)
 {
 	return e->event_id == KS_EVENT_OVERFLOW &&
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 8e90daf..4e572a1 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -667,9 +667,9 @@ static int tepdata_get_event_id(struct kshark_data_stream *stream,
 	return (event_id == -1)? -EFAULT : event_id;
 }
 
-static char* missed_events_dump(struct kshark_data_stream *stream,
-				      const struct kshark_entry *entry,
-				      bool get_info)
+static char* missed_events_dump(__attribute__ ((unused)) struct kshark_data_stream *stream,
+				const struct kshark_entry *entry,
+				bool get_info)
 {
 	char *buffer;
 	int size = 0;
diff --git a/src/libkshark.c b/src/libkshark.c
index 44e553f..8443279 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1572,7 +1572,7 @@ ssize_t kshark_find_entry_by_time(int64_t time,
  * @returns True if the Pid of the entry matches the value of "pid".
  *	    Else false.
  */
-bool kshark_match_pid(struct kshark_context *kshark_ctx,
+bool kshark_match_pid(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 		      struct kshark_entry *e, int sd, int *pid)
 {
 	if (e->stream_id == sd && e->pid == *pid)
@@ -1592,7 +1592,7 @@ bool kshark_match_pid(struct kshark_context *kshark_ctx,
  * @returns True if the Cpu of the entry matches the value of "cpu".
  *	    Else false.
  */
-bool kshark_match_cpu(struct kshark_context *kshark_ctx,
+bool kshark_match_cpu(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 		      struct kshark_entry *e, int sd, int *cpu)
 {
 	if (e->stream_id == sd && e->cpu == *cpu)
@@ -1612,7 +1612,7 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
  * @returns True if the event Id of the entry matches the value of "event_id".
  *	    Else false.
  */
-bool kshark_match_event_id(struct kshark_context *kshark_ctx,
+bool kshark_match_event_id(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 			   struct kshark_entry *e, int sd, int *event_id)
 {
 	return e->stream_id == sd && e->event_id == *event_id;
@@ -1630,7 +1630,7 @@ bool kshark_match_event_id(struct kshark_context *kshark_ctx,
  * @returns True if the event Id of the entry matches the values.
  *	    Else false.
  */
-bool kshark_match_event_and_pid(struct kshark_context *kshark_ctx,
+bool kshark_match_event_and_pid(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 				struct kshark_entry *e,
 				int sd, int *values)
 {
@@ -1651,7 +1651,7 @@ bool kshark_match_event_and_pid(struct kshark_context *kshark_ctx,
  * @returns True if the event Id of the entry matches the values.
  *	    Else false.
  */
-bool kshark_match_event_and_cpu(struct kshark_context *kshark_ctx,
+bool kshark_match_event_and_cpu(__attribute__ ((unused)) struct kshark_context *kshark_ctx,
 				struct kshark_entry *e,
 				int sd, int *values)
 {
diff --git a/src/plugins/EventFieldDialog.cpp b/src/plugins/EventFieldDialog.cpp
index fbfe4cc..7fdec8b 100644
--- a/src/plugins/EventFieldDialog.cpp
+++ b/src/plugins/EventFieldDialog.cpp
@@ -161,7 +161,7 @@ void KsEFPDialog::_reset()
 	_gui_ptr->wipPtr()->hide(work);
 }
 
-static void showDialog(KsMainWindow *ks)
+static void showDialog([[maybe_unused]] KsMainWindow *ks)
 {
 	efp_dialog->update();
 	efp_dialog->show();
diff --git a/src/plugins/LatencyPlotDialog.cpp b/src/plugins/LatencyPlotDialog.cpp
index 1fe8c39..c2c9b52 100644
--- a/src/plugins/LatencyPlotDialog.cpp
+++ b/src/plugins/LatencyPlotDialog.cpp
@@ -162,7 +162,7 @@ void LatencyPlotDialog::_reset()
 	_gui_ptr->wipPtr()->hide(work);
 }
 
-static void showDialog(KsMainWindow *ks)
+static void showDialog([[maybe_unused]] KsMainWindow *ks)
 {
 	lp_dialog->update();
 	lp_dialog->show();
diff --git a/tests/test-input.c b/tests/test-input.c
index c6a5fa2..a45d5b4 100644
--- a/tests/test-input.c
+++ b/tests/test-input.c
@@ -15,7 +15,7 @@
 #include "libkshark-plugin.h"
 
 static ssize_t load_entries(struct kshark_data_stream *stream,
-			    struct kshark_context *kshark_ctx,
+			    __attribute__ ((unused)) struct kshark_context *kshark_ctx,
 			    struct kshark_entry ***data_rows)
 {
 	struct kshark_entry **rows;
@@ -36,7 +36,7 @@ static ssize_t load_entries(struct kshark_data_stream *stream,
 	return total;
 }
 
-static char *dump_entry(struct kshark_data_stream *stream,
+static char *dump_entry(__attribute__ ((unused)) struct kshark_data_stream *stream,
 			const struct kshark_entry *entry)
 {
 	char *entry_str;
@@ -59,7 +59,7 @@ const char *KSHARK_INPUT_FORMAT()
 	return format_name;
 }
 
-bool KSHARK_INPUT_CHECK(const char *file, char **format)
+bool KSHARK_INPUT_CHECK(const char *file, __attribute__ ((unused)) char **format)
 {
 	char *ext = strrchr(file, '.');
 
@@ -69,14 +69,14 @@ bool KSHARK_INPUT_CHECK(const char *file, char **format)
 	return false;
 }
 
-static int get_pid(struct kshark_data_stream *stream,
+static int get_pid(__attribute__ ((unused)) struct kshark_data_stream *stream,
 		   const struct kshark_entry *entry)
 {
 	return entry->pid;
 }
 
-static char *get_task(struct kshark_data_stream *stream,
-		      const struct kshark_entry *entry)
+static char *get_task(__attribute__ ((unused)) struct kshark_data_stream *stream,
+		      __attribute__ ((unused)) const struct kshark_entry *entry)
 {
 	char *entry_str;
 	int ret;
@@ -89,7 +89,7 @@ static char *get_task(struct kshark_data_stream *stream,
 	return entry_str;
 }
 
-static char *get_event_name(struct kshark_data_stream *stream,
+static char *get_event_name(__attribute__ ((unused)) struct kshark_data_stream *stream,
 			    const struct kshark_entry *entry)
 {
 	char *evt_str;
@@ -130,5 +130,5 @@ int KSHARK_INPUT_INITIALIZER(struct kshark_data_stream *stream)
 	return 0;
 }
 
-void KSHARK_INPUT_DEINITIALIZER(struct kshark_data_stream *stream)
+void KSHARK_INPUT_DEINITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {}
diff --git a/tests/test-input_ctrl.c b/tests/test-input_ctrl.c
index 77abab1..9695ad9 100644
--- a/tests/test-input_ctrl.c
+++ b/tests/test-input_ctrl.c
@@ -15,7 +15,7 @@
 #include "libkshark-plugin.h"
 
 static ssize_t load_entries(struct kshark_data_stream *stream,
-			    struct kshark_context *kshark_ctx,
+			    __attribute__ ((unused)) struct kshark_context *kshark_ctx,
 			    struct kshark_entry ***data_rows)
 {
 	struct kshark_entry **rows;
@@ -37,7 +37,7 @@ static ssize_t load_entries(struct kshark_data_stream *stream,
 	return total;
 }
 
-static char *dump_entry(struct kshark_data_stream *stream,
+static char *dump_entry(__attribute__ ((unused)) struct kshark_data_stream *stream,
 			const struct kshark_entry *entry)
 {
 	char *entry_str;
@@ -61,7 +61,7 @@ const char *KSHARK_INPUT_FORMAT()
 	return format_name;
 }
 
-bool KSHARK_INPUT_CHECK(const char *file, char **format)
+bool KSHARK_INPUT_CHECK(const char *file, __attribute__ ((unused)) char **format)
 {
 	char *ext = strrchr(file, '.');
 
@@ -71,14 +71,14 @@ bool KSHARK_INPUT_CHECK(const char *file, char **format)
 	return false;
 }
 
-static int get_pid(struct kshark_data_stream *stream,
+static int get_pid(__attribute__ ((unused)) struct kshark_data_stream *stream,
 		   const struct kshark_entry *entry)
 {
 	return entry->pid;
 }
 
-static char *get_task(struct kshark_data_stream *stream,
-		      const struct kshark_entry *entry)
+static char *get_task(__attribute__ ((unused)) struct kshark_data_stream *stream,
+		      __attribute__ ((unused)) const struct kshark_entry *entry)
 {
 	char *entry_str;
 	int ret;
@@ -91,7 +91,7 @@ static char *get_task(struct kshark_data_stream *stream,
 	return entry_str;
 }
 
-static char *get_event_name(struct kshark_data_stream *stream,
+static char *get_event_name(__attribute__ ((unused)) struct kshark_data_stream *stream,
 			    const struct kshark_entry *entry)
 {
 	char *evt_str;
@@ -130,11 +130,11 @@ int KSHARK_INPUT_INITIALIZER(struct kshark_data_stream *stream)
 	return 0;
 }
 
-void KSHARK_INPUT_DEINITIALIZER(struct kshark_data_stream *stream)
+void KSHARK_INPUT_DEINITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {}
 
 /** Initialize the control interface of the plugin. */
-void *KSHARK_MENU_PLUGIN_INITIALIZER(void *ptr)
+void *KSHARK_MENU_PLUGIN_INITIALIZER(__attribute__ ((unused)) void *ptr)
 {
 	return NULL;
 }
diff --git a/tests/test-plugin_dpi.c b/tests/test-plugin_dpi.c
index 82f94f3..29c4391 100644
--- a/tests/test-plugin_dpi.c
+++ b/tests/test-plugin_dpi.c
@@ -12,14 +12,14 @@
 #include "libkshark-plugin.h"
 
 /** Load this plugin. */
-int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_INITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("--> plugin1\n");
 	return 1;
 }
 
 /** Unload this plugin. */
-int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("<-- plugin1\n");
 	return 1;
diff --git a/tests/test-plugin_dpi_ctrl.c b/tests/test-plugin_dpi_ctrl.c
index 5fafd1d..940f2b1 100644
--- a/tests/test-plugin_dpi_ctrl.c
+++ b/tests/test-plugin_dpi_ctrl.c
@@ -12,21 +12,21 @@
 #include "libkshark-plugin.h"
 
 /** Load this plugin. */
-int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_INITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("--> plugin2\n");
 	return 2;
 }
 
 /** Unload this plugin. */
-int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("<-- plugin2\n");
 	return 2;
 }
 
 /** Initialize the control interface of the plugin. */
-void *KSHARK_MENU_PLUGIN_INITIALIZER(void *ptr)
+void *KSHARK_MENU_PLUGIN_INITIALIZER(__attribute__ ((unused)) void *ptr)
 {
 	return NULL;
 }
diff --git a/tests/test-plugin_dpi_err.c b/tests/test-plugin_dpi_err.c
index 4148930..6b0aec4 100644
--- a/tests/test-plugin_dpi_err.c
+++ b/tests/test-plugin_dpi_err.c
@@ -12,14 +12,14 @@
 #include "libkshark-plugin.h"
 
 /** Load this plugin. */
-int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_INITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("--> plugin_err\n");
 	return 0;
 }
 
 /** Unload this plugin. */
-int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(__attribute__ ((unused)) struct kshark_data_stream *stream)
 {
 	printf("<-- plugin_err\n");
 	return 0;
-- 
2.42.0

