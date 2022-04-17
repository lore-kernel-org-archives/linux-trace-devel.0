Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BAAC43219
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiDQSsV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbiDQSsT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6C826AD6
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07107B80D8F
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237F3C385AC;
        Sun, 17 Apr 2022 18:45:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9tz-004NkC-5O;
        Sun, 17 Apr 2022 14:45:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 8/9] trace-cmd: Override tracecmd_debug() to show thread id
Date:   Sun, 17 Apr 2022 14:45:37 -0400
Message-Id: <20220417184538.1044417-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417184538.1044417-1-rostedt@goodmis.org>
References: <20220417184538.1044417-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To differentiate threads, have tracecmd_debug() show the thread id of
the debug prints.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index a83a8d0bb9e4..3f3e69a7f1e2 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -10,12 +10,17 @@
 #include <dirent.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <sys/syscall.h>
 
 #include "trace-local.h"
 
 int silence_warnings;
 int show_status;
 
+#ifndef gettid
+#define gettid() syscall(__NR_gettid)
+#endif
+
 void warning(const char *fmt, ...)
 {
 	va_list ap;
@@ -45,6 +50,19 @@ void *malloc_or_die(unsigned int size)
 	return data;
 }
 
+void tracecmd_debug(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (!tracecmd_get_debug())
+		return;
+
+	va_start(ap, fmt);
+	printf("[%d] ", (int)gettid());
+	vprintf(fmt, ap);
+	va_end(ap);
+}
+
 static struct trace_log_severity {
 	int		id;
 	const char	*name;
-- 
2.35.1

