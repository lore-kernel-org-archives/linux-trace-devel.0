Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F43C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EAE64E9C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBKKiK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhBKKfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:44 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47132C0617A7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:32 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y18so6359136edw.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=93Pyq9e2J5uu8aZ1e9+b7X1+knvIcOeiDFz4tedcvkY=;
        b=ZI7eWK6g9NzlZ2tNjfViXePtzeCGeTpLNCxMepVUCarYTItCypx/DPMHsKxHiXZnp2
         47IpuhkI75n+mHXjkcCrrJSWD9Y3N5xDfjmOkXvIPfP/FIbJtRl27NlxFhpqd7a1CVfC
         z/4Q/LbSJqXgi/40TzMpXhcP49VcRnGB26x2BM/VIfDNwYgmahRNf5LIij3289QzwbRd
         3n8eqIzRGo2cq04nI+xOsLVUUhoeLjJFlBk6S2oORB7UQAShx9r3ufzaNzSjaGC1gkK1
         q5av9t0yvACf3fbQJArhK5OR11bIVQfk+7FQlt7sydCZVizYoRt2IR78om/yYvZ8iZTi
         q/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=93Pyq9e2J5uu8aZ1e9+b7X1+knvIcOeiDFz4tedcvkY=;
        b=mpZ2HAMw2L7q/v2I7hccpxDyLIJF6/A/c6sNqJiDV8fepYc/ADcx8/QTPg7LAxfE9C
         oulCXptQBsaj1MqoM6jziM/u1ixr4J1CiCu1MbkXokx38/wi6ELcPcFOzNtMxElYhLZL
         q4ETId8nFf7mmUCDKJLedTUMjrza+eIOmosvv3upa7N1FL12PVzbxZXr30puKvkR8c83
         URbqCg7I3PsLt5ynCs9myoyBe5hEawQCDKNh69a7WfbX1/s99/ZkhLkJq8AvO8a3eXyV
         TPhktwh2NhScvdc72p39pIieNIzW9CoqFS2+miE6ZL3j53e5D4RdKtHYOAlURLsVbcg0
         V7JQ==
X-Gm-Message-State: AOAM530eqXfI9I5XO5S+2fehdBUlhqodms4+mLnRpAtfGlsSVf12RumA
        Pcm3RLQEeTRhwjpHUb4Ak1ix5Q1MtNU=
X-Google-Smtp-Source: ABdhPJxV/FnAZiYkJz+Nd/Iq+SNesvsQD36gVJRQNKYW5DuZvFsEsSPhxPDpNY0obtJd8WawWWioZw==
X-Received: by 2002:a05:6402:6cc:: with SMTP id n12mr7869034edy.69.1613039551097;
        Thu, 11 Feb 2021 02:32:31 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:30 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 10/27] kernel-shark: Add model tests
Date:   Thu, 11 Feb 2021 12:31:48 +0200
Message-Id: <20210211103205.418588-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add few simple test cases of the KsModel functionalities.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tests/libkshark-gui-tests.cpp | 59 +++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index de6eb30..dedd69f 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -12,6 +12,8 @@
 #include "libkshark.h"
 #include "libkshark-plugin.h"
 #include "KsUtils.hpp"
+#include "KsModels.hpp"
+
 
 using namespace KsUtils;
 
@@ -225,3 +227,60 @@ BOOST_AUTO_TEST_CASE(KsUtils_KsPluginManager)
 	kshark_free(kshark_ctx);
 	a.exit();
 }
+
+BOOST_AUTO_TEST_CASE(ViewModel)
+{
+	QStringList header{"#", "CPU", "Time Stamp", "Task", "PID", "Latency", "Event", "Info"};
+	struct kshark_context *kshark_ctx(nullptr);
+	KsViewModel model;
+	KsDataStore data;
+
+	data.loadDataFile(QString(KS_TEST_DIR) + "/trace_test1.dat", {});
+	model.fill(&data);
+	BOOST_CHECK_EQUAL(model.rowCount({}), N_RECORDS_TEST1);
+	BOOST_CHECK_EQUAL(model.columnCount({}), 8);
+	BOOST_CHECK_EQUAL(model.singleStream(), true);
+	BOOST_CHECK(model.header() == header);
+
+	data.appendDataFile(QString(KS_TEST_DIR) + "/trace_test2.dat", {});
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	BOOST_CHECK(getStreamIdList(kshark_ctx) == QVector<int>({0, 1}));
+
+	model.update(&data);
+	header = QStringList{" >> "} + header;
+
+	BOOST_CHECK_EQUAL(model.rowCount({}), N_RECORDS_TEST1 + N_RECORDS_TEST2);
+	BOOST_CHECK_EQUAL(model.columnCount({}), 9);
+	BOOST_CHECK_EQUAL(model.singleStream(), false);
+	BOOST_CHECK(model.header() == header);
+
+	BOOST_CHECK(model.getValueStr(0, 0) == "1");
+	BOOST_CHECK(model.getValueStr(4, 1) == "trace-cmd");
+	BOOST_CHECK(model.getValueStr(5, 2) == "29474");
+	BOOST_CHECK(model.getValueStr(7, 2) == "sched/sched_switch");
+
+	BOOST_CHECK(model.getValueStr(0, N_RECORDS_TEST1 + N_RECORDS_TEST2 - 1) == "0");
+	BOOST_CHECK(model.getValueStr(4, N_RECORDS_TEST1 + N_RECORDS_TEST2 - 1) == "<idle>");
+
+	model.reset();
+	BOOST_CHECK_EQUAL(model.rowCount({}), 0);
+}
+
+BOOST_AUTO_TEST_CASE(GraphModel)
+{
+	struct kshark_context *kshark_ctx(nullptr);
+	KsGraphModel model;
+	KsDataStore data;
+
+	data.loadDataFile(QString(KS_TEST_DIR) + "/trace_test1.dat", {});
+	BOOST_REQUIRE(kshark_instance(&kshark_ctx));
+	BOOST_CHECK(getStreamIdList(kshark_ctx) == QVector<int>({0}));
+
+	model.fill(&data);
+	BOOST_CHECK_EQUAL(model.rowCount({}), KS_DEFAULT_NBUNS);
+	BOOST_CHECK(abs(model.histo()->min - data.rows()[0]->ts) < model.histo()->bin_size);
+	BOOST_CHECK(abs(model.histo()->max - data.rows()[N_RECORDS_TEST1 - 1]->ts) < model.histo()->bin_size);
+
+	model.reset();
+	BOOST_CHECK_EQUAL(model.rowCount({}), 0);
+}
-- 
2.25.1

