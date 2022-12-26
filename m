Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDCAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Dec 2022 16:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiLZQ6B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Dec 2022 11:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiLZQ5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Dec 2022 11:57:54 -0500
X-Greylist: delayed 448 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Dec 2022 08:57:53 PST
Received: from smtpx.fel.cvut.cz (smtpx.feld.cvut.cz [147.32.210.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363B71176
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Dec 2022 08:57:52 -0800 (PST)
Received: from localhost (unknown [192.168.200.17])
        by smtpx.fel.cvut.cz (Postfix) with ESMTP id E1FB2142FE;
        Mon, 26 Dec 2022 17:50:21 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.fel.cvut.cz ([192.168.200.2])
        by localhost (styx2.feld.cvut.cz [192.168.200.17]) (amavisd-new, port 10060)
        with ESMTP id Fk_ISxbQcqdf; Mon, 26 Dec 2022 17:50:19 +0100 (CET)
Received: from resox.2x.cz (ip-89-103-132-49.bb.vodafone.cz [89.103.132.49])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sojkam1)
        by smtpx.fel.cvut.cz (Postfix) with ESMTPSA id 9001B140FA;
        Mon, 26 Dec 2022 17:50:18 +0100 (CET)
Received: (nullmailer pid 2632083 invoked by uid 1000);
        Mon, 26 Dec 2022 16:50:18 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Jan Engelhardt <jengelh@inai.de>,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] trace-cmd: Allow building with GNU Make 4.4
Date:   Mon, 26 Dec 2022 17:49:51 +0100
Message-Id: <20221226164951.2632069-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make 4.4 introduces several backward incompatibilities and the result
is that building trace-cmd with it never finishes. It seems that make
ends up in some kind of infinite recursion. The symptoms are:

    $ make -d
    GNU Make 4.4
    Built for x86_64-pc-linux-gnu
    Copyright (C) 1988-2022 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Reading makefiles...
    Reading makefile 'Makefile'...
    Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
    Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
    Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
    Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
    Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
    Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
    Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
    Makefile:79: not recursively expanding pkgconfig_dir to export to shell function

Build succeeds if recursively expanded variables (defined with '='),
which use $(shell ...) as its value, are replaced with simply expanded
variables (defined with ':=').

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 Makefile | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index bda49dd..d50e625 100644
--- a/Makefile
+++ b/Makefile
@@ -221,8 +221,8 @@ LIBS ?= -ldl
 LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
 LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so.$(LIBTRACECMD_VERSION)
-LIBTRACECMD_SHARED_VERSION = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
-LIBTRACECMD_SHARED_SO = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
+LIBTRACECMD_SHARED_VERSION := $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
+LIBTRACECMD_SHARED_SO := $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
 
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
@@ -230,12 +230,12 @@ export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
 LIBTRACEEVENT=libtraceevent
 LIBTRACEFS=libtracefs
 
-TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
-TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
+TEST_LIBTRACEEVENT := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
+TEST_LIBTRACEFS := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
 
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
-LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
-LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
+LIBTRACEEVENT_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
+LIBTRACEEVENT_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
 else
 .PHONY: warning
 warning:
@@ -253,8 +253,8 @@ endif
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
 
 ifeq ("$(TEST_LIBTRACEFS)", "y")
-LIBTRACEFS_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
-LIBTRACEFS_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
+LIBTRACEFS_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
+LIBTRACEFS_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
 else
 .PHONY: warning
 warning:
@@ -324,11 +324,11 @@ endif
 export ZLIB_LDLAGS
 
 ifndef NO_LIBZSTD
-TEST_LIBZSTD = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
+TEST_LIBZSTD := $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
 
 ifeq ("$(TEST_LIBZSTD)", "y")
-LIBZSTD_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
-LIBZSTD_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
+LIBZSTD_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
+LIBZSTD_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
 CFLAGS += -DHAVE_ZSTD
 ZSTD_INSTALLED=1
 $(info    Have ZSTD compression support)
-- 
2.38.1

