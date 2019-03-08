Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6390C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5B5420851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfCHRPZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:15:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33174 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfCHRPZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:15:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so22160928wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aufaCDtkY9mXlP1hwty/h041sVOcnpu0fmxVOqJsGKg=;
        b=uG+kzxfGpjRqpP3Jh0ip5ZNRSVTmY1zYGp799HKB2/p91ZTNkA4u3c4jNB1kGhudlM
         R89PGdJvS6kxtT/gngNALWX2UvUAhCq1vAw4em2jTS3vpiGs9iFFGCL3cA9le4Lw6QQM
         VPlH8fysTYmaVRKt0mv+8aslBWftj42csdz6Sow6yFYNu8JOdSGTBL4MzHajUxqarIIZ
         1Ob186ppLzlZjwoGPgeKqk5fM3Ol5Xnd2KYNNScXpdrxrsfPykdGaqut7JigdsppGWjp
         KRX95ENc/RddYaJTZCOmcw75SMWrj36cVB6ljgssJp1qtn6O4sRZZ9MqToK08fQ8Tyok
         1QdQ==
X-Gm-Message-State: APjAAAWpYjaet8r0PLYdwCgJvhFRLivKEEWLYnRB6i5DHGnOnoFhvbD+
        hSSia24lSLhy+0vDTHq5/MM=
X-Google-Smtp-Source: APXvYqzBmRSJ1/j5ZgnyXc0dwKDn+CeFm9Ychxq1uQiQ96MfA3giBrKYzmPNtluB2YrMgYhn/f3bgA==
X-Received: by 2002:a5d:4d12:: with SMTP id z18mr12074149wrt.115.1552065323560;
        Fri, 08 Mar 2019 09:15:23 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id 2sm8026978wrg.89.2019.03.08.09.15.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:15:23 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/3] kernel-shark: Reorder the priority when searching for trace-cmd libs
Date:   Fri,  8 Mar 2019 19:15:10 +0200
Message-Id: <20190308171512.15372-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171512.15372-1-ykaradzhov@vmware.com>
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CMAKE build system of KernelShark performs automated search for the
trace-cmd libraries, headers and executable before building the GUI.
The new order of the list of directories to search in is the following:

1. ${TRACE_CMD}/  ($TRACE_CMD is an environment variable)

2. CMAKE_SOURCE_DIR/../

3. Platform / system specific locations

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/FindTraceCmd.cmake | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index fb2092a..b09a11b 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -14,17 +14,27 @@
 
 # MESSAGE(" Looking for trace-cmd ...")
 
+# First search in the user provided paths.
 find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
                                 PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                       ${CMAKE_SOURCE_DIR}/../tracecmd/)
+                                       ${CMAKE_SOURCE_DIR}/../tracecmd/
+                                NO_DEFAULT_PATH)
 
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/)
+                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/
+                                NO_DEFAULT_PATH)
 
 find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/)
+                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/
+                                NO_DEFAULT_PATH)
+
+# If not found, search in the default system paths. Note that if the previous
+# search was successful "find_path" will do nothing this time.
+find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
+find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h)
+find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
-- 
2.19.1

