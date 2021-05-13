Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26A7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 02:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCF161420
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 02:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhEMCYM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 22:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhEMCYK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 22:24:10 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD0661413
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 02:23:01 +0000 (UTC)
Date:   Wed, 12 May 2021 22:22:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3] libtraceevent: Add back log functions for backward
 compatibility
Message-ID: <20210512222259.748cbb58@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The following functions are obsolete and were removed:

  tep_vwarning()
  pr_stat()
  vpr_stat()
  __pr_stat()
  __vpr_stat()

But unfortunately they were part of a library release. Add them back as
all weak functions and label them deprecated.

Link: https://lore.kernel.org/linux-trace-devel/20210428073001.755905-1-tz.stoyanov@gmail.com/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v2:
  Added "deprecated" to warn on use cases.

 src/event-utils.h |  9 +++++++++
 src/parse-utils.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/src/event-utils.h b/src/event-utils.h
index bdc6880..695905d 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -16,6 +16,15 @@ void tep_info(const char *fmt, ...);
 int tep_vprint(const char *name, enum tep_loglevel level,
 	       bool print_err, const char *fmt, va_list ap);
 
+#define __deprecated(msg) __attribute__((deprecated("msg")))
+
+/* For backward compatibilty, do not use */
+int tep_vwarning(const char *name, const char *fmt, va_list ap) __deprecated(Use tep_vprint instead);
+void pr_stat(const char *fmt, ...) __deprecated(Use tep_info instead);
+void vpr_stat(const char *fmt, va_list ap) __deprecated(Use tep_vprint instead);
+void __pr_stat(const char *fmt, ...) __deprecated(Use tep_info instead);;
+void __vpr_stat(const char *fmt, va_list ap) __deprecated(Use tep_vprint instead);;
+
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
diff --git a/src/parse-utils.c b/src/parse-utils.c
index 7510157..04237ba 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -79,3 +79,19 @@ void tep_info(const char *fmt, ...)
 	tep_vprint("libtraceevent", TEP_LOG_INFO, false, fmt, ap);
 	va_end(ap);
 }
+
+/* The below is for backward compatibility */
+int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
+{
+	return tep_vprint(name, TEP_LOG_WARNING, true, fmt, ap);
+}
+
+void pr_stat(const char *fmt, ...) __attribute__((weak, alias("tep_info")));
+void __pr_stat(const char *fmt, ...) __attribute__((weak, alias("tep_info")));
+
+void __weak __vpr_stat(const char *fmt, va_list ap)
+{
+	tep_vprint("libtraceevent", TEP_LOG_INFO, false, fmt, ap);
+}
+
+void vpr_stat(const char *fmt, va_list ap) __attribute__((weak, alias("__vpr_stat")));
-- 
2.29.2

