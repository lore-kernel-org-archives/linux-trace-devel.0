Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A5EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C758C23118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbhAGQQt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbhAGQQt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:16:49 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC536C0612F9
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:08 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x16so10436239ejj.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=VjmhkPOGSzA0apaVGJGw7A7VovnSh2H16vf+YLs+LmlBchgMPHWhtcfj50glfBvPqB
         kKU2+sNI7NjYuQVXPIuH6X0vwuNxoUBYliuJ/q3qX+zcb/lQWkTtto4vyQ7zRiR7913E
         BoyJAWDOHrHz+Lbjtnz5TSk/kDEpYqcOBTcgrx5vojp5r+4qEB7DprFE26/KW9RZ8uB+
         3rAqEVFyFUWOZiJsEwtd0WBH6NsG3AB18LE9HWZmBNr7XIy+GdQ9gtWSuKqiVIybDaIh
         fctqAJh7tqlnfhotWwd+zUt2Y9wMOkOYS4XOz/aWtFVOizZ8VX2BJRvIaeMijMrT058x
         CpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=P64rQGwgi3jrkbPXpcHtRy+MdjFo5eTeokEbSGiDh/4jRkyW57/hxs0sanlYpl3TDi
         bMDixmoet/c9sFeSXAfyVQujbEgyRkLIrdeIlPFNAQlTLJy6HEG1ZHcrlX6K7GpmoMsb
         d83gh7Q1GFB3IE9nTIExLKjxDMKiqsWMNq49JFXF/iRpa11q+TZPPNRFlIGbnOm1jw6F
         1bDmb16kxqIPPrDDEijlF5LdcSpgf140+xrd++E3Bxv5c64QAYrz2vV1VHDYeVx2ookl
         ikwOtEcU+wG8YDXWI25rPY2aLO4mxETBrtX0UaV0EhsaHLclH3B8bLM/9YAwAptOgm9U
         mHEg==
X-Gm-Message-State: AOAM533Oe6Ac8olhZd91d1R/Wvz/atotGtEZcWY29s///LzuSP84zsZ3
        8TC7aNl9xFMkd1fR6+4uEiJ1yRWp8eU/5w==
X-Google-Smtp-Source: ABdhPJz++kaJ4WKYXi0QWpFLVirXXBgOhvNb/Tr0ubUDXIaXFKXSXVnfTvvCswzIVrJPAV4af9mzkg==
X-Received: by 2002:a17:906:589:: with SMTP id 9mr7032786ejn.229.1610036167506;
        Thu, 07 Jan 2021 08:16:07 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:06 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/6] kernel-shark: Start using C++17
Date:   Thu,  7 Jan 2021 18:15:45 +0200
Message-Id: <20210107161547.207270-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
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

