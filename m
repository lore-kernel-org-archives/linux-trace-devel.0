Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706D1C2D0E5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BCEC20732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JN9cNLwZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgC3QHt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:49 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:42282 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgC3QHs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:48 -0400
Received: by mail-lj1-f172.google.com with SMTP id q19so18636311ljp.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWh96pHtq2YEpJ8Ynyix67c4H8qqWnyhyeJxbDkHswA=;
        b=JN9cNLwZ5y4qg0vvBDE/MmPqwKshfiyLbvb9+F6h4ccDhNN0Y6pU30y1+JuF4IiFX0
         kF0j3air9DpPwoZTyKlLqnfhPCoDThZwpa/pMP94ox1jlyUbxZgOu1EZuNpx9KgymSUI
         LReofhYtV5G96DSnrxxsilsOqYpsp7rA1RycPFg9ti+qoBPmZcOcY/m30uYkkxmXOkAq
         8MpCByRzYBN33HWa7gLAMd5GA+Kb7gn3dZMhxVckdoxgC9xgHyHt0DTs/0MlKdKJn8yq
         X+3fMNsXb4s3W073uEA4ADMd1GxjYcNzbO59+ijD+Uw+mv4NDqjW7oePsTr6/rSmTeV6
         QF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWh96pHtq2YEpJ8Ynyix67c4H8qqWnyhyeJxbDkHswA=;
        b=NXfYc6kROfAxgqkINk4V+96XzmLrQKKT9vjMrCad/8RKJKVToo0XlqvsXHsN4/ncMj
         +0WQ4BeXiLrEcXSZGyZwmbaYV/9FZtpoBTiomh6THH29u8fpFBuVjo0DccAAWEbJMMAj
         b8XdkPzsnf62hIGwDLEIM4DAxBKE2wktF+GlDkYuIZ7/RsvHiOEwGteqHcEbekS+FBH0
         xrCg39h/KgZjw59eTM4enyDxzJtxsopCsVGrAEot8c7pEc1f4yPGXN2A+pJounul1OLJ
         WX0UA6rjt4h9+2Oisk33iMpJtGliomQCN90HY6uRjsBpfyvPISjeZ2Q9f2zlz31rRyRs
         P3hQ==
X-Gm-Message-State: AGi0PuYhcjuBp6BXmrUJUuFf+fw+tpuzCudyiSXFjus7dRdX8AJQdKnK
        gLVzRD+uqMCd62Xk2vV9IWg=
X-Google-Smtp-Source: APiQypJpcvbzstsEdBoSKu0rHYvO1HcR0G+/l6UV4m4bAsLX7nrQXWdgFu8siJhHCS/vWPyv8RODMA==
X-Received: by 2002:a2e:3203:: with SMTP id y3mr5288122ljy.54.1585584465996;
        Mon, 30 Mar 2020 09:07:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 6/6] kernel-shark: Optimize the logic of the filtering menus
Date:   Mon, 30 Mar 2020 19:06:52 +0300
Message-Id: <20200330160652.28424-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic of the menus is optimized to automatically decide whether is
more efficient to use positive (show only) or negative (do not show)
ID filter. Note that there is no difference between using positive or
negative filters in terms of performance, because the IDs of each filter
are stored in a hash table, hence the checks are made in constant time.
The motivation is just to keep the configuration of the filters as
simple as possible, in particular when we want this configuration to be
saved and later restored from the Session. The patch also fixes the
problem of negative filters set from the Quick Context menu not being
shown in the main filtering menus.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 193 ++++++++++++++++++++----------
 kernel-shark/src/KsMainWindow.hpp |   9 ++
 2 files changed, 142 insertions(+), 60 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 9b5fc2d..1f56645 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -594,42 +594,127 @@ void KsMainWindow::_graphFilterSync(int state)
 	_data.update();
 }
 
+void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
+				   tracecmd_filter_id *hideFilter,
+				   KsCheckBoxWidget *cbw)
+{
+	if (!kshark_this_filter_is_set(showFilter) &&
+	    !kshark_this_filter_is_set(hideFilter)) {
+		/*
+		 * No filter is set currently. All CheckBoxes of the Widget
+		 * will be checked.
+		 */
+		cbw->setDefault(true);
+	} else {
+		QVector<int> ids = cbw->getIds();
+		QVector<bool>  status;
+		int n = ids.count();
+		bool show, hide;
+
+		if (kshark_this_filter_is_set(showFilter)) {
+			/*
+			 * The "show only" filter is set. The default status
+			 * of all CheckBoxes will be "unchecked".
+			 */
+			status = QVector<bool>(n, false);
+			for (int i = 0; i < n; ++i) {
+				show = !!tracecmd_filter_id_find(showFilter,
+							         ids[i]);
+
+				hide = !!tracecmd_filter_id_find(hideFilter,
+							         ids[i]);
+
+				if (show && !hide) {
+					/*
+					 * Both "show" and "hide" define this
+					 * Id as visible. Set the status of
+					 * its CheckBoxes to "checked".
+					 */
+					status[i] = true;
+				}
+			}
+		} else {
+			/*
+			 * Only the "do not show" filter is set. The default
+			 * status of all CheckBoxes will be "checked".
+			 */
+			status = QVector<bool>(n, true);
+			for (int i = 0; i < n; ++i) {
+				hide = !!tracecmd_filter_id_find(hideFilter,
+							         ids[i]);
+
+				if (hide)
+					status[i] = false;
+			}
+		}
+
+		cbw->set(status);
+	}
+}
+
+void KsMainWindow::_applyFilter(QVector<int> all, QVector<int> show,
+				std::function<void(QVector<int>)> posFilter,
+				std::function<void(QVector<int>)> negFilter)
+{
+	if (show.count() < all.count() / 2) {
+		posFilter(show);
+	} else {
+		/*
+		 * It is more efficiant to apply negative (do not show) filter.
+		 */
+		QVector<int> diff;
+
+		/*
+		 * The Ids may not be sorted, because in the widgets the items
+		 * are shown sorted by name. Get those Ids sorted first.
+		 */
+		std::sort(all.begin(), all.end());
+		std::sort(show.begin(), show.end());
+
+		/*
+		 * The IDs of the "do not show" filter are given by the
+		 * difference between "all" Ids and the Ids of the "show only"
+		 * filter.
+		 */
+		std::set_difference(all.begin(), all.end(),
+				    show.begin(), show.end(),
+				    std::inserter(diff, diff.begin()));
+
+		negFilter(diff);
+	}
+}
+
+/* Quiet warnings over documenting simple structures */
+//! @cond Doxygen_Suppress
+
+#define LAMDA_FILTER(method) [=] (QVector<int> vec) {method(vec);}
+
+//! @endcond
+
 void KsMainWindow::_showEvents()
 {
 	kshark_context *kshark_ctx(nullptr);
 	KsCheckBoxWidget *events_cb;
 	KsCheckBoxDialog *dialog;
+	QVector<bool> v;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
 	events_cb = new KsEventsCheckBoxWidget(_data.tep(), this);
 	dialog = new KsCheckBoxDialog(events_cb, this);
+	_presetCBWidget(kshark_ctx->show_event_filter,
+		        kshark_ctx->hide_event_filter,
+		        events_cb);
+
+	auto lamFilter = [=] (QVector<int> show) {
+		QVector<int> all = KsUtils::getEventIdList();
+		_applyFilter(all, show,
+			     LAMDA_FILTER(_data.applyPosEventFilter),
+			     LAMDA_FILTER(_data.applyNegEventFilter));
+	};
 
-	if (!kshark_ctx->show_event_filter ||
-	    !kshark_ctx->show_event_filter->count) {
-		events_cb->setDefault(true);
-	} else {
-		/*
-		 * The event filter contains IDs. Make this visible in the
-		 * CheckBox Widget.
-		 */
-		tep_event **events =
-			tep_list_events(_data.tep(), TEP_EVENT_SORT_SYSTEM);
-		int nEvts = tep_get_events_count(_data.tep());
-		QVector<bool> v(nEvts, false);
-
-		for (int i = 0; i < nEvts; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->show_event_filter,
-						    events[i]->id))
-				v[i] = true;
-		}
-
-		events_cb->set(v);
-	}
-
-	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosEventFilter);
+	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
 
 	dialog->show();
 }
@@ -639,32 +724,25 @@ void KsMainWindow::_showTasks()
 	kshark_context *kshark_ctx(nullptr);
 	KsCheckBoxWidget *tasks_cbd;
 	KsCheckBoxDialog *dialog;
+	QVector<bool> v;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
 	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), true, this);
 	dialog = new KsCheckBoxDialog(tasks_cbd, this);
+	_presetCBWidget(kshark_ctx->show_task_filter,
+			kshark_ctx->hide_task_filter,
+			tasks_cbd);
+
+	auto lamFilter = [=] (QVector<int> show) {
+		QVector<int> all = KsUtils::getEventIdList();
+		_applyFilter(all, show,
+			     LAMDA_FILTER(_data.applyPosTaskFilter),
+			     LAMDA_FILTER(_data.applyNegTaskFilter));
+	};
 
-	if (!kshark_ctx->show_task_filter ||
-	    !kshark_ctx->show_task_filter->count) {
-		tasks_cbd->setDefault(true);
-	} else {
-		QVector<int> pids = KsUtils::getPidList();
-		int nPids = pids.count();
-		QVector<bool> v(nPids, false);
-
-		for (int i = 0; i < nPids; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->show_task_filter,
-						    pids[i]))
-				v[i] = true;
-		}
-
-		tasks_cbd->set(v);
-	}
-
-	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosTaskFilter);
+	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
 
 	dialog->show();
 }
@@ -674,30 +752,25 @@ void KsMainWindow::_showCPUs()
 	kshark_context *kshark_ctx(nullptr);
 	KsCheckBoxWidget *cpu_cbd;
 	KsCheckBoxDialog *dialog;
+	QVector<bool> v;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
 	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
 	dialog = new KsCheckBoxDialog(cpu_cbd, this);
+	_presetCBWidget(kshark_ctx->show_cpu_filter,
+			kshark_ctx->hide_cpu_filter,
+			cpu_cbd);
+
+	auto lamFilter = [=] (QVector<int> show) {
+		QVector<int> all = KsUtils::getEventIdList();
+		_applyFilter(all, show,
+			     LAMDA_FILTER(_data.applyPosCPUFilter),
+			     LAMDA_FILTER(_data.applyNegCPUFilter));
+	};
 
-	if (!kshark_ctx->show_cpu_filter ||
-	    !kshark_ctx->show_cpu_filter->count) {
-		cpu_cbd->setDefault(true);
-	} else {
-		int nCPUs = tep_get_cpus(_data.tep());
-		QVector<bool> v(nCPUs, false);
-
-		for (int i = 0; i < nCPUs; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->show_cpu_filter, i))
-				v[i] = true;
-		}
-
-		cpu_cbd->set(v);
-	}
-
-	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosCPUFilter);
+	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
 
 	dialog->show();
 }
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 59030e4..997ea54 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -19,6 +19,7 @@
 // KernelShark
 #include "KsTraceViewer.hpp"
 #include "KsTraceGraph.hpp"
+#include "KsWidgetsLib.hpp"
 #include "KsSession.hpp"
 #include "KsUtils.hpp"
 
@@ -177,6 +178,14 @@ private:
 
 	void _graphFilterSync(int state);
 
+	void _presetCBWidget(tracecmd_filter_id *showFilter,
+			     tracecmd_filter_id *hideFilter,
+			     KsCheckBoxWidget *cbw);
+
+	void _applyFilter(QVector<int> all, QVector<int> show,
+			  std::function<void(QVector<int>)> posFilter,
+			  std::function<void(QVector<int>)> negFilter);
+
 	void _showEvents();
 
 	void _showTasks();
-- 
2.20.1

