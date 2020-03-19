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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58B8C4332B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC66521655
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PbM4FBtz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCSOMc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:12:32 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:41113 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgCSOLD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:11:03 -0400
Received: by mail-lj1-f172.google.com with SMTP id o10so2630773ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Mar 2020 07:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDCxMwSzWRHaK0sSIDqXTIKN/ZygkiDBI31F0c49wEI=;
        b=PbM4FBtzPVTcrzGxqPGAjOUor5IX4faPm90qTDuNBSHLmI2pqPW06ebayifmFBsmyM
         a3Qp6BAFCEEwoVhKiCAw1qd4RmRfkruS53Mnd1KKQharrsx9ry/Oe3OpLdj2GNOPi8zA
         y7ig1JkvIof6A8gEfLTyMT1KNJ8GSErl12wE4h/tunX9T5ej0Uj71ErWGTZjn9xsarPw
         TqE4cq1QGwB8cyQNXw1Mf0zpX/hna9z51ac2JJgZGHMS/s4iiZJC/KcJTBEwCPqJ40i/
         eTQrbd8HqmHU60b0ktIrxzjjWcZ4GKZO0T/GBhJSuCJWpsfi8CGYOqgEN/U2FHNiwBZ1
         BTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDCxMwSzWRHaK0sSIDqXTIKN/ZygkiDBI31F0c49wEI=;
        b=S7w5wjJZqDTLasVj4Wwl1lA7uAobrdz7Cw5VGRyB/7t1s1ZFvuPDZm1ctpqwSfH6fE
         k3JFHUNgPb6DiGI729mhA7GcITvBLjs6PULlIc060aYd/xVa/bLr8fskqdoYXop9ZqGY
         LRe0cyYIey51MkbYSc+0tHSRx9uxZC/PDX+z/Ihxj5Dc66J3C2A7bVR4MJgkjaWRxf8y
         ZDwVlsjMyBbVFWGo27ObITSAPy60D7taVAeURO0a2YvJFUUg/CPRyAniHUz4DTU0yAE8
         96FzOmFTCbHjJM9nXNBT3KikxkqU3K1K8oRe0pS3PPFynFt1HdtgA0MANOTPNtmvh8OU
         HTnA==
X-Gm-Message-State: ANhLgQ2xXRP2yajMndO3BeY20oZPY7A1vV9Rm54hyZ0eyQ7064dTHuxx
        qrN1/WFw42xS3ADLRoY7Vi4=
X-Google-Smtp-Source: ADFU+vsfNUOJV8CFnXTAYhuv6ZGlxeeehQDg4ECZguGNW6ZVep+GClHz1WGP7tf5g7BTXeU/FJONfQ==
X-Received: by 2002:a2e:3608:: with SMTP id d8mr2351298lja.189.1584627059431;
        Thu, 19 Mar 2020 07:10:59 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.223])
        by smtp.gmail.com with ESMTPSA id u14sm1817605ljj.54.2020.03.19.07.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:10:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] kernel-shark: Add two helper methods to KsUtils
Date:   Thu, 19 Mar 2020 16:10:29 +0200
Message-Id: <20200319141031.3774-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200319141031.3774-1-y.karadz@gmail.com>
References: <20200319141031.3774-1-y.karadz@gmail.com>
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

