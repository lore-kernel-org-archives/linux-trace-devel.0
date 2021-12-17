Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4217BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhLQFut (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbhLQFus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A2CC06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7BCBDCE23EB
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85839C36AEB;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056h-DD;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 04/15] libtracefs: Fix samples Makefile
Date:   Fri, 17 Dec 2021 00:50:30 -0500
Message-Id: <20211217055041.19559-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The commit that was added to build the samples was not fully committed,
and it did not build properly. Fix the Makefile so that the sample code
now builds.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/Makefile | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 4ccd28dcebaa..1e4fe7fb2144 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -26,31 +26,31 @@ TARGETS += $(EXAMPLES)
 
 bdir := $(obj)/bin
 
+TARGETS := $(patsubst %,$(bdir)/%,$(TARGETS))
+
 all: $(TARGETS)
 
 extract_example = \
 	cat $1 | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $2
 
-$(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
+$(bdir)/sqlhist.c: $(src)/Documentation/libtracefs-sql.txt
 	$(call extract_example,$<,$@)
 
-EXAMPLE_C_CODE := $(patsubst %,$(bdir)/%.c,$(EXAMPLES))
-
 $(bdir)/%.c: ../Documentation/libtracefs-%.txt
 	$(call extract_example,$<,$@)
 
 $(bdir):
 	@mkdir -p $(bdir)
 
-sqlhist: $(bdir) $(bdir) $(bdir)/sqlhist
+sqlhist: $(bdir)/sqlhist.c
 
 $(TARGETS): $(bdir)
 
 # sqlhist is unique and stands on its own
-sqlhist: $(bdir)/sqlhist
+$(bdir)/sqlhist: $(bdir)/sqlhist.c
 
 $(bdir)/%: $(bdir)/%.o
-	$(CC) -o $@ $^ $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS)
+	$(CC) -o $@ $< $(CFLAGS) $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS)
 
 $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 
@@ -60,9 +60,9 @@ $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 ## name, and the file will not be discarded by make.
 #
 # $(bdir)/XX.o: $(bdir)/XX.c
-#	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+#	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
-$(bdir)/%.o: %.c
+$(bdir)/%.o: $(bdir)/%.c
 	$(CC) -g -Wall -c $(CFLAGS) -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 clean:
-- 
2.33.0

