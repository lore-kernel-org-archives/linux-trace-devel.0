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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2A8C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93646206B6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klQl88QN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgIPGuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgIPGuh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 02:50:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FDFC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id w2so1638799wmi.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbhKnr+daA1Lbh8a5+Uxi4Fk14MMdGVCMAhEuc0wWw8=;
        b=klQl88QNyNoeWcFxpNdTVJTFMt8TrfgfL4w99+Q54TkXs4gHbf+fS6TcGxzSEQpakU
         tfJHjItMCzf7rDuqdQkAInIZIXa8/xHE/aHoHnyXmdoT3KkgpcWQet/h/3URCHkRrJI5
         cyfZTbo1dzp2BJ4FzTYdbtAthPNJWhLnSjpV8rwfEkXo0wQdhlfi6ClHGARTY0ohAZpC
         JE4YBOfoyNpNlgt1sURpvZ6zOltZHnPJM0IAAW5L9khpDBsj5vhk3VeroclqBSEI7hR7
         l9p4erDStcIlW3teiBPo126Ei7ePFa0Ekd2jmgeuWe5NGbJZG2bPNkSXJJBtUVE4ui/x
         BHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbhKnr+daA1Lbh8a5+Uxi4Fk14MMdGVCMAhEuc0wWw8=;
        b=WrTQ7nfrJR8reKN4UKES7ZJk5OWA3SCZCe3Emx5NdZkyYx1PgrLEPAPKnmuuyv6FJt
         GS1AbSTKjb1ouFpukTXRl30uBNWf5QXNYryiaviUecxSe6Io3AeYCjFRG2r6jfxOk0H1
         M+9fKqPz1fvAfDk0LWzIj/NTN8c69uuU2h9lx2F/gPZR1CzYQcTPZXylKno5ZS1QFM1+
         M1poGVtRbnxTsrJcN9z7byG7595i2bDScsGYiNVoMdcRo7pG5fk2Qpj1rEoDoq7OnNES
         +oJjI0aSGSW/XL3f272h61fpCIDNbNOdnWORKWlcsSrijykVgt1EAcA0y4tApkIvKQ4p
         3CMA==
X-Gm-Message-State: AOAM531J6WE1sxZAA6ym2XUnXUUgcEa1WVSSjDeulDcvJpiXBSSrybiS
        ylYm2iqc8m6ixjmZSkydWQ1L0Qeno0A=
X-Google-Smtp-Source: ABdhPJyMx5cfrXF/sACeaxvfXmzPqObG7t8KWHt+cBg9CxMhsdsM1h3lGsMAGbxaXEOlSL9b80lsRw==
X-Received: by 2002:a1c:b386:: with SMTP id c128mr2965825wmf.82.1600239033258;
        Tue, 15 Sep 2020 23:50:33 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id u126sm4229028wmu.9.2020.09.15.23.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 23:50:32 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark :Fix all build warnings for gcc 10.2.1
Date:   Wed, 16 Sep 2020 09:50:04 +0300
Message-Id: <20200916065007.9755-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tested on Fedora 32:
gcc (GCC) 10.2.1 20200723 (Red Hat 10.2.1-1)

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsAdvFilteringDialog.cpp |  6 +++---
 kernel-shark/src/KsCaptureDialog.cpp      |  2 +-
 kernel-shark/src/KsTraceGraph.cpp         | 23 ++++++++---------------
 kernel-shark/src/KsTraceGraph.hpp         |  4 ++++
 kernel-shark/src/KsUtils.cpp              |  4 ++--
 kernel-shark/src/KsUtils.hpp              |  6 +++---
 kernel-shark/src/KsWidgetsLib.cpp         |  6 +++---
 7 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/kernel-shark/src/KsAdvFilteringDialog.cpp b/kernel-shark/src/KsAdvFilteringDialog.cpp
index 6af1aea..8dc53bb 100644
--- a/kernel-shark/src/KsAdvFilteringDialog.cpp
+++ b/kernel-shark/src/KsAdvFilteringDialog.cpp
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
 
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index d6f8014..63fd5d6 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -219,7 +219,7 @@ QStringList KsCaptureControl::_getPlugins()
 	}
 
 	free (all_plugins);
-	qSort(pluginList);
+	std::sort(pluginList.begin(), pluginList.end());
 
 	return pluginList;
 }
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 90f83f3..f21fcfc 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -282,11 +282,9 @@ void KsTraceGraph::_stopUpdating()
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
@@ -316,13 +314,12 @@ void KsTraceGraph::_setPointerInfo(size_t i)
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
@@ -445,7 +442,7 @@ void KsTraceGraph::addCPUPlot(int cpu)
 		return;
 
 	_glWindow._cpuList.append(cpu);
-	qSort(_glWindow._cpuList);
+	std::sort(_glWindow._cpuList.begin(), _glWindow._cpuList.end());
 	_selfUpdate();
 }
 
@@ -456,7 +453,7 @@ void KsTraceGraph::addTaskPlot(int pid)
 		return;
 
 	_glWindow._taskList.append(pid);
-	qSort(_glWindow._taskList);
+	std::sort(_glWindow._taskList.begin(), _glWindow._taskList.end());
 	_selfUpdate();
 }
 
@@ -606,21 +603,17 @@ void KsTraceGraph::_updateGraphLegends()
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
diff --git a/kernel-shark/src/KsTraceGraph.hpp b/kernel-shark/src/KsTraceGraph.hpp
index c53258c..8abc06b 100644
--- a/kernel-shark/src/KsTraceGraph.hpp
+++ b/kernel-shark/src/KsTraceGraph.hpp
@@ -108,6 +108,10 @@ private:
 
 	void _markerReDraw();
 
+	QString _t2str(uint64_t sec, uint64_t usec) {
+		return QString::number(sec) + "." + QString::number(usec);
+	};
+
 	enum class GraphActions {
 		ZoomIn,
 		ZoomOut,
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 8c61b3f..24f7178 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
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
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 9adacd8..2772b84 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
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
diff --git a/kernel-shark/src/KsWidgetsLib.cpp b/kernel-shark/src/KsWidgetsLib.cpp
index 330230e..a84aff3 100644
--- a/kernel-shark/src/KsWidgetsLib.cpp
+++ b/kernel-shark/src/KsWidgetsLib.cpp
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
2.26.2

