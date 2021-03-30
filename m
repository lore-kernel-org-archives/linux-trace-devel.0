Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCB5C433EC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 613906024A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhC3AxP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhC3Awu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C128661988;
        Tue, 30 Mar 2021 00:52:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ci-003Thr-QD; Mon, 29 Mar 2021 20:52:48 -0400
Message-ID: <20210330005248.694899644@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 10/13 v2] libtracefs: Pass in reset via flags to tracefs_function_filter()
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of having a separate boolean to tell tracefs_function_filter() to
reset the file upon opening, make it a flag instead. This way other
booleans can be passed into the function without having to extend the
parameters.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 26 ++++++++++++++------
 include/tracefs.h                            | 10 +++++++-
 src/tracefs-tools.c                          | 19 ++++++++------
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 88aa3b923d54..5b55a72727c8 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -11,7 +11,7 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, bool _reset_, const char pass:[*]pass:[*]pass:[*]_errs_);
+int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, int _flags_, const char pass:[*]pass:[*]pass:[*]_errs_);
 --
 
 DESCRIPTION
@@ -25,18 +25,17 @@ _filters_, which is an array of the strings that represent a list of filters tha
 be applied to define what functions are to be traced and The array must end
 with a NULL pointer.
 _module_ , name of the module to be traced (or NULL for all functions),
-_reset_ if set will clear the current set of filters and then apply the
-filter list, otherwise the list of filters are added to the current set of
-filters,
+_flags_ which holds control knobs on how the filters will be handled (see *FLAGS*)
+section below,
 _errs_, is a pointer to an array of strings, which will be allocated if
 any of filters fail to match any available function, If _errs_ is NULL, it will
 be ignored.
 
 A filter in the array of _filters_ may be either a straight match of a
-function, a glob or regex(3). a glob is where '*' matches zero or more
+function, a glob or regex(3). a glob is where 'pass:[*]' matches zero or more
 characters, '?' will match zero or one character, and '.' only matches a
 period. If the filter is determined to be a regex (where it contains
-anything other than alpha numeric characters, or '.', '*', '?') the filter
+anything other than alpha numeric characters, or '.', 'pass:[*]', '?') the filter
 will be processed as a regex(3) following the rules of regex(3), and '.' is
 not a period, but will match any one character. To force a regular
 expression, either prefix the filter with a '^' or append it with a '$' as
@@ -44,6 +43,17 @@ all filters will act as complete matches of functions anyway.
 
 returns 0  on success, 1 or -x (where x is an integer) on error.
 
+FLAGS
+-----
+
+The _flags_ parameter may have the following set, or be zero.
+
+*TRACEFS_FL_RESET* :
+If _flags_ contains *TRACEFS_FL_RESET*, then it will clear the filters that
+are currently set before applying the list of filters from _filters_. Otherwise,
+the list of filters from _filters_ will be added to the current set of filters
+already enabled.
+
 RETURN VALUE
 ------------
 return 0 on success, if there is error, it will return 1 for general errors or
@@ -66,7 +76,7 @@ int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = tracefs_instance_create(INST);
 	const char **errs = NULL;
-	bool reset = 1;
+	int flags = TRACEFS_FL_RESET;
 	int ret;
 	int i = 0;
 
@@ -74,7 +84,7 @@ int main(int argc, char *argv[])
 		/* Error creating new trace instance */
 	}
 
-	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
+	ret = tracefs_function_filter(inst, filters, NULL, flags, &errs);
 
 	if (ret < 0 && errs) {
 		while (errs[i])
diff --git a/include/tracefs.h b/include/tracefs.h
index 9477fdb14c5a..5193d46f41f5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,6 +145,14 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
+
+/*
+ * RESET	- Reset on opening filter file (O_TRUNC)
+ */
+enum {
+	TRACEFS_FL_RESET	= (1 << 0),
+};
+
 int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
-			    const char *module, bool reset, const char ***errs);
+			    const char *module, unsigned int flags, const char ***errs);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 8f2130948fe0..6d03b4856a63 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -835,7 +835,7 @@ static int write_func_list(int fd, struct func_list *list)
  * @instance: ftrace instance, can be NULL for top tracing instance
  * @filters: An array of function names ending with a NULL pointer
  * @module: Module to be traced
- * @reset: set to true to reset the file before applying the filter
+ * @flags: flags on modifying the filter file
  * @errs: A pointer to array of constant strings that will be allocated
  * on negative return of this function, pointing to the filters that
  * failed.May be NULL, in which case this field will be ignored.
@@ -843,9 +843,11 @@ static int write_func_list(int fd, struct func_list *list)
  * The @filters is an array of strings, where each string will be used
  * to set a function or functions to be traced.
  *
- * If @reset is true, then all functions in the filter are cleared
- * before adding functions from @filters. Otherwise, the functions set
- * by @filters will be appended to the filter file
+ * @flags:
+ *   TRACEFS_FL_RESET - will clear the functions in the filter file
+ *          before applying the @filters. This flag is ignored
+ *          if this function is called again when the previous
+ *          call had TRACEFS_FL_CONTINUE set.
  *
  * returns -x on filter errors (where x is number of failed filter
  * srtings) and if @errs is not NULL will be an allocated string array
@@ -858,12 +860,13 @@ static int write_func_list(int fd, struct func_list *list)
  * return 0 on success and @errs is not set.
  */
 int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
-			    const char *module, bool reset, const char ***errs)
+			    const char *module, unsigned int flags, const char ***errs)
 {
 	struct func_filter *func_filters;
 	struct func_list *func_list = NULL;
 	char *ftrace_filter_path;
-	int flags;
+	bool reset = flags & TRACEFS_FL_RESET;
+	int open_flags;
 	int ret;
 	int fd;
 
@@ -887,9 +890,9 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (!ftrace_filter_path)
 		goto out_free;
 
-	flags = reset ? O_TRUNC : O_APPEND;
+	open_flags = reset ? O_TRUNC : O_APPEND;
 
-	fd = open(ftrace_filter_path, O_WRONLY | flags);
+	fd = open(ftrace_filter_path, O_WRONLY | open_flags);
 	tracefs_put_tracing_file(ftrace_filter_path);
 	if (fd < 0)
 		goto out_free;
-- 
2.30.1


