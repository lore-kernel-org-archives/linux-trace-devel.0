Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C94BC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD33208C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfFLMvj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfFLMvi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 08:51:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E5A20684;
        Wed, 12 Jun 2019 12:51:38 +0000 (UTC)
Date:   Wed, 12 Jun 2019 08:51:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Make the version defines part of tc-version.h
Message-ID: <20190612085136.248a4a0e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Move the version string creations as part of the tc-version.h file, and have
trace-record.c include and use that. The VERSION_STRING is already defined
and obsoletes TRACECMD_VERSION. For consistency, use VERSION_GIT to define
the git sha1. Also, add logic to detect if the source file is a git repo,
and use "not-a-git-repo" as the sha1 if it is not found. Add a "+" to the
end of the git sha1 if the repo has modifications in it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                | 4 ----
 scripts/utils.mk        | 9 +++++++++
 tracecmd/trace-record.c | 3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 2062d976..6df1f07b 100644
--- a/Makefile
+++ b/Makefile
@@ -238,10 +238,6 @@ endif
 override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
-# Append version define
-override CFLAGS += -DTRACECMD_VERSION=\"$(TRACECMD_VERSION)\"
-override CFLAGS += -DTRACECMD_VERSION_GIT=\"$(shell git log -1 --pretty=format:"%H")\"
-
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
 ###
diff --git a/scripts/utils.mk b/scripts/utils.mk
index f5feeca0..260023a1 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -79,6 +79,15 @@ define make_version.h
 	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
 	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
 	echo '#define FILE_VERSION '$(FILE_VERSION);					\
+	if [ -d $(src)/.git ]; then							\
+	  d=`git diff`;									\
+	  x="";										\
+	  if [ ! -z "$$d" ]; then x="+"; fi;						\
+	  echo '#define VERSION_GIT "'$(shell 						\
+		git log -1 --pretty=format:"%H" 2>/dev/null)$$x'"';			\
+	else										\
+	  echo '#define VERSION_GIT "not-a-git-repo"';					\
+	fi										\
 	) > $1
 endef
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8aa83455..ee35ada1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -34,6 +34,7 @@
 #include <limits.h>
 #include <libgen.h>
 
+#include "version.h"
 #include "trace-local.h"
 #include "trace-msg.h"
 
@@ -3149,7 +3150,7 @@ static void add_version(struct tracecmd_output *handle)
 	char *str;
 	int len;
 
-	len = asprintf(&str, "%s %s", TRACECMD_VERSION, TRACECMD_VERSION_GIT);
+	len = asprintf(&str, "%s %s", VERSION_STRING, VERSION_GIT);
 	if (len < 0)
 		return;
 
-- 
2.20.1

