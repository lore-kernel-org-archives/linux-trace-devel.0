Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1122EC2BB55
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D134B217D8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvuB3X/d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636422AbgDPQBE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636481AbgDPQA6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 12:00:58 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8737CC0610D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:57 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 198so5988830lfo.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4E7eTVb/T40qymVViOv/rYJ9j9vTRKLYbtX1hX7CAf8=;
        b=BvuB3X/dJ0nCKM8U7bpvoBV4KP33axCxGS+8ehVm9erboByXj0J8sWzytdMHLi3A7p
         4IusbCr9zb6GKATT8BH6j2jHBERO3nAYLw+opz1VO01Mj+7iB9s24jHmqRST0KqXgtPC
         ygaDFew764mg90aObkl+ZUqdcC5S3E6kPrApShP85LTSDGPwlOTFk+L7j00aAazrdViK
         rqhZss9ShezUimjsivKCQzEkljjZCV/6+22YFGbPTbrbKdlMu7K9fPO+ZVFHDuXKorXj
         ZDasZZP/0XnCVS4lXyX0HsnLSoJMf7uFR4gFXBwqSaivS97DTTpzG2/NILpvqxoDVtKf
         i0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4E7eTVb/T40qymVViOv/rYJ9j9vTRKLYbtX1hX7CAf8=;
        b=DpMtZyh8DRl4jOj6Bq2kVSUQ3SGD/iDI1h0708lIyl1SUYcn6F9YmoKVb2SXGTEAc3
         lslC0jTo1kqx/mfdm3YdL1dUV7UK28HAQXt0l1dCTrUb9CdMHiTCbtvDYDXJbqFfirYh
         b/OrVVh+leaOdqeDjnfarn6rrxY0/i578izswoZY5j6ZC3/CBEAEZi1zcgMZ3C6jXjrk
         w7vtmZqw14FOLrTZJ84T4/Mw0pz0dnCw9nOvxwHToooBBBUywY+m6iQJnKLyow6sYBLc
         F7/jEo/7mt8KCRJq42f+zn21wHxJ9cQgOdSXCL/CDx4bQSL8hgdMS8M1DlZksNkQUDqL
         7lXw==
X-Gm-Message-State: AGi0PuYY9pJd3G4sSqkH9RvDQiMYDVI5d2VYtQEbmZ/xxDWUbqa20Ot/
        //y270r/98mB8Rvw5vn44SqT6kjlJzA=
X-Google-Smtp-Source: APiQypKJjW4Neis75yJ9kgQ/ADI5ywfY82FDhOdr96tGb67/yYg5C2XN37JC6QDzK4DaVTspAZTleQ==
X-Received: by 2002:ac2:515d:: with SMTP id q29mr6414043lfd.210.1587052855896;
        Thu, 16 Apr 2020 09:00:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u2sm9030413lfk.67.2020.04.16.09.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:00:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/5] kernel-shark-2.alpha: Restructure KVMCombo plugin to use CPU mapping information from the trace files
Date:   Thu, 16 Apr 2020 19:00:47 +0300
Message-Id: <20200416160047.77118-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416160047.77118-1-tz.stoyanov@gmail.com>
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
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
 src/libkshark-tepdata.c  | 116 ++++++++++++++++++++++++++++
 src/libkshark-tepdata.h  |  10 +++
 src/plugins/KVMCombo.cpp | 158 ++++++++++++++++-----------------------
 src/plugins/KVMCombo.hpp |  16 ++--
 4 files changed, 197 insertions(+), 103 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index f280e57..048981e 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -22,6 +22,7 @@
 #include "tracefs/tracefs.h"
 
 // KernelShark
+#include "libkshark.h"
 #include "libkshark-plugin.h"
 #include "libkshark-tepdata.h"
 
@@ -1293,3 +1294,118 @@ char **kshark_tracecmd_local_plugins()
 {
 	return tracefs_tracers(tracefs_get_tracing_dir());
 }
+
+/**
+ * @brief Free an array, allocated by kshark_tracecmd_get_hostguest_mapping() API
+ *
+ *
+ * @param map: Array, allocated by kshark_tracecmd_get_hostguest_mapping() API
+ * @param count: Number of entries in the array
+ *
+ */
+void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count)
+{
+	int i;
+
+	if (!map)
+		return;
+	for (i = 0; i < count; i++) {
+		free(map[i].guest_name);
+		free(map[i].cpu_pid);
+		memset(&map[i], 0, sizeof(*map));
+	}
+	free(map);
+}
+
+/**
+ * @brief Get mapping of guest VCPU to host task, running that VCPU.
+ *	  Array of mappings for each guest is allocated and returned
+ *	  in map input parameter.
+ *
+ *
+ * @param map: Returns allocated array of kshark_host_guest_map structures, each
+ *	       one describing VCPUs mapping of one guest.
+ *
+ * @return The number of entries in the *map array, or a negative error code on
+ *	   failure.
+ */
+int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map)
+{
+	struct kshark_host_guest_map *gmap = NULL;
+	struct tracecmd_input *peer_handle = NULL;
+	struct kshark_data_stream *peer_stream;
+	struct tracecmd_input *guest_handle = NULL;
+	struct kshark_data_stream *guest_stream;
+	struct kshark_context *kshark_ctx = NULL;
+	unsigned long long trace_id;
+	const char *name;
+	int vcpu_count;
+	const int *cpu_pid;
+	int *streamIds;
+	int i, j, k;
+	int count = 0;
+	int ret;
+
+	if (!map || !kshark_instance(&kshark_ctx))
+		return -EFAULT;
+	if (*map)
+		return -EEXIST;
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
+			if (!ret && vcpu_count) {
+				gmap = realloc(*map,
+					       (count + 1) * sizeof(struct kshark_host_guest_map));
+				if (!gmap)
+					goto mem_error;
+				*map = gmap;
+				memset(&gmap[count], 0, sizeof(struct kshark_host_guest_map));
+				count++;
+				gmap[count - 1].guest_id = streamIds[i];
+				gmap[count - 1].host_id = streamIds[j];
+				gmap[count - 1].guest_name = strdup(name);
+				if (!gmap[count - 1].guest_name)
+					goto mem_error;
+				gmap[count - 1].vcpu_count = vcpu_count;
+				gmap[count - 1].cpu_pid = malloc(sizeof(int) * vcpu_count);
+				if (!gmap[count - 1].cpu_pid)
+					goto mem_error;
+				for (k = 0; k < vcpu_count; k++)
+					gmap[count - 1].cpu_pid[k] = cpu_pid[k];
+				break;
+			}
+		}
+	}
+
+	free(streamIds);
+	return count;
+
+mem_error:
+	free(streamIds);
+	if (*map) {
+		kshark_tracecmd_free_hostguest_map(*map, count);
+		*map = NULL;
+	}
+
+	return -ENOMEM;
+}
diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
index 53f6aff..76f488e 100644
--- a/src/libkshark-tepdata.h
+++ b/src/libkshark-tepdata.h
@@ -59,6 +59,16 @@ struct tep_record;
 ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
 				struct tep_record ***data_rows);
 
+struct kshark_host_guest_map {
+	int guest_id;		/* ID of guest stream */
+	int host_id;		/* ID of host stream */
+	char *guest_name;	/* Guest name */
+	int vcpu_count;		/* Number of guest's CPUs in *cpu_pid array */
+	int *cpu_pid;		/* Array of host task PIDs, index is the VCPU id */
+};
+void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count);
+int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index 1ae03aa..66bfab9 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -69,20 +69,30 @@ KsVCPUCheckBoxWidget::KsVCPUCheckBoxWidget(QWidget *parent)
 	_initTree();
 }
 
-void KsVCPUCheckBoxWidget::update(int sdHost, VCPUVector vcpus)
+void KsVCPUCheckBoxWidget::update(int GuestId,
+				  struct kshark_host_guest_map *gMap, int gMapCount)
 {
-	int nVCPUs = vcpus.count();
 	KsPlot::ColorTable colors;
+	int j;
+
+	for (j = 0; j < gMapCount; j++)
+		if (gMap[j].guest_id == GuestId)
+			break;
+	if (j == gMapCount)
+		return;
 
 	_tree.clear();
-	_id.resize(nVCPUs);
-	_cb.resize(nVCPUs);
+	_id.resize(gMap[j].vcpu_count);
+	_cb.resize(gMap[j].vcpu_count);
 	colors = KsPlot::getCPUColorTable();
 
-	for (int i = 0; i < nVCPUs; ++i) {
+	for (int i = 0; i < gMap[j].vcpu_count; ++i) {
+		QString strCPU = QLatin1String("vCPU ") + QString::number(i);
+		strCPU += (QLatin1String("\t<") + QLatin1String(gMap[j].guest_name) + QLatin1Char('>'));
+
 		QTreeWidgetItem *cpuItem = new QTreeWidgetItem;
 		cpuItem->setText(0, "  ");
-		cpuItem->setText(1, QString("vCPU %1").arg(vcpus.at(i).second));
+		cpuItem->setText(1, strCPU);
 		cpuItem->setCheckState(0, Qt::Checked);
 		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
 						      colors[i].g(),
@@ -168,26 +178,43 @@ KsComboPlotDialog::KsComboPlotDialog(QWidget *parent)
 		this,			SLOT(_guestStreamChanged(const QString &)));
 
 	setLayout(&_topLayout);
+
+	_guestMapCount = 0;
+	_guestMap = NULL;
 }
 
-void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
+KsComboPlotDialog::~KsComboPlotDialog()
+{
+	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
+	_guestMap = NULL;
+	_guestMapCount = 0;
+}
+
+void KsComboPlotDialog::update()
 {
 	kshark_context *kshark_ctx(nullptr);
-	int sd, *streamIds;
+	int ret;
+	int sd;
+	int i;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	_sdHost = sdHost;
-	_vcpus = vcpus;
+	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
+	_guestMap = NULL;
+	_guestMapCount = 0;
+	ret = kshark_tracecmd_get_hostguest_mapping(&_guestMap);
+	if (ret > 0)
+		_guestMapCount = ret;
+
 	KsUtils::setElidedText(&_hostFileLabel,
-			       kshark_ctx->stream[sdHost]->file,
+			       kshark_ctx->stream[_guestMap[0].host_id]->file,
 			       Qt::ElideLeft, LABEL_WIDTH);
 
-	streamIds = kshark_all_streams(kshark_ctx);
-	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
-		sd = streamIds[i];
-		if (sd == sdHost)
+	_guestStreamComboBox.clear();
+	for (i = 0; i < _guestMapCount; i++) {
+		sd = _guestMap[i].guest_id;
+		if (sd >= kshark_ctx->n_streams)
 			continue;
 
 		_guestStreamComboBox.addItem(kshark_ctx->stream[sd]->file,
@@ -200,8 +227,8 @@ void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
 				this,		&KsComboPlotDialog::_applyPress);
 	}
 
-	_vcpuTree.update(sdHost, vcpus);
-	free(streamIds);
+	sd = _guestStreamComboBox.currentData().toInt();
+	_vcpuTree.update(sd, _guestMap, _guestMapCount);
 }
 
 void KsComboPlotDialog::_applyPress()
@@ -210,6 +237,16 @@ void KsComboPlotDialog::_applyPress()
 	QVector<int> allCombosVec;
 	KsComboPlot combo(2);
 	int nPlots(0);
+	int GuestId;
+	int j;
+
+	GuestId = _guestStreamComboBox.currentData().toInt();
+	for (j = 0; j < _guestMapCount; j++)
+		if (_guestMap[j].guest_id == GuestId)
+			break;
+	if (j == _guestMapCount)
+		return;
+
 
 	/*
 	 * Disconnect _applyButton. This is done in order to protect
@@ -218,17 +255,20 @@ void KsComboPlotDialog::_applyPress()
 	disconnect(_applyButtonConnection);
 
 	for (auto const &i: cbVec) {
+		if (i >= _guestMap[j].vcpu_count)
+			continue;
+
 		allCombosVec.append(2);
 
-		combo[0]._streamId = _guestStreamComboBox.currentData().toInt();
-		combo[0]._id = _vcpus.at(i).second;
+		combo[0]._streamId = _guestMap[j].guest_id;
+		combo[0]._id = i;
 		combo[0]._type = KsPlot::KSHARK_CPU_DRAW |
 				 KsPlot::KSHARK_GUEST_DRAW;
 
 		combo[0] >> allCombosVec;
 
-		combo[1]._streamId = _sdHost;
-		combo[1]._id = _vcpus.at(i).first;
+		combo[1]._streamId = _guestMap[j].host_id;
+		combo[1]._id = _guestMap[j].cpu_pid[i];
 		combo[1]._type = KsPlot::KSHARK_TASK_DRAW |
 				 KsPlot::KSHARK_HOST_DRAW;
 
@@ -241,66 +281,8 @@ void KsComboPlotDialog::_applyPress()
 
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
+	_vcpuTree.update(GuestId, _guestMap, _guestMapCount);
 }
 
 KsComboPlotDialog dialog;
@@ -309,18 +291,11 @@ QMetaObject::Connection dialogConnection;
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
@@ -328,10 +303,7 @@ static void showDialog(KsMainWindow *ks)
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
index b47f557..ecb9aeb 100644
--- a/src/plugins/KVMCombo.hpp
+++ b/src/plugins/KVMCombo.hpp
@@ -15,10 +15,6 @@
 #include "KsMainWindow.hpp"
 #include "KsWidgetsLib.hpp"
 
-typedef QVector<QPair<int, int>> VCPUVector;
-
-typedef QMap<int, VCPUVector> HostMap;
-
 /**
  * The KsVCPUCheckBoxWidget class provides a widget for selecting CPU plots to
  * show.
@@ -27,7 +23,8 @@ struct KsVCPUCheckBoxWidget : public KsWidgetsLib::KsCheckBoxTreeWidget
 {
 	explicit KsVCPUCheckBoxWidget(QWidget *parent = nullptr);
 
-	void update(int sdHost, VCPUVector vcpus);
+	void update(int GuestId,
+		    struct kshark_host_guest_map *gMap, int gMapCount);
 };
 
 /**
@@ -39,17 +36,16 @@ class KsComboPlotDialog : public QDialog
 	Q_OBJECT
 public:
 	explicit KsComboPlotDialog(QWidget *parent = nullptr);
-
-	void update(int sdHost, VCPUVector vcpus);
+	~KsComboPlotDialog();
+	void update();
 
 signals:
 	/** Signal emitted when the "Apply" button is pressed. */
 	void apply(int sd, QVector<int>);
 
 private:
-	int				_sdHost;
-
-	VCPUVector			_vcpus;
+	int				_guestMapCount;
+	struct kshark_host_guest_map 	*_guestMap;
 
 	KsVCPUCheckBoxWidget		_vcpuTree;
 
-- 
2.25.1

