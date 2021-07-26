Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95636C4320A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8253D60FA0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbhGZPsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238959AbhGZPsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 11:48:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08E8A60F6D;
        Mon, 26 Jul 2021 16:29:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m83TO-0022ky-Jw; Mon, 26 Jul 2021 12:28:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd: Remove traceevent/ and tracefs/ from include headers
Date:   Mon, 26 Jul 2021 12:28:55 -0400
Message-Id: <20210726162857.487153-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726162857.487153-1-rostedt@goodmis.org>
References: <20210726162857.487153-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

trace-cmd now depends on the external libraries of both libtraceevent and
libtracefs and uses pkg-config to find their headers. As pkg-config will
find the full path to the headers, do not include parts of the path when
including them, because they may change, and the hardcoded path in the
code will not.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h                     | 4 ++--
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 +-
 lib/trace-cmd/trace-util.c                        | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6984db863303..7fea4e017b26 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -6,8 +6,8 @@
 #ifndef _TRACE_CMD_H
 #define _TRACE_CMD_H
 
-#include "traceevent/event-parse.h"
-#include "tracefs/tracefs.h"
+#include "event-parse.h"
+#include "tracefs.h"
 
 struct tracecmd_input;
 
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6440084ddd9d..c58b09e9da48 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -8,7 +8,7 @@
 
 #include <fcntl.h> /* for iovec */
 #include <sys/types.h>
-#include "traceevent/event-parse.h"
+#include "event-parse.h"
 #include "trace-cmd/trace-cmd.h"
 
 #define __packed __attribute__((packed))
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b0c98c724363..9bc948224732 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -20,8 +20,8 @@
 #include <sys/stat.h>
 #include <sys/sysinfo.h>
 #include <time.h>
-#include <traceevent/event-parse.h>
-#include <traceevent/event-utils.h>
+#include <event-parse.h>
+#include <event-utils.h>
 
 #include "trace-cmd-private.h"
 #include "trace-cmd-local.h"
-- 
2.30.2

