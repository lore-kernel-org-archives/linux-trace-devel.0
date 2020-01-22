Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E704C33CB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC8A24656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVRNb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:13:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A7D2253D
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 17:13:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJZJ-000hpN-5h
        for linux-trace-devel@vger.kernel.org; Wed, 22 Jan 2020 12:13:29 -0500
Message-Id: <20200122171329.057095088@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:12:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd: Create TRACECMD_MAGIC macro for magic number of trace-cmd
 data file
References: <20200122171250.252248737@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of copying the magic number around different files, just declare a
macro for it in the exported trace-cmd header and use that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h | 2 ++
 lib/trace-cmd/trace-input.c   | 2 +-
 tracecmd/trace-dump.c         | 3 +--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ee8cdc75a9b2..1f5a98b3f7af 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -8,6 +8,8 @@
 
 #include "traceevent/event-parse.h"
 
+#define TRACECMD_MAGIC { 23, 8, 68 }
+
 #define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
 #define __weak __attribute__((weak))
 #define __noreturn __attribute__((noreturn))
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 68da3a776d19..6d7f0feff3c0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2861,7 +2861,7 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
 struct tracecmd_input *tracecmd_alloc_fd(int fd)
 {
 	struct tracecmd_input *handle;
-	char test[] = { 23, 8, 68 };
+	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	char *version;
 	char buf[BUFSIZ];
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index d95b34c12776..ed6705886e39 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -14,7 +14,6 @@
 #include "trace-local.h"
 
 #define DEF_INPUT_FILE	"trace.dat"
-#define MAGIC_HEAD	{ 0x17, 0x08, 0x44 }
 #define TRACING_STR	"tracing"
 #define HEAD_PAGE_STR	"header_page"
 #define HEAD_PAGE_EVENT	"header_event"
@@ -142,7 +141,7 @@ static int read_file_number(int fd, void *digit, int size)
 
 static void dump_initial_format(int fd)
 {
-	char magic[] = MAGIC_HEAD;
+	char magic[] = TRACECMD_MAGIC;
 	char buf[DUMP_SIZE];
 	int val4;
 
-- 
2.24.1


