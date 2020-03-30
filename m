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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D01C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 245592072E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKlMoFpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgC3QHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:43 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:37896 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3QHm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:42 -0400
Received: by mail-lj1-f179.google.com with SMTP id w1so18668636ljh.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8GB/zARppi5VQsVLUke38/sanKYcAT6PYGrz43u9SU=;
        b=BKlMoFpuTH7NpfsGITSuP4CCJzfL0rAhgqkO02xDi4uAVJTSuu6pZW5uZCewcanNNa
         zEGNdLPsO/y1v71rQDZ0XQwt1E3PK2lT1/+b39xUeFLbsBURNrtskKHJ3PTEwnWYdCaf
         xmzhNVofjUcTXhxlKKLvrbX9wM2e/4nsUoaPHD87U6hH1Egsa0l0xN4TedwuhhxB+e2t
         iCnyOL6xbSBvNUzy0WJ/ohG5gtdxGnu/3+8QMWGtgRdvay+gKnAD98tcu1O6QKRbEKMe
         3FaWbbl/BZIPthSBr1iaK91eXwDxjbv2YlBJXQMB8foTrSKUCSPhV/LKHxIe7134HdPT
         IR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8GB/zARppi5VQsVLUke38/sanKYcAT6PYGrz43u9SU=;
        b=OmVJrrvFPZKMLq8swE5PZiw9nKra52NDlTc4hk8dJGFHZpXlwv0PtZbdtqp0XlD4SQ
         WetiZ+6yPyQl9QfIQmNWAnAYOGchv4fBllvHD8Qm8oqLYLDXEIjfFx9lAe5QSXyanfZX
         NO+Y/xVst1tD7+m71DNuEbL4sF7y/lUJQXD5DUYTme8+Rz2jCgUtZb5shHrQDgcd3hnw
         i5Ae+clB9u/Pd86oHMV4hHvhgjE3UG7sn/9oaAZviio8OlkV6XNabvlkWf6uX9WeiRWE
         ewuKJFsKV1QfiisVJrpE9HBcYxtgshFM2wxzGv+ahNW443CcnBmliupzp7zi+1eiSUqc
         Kqvw==
X-Gm-Message-State: AGi0PuaTlFGKMhi9FTlUrGlb5qgJODV6f3c4B3JVVNcRwi8Lgc+c0xt0
        xdWQ3OR8vBQRfw3bmYpL11w=
X-Google-Smtp-Source: APiQypLxHgyCIujZTnCDT4Nw9GkCsSlawD6qH69GytxgF7vbr3S6/wtH7+wiNjKN2FZy3NnggaReyw==
X-Received: by 2002:a2e:818e:: with SMTP id e14mr7604489ljg.225.1585584460223;
        Mon, 30 Mar 2020 09:07:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/6] kernel-shark: Remove unused methods from KsMainWindow class
Date:   Mon, 30 Mar 2020 19:06:51 +0300
Message-Id: <20200330160652.28424-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We used to have menu actions for applying negative ID filters (do not
show) for PIDs and CPU IDs. At some point we decided to remove all menu
actions for negative filters in order to avoid users being confused by
the possible unexpected behavior in the case when both positive (show
only) and negative filters are set. However we kept the corresponding
private methods, just in case we want to restore the menu actions in
the future. We can now finally remove those methods, because in the
following patch the logic will be optimized to automatically decide
whether is more efficient to use positive or negative filter.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 69 -------------------------------
 kernel-shark/src/KsMainWindow.hpp |  4 --
 2 files changed, 73 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index a5a399c..9b5fc2d 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -669,41 +669,6 @@ void KsMainWindow::_showTasks()
 	dialog->show();
 }
 
-void KsMainWindow::_hideTasks()
-{
-	kshark_context *kshark_ctx(nullptr);
-	KsCheckBoxWidget *tasks_cbd;
-	KsCheckBoxDialog *dialog;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), false, this);
-	dialog = new KsCheckBoxDialog(tasks_cbd, this);
-
-	if (!kshark_ctx->hide_task_filter ||
-	    !kshark_ctx->hide_task_filter->count) {
-		tasks_cbd->setDefault(false);
-	} else {
-		QVector<int> pids = KsUtils::getPidList();
-		int nPids = pids.count();
-		QVector<bool> v(nPids, false);
-
-		for (int i = 0; i < nPids; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->hide_task_filter,
-						    pids[i]))
-				v[i] = true;
-		}
-
-		tasks_cbd->set(v);
-	}
-
-	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyNegTaskFilter);
-
-	dialog->show();
-}
-
 void KsMainWindow::_showCPUs()
 {
 	kshark_context *kshark_ctx(nullptr);
@@ -737,40 +702,6 @@ void KsMainWindow::_showCPUs()
 	dialog->show();
 }
 
-void KsMainWindow::_hideCPUs()
-{
-	kshark_context *kshark_ctx(nullptr);
-	KsCheckBoxWidget *cpu_cbd;
-	KsCheckBoxDialog *dialog;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
-	dialog = new KsCheckBoxDialog(cpu_cbd, this);
-
-	if (!kshark_ctx->hide_cpu_filter ||
-	    !kshark_ctx->hide_cpu_filter->count) {
-		cpu_cbd->setDefault(false);
-	} else {
-		int nCPUs = tep_get_cpus(_data.tep());
-		QVector<bool> v(nCPUs, false);
-
-		for (int i = 0; i < nCPUs; ++i) {
-			if (tracecmd_filter_id_find(kshark_ctx->hide_cpu_filter,
-						    i))
-				v[i] = true;
-		}
-
-		cpu_cbd->set(v);
-	}
-
-	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_data,		&KsDataStore::applyNegCPUFilter);
-
-	dialog->show();
-}
-
 void KsMainWindow::_advancedFiltering()
 {
 	KsAdvFilteringDialog *dialog;
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index eef4f96..59030e4 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -181,12 +181,8 @@ private:
 
 	void _showTasks();
 
-	void _hideTasks();
-
 	void _showCPUs();
 
-	void _hideCPUs();
-
 	void _advancedFiltering();
 
 	void _clearFilters();
-- 
2.20.1

