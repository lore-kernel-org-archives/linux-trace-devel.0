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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABBDC43332
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E73E720CC7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULja2hzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCSOMb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:12:31 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:41127 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgCSOLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:11:03 -0400
Received: by mail-lj1-f182.google.com with SMTP id o10so2630902ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Mar 2020 07:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8GB/zARppi5VQsVLUke38/sanKYcAT6PYGrz43u9SU=;
        b=ULja2hzQOH80iwA+POZV6VhJF17ckWTJjikP7BO6pfm6mZNOWoLlaMQqMoL2jufBY/
         6cRoWEIchWMIIout0Za2oJpMdMC/nEWNGMjGU5cAeLh1ZVC2EvMR106yu4ZT9dgFXRH+
         H20gcc/Hw1lEst5pW7yINS/qp6scju3a4JLJqA4uFXF3lvPqo16AwK+V/utGpyaRpH3b
         +pesERuw/dsj32EBAegOs647BhaMcBDFM3khjSNNHBMY6KvUxc9KhZn5rftCF6isuw27
         BOy7i2SbKhjJ+ERMxSr4ES0ff1yNe0LoLznZZOIc3dtRcEBuVWBcY9oNQ6jWqZsH6sWn
         MXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8GB/zARppi5VQsVLUke38/sanKYcAT6PYGrz43u9SU=;
        b=pE5pTqnhbQF6rOwWJkhwXhpINjQVoY8kN6dtduPM5OK423jeMmwbLLLtoUV62vzXLL
         j8kXSxIR68Rt0g39MdT7KuAfe+t/o9sUEPxlR8GJYInaOUqNoEjNm1+hsZzZJxq9Usho
         M864UgJb6oNBCQw/gti53THSgcgM2J4OE3xX6Yjrmv36qkAC8ngQouE1HrA7WAjzhLV4
         HH7wt8/OznFgQa9EPEPtyvAXZ9wYAs2u4GOCyVGIUnn9h9pkISZtpgykBOchxwIFoR9J
         jagok6NpYF9YcHaLMmntuN8JlgbokpSSjBzXqhi1DIrWaqECgn4LHu6q2IQFKPz5vcyz
         oTQA==
X-Gm-Message-State: ANhLgQ2yqVu7yJCIAj3MvdQlZcKOyb5p+WBJI7/LyeYLjjnl2zxbw+4P
        03Ol8iMaLIrsD0VsOnorv00=
X-Google-Smtp-Source: ADFU+vt4hYmFpWStJ9GT3wG1IP/9AcUVlfeupa29+QYlbCuieGXC9eOxiEbg6lyTgMPLTOAQwgIFJw==
X-Received: by 2002:a2e:858c:: with SMTP id b12mr2353613lji.160.1584627061358;
        Thu, 19 Mar 2020 07:11:01 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.223])
        by smtp.gmail.com with ESMTPSA id u14sm1817605ljj.54.2020.03.19.07.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:11:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] kernel-shark: Remove unused methods from KsMainWindow class
Date:   Thu, 19 Mar 2020 16:10:30 +0200
Message-Id: <20200319141031.3774-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200319141031.3774-1-y.karadz@gmail.com>
References: <20200319141031.3774-1-y.karadz@gmail.com>
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

