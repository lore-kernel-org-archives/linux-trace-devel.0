Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349D9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhKVXxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:21 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7566 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232002AbhKVXxS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:18 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:08 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 674C120250;
        Mon, 22 Nov 2021 15:50:10 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 10/11] libtracefs: Add all working man page examples to samples
Date:   Mon, 22 Nov 2021 18:49:55 -0500
Message-ID: <20211122234956.788401-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Parse out all the working examples in the man pages, and have

  make samples

build them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/Makefile | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 53b6630..6ee57fe 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -7,9 +7,22 @@
 
 include $(src)/scripts/utils.mk
 
+EXAMPLES :=
+EXAMPLES += dynevents
+EXAMPLES += kprobes
+EXAMPLES += eprobes
+EXAMPLES += synth
+EXAMPLES += error
+EXAMPLES += filter
+EXAMPLES += function-filter
+EXAMPLES += hist
+EXAMPLES += hist-cont
+EXAMPLES += tracer
+EXAMPLES += stream
+
 TARGETS :=
 TARGETS += sqlhist
-TARGETS += dynevent
+TARGETS += $(EXAMPLES)
 
 bdir := $(obj)/bin
 
@@ -21,7 +34,9 @@ extract_example = \
 $(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
 	$(call extract_example,$<,$@)
 
-$(bdir)/dynevent.c: ../Documentation/libtracefs-dynevents.txt
+EXAMPLE_C_CODE := $(patsubst %,$(bdir)/%.c,$(EXAMPLES))
+
+$(bdir)/%.c: ../Documentation/libtracefs-%.txt
 	$(call extract_example,$<,$@)
 
 $(bdir):
@@ -31,10 +46,21 @@ sqlhist: $(bdir) $(bdir) $(bdir)/sqlhist
 
 $(TARGETS): $(bdir)
 
+# sqlhist is unique and stands on its own
+sqlhist: $(bdir)/sqlhist
+
 $(bdir)/%: $(bdir)/%.o
 	$(CC) -o $@ $^ $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS)
 
-$(TARGETS): $(patsubst %,$(bdir)/%,$(TARGETS))
+$(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
+
+## The intermediate files get removed by Make.
+## To examine the .c files created by one of the man pages,
+## uncomment the below, and replace the XX with the exec example
+## name, and the file will not be discarded by make.
+#
+# $(bdir)/XX.o: $(bdir)/XX.c
+#	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 $(bdir)/%.o: %.c
 	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
-- 
2.31.1

