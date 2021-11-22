Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077DCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhKVXxM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:12 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7560 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhKVXxL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:11 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:02 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 0C3902037D;
        Mon, 22 Nov 2021 15:50:03 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 01/11] libtracefs: Move creation of sqlhist into new samples directory
Date:   Mon, 22 Nov 2021 18:49:46 -0500
Message-ID: <20211122234956.788401-2-rostedt@goodmis.org>
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

Move the creation of the sqlhist utility into the samples directory. This
will be where other examples in the man pages will be extracted to create
the samples.

The executables will be added to a new bin/ directory as well as the
intermediate files used to create the binaries.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 13 +++++--------
 samples/Makefile | 27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 8 deletions(-)
 create mode 100644 samples/Makefile

diff --git a/Makefile b/Makefile
index 7f382c3..7c96674 100644
--- a/Makefile
+++ b/Makefile
@@ -142,6 +142,7 @@ LIBS = $(LIBTRACEEVENT_LIBS) -lpthread
 
 export LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
+export LIBTRACEEVENT_LIBS LIBTRACEEVENT_INCLUDES
 
 export Q SILENT VERBOSE EXT
 
@@ -364,21 +365,17 @@ $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
 	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src libtracefs.so
 
-$(bdir)/sqlhist.c: Documentation/libtracefs-sql.txt
-	cat $< | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $@
+samples/sqlhist: $(LIBTRACEFS_STATIC)
+	$(Q)$(MAKE) -C $(src)/samples sqlhist
 
-$(bdir)/sqlhist.o: $(bdir)/sqlhist.c
-	$(CC) -g -Wall -c -o $@ $^ -Iinclude/ $(LIBTRACEEVENT_INCLUDES)
-
-sqlhist: $(bdir)/sqlhist.o $(LIBTRACEFS_STATIC)
-	$(CC) -o $@ $^ $(LIBTRACEEVENT_LIBS)
+sqlhist: samples/sqlhist
 
 clean:
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/src clean
+	$(MAKE) -C $(src)/samples clean
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d
 	$(RM) $(PKG_CONFIG_FILE)
 	$(RM) $(VERSION_FILE)
-	$(RM) $(bdir)/sqlhist.o $(bdir)/sqlhist.c sqlhist
 
 .PHONY: clean
diff --git a/samples/Makefile b/samples/Makefile
new file mode 100644
index 0000000..aae3e27
--- /dev/null
+++ b/samples/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+#
+# The samples are pulled out of the examples used in the man pages
+# that are located in the Documentation directory.
+#
+
+include $(src)/scripts/utils.mk
+
+bdir := $(obj)/bin
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+sqlhist: $(bdir) $(bdir) $(bdir)/sqlhist
+
+$(bdir)/sqlhist: $(bdir)/sqlhist.o $(LIBTRACEFS_STATIC)
+	$(CC) -o $@ $^ $(LIBTRACEEVENT_LIBS)
+
+$(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
+	cat $< | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $@
+
+$(bdir)/sqlhist.o: $(bdir)/sqlhist.c
+	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+
+clean:
+	$(RM) $(bdir)/*
-- 
2.31.1

