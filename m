Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D10C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 01:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE55F61411
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 01:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEMB6D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 21:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEMB6D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 21:58:03 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7CC1613C9
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 01:56:54 +0000 (UTC)
Date:   Wed, 12 May 2021 21:56:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtraceevent: Add back log functions for backward
 compatibility
Message-ID: <20210512215652.50d9919d@oasis.local.home>
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
Changes since v1:
  Ported to the new version of "Add API to set severity to tracefs library logs"

 src/event-utils.h |  7 +++++++
 src/parse-utils.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

Index: libtraceevent.git/src/event-utils.h
===================================================================
--- libtraceevent.git.orig/src/event-utils.h
+++ libtraceevent.git/src/event-utils.h
@@ -15,6 +15,13 @@ void tep_info(const char *fmt, ...);
 int tep_vprint(const char *name, enum tep_loglevel level,
 	       bool print_err, const char *fmt, va_list ap);
 
+/* For backward compatibilty, do not use */
+int tep_vwarning(const char *name, const char *fmt, va_list ap);
+void pr_stat(const char *fmt, ...);
+void vpr_stat(const char *fmt, va_list ap);
+void __pr_stat(const char *fmt, ...);
+void __vpr_stat(const char *fmt, va_list ap);
+
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
Index: libtraceevent.git/src/parse-utils.c
===================================================================
--- libtraceevent.git.orig/src/parse-utils.c
+++ libtraceevent.git/src/parse-utils.c
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
