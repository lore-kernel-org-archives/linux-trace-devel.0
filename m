Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BA6C43460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9516144B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhENUvx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 16:51:53 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:56567 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhENUvw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 16:51:52 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 14 May 2021 13:50:36 -0700
Received: from vypre.com (unknown [10.21.244.184])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 689ED204D2;
        Fri, 14 May 2021 13:50:40 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtraceevent: Add __tep_vprint() for overrides to use
Date:   Fri, 14 May 2021 16:50:36 -0400
Message-ID: <20210514205036.1383167-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514205036.1383167-1-rostedt@goodmis.org>
References: <20210514205036.1383167-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a program wants to add something special to tep_vprint() but then also
call the default tep_vprint() it can't. If it overrides the function, it
loses the functionality for it.

Add __tep_vprint() for this use case.

Example:

 int tep_vprint(const char *name, enum tep_loglevel level,
	       bool print_err, const char *fmt, va_list ap)
 {
	if (quiet && !strcmp(name, "myprog"))
		return 0;
	return __tep_vprint(name, level, print_err, fmt, ap);
 }

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-utils.h |  6 ++++++
 src/parse-utils.c | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/src/event-utils.h b/src/event-utils.h
index 607be0c..d377201 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -14,10 +14,16 @@
 
 void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
+
 /* Can be overridden */
 int tep_vprint(const char *name, enum tep_loglevel level,
 	       bool print_err, const char *fmt, va_list ap);
 
+/* The actual call of tep_vprint() for overrides to use */
+int __tep_vprint(const char *name, enum tep_loglevel level,
+		 bool print_err, const char *fmt, va_list ap);
+
+
 #define __deprecated(msg) __attribute__((deprecated("msg")))
 
 /* For backward compatibilty, do not use */
diff --git a/src/parse-utils.c b/src/parse-utils.c
index 04237ba..89bf1cd 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -9,6 +9,7 @@
 #include <stdarg.h>
 #include <errno.h>
 
+#include "event-utils.h"
 #include "event-parse.h"
 
 #define __weak __attribute__((weak))
@@ -42,6 +43,28 @@ void tep_set_loglevel(enum tep_loglevel level)
  */
 int __weak tep_vprint(const char *name, enum tep_loglevel level,
 		      bool print_err, const char *fmt, va_list ap)
+{
+	return __tep_vprint(name, level, print_err, fmt, ap);
+}
+
+/**
+ * __tep_vprint - print library log messages
+ * @name: name of the library.
+ * @level: severity of the log message. This parameter is not used in this implementation, but as
+ *	   the function is weak and can be overridden, having the log level could be useful
+ *	   for other implementations.
+ * @print_err: whether to print the errno, if non zero.
+ * @fmt: printf format string of the message.
+ * @ap: list of printf parameters.
+ *
+ * This function is used to print all messages from traceevent, tracefs and trace-cmd libraries.
+ * It is defined as weak, so the application that uses those libraries can override it in order
+ * to implement its own logic for printing library logs.
+ *
+ * Return the value of errno at the function enter.
+ */
+int __tep_vprint(const char *name, enum tep_loglevel level,
+		      bool print_err, const char *fmt, va_list ap)
 {
 	int ret = errno;
 
-- 
2.29.2

