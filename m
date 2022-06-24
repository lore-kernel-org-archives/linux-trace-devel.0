Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79729C43334
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Jun 2022 21:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiFXVHb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 17:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiFXVHa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 17:07:30 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8852C85791
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Jun 2022 14:07:28 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id C1BDA587264B9; Fri, 24 Jun 2022 23:07:26 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 6B0205872649E;
        Fri, 24 Jun 2022 23:07:26 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH] libtracefs: unbreak parallel build
Date:   Fri, 24 Jun 2022 23:07:26 +0200
Message-Id: <20220624210726.84857-1-jengelh@inai.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The build is not parallel-safe. In particular,

	while :; do make clean; make -j8;
	ldd -r lib/libtracefs.so.1.4.1; done

randomly emits:

	undefined symbol: add_to        (/usr/lib64/libtracefs.so.1)
	undefined symbol: add_field     (/usr/lib64/libtracefs.so.1)
	undefined symbol: my_yyinput    (/usr/lib64/libtracefs.so.1)
	[...]

A file gets regenerated in one job while another reads it. The
hypothesis can be tested by interjecting the linker command. Like so:

	@@ -73,7 +73,8 @@ do_build_static_lib =                         \

	 do_compile_shared_library =                    \
		($(print_shared_lib_compile)            \
	-       $(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
	+       mkdir -p $$$$; cp -v $^ $$$$/; \
	+       $(CC) --shared $$$$/* '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))

	 do_compile_plugin_obj =                                \
		($(print_plugin_obj_compile)            \

This then reveals that indeed there is truncation:

	$ ls -lgo src/25067/
	total 416
	drwxr-xr-x 2  4096 Jun 20 17:07 .
	drwxr-xr-x 9  4096 Jun 20 17:07 ..
	-rw-r--r-- 1 39240 Jun 20 17:07 sqlhist-lex.o
	-rw-r--r-- 1 36088 Jun 20 17:07 sqlhist.tab.o
	-rw-r--r-- 1 28912 Jun 20 17:07 tracefs-dynevents.o
	-rw-r--r-- 1  5288 Jun 20 17:07 tracefs-eprobes.o
	-rw-r--r-- 1 46592 Jun 20 17:07 tracefs-events.o
	-rw-r--r-- 1 31136 Jun 20 17:07 tracefs-filter.o
	-rw-r--r-- 1 66840 Jun 20 17:07 tracefs-hist.o
	-rw-r--r-- 1 45368 Jun 20 17:07 tracefs-instance.o
	-rw-r--r-- 1  8056 Jun 20 17:07 tracefs-kprobes.o
	-rw-r--r-- 1 10912 Jun 20 17:07 tracefs-marker.o
	-rw-r--r-- 1     0 Jun 20 17:07 tracefs-sqlhist.o
	-rw-r--r-- 1 44968 Jun 20 17:07 tracefs-tools.o
	-rw-r--r-- 1  6080 Jun 20 17:07 tracefs-uprobes.o
	-rw-r--r-- 1 20784 Jun 20 17:07 tracefs-utils.o

The lines emitted by make also speak a rather clear picture (but I
agree we tend to not read it most of the time, especially when the
build is performed by the infrastructure of distributions and with
make V=1).

	$ make clean; make -j16
	  CLEAN              utest
	  CLEAN              src
	  CLEAN              samples
	  CLEAN              libtracefs
	  DESCEND            src libtracefs.so
	make[1]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
	  COMPILE FPIC       tracefs-utils.o
	  DESCEND            src libtracefs.a
	make[1]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
	  COMPILE FPIC       tracefs-utils.o
	  UPDATE             build_prefix
	  UPDATE             tfs_version.h
	  COMPILE FPIC       tracefs-instance.o
	  COMPILE FPIC       tracefs-instance.o
	  COMPILE FPIC       tracefs-events.o
	  COMPILE FPIC       tracefs-events.o
	[...]

The problem stems from two targets (libtracefs.a, libtracefs.so)
_individually_ invoking recursive make, which of course have no
knowledge of one another with respect to which targets have already
been made.

So make job #1 processes the libtracefs.a rule, whose command invokes
a sub-make which, at the time of checking, finds no .o files and
queues gcc invocations to build those file. Meanwhile, make job #2
processes the libtracefs.so rule, whose command also invokes a
sub-make which, at the time of checking, *also* finds no .o files and
queues gcc invocations for the *same* objects.

Entering a directory concurrently is worse than anything the
"recursive make considered harmful" essay could ever think of.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index fa0ba47..0044656 100644
--- a/Makefile
+++ b/Makefile
@@ -388,3 +388,7 @@ clean:
 	  $(BUILD_PREFIX))
 
 .PHONY: clean
+
+# libtracefs.a and libtracefs.so would concurrently enter the same directory -
+# a recipe for collisions.
+.NOTPARALLEL:
-- 
2.36.1

