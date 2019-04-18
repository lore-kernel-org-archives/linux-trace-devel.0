Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8F5C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43D3820821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfDRPWm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34060 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbfDRPWm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id w16so3477618wrl.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Il9dtqM4rEE4fCxC1xW8TVogsDxVa6Mcnm6E5248sis=;
        b=H+Uo4U8xsOaAbtfvXe0oEnzpUzBqBWn0qkjdcB7kCkj55ajuXj69eJAVqe4UlN1qrb
         Ud8fAZdPi9aicr4vyeZIYbfJ43ka7Bzk4nONc5m387vCzToyD2LzFj7MQbVr8PQVj2cp
         7i8Hz2eoImaE2jiZ83PLuIY0g4kuEgqk/yZlDCLKLYKsCSfcoNU1IAw9QDrVYWDI1+5d
         ZdG32/imBCt5MBG08EpTD2lrvfKOAC86+g2lIJlqHUpGccQ+KAmsEAXdkX5I9qxSUBW1
         eZCQrtPoBC/TR2h1Gzx5DSvSjqUXKhj9vJI2IIp4dzaALaIK2IhJMT3JDyYqKxZX5F/3
         NB/g==
X-Gm-Message-State: APjAAAXBPTo9+J+J7PKmXiVcqOowlqLMAqSab0Ja392BBExJUGOLjWXl
        RV5q0pgZtzOM5xbD/v4pRWc=
X-Google-Smtp-Source: APXvYqwTV8dAzZJUwizJ+4xhLtLUd963h8Atl6ufdvBfI6rCwZQI413oBGiWrmZZX+Gmbxpb2dLfxA==
X-Received: by 2002:adf:f149:: with SMTP id y9mr7440513wro.273.1555600960384;
        Thu, 18 Apr 2019 08:22:40 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:40 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 2/8] kernel-shark: Remove the definition of KS_CONF_DIR
Date:   Thu, 18 Apr 2019 18:21:40 +0300
Message-Id: <20190418152146.27232-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
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
2.19.1

