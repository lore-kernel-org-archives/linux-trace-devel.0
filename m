Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571ECC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 287AE21736
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfDSTle (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:41:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52961 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbfDSTle (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:41:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id a184so7190239wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZholOoeJP1gQpb7Y3E228BQvRpmVngdqPJVFbaYLOMc=;
        b=IvwkzY14RKN+wDtLmOKGUtHQi6eUGEGV9K2YRFNs6M+PFbM5MVKjKv1vfK8ubVP36H
         vEWCeMcZ8R9a0xmEg7GkWJwFAJBEC0wq/kalHA+5b2cN0oxv4T1fpiMpAEZJHiaVAuu0
         YfxxPrL5z8irmzgisZP4fsWxZpyjHD7/F3WyeXotM/rUfsuMsY6puWQ9QXxHmm0yYMii
         TJhMazK2mZw9oZ59W4ntcfUwGygPBgkEgnBEVIsVY9yS68laLpVkCCdd2VFV/DCHSqrD
         T1D2P3a5ug5xJqPFnAhRFlSgDoc/e+pWWmfrJKMNqFrDV3U2B3o+Zqg1bCSd/mJmflCM
         +0OQ==
X-Gm-Message-State: APjAAAXWD2z6MFfjj6pfZHQb00kLqDUxMUj1J0+u8pErflwO0pkgiC3V
        tCaU+yqHzij10kOO1Qc0k3/wrSLp
X-Google-Smtp-Source: APXvYqxSSG/LB6NOMc/O/0mYcdRwGDrYCahYou0UfHUg+jE/yamVMQk6+f7EKsTcbRNTGkv/+aVaDg==
X-Received: by 2002:a1c:a683:: with SMTP id p125mr2802471wme.151.1555681858050;
        Fri, 19 Apr 2019 06:50:58 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.50.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:50:57 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 2/8] kernel-shark: Remove the definition of KS_CONF_DIR
Date:   Fri, 19 Apr 2019 16:50:30 +0300
Message-Id: <20190419135036.19340-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KS_CONF_DIR is no longer used, so we do not need to define it in the
Cmake-generated header file.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt     | 5 -----
 kernel-shark/build/deff.h.cmake | 3 ---
 2 files changed, 8 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 10cb696..1aee858 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -12,11 +12,6 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
-# Make a directory to hold configuration files. To change this do:
-# cmake .. -DKS_CONF_DIR=/your/preferred/path
-set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
-file(MAKE_DIRECTORY ${KS_CONF_DIR})
-
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
 
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 80d624c..8041cfc 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,9 +14,6 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
 
-/** KernelShark configuration directory path. */
-#cmakedefine KS_CONF_DIR "@KS_CONF_DIR@"
-
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
 
-- 
2.20.1

