Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0429AC433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0ECB208E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 06:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVTflLHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgIPGup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgIPGun (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 02:50:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229CAC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:43 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a9so1723006wmm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Sep 2020 23:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+KZBIOcQJGO9I4kPWIAQkCtXcR3Btg9aV1WDBLfLbGw=;
        b=nVTflLHx8AnmBOtxWJiRZN48D/KbDhZq3BU4XBt5n/SUhqmT7QsalIEE2WcqRI9Pe5
         F77rIS3LfDTbGNPDdIRUDcZNsj74i3Fgl/7ZSSs4S2xgPjTvbNPQUTj7613vkkZk7tHX
         GwUzuw+GESCext10mL9PNsnt53+hzetDYvp1lkOSJ8LY1LDWZ5U94hR2ruDd35o8pTOG
         X/nOxCtnWtcUMjjDjCPS5RT0f1FeNNVtqH8xOqwtQtQbQGuvHlGCjXyBKLO1FQZrKE0I
         k34wEOasC6ZlFSGxjfPr60W0+P+mIV5rX+26nF0dz6HRE7vL+1Qqm/C5D4r8t/W54Voj
         3u3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+KZBIOcQJGO9I4kPWIAQkCtXcR3Btg9aV1WDBLfLbGw=;
        b=fumzFaQDZkdcK9LVLVFWrE61Bwud5yd1uo782QjONQ5MnIV0kgeJQa4EKR9WGTcZFB
         xQoJuvgLtYQbYyLtPk8t3DjqHyHGs9XfX9/m1GUv6g7ANiykxILFXCrwg0Sx0HRKri1W
         A2kgjiHTgMHBVEFSy4Tm7o/wRp6TN4oVB/icUTuKPyUO7JeWOH5ew74hxiiO+GuiRdOV
         Cpnjnioyxl+E15KNC/B+OUTbGvusAF4RNMpyVHWJmYfU9RlArMJOUCa+/fhheVgx4jBZ
         HuyxEHoJeoYY6qlUyWp0tOqFqe72+ZyHPJndg288ODsQdvfy6ZKurN6uo40R1MF2kZbP
         Pxag==
X-Gm-Message-State: AOAM530CAixkcpCI8P0y3STur292jbcm2FhkJsjc8wZQYmrGCJDty4nh
        uWRFcZAUwx9KdYnVTsK99s0ZIjvtjnY=
X-Google-Smtp-Source: ABdhPJwVjHW4MBPWzuh+1NZ9lJWhZcc952uqFTx3zJoVwJLG04krntOhR3mGLB0byptCb7B721FRAg==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr2917729wmk.97.1600239041689;
        Tue, 15 Sep 2020 23:50:41 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id u126sm4229028wmu.9.2020.09.15.23.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 23:50:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Check if Qt has been found when building the examples
Date:   Wed, 16 Sep 2020 09:50:06 +0300
Message-Id: <20200916065007.9755-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916065007.9755-1-y.karadz@gmail.com>
References: <20200916065007.9755-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some of the examples depend on Qt. Check if Qt exists befor trying
to build these examples.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/examples/CMakeLists.txt | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/examples/CMakeLists.txt b/kernel-shark/examples/CMakeLists.txt
index 35e6b1e..032f305 100644
--- a/kernel-shark/examples/CMakeLists.txt
+++ b/kernel-shark/examples/CMakeLists.txt
@@ -20,10 +20,14 @@ message(STATUS "dataplot")
 add_executable(dplot          dataplot.cpp)
 target_link_libraries(dplot   kshark-plot)
 
-message(STATUS "widgetdemo")
-add_executable(widgetdemo          widgetdemo.cpp)
-target_link_libraries(widgetdemo   kshark-gui)
+if (Qt5Widgets_FOUND)
 
-message(STATUS "cmd_split")
-add_executable(cmd_split           cmd_split.cpp)
-target_link_libraries(cmd_split    kshark-gui)
+    message(STATUS "widgetdemo")
+    add_executable(widgetdemo          widgetdemo.cpp)
+    target_link_libraries(widgetdemo   kshark-gui)
+
+    message(STATUS "cmd_split")
+    add_executable(cmd_split           cmd_split.cpp)
+    target_link_libraries(cmd_split    kshark-gui)
+
+endif (Qt5Widgets_FOUND)
-- 
2.26.2

