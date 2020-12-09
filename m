Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA447C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9667023B19
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgLIEWB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C4D2389E
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqye-0002z5-Ag
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:20 -0500
Message-ID: <20201209042120.195302380@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] libtraceevent: Use macro names for libtraceevent library binaries
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to move the libtraceevent library binaries to their own location in
the build directory, use macros for their names in the Makefile. This will
facilitate the changes to have their final locations be updated.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index ea00085091e4..e17e9674573b 100644
--- a/Makefile
+++ b/Makefile
@@ -94,8 +94,11 @@ N		=
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-LIB_TARGET  = libtraceevent.a libtraceevent.so libtraceevent.so.$(EP_VERSION) libtraceevent.so.$(EVENT_PARSE_VERSION)
-LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIBTRACEEVENT_STATIC = libtraceevent.a
+LIBTRACEEVENT_SHARED = libtraceevent.so.$(EVENT_PARSE_VERSION)
+
+LIB_TARGET  = $(LIBTRACEEVENT_STATIC) libtraceevent.so libtraceevent.so.$(EP_VERSION) $(LIBTRACEEVENT_SHARED)
+LIB_INSTALL = $(LIBTRACEEVENT_STATIC) libtraceevent.so*
 LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/include $(CONFIG_INCLUDES)
@@ -142,16 +145,16 @@ all_cmd: $(CMD_TARGETS)
 $(TE_IN): force
 	$(Q)$(MAKE) $(build)=libtraceevent
 
-$(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION): $(TE_IN)
+$(OUTPUT)$(LIBTRACEEVENT_SHARED): $(TE_IN)
 	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@  $(LIBS)
 
 $(OUTPUT)libtraceevent.so: $(OUTPUT)libtraceevent.so.$(EP_VERSION)
 	@ln -sf $(<F) $@
 
-$(OUTPUT)libtraceevent.so.$(EP_VERSION): $(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION)
+$(OUTPUT)libtraceevent.so.$(EP_VERSION): $(OUTPUT)$(LIBTRACEEVENT_SHARED)
 	@ln -sf $(<F) $@
 
-$(OUTPUT)libtraceevent.a: $(TE_IN)
+$(OUTPUT)$(LIBTRACEEVENT_STATIC): $(TE_IN)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
 $(OUTPUT)%.so: $(OUTPUT)%-in.o
-- 
2.29.2


