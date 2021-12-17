Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8181EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhLQFux (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50062 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhLQFuw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27C48CE20F3
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653A0C36AEA;
        Fri, 17 Dec 2021 05:50:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-000575-IL;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 12/15] libtracefs: Have samples build in separate directory from bin
Date:   Fri, 17 Dec 2021 00:50:38 -0500
Message-Id: <20211217055041.19559-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The samples destination directory is bin/. Do not build in that directory.
Have it build in the default directory, and then it can be set to build in
the same directory as the source (or copy if it is a remote build).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/Makefile | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 48c0e0e4160d..ace93448ff4e 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -24,9 +24,9 @@ TARGETS :=
 TARGETS += sqlhist
 TARGETS += $(EXAMPLES)
 
-bdir := $(obj)/bin
+sdir := $(obj)/bin
 
-TARGETS := $(patsubst %,$(bdir)/%,$(TARGETS))
+TARGETS := $(patsubst %,$(sdir)/%,$(TARGETS))
 
 all: $(TARGETS)
 
@@ -36,20 +36,21 @@ $(bdir)/sqlhist.c: $(src)/Documentation/libtracefs-sql.txt
 $(bdir)/%.c: ../Documentation/libtracefs-%.txt
 	$(call extract_example,$<,$@)
 
-$(bdir):
-	@mkdir -p $(bdir)
+$(sdir):
+	@mkdir -p $(sdir)
 
-sqlhist: $(bdir)/sqlhist.c
+sqlhist: $(sdir)/sqlhist
 
-$(TARGETS): $(bdir)
+$(TARGETS): $(sdir)
 
 # sqlhist is unique and stands on its own
-$(bdir)/sqlhist: $(bdir)/sqlhist.c
+$(sdir)/sqlhist: $(bdir)/sqlhist.c
+	$(call do_sample_build,$@,$<)
 
-$(bdir)/%: $(bdir)/%.o
+$(sdir)/%: $(bdir)/%.o
 	$(call do_sample_build,$@,$<)
 
-$(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
+$(EXAMPLES): $(patsubst %,$(sdir)/%,$(TARGETS))
 
 ## The intermediate files get removed by Make.
 ## To examine the .c files created by one of the man pages,
@@ -63,4 +64,4 @@ $(bdir)/%.o: $(bdir)/%.c
 	$(call do_sample_obj,$@,$^)
 
 clean:
-	$(Q)$(call do_clean,$(bdir)/*)
+	$(Q)$(call do_clean,$(sdir)/* $(bdir)/sqlhist.c $(bdir)/sqlhist.o)
-- 
2.33.0

