Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C33EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 240BB2312F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbhAFQMo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbhAFQMo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:44 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11765C06135A
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id h16so4866501edt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=RyEOAPgyFNfnfTut6h3hzXp0fb8WNmpylfxVeIc2l5Jz+azg0X8TCkmDqcS7J+xLxP
         ybDv1uDJvoKnEDhaPECruh/wn07cDRtg3x1BDXMEtoVUjzh46VyMM5EMdV/ysOb9t2bI
         rmIqMnfo7sUUUaNDiJgUPrBw/I7vDNGz9SON8YN5sIxWrY0J2INRRwhCeTV8nF/u+eH4
         /EDV+QyuSnaMFA8X9ebFvtZqWc7hdibVvbGVjKjz0vZdIf+4JLb9HrjAYjheH0jsbFVC
         e4KKB3ZtaZmrkkTq1KgCLCCzWcSDj8zRdvQg84lEIvtPms1ABme7lmRkIdyFH+HRC3B2
         J2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=WubS5r9PnTEVSWMz7/hSTgE/JL73dzA4DsGkZ1NuC7t23+Yyji0lgJT0YEwOt2yO8z
         tzw8Rvl+0MAXsTG5j2cu+8bh5oavIEhrAGgRizCTQqYptUAQmnCJcoVO9u7rAPT3cbte
         9M6Fe3DYVIygiGVWXFHZfzsanfOm0jjyof+RyMezy7+PXn1eCJRQwPHI4kpg59HFX2w2
         6+AY1EjQ4/HHyz3KEAjQUC8Odhy6XUINAHHt6ZvSPwTGT6DZgQFxzmRiPYA+NIOx7FdQ
         S65fN5spUVm6pSwrZK3SzfvRG+OuD7MjYINSGeIdet+m2kInMffBUMQdelnhQfYUXkwy
         11bA==
X-Gm-Message-State: AOAM533BI8kEa2mTJ0KBrhaVpMaGGqbSQaaBlkG0uM8C6e76G2RNv/QU
        h7SMQaKYcOC2mWjp5F4xj+s=
X-Google-Smtp-Source: ABdhPJxUpk0EC4EQwLJSGcSq+azYAbxrXEw/dlmLKXhRF7DJJyCqpwV4FgWqpHzp79yZPiryK61+hw==
X-Received: by 2002:a05:6402:41:: with SMTP id f1mr4365333edu.286.1609949497873;
        Wed, 06 Jan 2021 08:11:37 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:37 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/6] kernel-shark: Start using C++17
Date:   Wed,  6 Jan 2021 18:11:18 +0200
Message-Id: <20210106161120.119085-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106161120.119085-1-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Update to a more recent version of the C++ standard. The particular
motivation to do this change now is because, we would like to use
"auto" as a function parameter type for lambda functions.

Signen-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 9abacd0..dd62091 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -62,8 +62,12 @@ find_package (Boost COMPONENTS unit_test_framework)
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
-set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
-set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC -fno-common")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pthread -fPIC -fno-common")
+
+set(CMAKE_CXX_STANDARD 17)
+set(CMAKE_CXX_STANDARD_REQUIRED ON)
+set(CMAKE_CXX_EXTENSIONS OFF)
 
 if (NOT CMAKE_BUILD_TYPE)
     set(CMAKE_BUILD_TYPE RelWithDebInfo)
-- 
2.25.1

