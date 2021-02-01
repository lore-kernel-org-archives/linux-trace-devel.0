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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FC5C433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17EE664EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBARZn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhBARZj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:39 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC934C061793
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:22 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g10so1516895eds.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=93Pyq9e2J5uu8aZ1e9+b7X1+knvIcOeiDFz4tedcvkY=;
        b=jEfJdQ2XuvIi/NtkLPnXZKrbWJ0H+5vmYNAFezkQLkytOVPT7EJEBT2cxwgUTwlB58
         dqn+7vvQ6RhAtSyxv/kSfpbogrvejAQ6xfp2rMs9fWV11IVybp9IJFO8Ce2dlv3yd3zs
         2wKzt+1YC+y56CR5eGLhHm+GYZIVWVKMgfU2ylNHR9wUjNAqAmxm23taoJ5E/8nh7fDy
         l045VSBs9Cv2PYYbmASjvruYpe3vz8PCTRVUFeVRkIveGuBxBIw5pb8G6RLbnByyAF2m
         wN9ymP5NLnd8Kc8b6ahWdHIdY/oydttw9sYGOpLsszEKuydbOnBCIHOOGAKLSK867tiJ
         Mk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=93Pyq9e2J5uu8aZ1e9+b7X1+knvIcOeiDFz4tedcvkY=;
        b=YrbS9iWRUb7TxdWnq1rC6aE1NIh5ttY2JNzdTJxRpFgVtHPXUoKQcFbCcKsesBIVyu
         2VoV95gDSA4xCeWucuJ7PwQ9VqDV1U6xeIh8myfT3hP7EssrA1MA0cN87Fnq2W33QpJg
         u391p3sO1cyfiRjtk5PzQJMe88kn8w3clIZGgssnM6DGA3DbvIyfp9y9FslpKQkZOgZr
         4uPfNw+2bK+cGbXhGdBhPd/FfDjgdOMquqOH1Pf9idSK/u0mIRYcoGpxX0brIy8R6kBE
         ebntSN11RAcnWHuLuVdy4jvBcBI696ClpkiPnnJiyPfJ9115vKYIhLEu3cQy2ab6uoCe
         4EUA==
X-Gm-Message-State: AOAM5332NR6GCc65h8Y9l4W5fDoaQ8+RVoB7OP5aVQ/pcy3ROgQ9TGDa
        Zs+1/lh0u1y1/4GDQG5HFtNqICovhVg=
X-Google-Smtp-Source: ABdhPJz/G9NRX3ERJxUxOc25CpVDKJVd++jfCbUrwvbpsofTgzzEgvfNFEg3cY099Yek3BvI570NSw==
X-Received: by 2002:aa7:cd8c:: with SMTP id x12mr11745394edv.355.1612200261660;
        Mon, 01 Feb 2021 09:24:21 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:21 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 10/24] kernel-shark: Add model tests
Date:   Mon,  1 Feb 2021 19:23:44 +0200
Message-Id: <20210201172358.175407-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
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

