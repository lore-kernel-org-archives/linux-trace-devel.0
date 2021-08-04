Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BC1C19F3D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 14:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518686117A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 14:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhHDOdE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 10:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235113AbhHDObE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 10:31:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8121A60F94
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Aug 2021 14:30:48 +0000 (UTC)
Date:   Wed, 4 Aug 2021 10:30:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove include sys/stat.h from global tracefs.h
Message-ID: <20210804103046.5e5a174d@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When using libtracefs in a program, Adding the following:

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <tracefs.h>

Caused the following error:

In file included from /usr/include/bits/statx.h:31,
                 from /usr/include/sys/stat.h:446,
                 from /usr/local/include/tracefs/tracefs.h:9,
/usr/include/linux/stat.h:57:2: error: unknown type name â__s64â
   57 |  __s64 tv_sec;
      |  ^~~~~

The #define _GNU_SOURCE appears to cause this, but I needed it for my
program. I tried several combinations to fix it, but the only solution
I found that worked was to remove <sys/stat.h> from tracefs.h.

There's no reason to have it in the global header. The only includes that a
header should have are those that the header itself needed. As tracefs.h
does not need sys/stat.h itself, it should be removed.

Fixes: 4b05ae03 ("libtracefs: Add missing system includes")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   | 1 -
 src/tracefs-tools.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 55f8239..0e31a4f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -6,7 +6,6 @@
 #ifndef _TRACE_FS_H
 #define _TRACE_FS_H
 
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <sched.h>
 #include <event-parse.h>
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index ca0ed58..ae85444 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -11,6 +11,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <regex.h>
 #include <dirent.h>
 #include <limits.h>
-- 
2.31.1

