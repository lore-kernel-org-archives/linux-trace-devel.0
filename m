Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552D7C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 364D660EBC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhHLA4O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhHLA4N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 20:56:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F4361077;
        Thu, 12 Aug 2021 00:55:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDz0e-003oyV-2T; Wed, 11 Aug 2021 20:55:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Add random number to keep synthetic variables unique
Date:   Wed, 11 Aug 2021 20:55:45 -0400
Message-Id: <20210812005546.910833-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812005546.910833-1-rostedt@goodmis.org>
References: <20210812005546.910833-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The 'hist' triggers expect that all variables are unique. If two synthetic
events are created, it is possible that they will use the same variable
names, and this can break the logic for synthetic events. Add a random
number to the argument names that will help prevent that from happening.
There's no guarantee that there wont be collisions, but the chances of
that happening is 1 in 65535. If this is a problem, we could possibly look
for variables that are already in use.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 7f9cf3820611..8783ef4364bd 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -13,6 +13,8 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <time.h>
+#include <sys/types.h>
 
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -558,6 +560,7 @@ struct tracefs_synth {
 	unsigned int		end_parens;
 	unsigned int		end_state;
 	int			*start_type;
+	char			arg_name[16];
 	int			arg_cnt;
 };
 
@@ -957,7 +960,15 @@ static char *new_arg(struct tracefs_synth *synth)
 	char *arg;
 	int ret;
 
-	ret = asprintf(&arg, "__arg__%d", cnt);
+	/* Create a unique argument name */
+	if (!synth->arg_name[0]) {
+		srand(time(NULL));
+		ret = rand() + gettid();
+		/* Truncate so that ret is at most 65535 (total 13 bytes) */
+		ret &= (1 << 16) - 1;
+		sprintf(synth->arg_name, "__arg_%d_", ret);
+	}
+	ret = asprintf(&arg, "%s%d", synth->arg_name, cnt);
 	if (ret < 0)
 		return NULL;
 
-- 
2.30.2

