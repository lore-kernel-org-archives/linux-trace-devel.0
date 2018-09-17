Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41110 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbeIQT5w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 15:57:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id z96-v6so17566932wrb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Sep 2018 07:30:16 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark-qt: Add "-O2" compiler flag
Date: Mon, 17 Sep 2018 17:29:41 +0300
Message-Id: <20180917142942.7975-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

"-O2" compiler option is added to both C and C++ compiler flags.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 0187eb4..7769604 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -23,8 +23,8 @@ find_package(GLUT)
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
-set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread")
-set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread")
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -O2 -pthread")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -O2 -std=c++11 -pthread")
 
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
-- 
2.17.1
