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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1EEC43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DB9C20732
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSVwxO1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgC3QHd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:33 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:41664 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgC3QHc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:32 -0400
Received: by mail-lf1-f52.google.com with SMTP id z23so14680028lfh.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDCxMwSzWRHaK0sSIDqXTIKN/ZygkiDBI31F0c49wEI=;
        b=JSVwxO1lpW3ooiI6Ws1CLcD8+cTUSTYrl32nadhCjHWDVZdgexETQFbZd1xUQ3c7eu
         DP+vn/v1bl4F/RBza2eQ3coTRzIqpKp/qSjnnVUoD5nKmZGx9zrgHSnBZ8qM68hy1avD
         ECLGqRL0idXLJy0uULODBBe8kW6omMTR3zeQ1o1QE7hKIIF1Hh5gygmgeqHc8GJztj8+
         A31Mx8xKPZeRvRBgDxgXPtRX5V4md34P3Ur+VOaEYymYYs5uQAWzfe7/RVDKqcNisI8h
         JQRod47BqPYwpzmwECtuzxZRdAr17VL1I3/+voTUta78Frs2g633weVCxO+8JuVjUApF
         gYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDCxMwSzWRHaK0sSIDqXTIKN/ZygkiDBI31F0c49wEI=;
        b=qpXgOLhasgyHyxdUJX7XpGRll1xMGq9Z6unH24KlG+VRoX9vfdxSvGhtkdmCr25yS5
         kh2ICr2MvBw+Tdr0qG6Zveay38KYgWEPROLQ/7C7811LTn15fG+xwnIrtw76qYo10kE+
         SgACcQtTg5TF5GtiKckw5diL8Mf3XimBuN9XAJ2sr0HxBIwzQ5GzWAyEoFojN78ge830
         9RV9yM9IOQhyaBj5FHtNkQYvpWqSaC7HtfYDlb/YNT0VImsmiDMS2uC+ANkBnXvzZ6yo
         BU0qJm3wkmMFc+qUsHELcfKW7kEoMIXdbCvKJvsqM7ChFrfaod08d2rI0hQF9EOf4I7j
         VuZg==
X-Gm-Message-State: AGi0PuaktYgvhaKi3d1blS6/YtyN2MEvDzGge7pEKcdNs4wEZmmValAb
        bH/U06TsfxXMjjrecPLT6oE=
X-Google-Smtp-Source: APiQypIpF9PNUvS74+rymq88cz5V5o+Gnf+iEjH+qsRnYKQk1aTOCsR9Sno5XeJSgvbcZ5HwwQ1OjA==
X-Received: by 2002:a05:6512:308e:: with SMTP id z14mr8674310lfd.110.1585584450168;
        Mon, 30 Mar 2020 09:07:30 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:28 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/6] kernel-shark: Add two helper methods to KsUtils
Date:   Mon, 30 Mar 2020 19:06:49 +0300
Message-Id: <20200330160652.28424-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The methods can be used to easily retrieve a QVector<int> containing
all CPU or Event IDs. We will later use these method in the GUI
(following patch).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp |  6 ++---
 kernel-shark/src/KsUtils.cpp         | 38 ++++++++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp         |  4 +++
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 69b9944..d6f8014 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -230,7 +230,7 @@ void KsCaptureControl::_importSettings()
 	kshark_config_doc *conf, *jevents, *temp;
 	QVector<bool> v(nEvts, false);
 	tracecmd_filter_id *eventHash;
-	tep_event **events;
+	QVector<int> eventIds;
 	QString fileName;
 
 	auto lamImportError = [this] () {
@@ -238,7 +238,7 @@ void KsCaptureControl::_importSettings()
 	};
 
 	/** Get all available events. */
-	events = tep_list_events(_localTEP, TEP_EVENT_SORT_SYSTEM);
+	eventIds = KsUtils::getEventIdList(TEP_EVENT_SORT_SYSTEM);
 
 	/* Get the configuration document. */
 	fileName = KsUtils::getFile(this, "Import from Filter",
@@ -277,7 +277,7 @@ void KsCaptureControl::_importSettings()
 	}
 
 	for (int i = 0; i < nEvts; ++i) {
-		if (tracecmd_filter_id_find(eventHash, events[i]->id))
+		if (tracecmd_filter_id_find(eventHash, eventIds[i]))
 			v[i] = true;
 	}
 
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index e99509f..77d0c7c 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -15,6 +15,22 @@
 
 namespace KsUtils {
 
+/** @brief Get a sorted vector of CPU Ids. */
+QVector<int> getCPUList()
+{
+	kshark_context *kshark_ctx(nullptr);
+	int nCPUs;
+
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	nCPUs = tep_get_cpus(kshark_ctx->pevent);
+	QVector<int> allCPUs = QVector<int>(nCPUs);
+	std::iota(allCPUs.begin(), allCPUs.end(), 0);
+
+	return allCPUs;
+}
+
 /** @brief Get a sorted vector of Task's Pids. */
 QVector<int> getPidList()
 {
@@ -37,6 +53,28 @@ QVector<int> getPidList()
 	return pids;
 }
 
+/**
+ * @brief Get a sorted vector of Event Ids.
+ */
+QVector<int> getEventIdList(tep_event_sort_type sortType)
+{
+	kshark_context *kshark_ctx(nullptr);
+	tep_event **events;
+	int nEvts;
+
+	if (!kshark_instance(&kshark_ctx))
+		return {};
+
+	nEvts = tep_get_events_count(kshark_ctx->pevent);
+	events = tep_list_events(kshark_ctx->pevent, sortType);
+
+	QVector<int> allEvts(nEvts);
+	for (int i = 0; i < nEvts; ++i)
+		allEvts[i] = events[i]->id;
+
+	return allEvts;
+}
+
 /** @brief Get a sorted vector of Id values of a filter. */
 QVector<int> getFilterIds(tracecmd_filter_id *filter)
 {
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index db1bf5e..f44139b 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -82,8 +82,12 @@ std::chrono::high_resolution_clock::now() - t0).count()
 
 namespace KsUtils {
 
+QVector<int> getCPUList();
+
 QVector<int> getPidList();
 
+QVector<int> getEventIdList(tep_event_sort_type sortType=TEP_EVENT_SORT_ID);
+
 QVector<int> getFilterIds(tracecmd_filter_id *filter);
 
 /** @brief Geat the list of plugins. */
-- 
2.20.1

