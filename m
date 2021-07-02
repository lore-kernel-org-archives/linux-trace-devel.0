Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FC3C07E98
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE14861430
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhGBUUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232743AbhGBUUD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:20:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E496261421;
        Fri,  2 Jul 2021 20:17:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPbN-000i0S-QU; Fri, 02 Jul 2021 16:17:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v7 05/10] libtracefs: Add helper function to parse kprobes
Date:   Fri,  2 Jul 2021 16:17:22 -0400
Message-Id: <20210702201727.169080-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702201727.169080-1-rostedt@goodmis.org>
References: <20210702201727.169080-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a helper function to parse kprobes and use that for
tracefs_get_kprobes(). This will allow other functions to easily parse the
kprobe_events file without having to duplicate the parsing code.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-kprobes.c | 76 +++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 17 deletions(-)

diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 3bba3683f29b..713715e96f4f 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -104,6 +104,58 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 	return insert_kprobe("r", system, event, addr, format);
 }
 
+/*
+ * Helper function to parse kprobes.
+ * @content: The content of kprobe_events on the first iteration.
+ *           NULL on next iterations.
+ * @saveptr: Same as saveptr for strtok_r
+ * @type: Where to store the type (before ':')
+ * @system: Store the system of the kprobe (NULL to have event contain
+ *          both system and event, as in "kprobes/myprobe").
+ * @event: Where to store the event.
+ * @addr: Where to store the addr (may be NULL to ignore)
+ * @format: Where to store the format (may be NULL to ignore)
+ */
+static int parse_kprobe(char *content, char **saveptr,
+			char **type, char **system, char **event,
+			char **addr, char **format)
+{
+	char *p;
+
+	p = strtok_r(content, ":", saveptr);
+	if (!p)
+		return 1; /* eof */
+	*type = p;
+
+	if (system) {
+		p = strtok_r(NULL, "/", saveptr);
+		if (!p)
+			return -1;
+		*system = p;
+	}
+
+	p = strtok_r(NULL, " ", saveptr);
+	if (!p)
+		return -1;
+	*event = p;
+
+	if (addr || format) {
+		p = strtok_r(NULL, " ", saveptr);
+		if (!p)
+			return -1;
+		if (addr)
+			*addr = p;
+	}
+
+	p = strtok_r(NULL, "\n", saveptr);
+	if (!p)
+		return -1;
+	if (format)
+		*format = p;
+
+	return 0;
+}
+
 /**
  * tracefs_get_kprobes - return a list kprobes (by group/event name)
  * @type: The type of kprobes to return.
@@ -127,8 +179,9 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 	char *content;
 	char *saveptr;
 	char *event;
-	char *p;
+	char *ktype;
 	int cnt = 0;
+	int ret;
 
 	errno = 0;
 	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
@@ -140,13 +193,13 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 		return list;
 	}
 
-	p = strtok_r(content, ":", &saveptr);
+	ret = parse_kprobe(content, &saveptr, &ktype, NULL, &event, NULL, NULL);
 
-	while (p) {
+	while (!ret) {
 		char **tmp;
 
 		if (type != TRACEFS_ALL_KPROBES) {
-			switch (*p) {
+			switch (*ktype) {
 			case 'p':
 				if (type != TRACEFS_KPROBE)
 					goto next;
@@ -160,12 +213,7 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 			}
 		}
 
-		/* Failed parsing always return a failure */
-		p = strtok_r(NULL, " ", &saveptr);
-		if (!p)
-			break;
-
-		event = strdup(p);
+		event = strdup(event);
 		if (!event)
 			goto fail;
 
@@ -177,13 +225,7 @@ char **tracefs_get_kprobes(enum tracefs_kprobe_type type)
 		list[cnt++] = event;
 		list[cnt] = NULL;
  next:
-		p = strtok_r(NULL, "\n", &saveptr);
-		/* Could be end of content */
-		if (!p)
-			break;
-
-		/* p is NULL on end of content */
-		p = strtok_r(NULL, ":", &saveptr);
+		ret = parse_kprobe(NULL, &saveptr, &ktype, NULL, &event, NULL, NULL);
 	}
 
 	if (!list)
-- 
2.30.2

