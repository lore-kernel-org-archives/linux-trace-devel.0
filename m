Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E2FC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E46F2389E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgLIEWm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgLIEWm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D8E23B4B
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqyf-000312-0A
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:21 -0500
Message-ID: <20201209042120.874416130@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/6] libtraceevent: Have binary libraries build into lib directory
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

To clean up the source directory, have the library binaries build into its
own "lib" directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 330c8339f023..9ec880c0105b 100644
--- a/Makefile
+++ b/Makefile
@@ -94,11 +94,15 @@ N		=
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-LIBTRACEEVENT_STATIC = libtraceevent.a
-LIBTRACEEVENT_SHARED = libtraceevent.so.$(EVENT_PARSE_VERSION)
+bdir = lib
 
-LIB_TARGET  = $(LIBTRACEEVENT_STATIC) libtraceevent.so libtraceevent.so.$(EP_VERSION) $(LIBTRACEEVENT_SHARED)
-LIB_INSTALL = $(LIBTRACEEVENT_STATIC) libtraceevent.so*
+export bdir
+
+LIBTRACEEVENT_STATIC = $(bdir)/libtraceevent.a
+LIBTRACEEVENT_SHARED = $(bdir)/libtraceevent.so.$(EVENT_PARSE_VERSION)
+
+LIB_TARGET  = $(LIBTRACEEVENT_STATIC) $(bdir)/libtraceevent.so $(bdir)/libtraceevent.so.$(EP_VERSION) $(LIBTRACEEVENT_SHARED)
+LIB_INSTALL = $(LIBTRACEEVENT_STATIC) $(bdir)/libtraceevent.so*
 LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/include $(CONFIG_INCLUDES)
@@ -146,18 +150,20 @@ $(TE_IN): force
 	$(Q)$(MAKE) $(build)=libtraceevent
 
 $(OUTPUT)$(LIBTRACEEVENT_SHARED): $(TE_IN)
+	$(Q)mkdir -p $(OUTPUT)$(bdir)
 	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@  $(LIBS)
 
-$(OUTPUT)libtraceevent.so: $(OUTPUT)libtraceevent.so.$(EP_VERSION)
+$(OUTPUT)$(bdir)/libtraceevent.so: $(OUTPUT)$(bdir)/libtraceevent.so.$(EP_VERSION)
 	@ln -sf $(<F) $@
 
-$(OUTPUT)libtraceevent.so.$(EP_VERSION): $(OUTPUT)$(LIBTRACEEVENT_SHARED)
+$(OUTPUT)$(bdir)/libtraceevent.so.$(EP_VERSION): $(OUTPUT)$(LIBTRACEEVENT_SHARED)
 	@ln -sf $(<F) $@
 
 $(OUTPUT)$(LIBTRACEEVENT_STATIC): $(TE_IN)
+	$(Q)mkdir -p $(OUTPUT)$(bdir)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
-$(OUTPUT)%.so: $(OUTPUT)%-in.o
+$(OUTPUT)$(bdir)/%.so: $(OUTPUT)%-in.o
 	$(QUIET_LINK)$(CC) $(CFLAGS) -shared $(LDFLAGS) -nostartfiles -o $@ $^ $(LIBS)
 
 define make_version.h
-- 
2.29.2


