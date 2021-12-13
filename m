Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FAAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 19:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhLMTQG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 14:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhLMTQF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 14:16:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F5C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 11:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7812BB81289
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 19:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2478C34602
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 19:16:02 +0000 (UTC)
Date:   Mon, 13 Dec 2021 14:16:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH for 2.9] trace-cmd: Fix python build to handle new library
 headers
Message-ID: <20211213141601.480b173d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The python build still references the internal event-parse.h header even
if the latest libtraceevent is installed on the system. This causes
inconsistencies between what's in the updated system header with the
obsoleted internal header.

Update the make files to use the proper header to build the python code as
the rest of the build uses.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile        | 7 ++++---
 python/Makefile | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 2ff40a8e..3bcafd74 100644
--- a/Makefile
+++ b/Makefile
@@ -280,7 +280,9 @@ export LIBTRACEFS_CFLAGS LIBTRACEFS_LDLAGS
 TRACE_LIBS = -L$(LIBTRACECMD_DIR) -ltracecmd	\
 	     $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
-export LIBS TRACE_LIBS
+TRACE_INCLUDES = $(LIBTRACEEVENT_CFLAGS) $(LIBTRACEFS_CFLAGS)
+
+export LIBS TRACE_LIBS TRACE_INCLUDES
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR LIBTRACEFS_DIR
 export Q SILENT VERBOSE EXT
 
@@ -292,8 +294,7 @@ INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/lib/trace-cmd/include/private
 INCLUDES += -I$(src)/tracecmd/include
-INCLUDES += $(LIBTRACEEVENT_CFLAGS)
-INCLUDES += $(LIBTRACEFS_CFLAGS)
+INCLUDES += $(TRACE_INCLUDES)
 
 include $(src)/features.mk
 
diff --git a/python/Makefile b/python/Makefile
index d2906c4f..ddb9af4c 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -9,8 +9,8 @@ PYTHON_PY_LIBS := tracecmd.install
 endif
 
 ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
-	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
+	swig -Wall -python -noproxy -I$(src)/include/trace-cmd $(TRACE_INCLUDES) ctracecmd.i
+	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES) $(TRACE_INCLUDES) ctracecmd_wrap.c
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
 
 $(PYTHON_SO_INSTALL): %.install : %.so force
-- 
2.31.1

