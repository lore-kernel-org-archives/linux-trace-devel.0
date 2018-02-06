Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35186 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbeBFItm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:42 -0500
Received: by mail-pl0-f67.google.com with SMTP id j19so855126pll.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:42 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 17/24] trace-cmd: Fix the logic behind SWIG_DEFINED in the Makefile
Date: Tue,  6 Feb 2018 10:48:59 +0200
Message-Id: <20180206084906.9854-18-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

At least on Ubuntu, the $(shell ...) command used in the master Makefile to test
for the existence of the 'swig' command does not work in the negative case.
That causes the build to report ugly errors in case 'swig' is not installed on
the system.
This one-line patch, fixes the problem by using the POSIX 'comamnd -v {CMD}'
in $(shell ...) to detect the presence of the swig and restores this way the
fake report_noswig target.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index cc96534..6016bec 100644
--- a/Makefile
+++ b/Makefile
@@ -103,7 +103,7 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-SWIG_DEFINED := $(shell if swig -help &> /dev/null; then echo 1; else echo 0; fi)
+SWIG_DEFINED := $(shell if command -v swig; then echo 1; else echo 0; fi)
 ifeq ($(SWIG_DEFINED), 0)
 BUILD_PYTHON := report_noswig
 NO_PYTHON = 1
@@ -116,7 +116,7 @@ PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 PYTHON_VERS ?= python
 
 # Can build python?
-ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && which swig && echo y"), y)
+ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	BUILD_PYTHON_WORKS := 1
-- 
2.14.1
