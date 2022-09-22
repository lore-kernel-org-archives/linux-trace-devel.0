Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F194C6FA95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiIVPYS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiIVPYN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EA0F8C09
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2893B83861
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C79BC43144;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzkj-1v;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/9] libtraceevent: Add check-manpages.sh
Date:   Thu, 22 Sep 2022 11:25:02 -0400
Message-Id: <20220922152510.3335601-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the script check-manpages.sh that makes sure all the function that
are documented in the man pages are show in the overall man page
"libtraceevent" as well as making sure that all functions in
event-parse.h is also documented.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile          |  5 ++++-
 check-manpages.sh | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100755 check-manpages.sh

diff --git a/Makefile b/Makefile
index a32052385e9e..dcd4ad9689ff 100644
--- a/Makefile
+++ b/Makefile
@@ -378,7 +378,7 @@ uninstall: $(BUILD_OUTPUT)/build_uninstall
 	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_uninstall),$(call uninstall_file,$(file)))
 
 PHONY += doc
-doc:
+doc: check_doc
 	$(Q)$(call descend,$(src)/Documentation,)
 
 PHONY += doc-clean
@@ -389,6 +389,9 @@ PHONY += doc-install
 doc-install:
 	$(Q)$(call descend,$(src)/Documentation,install)
 
+check_doc: force
+	$(Q)$(src)/check-manpages.sh $(src)/Documentation
+
 
 PHONY += doc-uninstall
 doc-uninstall:
diff --git a/check-manpages.sh b/check-manpages.sh
new file mode 100755
index 000000000000..a2f4f264b42b
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
+MAIN=libtraceevent
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
+sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceevent/event-parse.h | while read f; do
+	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
+		if [ "${DEPRECATED/\*$f\*/}" != "${DEPRECATED}" ]; then
+			continue;
+		fi
+		if [ "$last" == "" ]; then
+			echo
+			echo "Missing functions from $MAIN_FILE that are in event-parse.h"
+			last=$f
+		fi
+		echo "   ${f}"
+	fi
+done
-- 
2.35.1

