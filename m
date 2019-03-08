Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BC1C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7A920851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfCHRP0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:15:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51919 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfCHRP0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:15:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id n19so13209324wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+Kf/O1tmvXj0y/puSt+huAvrppxEVmqP6IUqrPfKeY=;
        b=aBXaRAGvpyda4wHHPztvg0nMRonYcmxvVS+y/BIhnmV+7Y1I5RWQKdlXG/nlBcyBf8
         /x7XE+2tV+y9DAAno8mrIq8g58K4p1j/wIbRkd2y66uy/9CLI2/J4BPRpkL1TMRGkEv7
         o14edVyY9ezW3Mcyrpo3B6t5ryR9KpkioRXl9IizMhBCNFJe5dSHeHss6iRd1Yqo4D4N
         1KeD/RtgPjdOyTa8bARTkx3RLMk2SKwwSfZg54N79tTleEsv0CeyCwbDCqoIlxVe8vzM
         lVdade25io5K9rGneQ9KM9hd9bFFge9Q8wuPLcwjzMlKTWnRm3LGaU/Cmrdr2hkHYlct
         uK/g==
X-Gm-Message-State: APjAAAXCxX+gaMlyOkpRYFSrXmIHB7BFwyV5XxXJBOjuMIUobGzsWCEE
        0WDT4apJAVLVz6vIDZKiFyZYHYNjcFA=
X-Google-Smtp-Source: APXvYqxo4fyzJbhYimyyPg49g78JexrdGDL6v55jmOu2FIyoUxq57WE1dlp6uOYSoViCGvR73vEb3g==
X-Received: by 2002:a1c:4889:: with SMTP id v131mr9750527wma.146.1552065324761;
        Fri, 08 Mar 2019 09:15:24 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id 2sm8026978wrg.89.2019.03.08.09.15.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:15:24 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/3] kernel-shark: Save the configuration information in ${HOME}/.kshark
Date:   Fri,  8 Mar 2019 19:15:11 +0200
Message-Id: <20190308171512.15372-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171512.15372-1-ykaradzhov@vmware.com>
References: <20190308171512.15372-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default the "Last session" configuration file will be saved in
${HOME}/.kshark

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile                    | 2 +-
 kernel-shark/CMakeLists.txt | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index b780718..967c364 100644
--- a/Makefile
+++ b/Makefile
@@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
 CMAKE_COMMAND = /usr/bin/cmake
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DKS_CONF_DIR=$(HOME)/.kshark ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20ced14..3c3beb0 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -14,7 +14,7 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
 
 # Make a directory to hold configuration files. To change this do:
 # cmake .. -DKS_CONF_DIR=/your/preferred/path
-set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
+set(KS_CONF_DIR "$ENV{HOME}/.kshark" CACHE STRING "Directory for configuration files.")
 file(MAKE_DIRECTORY ${KS_CONF_DIR})
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
@@ -59,7 +59,8 @@ include_directories(${KS_DIR}/src/
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
 message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
-message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
+message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
+message(STATUS "config. files saved in ${KS_CONF_DIR}")
 
 add_subdirectory(${KS_DIR}/src)
 add_subdirectory(${KS_DIR}/examples)
-- 
2.19.1

