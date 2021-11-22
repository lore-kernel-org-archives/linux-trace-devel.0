Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE5EC43219
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhKVXxO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:14 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32627 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231894AbhKVXxO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:14 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:05 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id E078E20355;
        Mon, 22 Nov 2021 15:50:06 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 05/11] libtracefs: Make samples easily extract man page example programs
Date:   Mon, 22 Nov 2021 18:49:50 -0500
Message-ID: <20211122234956.788401-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Have the Makefile in the samples directory extract examples out of the man
pages and create them as executables in the bin directory.

This adds the infrastructure to do so, and includes the dynevent example.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         |  3 +++
 samples/Makefile | 26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 7c96674..85b3c39 100644
--- a/Makefile
+++ b/Makefile
@@ -370,6 +370,9 @@ samples/sqlhist: $(LIBTRACEFS_STATIC)
 
 sqlhist: samples/sqlhist
 
+samples: $(LIBTRACEFS_STATIC) force
+	$(Q)$(MAKE) -C $(src)/samples all
+
 clean:
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/src clean
diff --git a/samples/Makefile b/samples/Makefile
index aae3e27..53b6630 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -7,20 +7,36 @@
 
 include $(src)/scripts/utils.mk
 
+TARGETS :=
+TARGETS += sqlhist
+TARGETS += dynevent
+
 bdir := $(obj)/bin
 
+all: $(TARGETS)
+
+extract_example = \
+	cat $1 | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $2
+
+$(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
+	$(call extract_example,$<,$@)
+
+$(bdir)/dynevent.c: ../Documentation/libtracefs-dynevents.txt
+	$(call extract_example,$<,$@)
+
 $(bdir):
 	@mkdir -p $(bdir)
 
 sqlhist: $(bdir) $(bdir) $(bdir)/sqlhist
 
-$(bdir)/sqlhist: $(bdir)/sqlhist.o $(LIBTRACEFS_STATIC)
-	$(CC) -o $@ $^ $(LIBTRACEEVENT_LIBS)
+$(TARGETS): $(bdir)
 
-$(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
-	cat $< | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $@
+$(bdir)/%: $(bdir)/%.o
+	$(CC) -o $@ $^ $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS)
+
+$(TARGETS): $(patsubst %,$(bdir)/%,$(TARGETS))
 
-$(bdir)/sqlhist.o: $(bdir)/sqlhist.c
+$(bdir)/%.o: %.c
 	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 clean:
-- 
2.31.1

