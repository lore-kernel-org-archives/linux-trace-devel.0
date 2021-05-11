Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BC5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05DF61264
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhEKNkU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhEKNkT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:40:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE30C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:39:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n2so29804890ejy.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++gGosc1vOy6TBhMOzIibQzIj6vIi4bjNWnAo+TYEyM=;
        b=ez1mCHNW748VbCSrNeP1Imf2il4Vq6vq2oEwaKnjKN5ADV69WDDbHeJkOZxWmfWpue
         vqNLVMTunW6DZqB57iptc6GybCG5WVxQVUhNmvI0u3PuFSqvcEuZJCZBy91fF1ETeQin
         MR0P2xj3vUaLX5unu5ERv4xKP9QS25seCC4iAI33QKxFboZud6zASurpWpneEj7qA0a4
         V7YQ/ebrUz8Vz03zrPNjHjg6S3Nud1X++iEB1mVEcYWjUL2XkVkdsl8rMEzWUj1UHNCb
         2xwGKiqNoFbA2gQ539WLjtzHNU6NXTvStsrgI1ljOYB/gZC4Kwdr9EW0+7YSQYYqtfQJ
         5dxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++gGosc1vOy6TBhMOzIibQzIj6vIi4bjNWnAo+TYEyM=;
        b=OTUDCkjJXBEcjOJ0VQRhyIS2ot7McujzaoITJu6T9dp2QN2mJS+K7SHOrthv6IDHAr
         xGtH2hCL9AJ1O79DpwgXGrWuH9mOHx9O3iRtX0rKiix5irhItuF/2vUTJglMoFQrYOE6
         XmyljvW0oABxqHRCmH5p++nkBwvNunMQMFms0uMZdwiVmdP7J12NTOStAXnJJ3nKOSdN
         ZRwiWioo0XAJclf2vHaxYJKh6CliuwAaep6/BwmCdLtzQXT7glmCcNXu6eQcUoK0k7OH
         I3ajLpUNHl417KyG0rMkzPovaayrPoZ9L3UcJgUL4pgu0Hv9u2Mu+AXhePDmgMwmZdhr
         ycEg==
X-Gm-Message-State: AOAM531molluiyTd9Wreg9/xyTorZBf0wg0oev4uV49wPd1owZawp33/
        92wIVUOM65aC/F+cIf5QbfkKPaOCZwo=
X-Google-Smtp-Source: ABdhPJwcW6cEHvoL6EnOLXl9HYjMEsxqIrTGnvR8kk98wwvXlfAZQO3EvZqWngEwl/+yyox+XlrIYg==
X-Received: by 2002:a17:906:a51:: with SMTP id x17mr31742125ejf.25.1620740350559;
        Tue, 11 May 2021 06:39:10 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id v12sm15025942edb.81.2021.05.11.06.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:39:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Add KVMCombo plugin
Date:   Tue, 11 May 2021 16:39:00 +0300
Message-Id: <20210511133900.287636-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The plugin allows the user to visualize the execution flow between
the host and guest virtual machines. It exploits the concept of
"Combo Plots" that allows to have two normal graphs stacked together
(on top of each other). The plugin uses a "combo" between the task
in the host that emulates a virtual CPU and the corresponding
CPU graph from the VM. The plugin draws additional graphical elements
on top of this "combo", helping the user to intuitively interpret
the data and see how the execution flow goes from host to guest and
back. The core KVM-specific logic that implements the processing of
the data and the visualization itself is implemented in:

src/plugins/kvm_combo.h
src/plugins/kvm_combo.c
src/plugins/KVMCombo.cpp

Some general purposes tools for plotting, that in the future can
be used to implement similar plugins for other hypervisor are
available in:

plugins/VirtComboPlotTools.hpp

The plugin also registers its own dialog, that allows the user to
select the "combos" to be visualized. The widget of the dialog gets
implemented in:

src/plugins/KVMComboDialog.hpp
src/plugins/KVMComboDialog.cpp

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c            |   1 +
 src/plugins/CMakeLists.txt         |   5 +
 src/plugins/KVMCombo.cpp           |  39 ++++
 src/plugins/KVMComboDialog.cpp     | 350 +++++++++++++++++++++++++++++
 src/plugins/KVMComboDialog.hpp     |  89 ++++++++
 src/plugins/VirtComboPlotTools.hpp | 171 ++++++++++++++
 src/plugins/kvm_combo.c            |  72 ++++++
 src/plugins/kvm_combo.h            |  49 ++++
 tests/libkshark-gui-tests.cpp      |   1 +
 9 files changed, 777 insertions(+)
 create mode 100644 src/plugins/KVMCombo.cpp
 create mode 100644 src/plugins/KVMComboDialog.cpp
 create mode 100644 src/plugins/KVMComboDialog.hpp
 create mode 100644 src/plugins/VirtComboPlotTools.hpp
 create mode 100644 src/plugins/kvm_combo.c
 create mode 100644 src/plugins/kvm_combo.h

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index f7cd083..bc5babb 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1210,6 +1210,7 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
 const char *tep_plugin_names[] = {
 	"sched_events",
 	"missed_events",
+	"kvm_combo",
 };
 
 /**
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 2906dd4..3e170fa 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -54,6 +54,11 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE latency_plot.c LatencyPlot.cpp LatencyPlotDialog.cpp)
     list(APPEND PLUGIN_LIST "latency_plot")
 
+    BUILD_GUI_PLUGIN(NAME kvm_combo
+                     MOC KVMComboDialog.hpp
+                     SOURCE kvm_combo.c KVMCombo.cpp KVMComboDialog.cpp)
+    list(APPEND PLUGIN_LIST "kvm_combo")
+
 endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
 BUILD_PLUGIN(NAME missed_events
diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
new file mode 100644
index 0000000..c7e89d8
--- /dev/null
+++ b/src/plugins/KVMCombo.cpp
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KVMCombo.cpp
+ *  @brief   Plugin for visualization of KVM events.
+ */
+
+// KernelShark
+#include "plugins/kvm_combo.h"
+#include "VirtComboPlotTools.hpp"
+#include "KsPlugins.hpp"
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sdHost: Data stream identifier of the Host.
+ * @param pidHost: Process Id of the virtual CPU process in the Host.
+ * @param draw_action: Draw action identifier.
+ */
+__hidden void draw_kvm_combos(kshark_cpp_argv *argv_c,
+			      int sdHost, int pidHost,
+			      int draw_action)
+{
+	plugin_kvm_context *plugin_ctx = __get_context(sdHost);
+	if (!plugin_ctx)
+		return;
+
+	drawVirtCombos(argv_c,
+		       sdHost,
+		       pidHost,
+		       plugin_ctx->vm_entry_id,
+		       plugin_ctx->vm_exit_id,
+		       draw_action);
+}
diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
new file mode 100644
index 0000000..b3ec846
--- /dev/null
+++ b/src/plugins/KVMComboDialog.cpp
@@ -0,0 +1,350 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    KVMComboDialog.cpp
+ *  @brief   Dialog class used by the KVMCombo plugin.
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-tepdata.h"
+#include "plugins/kvm_combo.h"
+#include "KsMainWindow.hpp"
+#include "KVMComboDialog.hpp"
+
+using namespace KsWidgetsLib;
+
+static KsComboPlotDialog *combo_dialog(nullptr);
+
+static QMetaObject::Connection combo_dialogConnection;
+
+/** The name of the menu item used to start the dialog of the plugin. */
+#define DIALOG_NAME	"KVM Combo plots"
+
+static void showDialog(KsMainWindow *ks)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (kshark_ctx->n_streams < 2) {
+		QString err("Data from one Host and at least one Guest is required.");
+		QMessageBox msgBox;
+		msgBox.critical(nullptr, "Error", err);
+
+		return;
+	}
+
+	combo_dialog->update();
+
+	if (!combo_dialogConnection) {
+		combo_dialogConnection =
+			QObject::connect(combo_dialog,	&KsComboPlotDialog::apply,
+					 ks->graphPtr(),&KsTraceGraph::comboReDraw);
+	}
+
+	combo_dialog->show();
+}
+
+/** Add the dialog of the plugin to the KernelShark menus. */
+__hidden void *plugin_kvm_add_menu(void *ks_ptr)
+{
+	KsMainWindow *ks = static_cast<KsMainWindow *>(ks_ptr);
+	QString menu("Plots/");
+	menu += DIALOG_NAME;
+	ks->addPluginMenu(menu, showDialog);
+
+	if (!combo_dialog)
+		combo_dialog = new KsComboPlotDialog();
+
+	combo_dialog->_gui_ptr = ks;
+
+	return combo_dialog;
+}
+
+/**
+ * @brief Create KsCPUCheckBoxWidget.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsVCPUCheckBoxWidget::KsVCPUCheckBoxWidget(QWidget *parent)
+: KsCheckBoxTreeWidget(0, "vCPUs", parent)
+{
+	int height(FONT_HEIGHT * 1.5);
+	QString style;
+
+	style = QString("QTreeView::item { height: %1 ;}").arg(height);
+	_tree.setStyleSheet(style);
+
+	_initTree();
+}
+
+/**
+ * Update the widget according to the mapping between host processes and guest
+ * virtual CPUs.
+ */
+void KsVCPUCheckBoxWidget::update(int guestId,
+				  kshark_host_guest_map *gMap, int gMapCount)
+{
+	KsPlot::ColorTable colTable;
+	QColor color;
+	int j;
+
+	for (j = 0; j < gMapCount; j++)
+		if (gMap[j].guest_id == guestId)
+			break;
+	if (j == gMapCount)
+		return;
+
+	_tree.clear();
+	_id.resize(gMap[j].vcpu_count);
+	_cb.resize(gMap[j].vcpu_count);
+	colTable = KsPlot::CPUColorTable();
+
+	for (int i = 0; i < gMap[j].vcpu_count; ++i) {
+		QString strCPU = QLatin1String("vCPU ") + QString::number(i);
+		strCPU += (QLatin1String("\t<") + QLatin1String(gMap[j].guest_name) + QLatin1Char('>'));
+
+		QTreeWidgetItem *cpuItem = new QTreeWidgetItem;
+		cpuItem->setText(0, "  ");
+		cpuItem->setText(1, strCPU);
+		cpuItem->setCheckState(0, Qt::Checked);
+		color << colTable[i];
+		cpuItem->setBackground(0, color);
+		_tree.addTopLevelItem(cpuItem);
+		_id[i] = i;
+		_cb[i] = cpuItem;
+	}
+
+	_adjustSize();
+	setDefault(false);
+}
+
+//! @cond Doxygen_Suppress
+
+#define LABEL_WIDTH	(FONT_WIDTH * 50)
+
+//! @endcond
+
+/** Create default KsComboPlotDialog. */
+KsComboPlotDialog::KsComboPlotDialog(QWidget *parent)
+: QDialog(parent),
+  _vcpuTree(this),
+  _hostLabel("Host:", this),
+  _hostFileLabel("", this),
+  _guestLabel("Guest:", this),
+  _guestStreamComboBox(this),
+  _applyButton("Apply", this),
+  _cancelButton("Cancel", this),
+  _currentGuestStream(0)
+{
+	kshark_context *kshark_ctx(nullptr);
+	int buttonWidth;
+
+	auto lamAddLine = [&] {
+		QFrame* line = new QFrame();
+
+		line->setFrameShape(QFrame::HLine);
+		line->setFrameShadow(QFrame::Sunken);
+		_topLayout.addWidget(line);
+	};
+
+	setWindowTitle(DIALOG_NAME);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	_guestStreamComboBox.setMaximumWidth(LABEL_WIDTH);
+
+	_streamMenuLayout.addWidget(&_hostLabel, 0, 0);
+	_streamMenuLayout.addWidget(&_hostFileLabel, 0, 1);
+	_streamMenuLayout.addWidget(&_guestLabel, 1, 0);
+	_streamMenuLayout.addWidget(&_guestStreamComboBox, 1, 1);
+
+	_topLayout.addLayout(&_streamMenuLayout);
+
+	lamAddLine();
+
+	_topLayout.addWidget(&_vcpuTree);
+
+	lamAddLine();
+
+	buttonWidth = STRING_WIDTH("--Cancel--");
+	_applyButton.setFixedWidth(buttonWidth);
+	_cancelButton.setFixedWidth(buttonWidth);
+
+	_buttonLayout.addWidget(&_applyButton);
+	_applyButton.setAutoDefault(false);
+
+	_buttonLayout.addWidget(&_cancelButton);
+	_cancelButton.setAutoDefault(false);
+
+	_buttonLayout.setAlignment(Qt::AlignLeft);
+	_topLayout.addLayout(&_buttonLayout);
+
+	connect(&_applyButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	connect(&_cancelButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	/*
+	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
+	 * has overloads.
+	 */
+	connect(&_guestStreamComboBox,	SIGNAL(currentIndexChanged(const QString &)),
+		this,			SLOT(_guestStreamChanged(const QString &)));
+
+	setLayout(&_topLayout);
+
+	_guestMapCount = 0;
+	_guestMap = nullptr;
+}
+
+KsComboPlotDialog::~KsComboPlotDialog()
+{
+	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
+}
+
+/** Update the Plugin dialog. */
+void KsComboPlotDialog::update()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsPlot::ColorTable colTable;
+	QString streamName;
+	QColor color;
+	int ret, sd, i;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
+	_guestMap = nullptr;
+	_guestMapCount = 0;
+	ret = kshark_tracecmd_get_hostguest_mapping(&_guestMap);
+	if (ret <= 0) {
+		QString err("Cannot find host / guest tracing into the loaded streams");
+		QMessageBox msgBox;
+		msgBox.critical(nullptr, "Error", err);
+		return;
+	} else {
+		_guestMapCount = ret;
+	}
+
+	streamName = KsUtils::streamDescription(kshark_ctx->stream[_guestMap[0].host_id]);
+	KsUtils::setElidedText(&_hostFileLabel, streamName, Qt::ElideLeft, LABEL_WIDTH);
+
+	_guestStreamComboBox.clear();
+	colTable = KsPlot::streamColorTable();
+	for (i = 0; i < _guestMapCount; i++) {
+		sd = _guestMap[i].guest_id;
+		if (sd >= kshark_ctx->n_streams)
+			continue;
+
+		streamName = KsUtils::streamDescription(kshark_ctx->stream[sd]);
+		_guestStreamComboBox.addItem(streamName, sd);
+		color << colTable[sd];
+		_guestStreamComboBox.setItemData(i, QBrush(color),
+						    Qt::BackgroundRole);
+	}
+
+	if (!_applyButtonConnection) {
+		_applyButtonConnection =
+			connect(&_applyButton,	&QPushButton::pressed,
+				this,		&KsComboPlotDialog::_applyPress);
+	}
+
+	sd = _guestStreamComboBox.currentData().toInt();
+	_setCurrentPlots(sd);
+}
+
+int KsComboPlotDialog::_findGuestPlots(int sdGuest)
+{
+	for (int i = 0; i < _guestMapCount; i++)
+		if (_guestMap[i].guest_id == sdGuest)
+			return i;
+	return -1;
+}
+
+QVector<KsComboPlot> KsComboPlotDialog::_streamCombos(int sdGuest)
+{
+	QVector<int> cbVec = _vcpuTree.getCheckedIds();
+	int j = _findGuestPlots(sdGuest);
+	QVector <KsComboPlot> plots;
+	KsComboPlot combo(2);
+
+	if (j < 0)
+		return {};
+
+	for (auto const &i: cbVec) {
+		if (i >= _guestMap[j].vcpu_count)
+			continue;
+
+		combo[0]._streamId = _guestMap[j].guest_id;
+		combo[0]._id = i;
+		combo[0]._type = KSHARK_CPU_DRAW |
+				 KSHARK_GUEST_DRAW;
+
+		combo[1]._streamId = _guestMap[j].host_id;
+		combo[1]._id = _guestMap[j].cpu_pid[i];
+		combo[1]._type = KSHARK_TASK_DRAW |
+				 KSHARK_HOST_DRAW;
+
+		plots.append(combo);
+	}
+
+	return plots;
+}
+
+void KsComboPlotDialog::_applyPress()
+{
+	int guestId = _guestStreamComboBox.currentData().toInt();
+	QVector<int> allCombosVec;
+	int nPlots(0);
+
+	_plotMap[guestId] = _streamCombos(guestId);
+	for (auto const &stream: _plotMap)
+		for (auto const &combo: stream) {
+			allCombosVec.append(2);
+			combo[0] >> allCombosVec;
+			combo[1] >> allCombosVec;
+			++nPlots;
+		}
+
+	emit apply(nPlots, allCombosVec);
+}
+
+void KsComboPlotDialog::_setCurrentPlots(int sdGuest)
+{
+	QVector<KsComboPlot> currentCombos =_plotMap[sdGuest];
+	int i = _findGuestPlots(sdGuest);
+	if (i < 0 || _guestMap[i].vcpu_count <= 0)
+		return;
+
+	QVector<int> vcpuCBs(_guestMap[i].vcpu_count, 0);
+	for(auto const &p: currentCombos)
+		vcpuCBs[p[0]._id] = 1;
+
+	_vcpuTree.set(vcpuCBs);
+}
+
+void KsComboPlotDialog::_guestStreamChanged(const QString &sdStr)
+{
+	if (sdStr.isEmpty())
+		return;
+
+	int newGuestId = _guestStreamComboBox.currentData().toInt();
+	QVector<int> vcpuCBs(_guestMapCount, 0);
+
+	_plotMap[_currentGuestStream] = _streamCombos(_currentGuestStream);
+
+	_vcpuTree.update(newGuestId, _guestMap, _guestMapCount);
+	_setCurrentPlots(newGuestId);
+
+	_currentGuestStream = newGuestId;
+}
diff --git a/src/plugins/KVMComboDialog.hpp b/src/plugins/KVMComboDialog.hpp
new file mode 100644
index 0000000..52e7e92
--- /dev/null
+++ b/src/plugins/KVMComboDialog.hpp
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KVMComboDialog.hpp
+ *  @brief   Plugin for visualization of KVM events.
+ */
+
+#ifndef _KS_COMBO_DIALOG_H
+#define _KS_COMBO_DIALOG_H
+
+#include "KsMainWindow.hpp"
+#include "KsWidgetsLib.hpp"
+
+/**
+ * The KsVCPUCheckBoxWidget class provides a widget for selecting CPU plots to
+ * show.
+ */
+struct KsVCPUCheckBoxWidget : public KsWidgetsLib::KsCheckBoxTreeWidget
+{
+	explicit KsVCPUCheckBoxWidget(QWidget *parent = nullptr);
+
+	void update(int GuestId,
+		    struct kshark_host_guest_map *gMap, int gMapCount);
+};
+
+/**
+ * The KsComboPlotDialog class provides a widget for selecting Combo plots to
+ * show.
+ */
+class KsComboPlotDialog : public QDialog
+{
+	Q_OBJECT
+public:
+	explicit KsComboPlotDialog(QWidget *parent = nullptr);
+
+	~KsComboPlotDialog();
+
+	void update();
+
+	/** KernelShark GUI (main window) object. */
+	KsMainWindow	*_gui_ptr;
+
+signals:
+	/** Signal emitted when the "Apply" button is pressed. */
+	void apply(int sd, QVector<int>);
+
+private:
+	int				_guestMapCount;
+
+	struct kshark_host_guest_map	*_guestMap;
+
+	KsVCPUCheckBoxWidget		_vcpuTree;
+
+	QVBoxLayout			_topLayout;
+
+	QGridLayout			_streamMenuLayout;
+
+	QHBoxLayout			_buttonLayout;
+
+	QLabel				_hostLabel, _hostFileLabel, _guestLabel;
+
+	QComboBox			_guestStreamComboBox;
+
+	QPushButton			_applyButton, _cancelButton;
+
+	QMetaObject::Connection		_applyButtonConnection;
+
+	QMap<int, QVector<KsComboPlot>>	_plotMap;
+
+	int	_currentGuestStream;
+
+	int _findGuestPlots(int sdGuest);
+
+	QVector<KsComboPlot> _streamCombos(int sdGuest);
+
+	void _setCurrentPlots(int guestSd);
+
+	void _applyPress();
+
+private slots:
+
+	void _guestStreamChanged(const QString&);
+};
+
+#endif
diff --git a/src/plugins/VirtComboPlotTools.hpp b/src/plugins/VirtComboPlotTools.hpp
new file mode 100644
index 0000000..4daea79
--- /dev/null
+++ b/src/plugins/VirtComboPlotTools.hpp
@@ -0,0 +1,171 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    VirtComboPlotTools.hpp
+ *  @brief   Tools for plotting Virt Combs.
+ */
+
+// C++
+#include <iostream>
+
+// KernelShark
+#include "KsPlugins.hpp"
+#include "KsPlotTools.hpp"
+
+static void drawVirt(kshark_trace_histo *histo,
+		     KsPlot::Graph *hostGraph,
+		     int sdHost, int pidHost,
+		     int vcpuEntryId, int vcpuExitId,
+		     KsPlot::PlotObjList *shapes)
+{
+	int guestBaseY = hostGraph->bin(0)._base.y() - hostGraph->height();
+	int gapHeight = hostGraph->height() * .3;
+	KsPlot::VirtBridge *bridge = new KsPlot::VirtBridge();
+	KsPlot::VirtGap *gap = new KsPlot::VirtGap(gapHeight);
+	const kshark_entry *entry, *exit;
+	ssize_t indexEntry, indexExit;
+	int values[2] = {-1, pidHost};
+
+	bridge->_size = 2;
+	bridge->_visible = false;
+	bridge->setEntryHost(hostGraph->bin(0)._base.x(), guestBaseY);
+	bridge->setEntryGuest(hostGraph->bin(0)._base.x(), guestBaseY);
+
+	gap->_size = 2;
+	gap->_visible = false;
+	gap->_exitPoint = KsPlot::Point(hostGraph->bin(0)._base.x(),
+					guestBaseY);
+
+	auto lamStartBridg = [&] (int bin) {
+		if (!bridge)
+			bridge = new KsPlot::VirtBridge();
+
+		bridge->setEntryHost(hostGraph->bin(bin)._base.x(),
+				     hostGraph->bin(bin)._base.y());
+
+		bridge->setEntryGuest(hostGraph->bin(bin)._base.x(),
+				      guestBaseY);
+
+		bridge->_color = hostGraph->bin(bin)._color;
+	};
+
+	auto lamCloseBridg = [&] (int bin) {
+		if (!bridge)
+			return;
+
+		bridge->setExitGuest(hostGraph->bin(bin)._base.x(),
+				     guestBaseY);
+
+		bridge->setExitHost(hostGraph->bin(bin)._base.x(),
+				    hostGraph->bin(bin)._base.y());
+
+		bridge->_color = hostGraph->bin(bin)._color;
+		bridge->_visible = true;
+		bridge->_size = -1; // Default size
+
+		shapes->push_front(bridge);
+		bridge = nullptr;
+	};
+
+	auto lamStartGap = [&] (int bin) {
+		if (!gap)
+			gap = new KsPlot::VirtGap(gapHeight);
+
+		gap->_exitPoint =
+			KsPlot::Point(hostGraph->bin(bin)._base.x(),
+				      guestBaseY);
+	};
+
+	auto lamCloseGap = [&] (int bin) {
+		if (!gap)
+			return;
+
+		gap->_entryPoint =
+			KsPlot::Point(hostGraph->bin(bin)._base.x(),
+				      guestBaseY);
+
+		gap->_visible = true;
+		gap->_size = -1; // Default size
+
+		shapes->push_front(gap);
+		gap = nullptr;
+	};
+
+	for (int bin = 0; bin < histo->n_bins; ++bin) {
+		values[0] = vcpuEntryId;
+		entry = ksmodel_get_entry_back(histo, bin, true,
+					       kshark_match_event_and_pid,
+					       sdHost, values,
+					       nullptr, &indexEntry);
+
+		values[0] = vcpuExitId;
+		exit = ksmodel_get_entry_back(histo, bin, true,
+					      kshark_match_event_and_pid,
+					      sdHost, values,
+					      nullptr, &indexExit);
+
+		if (entry && !exit) {
+			lamStartBridg(bin);
+			lamCloseGap(bin);
+		}
+
+		if (exit && !entry) {
+			lamCloseBridg(bin);
+			lamStartGap(bin);
+		}
+
+		if (exit && entry) {
+			if (bridge && bridge->_visible)
+				lamCloseBridg(bin);
+
+			if (gap && gap->_visible)
+				lamCloseGap(bin);
+
+			if (indexEntry > indexExit) {
+				lamStartBridg(bin);
+			} else {
+				lamStartBridg(bin);
+				lamCloseBridg(bin);
+				lamStartGap(bin);
+			}
+		}
+	}
+
+	if (bridge && bridge->_visible) {
+		bridge->setExitGuest(hostGraph->bin(histo->n_bins - 1)._base.x(),
+				     guestBaseY);
+
+		bridge->setExitHost(hostGraph->bin(histo->n_bins - 1)._base.x(),
+				    guestBaseY);
+		bridge->_size = -1; // Default size
+
+		shapes->push_front(bridge);
+	}
+}
+
+static void drawVirtCombos(kshark_cpp_argv *argv_c,
+			   int sdHost, int pidHost,
+			   int entryId, int exitId,
+			   int draw_action)
+{
+	KsCppArgV *argvCpp;
+
+	if (!(draw_action & KSHARK_HOST_DRAW) || pidHost == 0)
+		return;
+
+	argvCpp = KS_ARGV_TO_CPP(argv_c);
+	try {
+		drawVirt(argvCpp->_histo,
+			 argvCpp->_graph,
+			 sdHost, pidHost,
+			 entryId,
+			 exitId,
+			 argvCpp->_shapes);
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in drawVirtCombos()\n" << exc.what();
+	}
+}
diff --git a/src/plugins/kvm_combo.c b/src/plugins/kvm_combo.c
new file mode 100644
index 0000000..87398e6
--- /dev/null
+++ b/src/plugins/kvm_combo.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    kvm_combo.c
+ *  @brief   Plugin for visualization of KVM events.
+ */
+
+// C
+#include <assert.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+// KernelShark
+#include "plugins/kvm_combo.h"
+#include "libkshark-plugin.h"
+#include "libkshark-tepdata.h"
+
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_kvm_context, free);
+
+static bool plugin_kvm_init_context(struct kshark_data_stream *stream,
+				    struct plugin_kvm_context *plugin_ctx)
+{
+	plugin_ctx->vm_entry_id = kshark_find_event_id(stream, "kvm/kvm_entry");
+	plugin_ctx->vm_exit_id = kshark_find_event_id(stream, "kvm/kvm_exit");
+	if (plugin_ctx->vm_entry_id < 0 ||
+	    plugin_ctx->vm_exit_id < 0)
+		return false;
+
+	return true;
+}
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_kvm_context *plugin_ctx = __init(stream->stream_id);
+
+	if (!plugin_ctx || !plugin_kvm_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
+	}
+
+	kshark_register_draw_handler(stream, draw_kvm_combos);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_kvm_context *plugin_ctx = __get_context(stream->stream_id);
+	int ret = 0;
+
+	if (plugin_ctx) {
+		kshark_unregister_draw_handler(stream, draw_kvm_combos);
+		ret = 1;
+	}
+
+	__close(stream->stream_id);
+
+	return ret;
+}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
+{
+	return plugin_kvm_add_menu(gui_ptr);
+}
diff --git a/src/plugins/kvm_combo.h b/src/plugins/kvm_combo.h
new file mode 100644
index 0000000..86d0da9
--- /dev/null
+++ b/src/plugins/kvm_combo.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <ykaradzov@vmware.com>
+ */
+
+/**
+ *  @file    kvm_combo.h
+ *  @brief   Plugin for visualization of KVM events.
+ */
+
+#ifndef _KS_PLUGIN_KVM_COMBO_H
+#define _KS_PLUGIN_KVM_COMBO_H
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/** Structure representing a plugin-specific context. */
+struct plugin_kvm_context {
+	/** Input handle for the trace data file. */
+	struct tracecmd_input	*handle;
+
+	/** Page event used to parse the page. */
+	struct tep_handle	*pevent;
+
+	/** kvm_entry Id. */
+	int vm_entry_id;
+
+	/** kvm_exit Id. */
+	int vm_exit_id;
+};
+
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_kvm_context)
+
+void draw_kvm_combos(struct kshark_cpp_argv *argv,
+		     int sd, int pid, int draw_action);
+
+void *plugin_kvm_add_menu(void *ks_ptr);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index f96b3dd..031e836 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -149,6 +149,7 @@ BOOST_AUTO_TEST_CASE(KsUtils_getPluginList)
 	QStringList plugins{"sched_events",
 			    "event_field_plot",
 			    "latency_plot",
+			    "kvm_combo",
 			    "missed_events"
 	};
 
-- 
2.27.0

