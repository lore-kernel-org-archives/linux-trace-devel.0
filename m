Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D229CC2BB86
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E69920771
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSK4+522"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgDIOZS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:25:18 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:42182 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbgDIOZS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:18 -0400
Received: by mail-lj1-f178.google.com with SMTP id q19so11606898ljp.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 07:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CEsiLO/4LFEoFcn8EaXgJx1Vvb/8n3UjnN+SlB+ioTY=;
        b=XSK4+522TprSwhnoEaeiF4m1/jBJLOswGTBeul+qZm8JsltXcMWlaXU0ndMXyBS0Qz
         y4M6Pz06INAczIh0C1ka75n3uPmTRCw+sZtlo2/XE1KKD8kqI8A90Q7T6eeFET/KVWNa
         W3SdZI88I6NyW4nUAhdDhGYtkmavXuav9S3hpFRurH4bOqBtJML+XLcbhpEymBCveFa4
         je204sYR5/3tocmc+rB8tzNIO27OhF/5G4iila/Lgl21agGA7TKjRHW2UvbuJJVCtLu6
         xlKsbhUJZNjsFtjkQeuLm5mzzlLdywmwktSMoIbpD3MY136eCNpDGpGKpaqX/3ZqXifr
         PkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CEsiLO/4LFEoFcn8EaXgJx1Vvb/8n3UjnN+SlB+ioTY=;
        b=PflT7hf7NVFOHd5xcCASAkVYk+s0NhiVWJ4VTTue7hwc/Gf74zDXF+0mTW3zcwEhCt
         h7v7WNvlzFwaJwOKJm4MpApeXy9yYvtfC6oN87yATv7kU4PDClE7MQPvilMVuw990DPf
         EnP9SUMnJ30+f1MgdNE3LSWQB9aczz9ZKscgRml2qNliobyAdkp92OJH/OH3oBPWWxCj
         c4g4J/7/7wi2xHSrAw45Cy32EFRIzZCybiNoO19sDU8CISibvOsOjWlAcYPOlSLY+thk
         OUzwak4gyexSdw18Z9+yl6Ted1WxkA85qwEyGorDeJ0t4LORujvyFTvJ1WbI9CkpbJ+6
         iO6w==
X-Gm-Message-State: AGi0PuYuMRscmJ21TVu9bhgs0M0xDQ8o5mTi1bl5b6zgxzKmtd5Xwq1D
        MtvAxFwtdcL3U/ue1jV+eZIEcsu+8jU=
X-Google-Smtp-Source: APiQypJCet3u5XNLmEcB/5xiVqbSRjdsuNEo9qqimkZjM2NYtPIpo3IcJwQY85/cwIPVv1oZccAhZw==
X-Received: by 2002:a2e:9ac9:: with SMTP id p9mr30280ljj.222.1586442317030;
        Thu, 09 Apr 2020 07:25:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm181230lfc.72.2020.04.09.07.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:25:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark-2.alpha: Restructure KVMCombo plugin to use CPU mapping information from the trace files
Date:   Thu,  9 Apr 2020 17:25:09 +0300
Message-Id: <20200409142511.82228-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409142511.82228-1-tz.stoyanov@gmail.com>
References: <20200409142511.82228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

In the upcoming trace-cmd 2.9, extra information about host and guest tracing
will be stored in the trace.dat files. Information about host CPU - guest vCPU
mapping will be saved in host trace file. This mapping is mandatory for KVMCombo
plugin. Currently, the mapping is extracted for the tracing data.
Getting the information from the trace files is more reliable and solves the use
case with more than one guest.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/plugins/KVMCombo.cpp | 203 ++++++++++++++++++++++-----------------
 src/plugins/KVMCombo.hpp |  14 +--
 2 files changed, 120 insertions(+), 97 deletions(-)

diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index 1ae03aa..25c2331 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -69,10 +69,19 @@ KsVCPUCheckBoxWidget::KsVCPUCheckBoxWidget(QWidget *parent)
 	_initTree();
 }
 
-void KsVCPUCheckBoxWidget::update(int sdHost, VCPUVector vcpus)
+void KsVCPUCheckBoxWidget::update(int GuestId, GuestMap *gMap, GuestName *gName)
 {
-	int nVCPUs = vcpus.count();
 	KsPlot::ColorTable colors;
+	VCPUVector VCPUs;
+	HostPair Host;
+	int nVCPUs;
+
+	if (!gMap->contains(GuestId) || !gName->contains(GuestId))
+		return;
+
+	Host = gMap->value(GuestId);
+	VCPUs = Host.second;
+	nVCPUs = VCPUs.count();
 
 	_tree.clear();
 	_id.resize(nVCPUs);
@@ -80,9 +89,12 @@ void KsVCPUCheckBoxWidget::update(int sdHost, VCPUVector vcpus)
 	colors = KsPlot::getCPUColorTable();
 
 	for (int i = 0; i < nVCPUs; ++i) {
+		QString strCPU = QLatin1String("vCPU ") + QString::number(VCPUs.at(i).second);
+		strCPU += (QLatin1String("\t<") + gName->value(GuestId) + QLatin1Char('>'));
+
 		QTreeWidgetItem *cpuItem = new QTreeWidgetItem;
 		cpuItem->setText(0, "  ");
-		cpuItem->setText(1, QString("vCPU %1").arg(vcpus.at(i).second));
+		cpuItem->setText(1, strCPU);
 		cpuItem->setCheckState(0, Qt::Checked);
 		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
 						      colors[i].g(),
@@ -96,6 +108,65 @@ void KsVCPUCheckBoxWidget::update(int sdHost, VCPUVector vcpus)
 	setDefault(false);
 }
 
+static void getGuestMap(GuestMap *gMap, GuestName *gName)
+{
+	struct tracecmd_input *peer_handle = NULL;
+	struct kshark_data_stream *peer_stream;
+	struct tracecmd_input *guest_handle = NULL;
+	struct kshark_data_stream *guest_stream;
+	kshark_context *kshark_ctx(nullptr);
+	unsigned long long trace_id;
+	int ret;
+	const char *name;
+	int vcpu_count;
+	const int *cpu_pid;
+	int *streamIds;
+	int i, j, k;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	gMap->clear();
+	gName->clear();
+
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (i = 0; i < kshark_ctx->n_streams; i++) {
+		guest_stream = kshark_get_data_stream(kshark_ctx, streamIds[i]);
+		if (!guest_stream || guest_stream->format != KS_TEP_DATA)
+			continue;
+		guest_handle = kshark_get_tep_input(guest_stream);
+		if (!guest_handle)
+			continue;
+		trace_id = tracecmd_get_traceid(guest_handle);
+		if (!trace_id)
+			continue;
+		for (j = 0; j < kshark_ctx->n_streams; j++) {
+			if (streamIds[i] == streamIds[j])
+				continue;
+			peer_stream = kshark_get_data_stream(kshark_ctx, streamIds[j]);
+			if (!peer_stream || peer_stream->format != KS_TEP_DATA)
+				continue;
+			peer_handle = kshark_get_tep_input(peer_stream);
+			if (!peer_handle)
+				continue;
+			ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
+							&name, &vcpu_count, &cpu_pid);
+			if (!ret) {
+				VCPUVector vcpus(vcpu_count);
+				for (k = 0; k < vcpu_count; k++) {
+					vcpus[k].first = cpu_pid[k];
+					vcpus[k].second = k;
+				}
+				gMap->insert(streamIds[i], QPair<int, VCPUVector>(streamIds[j], vcpus));
+				gName->insert(streamIds[i], QString(name));
+				break;
+			}
+		}
+	}
+
+	free(streamIds);
+}
+
 #define DIALOG_NAME	"KVM Combo plots"
 
 #define LABEL_WIDTH	(FONT_WIDTH * 50)
@@ -170,24 +241,29 @@ KsComboPlotDialog::KsComboPlotDialog(QWidget *parent)
 	setLayout(&_topLayout);
 }
 
-void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
+void KsComboPlotDialog::update()
 {
 	kshark_context *kshark_ctx(nullptr);
-	int sd, *streamIds;
+	GuestMap::iterator i;
+	VCPUVector Vect;
+	HostPair hPair;
+	int sd;
+	int j;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	_sdHost = sdHost;
-	_vcpus = vcpus;
+	getGuestMap(&_guestMap, &_guestName);
+
+	hPair = _guestMap.begin().value();
 	KsUtils::setElidedText(&_hostFileLabel,
-			       kshark_ctx->stream[sdHost]->file,
+			       kshark_ctx->stream[hPair.first]->file,
 			       Qt::ElideLeft, LABEL_WIDTH);
 
-	streamIds = kshark_all_streams(kshark_ctx);
-	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
-		sd = streamIds[i];
-		if (sd == sdHost)
+	_guestStreamComboBox.clear();
+	for (i = _guestMap.begin(); i != _guestMap.end(); ++i) {
+		sd = i.key();
+		if (sd >= kshark_ctx->n_streams)
 			continue;
 
 		_guestStreamComboBox.addItem(kshark_ctx->stream[sd]->file,
@@ -200,8 +276,8 @@ void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
 				this,		&KsComboPlotDialog::_applyPress);
 	}
 
-	_vcpuTree.update(sdHost, vcpus);
-	free(streamIds);
+	sd = _guestStreamComboBox.currentData().toInt();
+	_vcpuTree.update(sd, &_guestMap, &_guestName);
 }
 
 void KsComboPlotDialog::_applyPress()
@@ -210,6 +286,18 @@ void KsComboPlotDialog::_applyPress()
 	QVector<int> allCombosVec;
 	KsComboPlot combo(2);
 	int nPlots(0);
+	VCPUVector VCPUs;
+	HostPair Host;
+	int GuestId;
+	int nVCPUs;
+
+	GuestId = _guestStreamComboBox.currentData().toInt();
+	if (!_guestMap.contains(GuestId))
+		return;
+
+	Host = _guestMap.value(GuestId);
+	VCPUs = Host.second;
+	nVCPUs = VCPUs.count();
 
 	/*
 	 * Disconnect _applyButton. This is done in order to protect
@@ -218,17 +306,20 @@ void KsComboPlotDialog::_applyPress()
 	disconnect(_applyButtonConnection);
 
 	for (auto const &i: cbVec) {
+		if (i >= nVCPUs)
+			continue;
+
 		allCombosVec.append(2);
 
-		combo[0]._streamId = _guestStreamComboBox.currentData().toInt();
-		combo[0]._id = _vcpus.at(i).second;
+		combo[0]._streamId = GuestId;
+		combo[0]._id = VCPUs.at(i).second;
 		combo[0]._type = KsPlot::KSHARK_CPU_DRAW |
 				 KsPlot::KSHARK_GUEST_DRAW;
 
 		combo[0] >> allCombosVec;
 
-		combo[1]._streamId = _sdHost;
-		combo[1]._id = _vcpus.at(i).first;
+		combo[1]._streamId = Host.first;
+		combo[1]._id = VCPUs.at(i).first;
 		combo[1]._type = KsPlot::KSHARK_TASK_DRAW |
 				 KsPlot::KSHARK_HOST_DRAW;
 
@@ -241,66 +332,8 @@ void KsComboPlotDialog::_applyPress()
 
 void KsComboPlotDialog::_guestStreamChanged(const QString &sdStr)
 {
-
-}
-
-static int getVCPU(plugin_kvm_context *plugin_ctx,
-		   kshark_trace_histo *histo,
-		   int sdHost, int pid)
-{
-	int values[2] = {plugin_ctx->vm_entry_id, pid};
-	const kshark_entry *entry;
-	unsigned long long vcpu;
-
-	for (int b = 0; b < histo->n_bins; ++b) {
-		entry = ksmodel_get_entry_front(histo,
-						b, false,
-						kshark_match_event_and_pid,
-						sdHost, values,
-						nullptr,
-						nullptr);
-		if (!entry)
-			continue;
-
-		if (kshark_read_event_field(entry, "vcpu_id", &vcpu) >= 0)
-			return vcpu;
-	}
-
-	return -1;
-}
-
-HostMap getVCPUPids(kshark_context *kshark_ctx, kshark_trace_histo *histo)
-{
-	int sd, n_vcpus, *streamIds, *pids;
-	plugin_kvm_context *plugin_ctx;
-	HostMap hMap;
-
-	streamIds = kshark_all_streams(kshark_ctx);
-	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
-		sd = streamIds[i];
-		plugin_ctx = get_kvm_context(sd);
-		if (!plugin_ctx)
-			continue;
-
-		/* This stream contains KVM events. */
-		n_vcpus = plugin_ctx->vcpu_pids->count;
-		if (n_vcpus) {
-			VCPUVector vcpus(n_vcpus);
-			pids = kshark_hash_ids(plugin_ctx->vcpu_pids);
-			for (int j = 0; j < n_vcpus; ++j) {
-				vcpus[j].first = pids[j];
-				vcpus[j].second = getVCPU(plugin_ctx,
-							  histo,
-							  sd, pids[j]);
-			}
-
-			free(pids);
-			hMap[sd] = vcpus;
-		}
-	}
-
-	free(streamIds);
-	return hMap;
+	int GuestId = _guestStreamComboBox.currentData().toInt();
+	_vcpuTree.update(GuestId, &_guestMap, &_guestName);
 }
 
 KsComboPlotDialog dialog;
@@ -309,18 +342,11 @@ QMetaObject::Connection dialogConnection;
 static void showDialog(KsMainWindow *ks)
 {
 	kshark_context *kshark_ctx(nullptr);
-	kshark_trace_histo *histo;
-	VCPUVector vcpus;
-	HostMap hMap;
-	int sdHost;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	histo = ks->graphPtr()->glPtr()->model()->histo();
-	hMap = getVCPUPids(kshark_ctx, histo);
-
-	if (kshark_ctx->n_streams < 2 || hMap.count() != 1) {
+	if (kshark_ctx->n_streams < 2) {
 		QString err("Data from one Host and at least one Guest is required.");
 		QMessageBox msgBox;
 		msgBox.critical(nullptr, "Error", err);
@@ -328,10 +354,7 @@ static void showDialog(KsMainWindow *ks)
 		return;
 	}
 
-	sdHost = hMap.begin().key();
-	vcpus = hMap.begin().value();
-
-	dialog.update(sdHost, vcpus);
+	dialog.update();
 
 	if (!dialogConnection) {
 		dialogConnection =
diff --git a/src/plugins/KVMCombo.hpp b/src/plugins/KVMCombo.hpp
index b47f557..a343141 100644
--- a/src/plugins/KVMCombo.hpp
+++ b/src/plugins/KVMCombo.hpp
@@ -16,8 +16,9 @@
 #include "KsWidgetsLib.hpp"
 
 typedef QVector<QPair<int, int>> VCPUVector;
-
-typedef QMap<int, VCPUVector> HostMap;
+typedef QPair<int, VCPUVector> HostPair;
+typedef QMap<int, HostPair> GuestMap;
+typedef QMap<int, QString> GuestName;
 
 /**
  * The KsVCPUCheckBoxWidget class provides a widget for selecting CPU plots to
@@ -27,7 +28,7 @@ struct KsVCPUCheckBoxWidget : public KsWidgetsLib::KsCheckBoxTreeWidget
 {
 	explicit KsVCPUCheckBoxWidget(QWidget *parent = nullptr);
 
-	void update(int sdHost, VCPUVector vcpus);
+	void update(int GuestId, GuestMap *gMap, GuestName *gName);
 };
 
 /**
@@ -40,16 +41,15 @@ class KsComboPlotDialog : public QDialog
 public:
 	explicit KsComboPlotDialog(QWidget *parent = nullptr);
 
-	void update(int sdHost, VCPUVector vcpus);
+	void update();
 
 signals:
 	/** Signal emitted when the "Apply" button is pressed. */
 	void apply(int sd, QVector<int>);
 
 private:
-	int				_sdHost;
-
-	VCPUVector			_vcpus;
+	GuestMap			_guestMap;
+	GuestName			_guestName;
 
 	KsVCPUCheckBoxWidget		_vcpuTree;
 
-- 
2.25.1

