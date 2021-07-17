Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6717FC12002
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Jul 2021 02:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1F060FF3
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Jul 2021 02:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhGQDAK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Jul 2021 23:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhGQDAJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Jul 2021 23:00:09 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D1560FF3;
        Sat, 17 Jul 2021 02:57:13 +0000 (UTC)
Date:   Fri, 16 Jul 2021 22:57:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: [PATCH for v2.9] trace-cmd: For libtraceevent 1.3 have pr_info
 equal tep_info
Message-ID: <20210716225712.1bc5aa77@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In version libtracevent 1.3, pr_stat() turned to tep_info(), because
"pr_stat" was too generic. Although a compiled version of trace-cmd may
still work because of the use of weak functions, building this version of
trace-cmd may cause several warnings because warning is not declared.

Since pr_stat is called out as deprecated, simply doing a:

  -Dpr_stat=tep_info

is not sufficient, as the header that deprecates pr_stat will also be
affected, and you still get the warning, that is confusing.

  "tep_info" is deprecated, use tep_info instead.

Instead, change all callers of pr_stat() to pr_info() and have the
Makefile do -Dpr_info=pr_stat when libtraceevent is less than 1.3, and
-Dpr_info=tep_info when it is equal or greater to 1.3.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                             | 5 ++++-
 lib/trace-cmd/trace-input.c          | 2 +-
 lib/trace-cmd/trace-plugin.c         | 2 +-
 lib/traceevent/event-parse.c         | 8 ++++----
 lib/traceevent/event-plugin.c        | 2 +-
 lib/traceevent/include/event-utils.h | 2 +-
 lib/traceevent/parse-utils.c         | 2 +-
 python/ctracecmd.i                   | 6 +++---
 tracecmd/trace-cmd.c                 | 2 +-
 tracecmd/trace-record.c              | 2 +-
 10 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index 06cf5946..3ed7f891 100644
--- a/Makefile
+++ b/Makefile
@@ -240,10 +240,13 @@ TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /d
 TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
 endif
 
+# My get overwritten if libtraceveent is 1.3 or greater.
+TEP_WARNING = -Dpr_info=pr_stat
+
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 TRACEEVENT_V13 = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.3 $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
 ifeq ("$(TRACEEVENT_V13)", "y")
-   TEP_WARNING=-Dwarning=tep_warning
+   TEP_WARNING = -Dwarning=tep_warning -Dpr_info=tep_info
 endif
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)") $(TEP_WARNING)
 LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 51b96035..1ad49093 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3170,7 +3170,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	pr_stat("version = %s\n", version);
+	pr_info("version = %s\n", version);
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 92f9edf3..1d2ab29b 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -140,7 +140,7 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 	list->name = plugin;
 	*plugin_list = list;
 
-	pr_stat("registering plugin: %s", plugin);
+	pr_info("registering plugin: %s", plugin);
 	func(trace);
 	return;
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index f3587841..63b6e0c1 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6764,7 +6764,7 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
 	if (!(*next))
 		return 0;
 
-	pr_stat("overriding event (%d) %s:%s with new print handler",
+	pr_info("overriding event (%d) %s:%s with new print handler",
 		event->id, event->system, event->name);
 
 	event->handler = handle->func;
@@ -7241,7 +7241,7 @@ int tep_register_print_function(struct tep_handle *tep,
 		 * plugins updating the function. This overrides the
 		 * system defaults.
 		 */
-		pr_stat("override of function helper '%s'", name);
+		pr_info("override of function helper '%s'", name);
 		remove_func_handler(tep, name);
 	}
 
@@ -7379,7 +7379,7 @@ int tep_register_event_handler(struct tep_handle *tep, int id,
 	if (event == NULL)
 		goto not_found;
 
-	pr_stat("overriding event (%d) %s:%s with new print handler",
+	pr_info("overriding event (%d) %s:%s with new print handler",
 		event->id, event->system, event->name);
 
 	event->handler = func;
@@ -7465,7 +7465,7 @@ int tep_unregister_event_handler(struct tep_handle *tep, int id,
 		goto not_found;
 
 	if (event->handler == func && event->context == context) {
-		pr_stat("removing override handler for event (%d) %s:%s. Going back to default handler.",
+		pr_info("removing override handler for event (%d) %s:%s. Going back to default handler.",
 			event->id, event->system, event->name);
 
 		event->handler = NULL;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 07a860ff..7b55dd3c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -498,7 +498,7 @@ load_plugin(struct tep_handle *tep, const char *path,
 	list->name = plugin;
 	*plugin_list = list;
 
-	pr_stat("registering plugin: %s", plugin);
+	pr_info("registering plugin: %s", plugin);
 	func(tep);
 	return;
 
diff --git a/lib/traceevent/include/event-utils.h b/lib/traceevent/include/event-utils.h
index 69e889a8..b8f7c127 100644
--- a/lib/traceevent/include/event-utils.h
+++ b/lib/traceevent/include/event-utils.h
@@ -10,7 +10,7 @@
 
 /* Can be overridden */
 void warning(const char *fmt, ...);
-void pr_stat(const char *fmt, ...);
+void pr_info(const char *fmt, ...);
 void vpr_stat(const char *fmt, va_list ap);
 
 /* Always available */
diff --git a/lib/traceevent/parse-utils.c b/lib/traceevent/parse-utils.c
index 150cee84..abbdc67a 100644
--- a/lib/traceevent/parse-utils.c
+++ b/lib/traceevent/parse-utils.c
@@ -57,6 +57,6 @@ void __weak vpr_stat(const char *fmt, va_list ap)
 {
 }
 
-void __weak pr_stat(const char *fmt, ...)
+void __weak pr_info(const char *fmt, ...)
 {
 }
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 5f7181c7..625daf5c 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -44,14 +44,14 @@ static void py_supress_trace_output(void)
 	skip_output = 1;
 }
 
-void pr_stat(const char *fmt, ...)
+void pr_info(const char *fmt, ...)
 {
         va_list ap;
 
 	if (skip_output)
 		return;
 	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
+	__vpr_info(fmt, ap);
 	va_end(ap);
 }
 
@@ -249,7 +249,7 @@ static int python_callback(struct trace_seq *s,
 
 
 %ignore trace_seq_vprintf;
-%ignore vpr_stat;
+%ignore vpr_info;
 
 /* SWIG can't grok these, define them to nothing */
 #define __trace
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..0ed0fc9f 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -35,7 +35,7 @@ void warning(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
-void pr_stat(const char *fmt, ...)
+void pr_info(const char *fmt, ...)
 {
 	va_list ap;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 89a3e761..16313fdd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2940,7 +2940,7 @@ static int expand_event_files(struct buffer_instance *instance,
 		path = globbuf.gl_pathv[i];
 
 		event = create_event(instance, path, old_event);
-		pr_stat("%s\n", path);
+		pr_info("%s\n", path);
 
 		len = strlen(path);
 
-- 
2.31.1

