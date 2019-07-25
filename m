Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8EEC76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 20:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DCA1218F0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 20:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfGYUmn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 16:42:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40304 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfGYUmn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 16:42:43 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 1AF93348AEE
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 20:42:43 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Allow setting of the name of Python in pkgconfig
Date:   Thu, 25 Jul 2019 13:42:37 -0700
Message-Id: <20190725204237.3864194-1-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

Some vendors use different names for Python in pkgconfig, this allows
the name of the Python version in pkgconfig to differ from the Python
interperter name. The default remains the Python version.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 3e63e9e..3afd982 100644
--- a/Makefile
+++ b/Makefile
@@ -115,9 +115,10 @@ PYTHON		:= ctracecmd.so
 PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 
 PYTHON_VERS ?= python
+PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
 
 # Can build python?
-ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_PKGCONFIG_VERS) > /dev/null 2>&1 && echo y"), y)
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	BUILD_PYTHON_WORKS := 1
@@ -387,8 +388,8 @@ report_nopythondev: force
 	$(Q)echo
 
 ifndef NO_PYTHON
-PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_VERS)`
-PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
+PYTHON_INCLUDES = `pkg-config --cflags $(PYTHON_PKGCONFIG_VERS)`
+PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_PKGCONFIG_VERS)` \
 		$(shell $(PYTHON_VERS)-config --ldflags)
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 else
-- 
2.22.0

