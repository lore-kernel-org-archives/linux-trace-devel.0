Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC4BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B379613B6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 14:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243686AbhDUOwb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbhDUOw1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 10:52:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89024C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so63893427ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 07:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sPUTZrGG5XrHdRVpHjc7tpNelayDrpB21Noa+GLett0=;
        b=TJnoIfD57vsEFKG4YsJ0IdZNz7decTbHgtDaA7Oq0xJ9iPsdae/jJsCcx/Azk+uMMu
         pEFrUquRWImWafccfPVJPf7vYbEvEuDlsCDsuCg0aqbQl/fJ4nx7voKXlYRN4wBcQ7Bg
         bithveVyKiByu+0fMwaMk10V470XBqoYcqV3hm74jTn97H95rebB6Xg7G8bttZrKzpb0
         A7I6Rxv6RboJcl4NUezl4LD853s4S11XUlaTJUl0i46O0ahYDNA6VWWdxPMkwkZOp2Fu
         IIvMCXQ4XOqF99IXINxGocwMN9IMyloCaseCuQOgSW3k0+MH86ByZDk1FHM8NaJRUXq1
         IRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sPUTZrGG5XrHdRVpHjc7tpNelayDrpB21Noa+GLett0=;
        b=GehyjPraHfQBFnU2ZFb7YfOdAXl5jUBgB97GFGkJXVtfLF9nKUkRilz2aALRvS1qnn
         op52eSACa8SQ/n5pOG0a7Dcwmb8EITXdfwkuedR1YhPVPdhAjQODV2fa5PVsA1ZcLZu5
         kX167rX2z9yMgM/H3T9FAibQYYdDVpdJSTXescjE1FvXD19aIXDN3VpRN60QFyfU6eRO
         lTfBcGwX6nEbC6lfLrvQGkcKRo4HONzfGeYPh4Li5Rz3yxLeq8FTnESXmSMhycSB4/cK
         qpVgb4X96pIX4XS8piw3Hsa4FVyAzfuuxlYsuA6A4lj2QLEhIcuZPFrfrQC2QRFiLSWk
         Fu2w==
X-Gm-Message-State: AOAM533I8m9DfF2lzoSfjNk4G0+7U4KqpPwlcJhzUh+k/QlcCX+9U95u
        mufM+U3Cl/yF8kv5MWx+L4PuefJ4I5s=
X-Google-Smtp-Source: ABdhPJwcFMyrqqbcvqnog+i07+lkUsm4+3qCYylWCayFquVaOSO/28Mnf4xTPya30D7KajzHqVXfqA==
X-Received: by 2002:a17:906:5490:: with SMTP id r16mr34344335ejo.352.1619016713118;
        Wed, 21 Apr 2021 07:51:53 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id ke14sm2730325ejc.1.2021.04.21.07.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 07:51:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark: Fix warnings from deprecated Qt APIs
Date:   Wed, 21 Apr 2021 17:51:37 +0300
Message-Id: <20210421145140.95517-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210421145140.95517-1-y.karadz@gmail.com>
References: <20210421145140.95517-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Couple of APIs used by KernelShark have been marked as deprecated
in the recent version of Qt. Fix all compilation warnings caused
by the usage of these deprecated APIs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsTraceGraph.cpp |  9 +++++++--
 src/KsWidgetsLib.cpp | 14 +++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index fd9cfac..1e976df 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -327,13 +327,18 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	QString aux(lanMakeString(kshark_get_aux_info(e)));
 	QString info(lanMakeString(kshark_get_info(e)));
 	QString comm(lanMakeString(kshark_get_task(e)));
-	QString pointer, elidedText;
+	QString elidedText;
 	int labelWidth;
 	uint64_t sec, usec;
+	char *pointer;
 
 	kshark_convert_nano(e->ts, &sec, &usec);
-	pointer.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	labelWidth = asprintf(&pointer, "%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	if (labelWidth <= 0)
+		return;
+
 	_labelP2.setText(pointer);
+	free(pointer);
 
 	comm.append("-");
 	comm.append(QString("%1").arg(kshark_get_pid(e)));
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index 4ec6033..e30bf27 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -926,9 +926,9 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(kshark_data_stream *stream, QWidget *pa
 		cpuItem->setText(0, "  ");
 		cpuItem->setText(1, QString("CPU %1").arg(i));
 		cpuItem->setCheckState(0, Qt::Checked);
-		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
-						      colors[i].g(),
-						      colors[i].b()));
+		cpuItem->setBackground(0, QColor(colors[i].r(),
+						 colors[i].g(),
+						 colors[i].b()));
 		_tree.addTopLevelItem(cpuItem);
 		_id[i] = i;
 		_cb[i] = cpuItem;
@@ -1115,12 +1115,12 @@ KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(kshark_data_stream *stream,
 
 		comItem = new QTableWidgetItem(tr(comm));
 
-		pidItem->setBackgroundColor(QColor(colors[pid].r(),
-						   colors[pid].g(),
-						   colors[pid].b()));
+		pidItem->setBackground(QColor(colors[pid].r(),
+					      colors[pid].g(),
+					      colors[pid].b()));
 
 		if (_id[i] == 0)
-			pidItem->setTextColor(Qt::white);
+			pidItem->setForeground(Qt::white);
 
 		_table.setItem(i, 2, comItem);
 	}
-- 
2.27.0

