Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19F3ECAAD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiIVA2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIVA2k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F943A9255
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC3B62985
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263A4C433D7;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr5H-0H;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/5] libtracecmd: Add check-manpages.sh
Date:   Wed, 21 Sep 2022 20:29:38 -0400
Message-Id: <20220922002940.3302285-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002940.3302285-1-rostedt@goodmis.org>
References: <20220922002940.3302285-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the script check-manpages.sh that makes sure all the function that
are documented in the man pages are show in the overall man page
"libtracecmd" as well as making sure that all functions in
trace-cmd.h is also documented.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile          |  5 ++++-
 check-manpages.sh | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100755 check-manpages.sh

diff --git a/Makefile b/Makefile
index 7178d7a9758d..f0c7938b6908 100644
--- a/Makefile
+++ b/Makefile
@@ -508,7 +508,7 @@ install_gui: force
 install_libs: libs
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/ $@
 
-doc:
+doc: check_doc
 	$(MAKE) -C $(src)/Documentation all
 
 doc_clean:
@@ -517,6 +517,9 @@ doc_clean:
 install_doc:
 	$(MAKE) -C $(src)/Documentation install
 
+check_doc: force
+	$(Q)$(src)/check-manpages.sh $(src)/Documentation/libtracecmd
+
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope* $(PKG_CONFIG_SOURCE_FILE) $(VERSION_FILE)
diff --git a/check-manpages.sh b/check-manpages.sh
new file mode 100755
index 000000000000..1166bbe82cad
--- /dev/null
+++ b/check-manpages.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+# SPDX-License-Identifier: LGPL-2.1
+# Copyright (C) 2022, Google Inc, Steven Rostedt <rostedt@goodmis.org>
+#
+# This checks if any function is listed in a man page that is not listed
+# in the main man page.
+
+if [ $# -lt 1 ]; then
+	echo "usage: check-manpages man-page-path"
+	exit 1
+fi
+
+cd $1
+
+MAIN=libtracecmd
+MAIN_FILE=${MAIN}.txt
+
+# Ignore man pages that do not contain functions
+IGNORE=""
+
+for man in ${MAIN}-*.txt; do
+
+	sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man | while read a; do
+		if [ "${IGNORE/$man/}" != "${IGNORE}" ]; then
+			continue
+		fi
+		if ! grep -q '\*'${a}'\*' $MAIN_FILE; then
+			if [ "$last" == "" ]; then
+				echo
+			fi
+			if [ "$last" != "$man" ]; then
+				echo "Missing functions from $MAIN_FILE that are in $man"
+				last=$man
+			fi
+			echo "   ${a}"
+		fi
+	done
+done
+
+DEPRECATED=""
+
+sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../../include/trace-cmd/trace-cmd.h | while read f; do
+	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
+		if [ "${DEPRECATED/\*$f\*/}" != "${DEPRECATED}" ]; then
+			continue;
+		fi
+		if [ "$last" == "" ]; then
+			echo
+			echo "Missing functions from $MAIN_FILE that are in tracefs.h"
+			last=$f
+		fi
+		echo "   ${f}"
+	fi
+done
-- 
2.35.1

