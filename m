Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E9C31E5C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520C52089E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfFQWcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfFQWcY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:32:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0176A2064B;
        Mon, 17 Jun 2019 22:32:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hd0Ao-000344-2a; Mon, 17 Jun 2019 18:32:22 -0400
Message-Id: <20190617223221.968420020@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 17 Jun 2019 18:31:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Add make BUILD_TYPE=X gui to change how the gui is
 made
References: <20190617223129.706595135@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a option to the Makefile called "BUILD_TYPE" that is passed to the CMake
commonds to change how kernelshark is built. The current options are:

 make BUILD_TYPE=Debug gui          - for "-g" option
 make BUILD_TYPE=Release gui        - for "-O3" option
 make BUILD_TYPE=RelWithDebInfo gui - for "-g -O2" option (default)
 make BUILD_TYPE=MinSizeRel gui     - for "-Os" option

By default, BUILD_TYPE is set to RelWithDebInfo.

Also change the CMakeLists.txt to use RelWithDebInfo as the default
instead of just Debug.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                    | 5 ++++-
 kernel-shark/CMakeLists.txt | 2 +-
 kernel-shark/README         | 6 +++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index c9679d42fdbd..ad74a969249f 100644
--- a/Makefile
+++ b/Makefile
@@ -252,8 +252,11 @@ all_cmd: $(CMD_TARGETS)
 
 CMAKE_COMMAND = /usr/bin/cmake
 
+# Build with "BUILD_TYPE=Release" to remove cmake debug info
+BUILD_TYPE ?= RelWithDebInfo
+
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index d932c396e4a6..58a3c3b84309 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -37,7 +37,7 @@ set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
 
 if (NOT CMAKE_BUILD_TYPE)
-    set(CMAKE_BUILD_TYPE Debug)
+    set(CMAKE_BUILD_TYPE RelWithDebInfo)
 endif (NOT CMAKE_BUILD_TYPE)
 
 message("\n Build type: ${CMAKE_BUILD_TYPE}")
diff --git a/kernel-shark/README b/kernel-shark/README
index 4fb13698261b..15d6fbab36fd 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -59,9 +59,13 @@ CMAKE_XXXX_FLAGS_PACKAGE Command-Line options (see the example below).
 Note that when built as a "Package" the RPATH-s of the executables are
 set directly to _INSTALL_PREFIX/lib/kernelshark/
 
-If no build types is specified, the type will be "Debug".
+If no build types is specified, the type will be "RelWithDebInfo".
 
 Examples:
+    make BUILD_TYPE=Release
+
+  or directly with cmake in the kernel-shark/build directory:
+
     cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
 
     cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
-- 
2.20.1


