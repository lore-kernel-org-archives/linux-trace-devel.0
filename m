Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34215C433E6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03988238A1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbhAHOcj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jan 2021 09:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbhAHOcj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jan 2021 09:32:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15079C0612FE
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jan 2021 06:31:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p22so11309775edu.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Jan 2021 06:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=JWduVzasZxft8iKzPuYzzrnytO3r8eukytsk5t47TvEo0HwaC7sRN4frxE9FAS04DF
         kEUjnRcSh7d1kfpUy4uAMAy3C/Ju+OTh5PNgIWIZvzlIqltt4IxTuRAvBKc+Pr0B6SKh
         PItEsM1xFdhRrm+RHeYiJPfnI9ureqkLdijqkh1+cqAxMJ3VGMH7EDnj6dxkkvqs0yoA
         FhEbEE3wW5Gp+gXQCPkUkfcUjbjX0LHstbKkz7NwZ4mO2zrlugp+tviucgXc18J1Fmrn
         N68+kdKbXAUVMB8sBvUPmC2Szncb1321A2s2iyRYA8x3wvdZLP5EYzzpUtt14eocJJpD
         baug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jo+XK2A5ZjaTMZ0pG8VBbZT5SAXfAyjI5CCbxG2kVk=;
        b=Xs+FpuCFPPTnKACyo3b9NnoOzcdCHLhBYV3SblKC2OA3WiRVXfRE//OQv/dTxlwd63
         mfbHZuLJZVOUUbezGTr1OzgzjNrjZMwKFcaSThquMapRUGDA65Q6C3lIBdV6vBQoHAJS
         yxgRHDrny/d0VrB5tmpFLzYJG1hddrfzksC8/92QwkLEKa2gKztNCbsbhRL6CKM/miVc
         Vlh6ZY8m/0hIOJG/RbCtvFtRDIBfr3ythy+qerdNpxq0yE2TEWcmAJOPN0tpohC4oJyw
         +yeZgGszyNWjwNocHiNruQ8jyZN0hZfqxNAUWNZbfUqwDc3r5l3i8fSpg6M7tZCVtKFA
         LPXA==
X-Gm-Message-State: AOAM5314nx5/HiiC3asAHTyNMm6k3lo/MfTAfxsYbZc0Ursc8UwL2oFP
        EkfN3LVX0b1W0wTO46RQL368lTmKRwlXig==
X-Google-Smtp-Source: ABdhPJxhKUxYqPiu4G7NS8AGXsI9jyfTmILQeQXH5uTb4D+VkVZBWw1hS3oFFf5WUz6Xy5iwvwGZog==
X-Received: by 2002:aa7:cd06:: with SMTP id b6mr5425912edw.43.1610116317872;
        Fri, 08 Jan 2021 06:31:57 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id d13sm3588120ejc.44.2021.01.08.06.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 06:31:57 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 4/6] kernel-shark: Start using C++17
Date:   Fri,  8 Jan 2021 16:31:38 +0200
Message-Id: <20210108143140.285037-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108143140.285037-1-y.karadz@gmail.com>
References: <20210108143140.285037-1-y.karadz@gmail.com>
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

