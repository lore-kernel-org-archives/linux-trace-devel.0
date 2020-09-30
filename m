Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28956C4727E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF452076B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 15:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyat5Fsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgI3PIM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgI3PIL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 11:08:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1367DC061755
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:10 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t17so2161960wmi.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 08:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebrbdevgi6FUEgGptFpxVEWU1y5LoDhpQCpoVTGFgpI=;
        b=fyat5Fsu5MG/9Un8114IB5bklZ49fXn9L00MJSTmzJb7l3bZoJxsMWs2aLZUB+r8AY
         D1fBpdCtcCVgwODJByOZrRo/T4uYlnGvBYM/2IFBV00JkYo1Et8HeedHzfwbk+/Y+mjj
         bVbWVGS7OUUtu6SlmnhgC8H9A7ch0CZNqTcC5fuXUv+xOJbpEKy9jirItD0Zg14Vnypx
         ImXGRgZ2/hl9ljk4eJMKthO9MDm9rn40AbRQ/RYq++wCCS576ljxyLO9/zHIW4878UXY
         utkLs5/UnZg+3AEQWdsUZeRfSn7GkERDZXzjHXVoy8D7F7GRN2/bIcRIKEEkojbOalOi
         F0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebrbdevgi6FUEgGptFpxVEWU1y5LoDhpQCpoVTGFgpI=;
        b=l5Un+JwOsVKq+ryKiODmo1Pz1Ytd1hltg40KjgN0VOOJFdUcqOcO1d8bcfRAE3SvHX
         4CDgFdeLgNqQUXEde9hqmorw1J5yBAnRsO4hYFAlVxnxu26ABHwvR/iWw8y6LEu0bHs+
         ne3JO21H7SfbpUWJOualXg9id7aLW2tBlHTH+A3++R6wZiRKnEL2g8aDqNR2uiCx5Q2k
         XCwZHruXJoUO8oMWGs0dH/lGIetkezfJVWDMFGjJF43vIpqZo0MH4Zr2gf1oirgu4HQI
         MTluvOEbfTxUNZ9ZMnC1N6Ve35Zk5bjxc/+zbQElA6iC3TJbJJW6EahV2vs+KcyMIbiz
         VXrQ==
X-Gm-Message-State: AOAM532DwKisREy1xt2/UrXoW3kiX7CoyHx22jdFGYEfVOcmF6EhB48e
        dvCH6VmaUjM9oNiwExSRNsM=
X-Google-Smtp-Source: ABdhPJy0jDZ/zVvduDcp9a1AxIP7XAFKOmnv+DVoCdvpr9feTsPwKmR4vpLfIf2wDkQ/Y6MYsq03iw==
X-Received: by 2002:a1c:7f8b:: with SMTP id a133mr3779131wmd.155.1601478488825;
        Wed, 30 Sep 2020 08:08:08 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id k4sm3613486wrx.51.2020.09.30.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 08:08:08 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: Check if Qt has been found when building the examples
Date:   Wed, 30 Sep 2020 18:07:40 +0300
Message-Id: <20200930150741.224779-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200930150741.224779-1-y.karadz@gmail.com>
References: <20200930150741.224779-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some of the examples depend on Qt. Check is Qt exists befor trying
to build these examples.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 35e6b1e..032f305 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
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
2.25.1

