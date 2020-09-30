Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFA8C4727E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D95C207FB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P77JX54G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgI3PIH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgI3PIH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 11:08:07 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450ACC061755
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id a9so2170854wmm.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=usR3R8yFGdNfThG0NRroYuDv45MtH8w8x4GjxNoK9Ek=;
        b=P77JX54G0mOEmlm/75hHWEg6NzBlI47GXERKUFfycbua6e+X67OJP6cmQnI2KnQMwR
         2K7GHq4dvNd2a69IABGRK6/32dR5qCbkVT2yLDsJP18AiYnR0T57E0NMqWO6KIj2Sc1g
         MinVlagK0KdTN0D9BFzF7deUL/VOXYO8EP6Yt+IqeqyBWOPtkDcVODx2jMW3Ko0ugI6F
         EReI0ibR8JAdEbFwMhgl8VlL/z0sP+L4Gd1oIB5oBVU5+AH6R9ZoH+L76eIjQ3vWi2qI
         J2pNJLeb/fsfoM4lmQ/7aMHcbUXPBBVVSnS4BjJAGu243hEPwfb5td4JL/6nVnSfOFMB
         7TqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=usR3R8yFGdNfThG0NRroYuDv45MtH8w8x4GjxNoK9Ek=;
        b=hXhwJho1qDe53A1cCQF9zgRNGtSIfUvpNaRVrD9EZGnrvwqKaO6ZGXV+oTtw0g77GA
         iBT4eMFTn297qBhFpyNTJqONGDr58/aBWTDZhEfPBYK385DYYDV05+Bm2JNm+KtSf/M6
         P7VPCsLjZVMALuyRQ3OymaevUBe3TE/lvaiolRaJymrEirK1/IFG9y808qoXlgcTjUlU
         hHedyJeg17MPxQQT36Iz+tuF9t5U5xBly+BDgpC5dyUe/Wipi2gmZeIoxxB5k0/NcNJG
         gHR523XYa2wkObLFMeiiIs0qp3rUrPGhere9h0PkwpIrXep0q/DEZNyvD6W26LJ/PoHh
         2e6Q==
X-Gm-Message-State: AOAM531CoGY0v4/XHErNr/zoEGXIS9YPMzNxIiaA9vl0M0I25QrAulaa
        qN4b7LexghvJAkuKlw3Ux7hamyCGipo=
X-Google-Smtp-Source: ABdhPJwF6cF2Xzyj5URDp7BjynrxLZpb/kiCbqi0c3Ur8mFnTA0UZPb5elwwQqrGBQRzySSJgrMYzQ==
X-Received: by 2002:a1c:7514:: with SMTP id o20mr3482198wmc.76.1601478485815;
        Wed, 30 Sep 2020 08:08:05 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id k4sm3613486wrx.51.2020.09.30.08.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 08:08:04 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark: Fix all warnings showing when bulding with gcc 10.2.1
Date:   Wed, 30 Sep 2020 18:07:39 +0300
Message-Id: <20200930150741.224779-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tested on Fedora 32:
gcc (GCC) 10.2.1 20200723 (Red Hat 10.2.1-1)

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsAdvFilteringDialog.cpp |  6 +++---
 src/KsCaptureDialog.cpp      |  2 +-
 src/KsTraceGraph.cpp         | 36 +++++++++++++++++++++---------------
 src/KsTraceGraph.hpp         |  2 ++
 src/KsUtils.cpp              |  4 ++--
 src/KsUtils.hpp              |  6 +++---
 src/KsWidgetsLib.cpp         |  6 +++---
 7 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 6af1aea..8dc53bb 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -170,7 +170,7 @@ void KsAdvFilteringDialog::_setSystemCombo(struct kshark_context *kshark_ctx)
 		}
 	}
 
-	qSort(sysList);
+	std::sort(sysList.begin(), sysList.end());
 	_systemComboBox.addItems(sysList);
 
 	i = _systemComboBox.findText("ftrace");
@@ -291,7 +291,7 @@ void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
 			evtsList << events[i]->name;
 	}
 
-	qSort(evtsList);
+	std::sort(evtsList.begin(), evtsList.end());
 	_eventComboBox.addItems(evtsList);
 
 	i = _eventComboBox.findText("function");
@@ -310,7 +310,7 @@ KsAdvFilteringDialog::_getEventFormatFields(struct tep_event *event)
 
 	free(fields);
 
-	qSort(fieldList);
+	std::sort(fieldList.begin(), fieldList.end());
 	return fieldList;
 }
 
diff --git a/src/KsCaptureDialog.cpp b/src/KsCaptureDialog.cpp
index d6f8014..63fd5d6 100644
--- a/src/KsCaptureDialog.cpp
+++ b/src/KsCaptureDialog.cpp
@@ -219,7 +219,7 @@ QStringList KsCaptureControl::_getPlugins()
 	}
 
 	free (all_plugins);
-	qSort(pluginList);
+	std::sort(pluginList.begin(), pluginList.end());
 
 	return pluginList;
 }
diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index 90f83f3..7b656c0 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -279,14 +279,25 @@ void KsTraceGraph::_stopUpdating()
 	_keyPressed = false;
 }
 
+QString KsTraceGraph::_t2str(uint64_t sec, uint64_t usec) {
+	QString usecStr;
+	QTextStream ts(&usecStr);
+
+	ts.setFieldAlignment(QTextStream::AlignRight);
+	ts.setFieldWidth(6);
+	ts.setPadChar('0');
+
+	ts << usec;
+
+	return QString::number(sec) + "." + usecStr;
+}
+
 void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
 {
 	uint64_t sec, usec;
-	QString pointer;
 
 	kshark_convert_nano(ts, &sec, &usec);
-	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
-	_labelP2.setText(pointer);
+	_labelP2.setText(_t2str(sec, usec));
 
 	if (pid > 0 && cpu >= 0) {
 		struct kshark_context *kshark_ctx(NULL);
@@ -316,13 +327,12 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	QString lat(kshark_get_latency_easy(e));
 	QString info(kshark_get_info_easy(e));
 	QString comm(kshark_get_task_easy(e));
-	QString pointer, elidedText;
 	int labelWidth, width;
+	QString elidedText;
 	uint64_t sec, usec;
 
 	kshark_convert_nano(e->ts, &sec, &usec);
-	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
-	_labelP2.setText(pointer);
+	_labelP2.setText(_t2str(sec, usec));
 
 	comm.append("-");
 	comm.append(QString("%1").arg(kshark_get_pid_easy(e)));
@@ -445,7 +455,7 @@ void KsTraceGraph::addCPUPlot(int cpu)
 		return;
 
 	_glWindow._cpuList.append(cpu);
-	qSort(_glWindow._cpuList);
+	std::sort(_glWindow._cpuList.begin(), _glWindow._cpuList.end());
 	_selfUpdate();
 }
 
@@ -456,7 +466,7 @@ void KsTraceGraph::addTaskPlot(int pid)
 		return;
 
 	_glWindow._taskList.append(pid);
-	qSort(_glWindow._taskList);
+	std::sort(_glWindow._taskList.begin(), _glWindow._taskList.end());
 	_selfUpdate();
 }
 
@@ -606,21 +616,17 @@ void KsTraceGraph::_updateGraphLegends()
 void KsTraceGraph::_updateTimeLegends()
 {
 	uint64_t sec, usec, tsMid;
-	QString tMin, tMid, tMax;
 
 	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
-	tMin.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
-	_labelXMin.setText(tMin);
+	_labelXMin.setText(_t2str(sec, usec));
 
 	tsMid = (_glWindow.model()->histo()->min +
 		 _glWindow.model()->histo()->max) / 2;
 	kshark_convert_nano(tsMid, &sec, &usec);
-	tMid.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
-	_labelXMid.setText(tMid);
+	_labelXMid.setText(_t2str(sec, usec));
 
 	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
-	tMax.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
-	_labelXMax.setText(tMax);
+	_labelXMax.setText(_t2str(sec, usec));
 }
 
 /**
diff --git a/src/KsTraceGraph.hpp b/src/KsTraceGraph.hpp
index c53258c..0eeef14 100644
--- a/src/KsTraceGraph.hpp
+++ b/src/KsTraceGraph.hpp
@@ -108,6 +108,8 @@ private:
 
 	void _markerReDraw();
 
+	QString _t2str(uint64_t sec, uint64_t usec);
+
 	enum class GraphActions {
 		ZoomIn,
 		ZoomOut,
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 8c61b3f..24f7178 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -48,7 +48,7 @@ QVector<int> getPidList()
 
 	free(tempPids);
 
-	qSort(pids);
+	std::sort(pids.begin(), pids.end());
 
 	return pids;
 }
@@ -90,7 +90,7 @@ QVector<int> getFilterIds(tracecmd_filter_id *filter)
 	for (int i = 0; i < n; ++i)
 		v.append(cpuFilter[i]);
 
-	qSort(v);
+	std::sort(v.begin(), v.end());
 
 	free(cpuFilter);
 	return v;
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index 9adacd8..2772b84 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -25,10 +25,10 @@
 #include "KsPlotTools.hpp"
 
 /** Macro providing the height of the screen in pixels. */
-#define SCREEN_HEIGHT  QApplication::desktop()->screenGeometry().height()
+#define SCREEN_HEIGHT  QGuiApplication::screens()[0]->geometry().height()
 
 /** Macro providing the width of the screen in pixels. */
-#define SCREEN_WIDTH   QApplication::desktop()->screenGeometry().width()
+#define SCREEN_WIDTH   QGuiApplication::screens()[0]->geometry().width()
 
 //! @cond Doxygen_Suppress
 
@@ -45,7 +45,7 @@ static auto stringWidth = [](QString s)
 	QFont font;
 	QFontMetrics fm(font);
 
-	return fm.width(s);
+	return fm.horizontalAdvance(s);
 };
 
 //! @endcond
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index 330230e..a84aff3 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -642,7 +642,7 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_handle *tep,
 		cpuItem->setText(0, "  ");
 		cpuItem->setText(1, QString("CPU %1").arg(i));
 		cpuItem->setCheckState(0, Qt::Checked);
-		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
+		cpuItem->setBackground(0, QColor(colors[i].r(),
 						      colors[i].g(),
 						      colors[i].b()));
 		_tree.addTopLevelItem(cpuItem);
@@ -799,12 +799,12 @@ KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct tep_handle *pevent,
 		comm = tep_data_comm_from_pid(kshark_ctx->pevent, pid);
 		comItem = new QTableWidgetItem(tr(comm));
 
-		pidItem->setBackgroundColor(QColor(colors[pid].r(),
+		pidItem->setBackground(QColor(colors[pid].r(),
 						   colors[pid].g(),
 						   colors[pid].b()));
 
 		if (_id[i] == 0)
-			pidItem->setTextColor(Qt::white);
+			pidItem->setForeground(Qt::white);
 
 		_table.setItem(i, 2, comItem);
 	}
-- 
2.25.1

