Return-Path: <SRS0=8+AL=7P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D01C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 22:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76C72067B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 22:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBWQW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBWQU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 18:16:20 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255D62067B
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jun 2020 22:16:20 +0000 (UTC)
Date:   Tue, 2 Jun 2020 18:16:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix build dependencies
Message-ID: <20200602181618.737914a8@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After having trace-cmd break because not all proper files are being compiled
when needed, I looked into why the dependencies were not working. I found
that the .foo.d files that were being created required having the full path
of the object file in them. Without that, the dependencies were being
ignored.

By adding "-MT $(bdir)/$*.o", to the dependency creating rules, the full
path would be added to targets for the object files, and this makes the
depencies work again.

Fixes: 60f0a40bb ("trace-cmd: Make libtraceevent buildable out-of-tree")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile          | 2 +-
 lib/trace-cmd/plugins/Makefile  | 2 +-
 lib/traceevent/Makefile         | 2 +-
 lib/traceevent/plugins/Makefile | 2 +-
 lib/tracefs/Makefile            | 2 +-
 tracecmd/Makefile               | 2 +-
 utest/Makefile                  | 1 +
 7 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ab7440ac..994ae94d 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -45,7 +45,7 @@ $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
 $(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
diff --git a/lib/trace-cmd/plugins/Makefile b/lib/trace-cmd/plugins/Makefile
index 240e6be3..ed5a9cea 100644
--- a/lib/trace-cmd/plugins/Makefile
+++ b/lib/trace-cmd/plugins/Makefile
@@ -26,7 +26,7 @@ $(PLUGIN_BUILD): $(bdir)/%.so: $(bdir)/%.o
 	$(Q)$(do_plugin_build)
 
 $(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(PLUGIN_OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index c3f09572..d0666911 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -37,7 +37,7 @@ $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
 $(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
diff --git a/lib/traceevent/plugins/Makefile b/lib/traceevent/plugins/Makefile
index 40500194..21e933af 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -40,7 +40,7 @@ $(PLUGIN_BUILD): $(bdir)/%.so: $(bdir)/%.o
 	$(Q)$(do_plugin_build)
 
 $(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(PLUGIN_OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index f6d93ec8..b810bbf4 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -34,7 +34,7 @@ $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
 $(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 17e67600..5a7f7d2b 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -70,7 +70,7 @@ $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
 
 $(all_deps): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(all_deps): $(TC_VERSION)
 
diff --git a/utest/Makefile b/utest/Makefile
index 55aa46ab..d635650d 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -30,6 +30,7 @@ $(bdir)/%.o: %.c
 
 $(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
-- 
2.25.4

