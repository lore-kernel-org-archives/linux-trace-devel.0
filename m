Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E1EC43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380230AbiDTP3f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380231AbiDTP32 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA0C45ADE
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:26:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D2D961949
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 15:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BAEC385B0;
        Wed, 20 Apr 2022 15:26:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nhCE2-0003Re-MJ;
        Wed, 20 Apr 2022 11:26:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 08/11] trace-cmd: Override tracecmd_debug() to show thread id
Date:   Wed, 20 Apr 2022 11:26:34 -0400
Message-Id: <20220420152637.13105-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420152637.13105-1-rostedt@goodmis.org>
References: <20220420152637.13105-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To differentiate threads, have tracecmd_debug() show the thread id of
the debug prints.

Link: https://lore.kernel.org/linux-trace-devel/20220417184538.1044417-9-rostedt@goodmis.org

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

