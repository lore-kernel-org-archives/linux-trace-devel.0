Return-Path: <SRS0=DKMX=5E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B796FC4332D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B16720CC7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qXwVTLjZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgCSOMY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:12:24 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:41125 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgCSOLF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:11:05 -0400
Received: by mail-lj1-f174.google.com with SMTP id o10so2631059ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Mar 2020 07:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CbjbeuWo/wPUOUT85q7xxSgJOd1G/6xrr8d+xRiVHU=;
        b=qXwVTLjZM3gmukYre2AowplXOUgoGtBomyieN8+5N553ugcM/Q3sgZRRBKIloFKrRB
         GC5PMkYEqdJhAOHC1x+Vr0iqM4ATQYd/bf28v3dXL8FwYfuyUnNwZgi2olulr166RzgC
         CONh7qDd8ZnqODiqedZya65E3alwQvuqqjrDzIklBBcYoYIju0OdQ8pmm9G/J/zuFaGV
         7Ju07y7dtAw4ZS3Nc0AZzvCRUclY7iyci9vep0UdJOiLGrcTN1nm9fgHmgeRgMIWKhkL
         d7xnSugZ3cPY9d0gTeSGTiA0sL289kL78Mog3sOytlvO5EMKKfGMFuFnaGK1qC4ZFfWC
         l9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CbjbeuWo/wPUOUT85q7xxSgJOd1G/6xrr8d+xRiVHU=;
        b=JTmgAMoSUVOu1X5B6TsQSyAMFt0IZ++9rU+2Vk5ZR7Zx+G/on5MLcYKScWIqKUdAwy
         RXRkxdyfN/vdfwdvUBfNvI0BoutLA2/4u1gjAKWdWMOklbiaMxc6+1CvjRUMFeAJYYXg
         yC8Hq056chu0vZbSZtP6Lr/v/fuI2/TBjrWtg5vcQZBQFKyJKXqMR0FBvG6Y4C7IhMWD
         IFu9D/YHlH3baPl1JkYuXDgkcIFJmO7pWBxOOeBiKIZGDTJVpEFFRGerDuyme2G4axe9
         6FFzfqmNarI5aNoB/iUTT4vzDZshS7Stf1XWh2LmOyYLj+Qkq+o+hr9BiyOBpiXHplRr
         iSEQ==
X-Gm-Message-State: ANhLgQ0hkxSukkKrPDzlrqpZuo7kW7zpCEuZlKTJMFqjSr/RvDnKLvQp
        gYP8WoexzvF5i0WqVB6+tu1QLpQ3
X-Google-Smtp-Source: ADFU+vv4MKeQ9q2OniJ3FMGhthOo7XWTXYByydDyNK/Z7NaY8RlTwy/sNaBbD2fdXCJz43ZtgwmPlw==
X-Received: by 2002:a05:651c:234:: with SMTP id z20mr2226457ljn.187.1584627063308;
        Thu, 19 Mar 2020 07:11:03 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.223])
        by smtp.gmail.com with ESMTPSA id u14sm1817605ljj.54.2020.03.19.07.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:11:02 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] kernel-shark: Optimize the logic of the filtering menus
Date:   Thu, 19 Mar 2020 16:10:31 +0200
Message-Id: <20200319141031.3774-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200319141031.3774-1-y.karadz@gmail.com>
References: <20200319141031.3774-1-y.karadz@gmail.com>
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
 kernel-shark/src/KsMainWindow.cpp | 184 +++++++++++++++++++++++-------
 kernel-shark/src/KsMainWindow.hpp |  12 ++
 2 files changed, 156 insertions(+), 40 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 9b5fc2d..aed28a8 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -594,114 +594,218 @@ void KsMainWindow::_graphFilterSync(int state)
 	_data.update();
 }
 
+QVector<bool> KsMainWindow::_getFilterCbStatus(tracecmd_filter_id *showFilter,
+					       tracecmd_filter_id *hideFilter,
+					       QVector<int> ids)
+{
+	QVector<bool> v;
+
+	if (!kshark_this_filter_is_set(showFilter) &&
+	    !kshark_this_filter_is_set(hideFilter)) {
+		return v;
+	} else {
+		int n = ids.count();
+		bool show, hide;
+
+		if (kshark_this_filter_is_set(showFilter)) {
+			/*
+			 * The "show only" filter is set. The default status
+			 * of all CheckBoxes will be "unchecked".
+			 */
+			v = QVector<bool>(n, false);
+			for (int i = 0; i < n; ++i) {
+				show = !!tracecmd_filter_id_find(showFilter,
+								 ids[i]);
+
+				hide = !!tracecmd_filter_id_find(hideFilter,
+								 ids[i]);
+
+				if (show && !hide) {
+					/*
+					 * Both "show" and "hide" define this
+					 * Id as visible. Set the status of
+					 * its CheckBoxes to "checked".
+					 */
+					v[i] = true;
+				}
+			}
+		} else { // Only hide filter is set.
+			v = QVector<bool>(n, true);
+			for (int i = 0; i < n; ++i) {
+				hide = !!tracecmd_filter_id_find(hideFilter,
+								 ids[i]);
+
+				if (hide)
+					v[i] = false;
+			}
+		}
+	}
+
+	return v;
+}
+
+QVector<int> KsMainWindow::_revertFilterIds(QVector<int> all, QVector<int> vec)
+{
+	QVector<int> diff;
+
+	/*
+	 * The Ids may not be sorted, becausein in the widgets the items are
+	 * shown sorted by name. Get those Ids sorted first.
+	 */
+	std::sort(vec.begin(), vec.end());
+
+	/*
+	 * The IDs of the "do not show" filter are given by the difference
+	 * between "all Ids" and the "show only" filter.
+	 */
+	std::set_difference(all.begin(), all.end(),
+			    vec.begin(), vec.end(),
+			    std::inserter(diff, diff.begin()));
+
+	return diff;
+}
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
+	v = _getFilterCbStatus(kshark_ctx->show_event_filter,
+			       kshark_ctx->hide_event_filter,
+			       KsUtils::getEventIdList(TEP_EVENT_SORT_SYSTEM));
 
-	if (!kshark_ctx->show_event_filter ||
-	    !kshark_ctx->show_event_filter->count) {
+	if (v.count() == 0) {
 		events_cb->setDefault(true);
 	} else {
 		/*
-		 * The event filter contains IDs. Make this visible in the
-		 * CheckBox Widget.
+		 * Some of the event filters contains IDs. Make this visible
+		 * in the CheckBox Widget.
 		 */
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
 		events_cb->set(v);
 	}
 
 	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosEventFilter);
+		this,		&KsMainWindow::_applyEventFilter);
 
 	dialog->show();
 }
 
+void KsMainWindow::_applyEventFilter(QVector<int> showEvents)
+{
+	QVector<int> allEvents = KsUtils::getEventIdList();
+
+	if (showEvents.count() < allEvents.count() / 2) {
+		_data.applyPosEventFilter(showEvents);
+	} else {
+		/*
+		 * It is more efficiant to apply negative (do not show) filter.
+		 */
+		QVector<int> diff = _revertFilterIds(allEvents, showEvents);
+		_data.applyNegEventFilter(diff);
+	}
+}
+
 void KsMainWindow::_showTasks()
 {
 	kshark_context *kshark_ctx(nullptr);
 	KsCheckBoxWidget *tasks_cbd;
 	KsCheckBoxDialog *dialog;
+	QVector<bool> v;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
 	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), true, this);
 	dialog = new KsCheckBoxDialog(tasks_cbd, this);
+	v = _getFilterCbStatus(kshark_ctx->show_task_filter,
+			       kshark_ctx->hide_task_filter,
+			       KsUtils::getPidList());
 
-	if (!kshark_ctx->show_task_filter ||
-	    !kshark_ctx->show_task_filter->count) {
+	if (v.count() == 0) {
 		tasks_cbd->setDefault(true);
 	} else {
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
+		/*
+		 * Some of the task filters contains PIDs. Make this visible
+		 * in the CheckBox Widget.
+		 */
 		tasks_cbd->set(v);
 	}
 
 	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosTaskFilter);
+		this,		&KsMainWindow::_applyTaskFilter);
 
 	dialog->show();
 }
 
+void KsMainWindow::_applyTaskFilter(QVector<int> showPids)
+{
+	QVector<int> allPids = KsUtils::getPidList();
+
+	if (showPids.count() <  allPids.count() / 2) {
+		_data.applyPosTaskFilter(showPids);
+	} else {
+		/*
+		 * It is more efficiant to apply negative (do not show) filter.
+		 */
+		QVector<int> diff = _revertFilterIds(allPids, showPids);
+		_data.applyNegTaskFilter(diff);
+	}
+}
+
 void KsMainWindow::_showCPUs()
 {
 	kshark_context *kshark_ctx(nullptr);
 	KsCheckBoxWidget *cpu_cbd;
 	KsCheckBoxDialog *dialog;
+	QVector<bool> v;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
 	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
 	dialog = new KsCheckBoxDialog(cpu_cbd, this);
+	v = _getFilterCbStatus(kshark_ctx->show_cpu_filter,
+			       kshark_ctx->hide_cpu_filter,
+			       KsUtils::getCPUList());
 
-	if (!kshark_ctx->show_cpu_filter ||
-	    !kshark_ctx->show_cpu_filter->count) {
+	if (v.count() == 0) {
 		cpu_cbd->setDefault(true);
 	} else {
-		int nCPUs = tep_get_cpus(_data.tep());
-		QVector<bool> v(nCPUs, false);
-
-		for (int i = 0; i < nCPUs; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->show_cpu_filter, i))
-				v[i] = true;
-		}
-
+		/*
+		 * Some of the CPU filters contains IDs. Make this visible
+		 * in the CheckBox Widget.
+		 */
 		cpu_cbd->set(v);
 	}
 
 	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyPosCPUFilter);
+		this,		&KsMainWindow::_applyCPUFilter);
 
 	dialog->show();
 }
 
+void KsMainWindow::_applyCPUFilter(QVector<int> showCPUs)
+{
+	QVector<int> allCPUs = KsUtils::getCPUList();
+
+	if (showCPUs.count() < allCPUs.count() / 2) {
+		_data.applyPosCPUFilter(showCPUs);
+	} else {
+		/*
+		 * It is more efficiant to apply negative (do not show) filter.
+		 */
+		QVector<int> diff = _revertFilterIds(allCPUs, showCPUs);
+		_data.applyNegCPUFilter(diff);
+	}
+}
+
 void KsMainWindow::_advancedFiltering()
 {
 	KsAdvFilteringDialog *dialog;
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 59030e4..ecfc12c 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -177,6 +177,18 @@ private:
 
 	void _graphFilterSync(int state);
 
+	QVector<bool> _getFilterCbStatus(tracecmd_filter_id *showFilter,
+					 tracecmd_filter_id *hideFilter,
+					 QVector<int> ids);
+
+	QVector<int> _revertFilterIds(QVector<int> all, QVector<int> vec);
+
+	void _applyEventFilter(QVector<int> showEvents);
+
+	void _applyTaskFilter(QVector<int> showPids);
+
+	void _applyCPUFilter(QVector<int> showCPUs);
+
 	void _showEvents();
 
 	void _showTasks();
-- 
2.20.1

