Return-Path: <SRS0=/5S9=A7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6192AC433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7602070A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgGTQpA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:45:00 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:46606 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbgGTQo5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 12:44:57 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E273572CCDC;
        Mon, 20 Jul 2020 19:44:55 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [83.220.44.62])
        by imap.altlinux.org (Postfix) with ESMTPSA id BDCC94A4AEE;
        Mon, 20 Jul 2020 19:44:55 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     Vitaly Chikunov <vt@altlinux.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>
Subject: [PATCH 1/2] Makefile: Fix CUNIT_INSTALLED test to work with make 4.3 and dash
Date:   Mon, 20 Jul 2020 19:44:52 +0300
Message-Id: <20200720164453.5161-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In GNU Make 4.3 there is backward incompatible change that there is no need
to quote '#' in shell invocations anymore. If quoted, backslash character is
passed into gcc making cunit (and vsock) tests fail to compile.

Also, `echo -e' is replaced with `printf' to interpret '\n', because, on
Debian dash's `echo' does not support `-e', thus having `-e' passed into
test source making gcc fail to compile the test.

make test error message:

  Makefile:342: *** CUnit framework not installed, cannot build unit tests.  Stop.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Cc: Dmitry V. Levin <ldv@altlinux.org>
---
 Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4b72a04..6b606da 100644
--- a/Makefile
+++ b/Makefile
@@ -86,6 +86,8 @@ plugin_traceevent_dir_SQ = $(subst ','\'',$(plugin_traceevent_dir))
 plugin_tracecmd_dir_SQ = $(subst ','\'',$(plugin_tracecmd_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
+pound := \#
+
 VAR_DIR = -DVAR_DIR="$(var_dir)"
 VAR_DIR_SQ = '$(subst ','\'',$(VAR_DIR))'
 var_dir_SQ = '$(subst ','\'',$(var_dir))'
@@ -233,14 +235,14 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
-VSOCK_DEFINED := $(shell if (echo "\#include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+VSOCK_DEFINED := $(shell if (echo "$(pound)include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 
 export VSOCK_DEFINED
 ifeq ($(VSOCK_DEFINED), 1)
 CFLAGS += -DVSOCK
 endif
 
-CUNIT_INSTALLED := $(shell if (echo -e "\#include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
 export CFLAGS
-- 
2.11.0

