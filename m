Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E1DC433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 01:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A63D361999
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 01:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhC3BDE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 21:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhC3BDE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 21:03:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9B861996;
        Tue, 30 Mar 2021 01:03:03 +0000 (UTC)
Date:   Mon, 29 Mar 2021 21:03:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [RFC][PATCH 14/13 v2] libtracefs: Just past one filter in for
 tracefs_function_filter()
Message-ID: <20210329210302.0f7910e3@oasis.local.home>
In-Reply-To: <20210330005123.151740983@goodmis.org>
References: <20210330005123.151740983@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[
  Now that we have a way to call tracefs_function_filter() more than
  once without committing the filter, I think it now makes sense to go
  back to Tzvetomir's original proposal of calling this function once
  per filter and not pass in an array. This greatly simplifies the
  code, and makes the errs parameter obsolete. I played a little with
  this interface, and I think it makes a lot of sense.

  Comments?
]

With the new CONTINUE flag, it is inconsistent to have an array of filters
but only one module. Change the API to pass in a single filter, and remove
the errs parameter. Also change the return value to be 0 on success, 1 if
it failed before starting to write to the filter file, and -1 if it failed
after starting to write to the filter file.

Also, set errno appropriately, where if the filter fails EINVAL is set.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 105 ++++++----
 include/tracefs.h                            |   4 +-
 src/tracefs-tools.c                          | 208 +++++--------------
 3 files changed, 109 insertions(+), 208 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 1ac8a06..5631ff7 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -11,37 +11,31 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, int _flags_, const char pass:[*]pass:[*]pass:[*]_errs_);
+int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
 --
 
 DESCRIPTION
 -----------
-This function can be used to limit the Linux kernel functions that were
+This function can be used to limit the Linux kernel functions that would be
 traced by the function and function-graph tracers
 
-It will take
-_instance_ , that can be NULL for the top level tracing.
-_filters_, which is an array of the strings that represent a list of filters that should
-be applied to define what functions are to be traced and The array must end
-with a NULL pointer.
-_module_ , name of the module to be traced (or NULL for all functions),
+It will take an
+_instance_ , that can be NULL for the top level tracing,
+_filter_, a string that represents a filter that should
+be applied to define what functions are to be traced,
+_module_, to limit the filtering on a specific module (or NULL to filter on all functions),
 _flags_ which holds control knobs on how the filters will be handled (see *FLAGS*)
-section below,
-_errs_, is a pointer to an array of strings, which will be allocated if
-any of filters fail to match any available function, If _errs_ is NULL, it will
-be ignored.
+section below.
 
-A filter in the array of _filters_ may be either a straight match of a
-function, a glob or regex(3). a glob is where 'pass:[*]' matches zero or more
+The _filter may be either a straight match of a
+function, a glob or regex(3). A glob is where 'pass:[*]' matches zero or more
 characters, '?' will match zero or one character, and '.' only matches a
-period. If the filter is determined to be a regex (where it contains
-anything other than alpha numeric characters, or '.', 'pass:[*]', '?') the filter
+period. If the _filter_ is determined to be a regex (where it contains
+anything other than alpha numeric characters, or '.', 'pass:[*]', '?') the _filter_
 will be processed as a regex(3) following the rules of regex(3), and '.' is
 not a period, but will match any one character. To force a regular
-expression, either prefix the filter with a '^' or append it with a '$' as
-all filters will act as complete matches of functions anyway.
-
-returns 0  on success, 1 or -x (where x is an integer) on error.
+expression, either prefix _filter_ with a '^' or append it with a '$' as
+the _filter_ does complete matches of the functions anyway.
 
 FLAGS
 -----
@@ -50,18 +44,19 @@ The _flags_ parameter may have the following set, or be zero.
 
 *TRACEFS_FL_RESET* :
 If _flags_ contains *TRACEFS_FL_RESET*, then it will clear the filters that
-are currently set before applying the list of filters from _filters_. Otherwise,
-the list of filters from _filters_ will be added to the current set of filters
-already enabled. This flag is ignored if a previous call to
-tracefs_function_filter() had the same _instance_ and the
+are currently set before applying _filter_. Otherwise, _filter_ is added to
+the current set of filters already enabled. This flag is ignored if a
+previous call to tracefs_function_filter() had the same _instance_ and the
 *TRACEFS_FL_CONTINUE* flag was set.
 
 *TRACEFS_FL_CONTINUE* :
-If _flags_ contains *TRACEFS_FL_CONTINUE*, then the filters will not take
+If _flags_ contains *TRACEFS_FL_CONTINUE*, then _filter_ will not take
 effect after a successful call to tracefs_function_filter(). This allows for
-multiple calls to tracefs_function_filter() to update the filter function.
-It can be called multiple times and add more filters. A call without this
-flag set will commit the changes before returning (if the filters passed in
+multiple calls to tracefs_function_filter() to update the filter function
+and then a single call (one without the *TRACEFS_FL_CONTINUE* flag set) to
+commit all the filters.
+It can be called multiple times to add more filters. A call without this
+flag set will commit the changes before returning (if the _filter_ passed in
 successfully matched). A tracefs_function_filter() call after one that had
 the *TRACEFS_FL_CONTINUE* flag set for the same instance will ignore the
 *TRACEFS_FL_RESET* flag, as the reset flag is only applicable for the first
@@ -69,49 +64,67 @@ filters to be added before committing.
 
 RETURN VALUE
 ------------
-return 0 on success, if there is error, it will return 1 for general errors or
-negative number -x(x denotes number of failed filters), if there are any failed filters.
+Returns 0 on success. If the there is an error but the filtering was not
+started, then 1 is returned. If filtering was started but an error occurs,
+then -1 is returned. The state of the filtering may be in an unknown state.
+
+If *TRACEFS_FL_CONTINUE* was set, and 0 or -1 was returned, then another call
+to tracefs_function_filter() must be done without *TRACEFS_FL_CONTINUE* set
+in order to commit (and close) the filtering.
+
+ERRORS
+------
 
-In case of negative return value, errs have to be checked and must be freed
-using the free()
+*tracefs_function_filter*() can fail with the following errors:
+
+*EINVAL* The filter is invalid or did not match any functions.
+
+Other errors may also happen caused by internal system calls.
 
 EXAMPLE
 -------
 [source,c]
 --
+#include <stdio.h>
+#include <errno.h>
 #include <tracefs.h>
 
 #define INST "dummy"
 
 static const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
-static const char *all[] = { "*", NULL };
 
 int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = tracefs_instance_create(INST);
-	const char **errs = NULL;
 	int ret;
-	int i = 0;
+	int i;
 
 	if (!inst) {
 		/* Error creating new trace instance */
 	}
 
-	ret = tracefs_function_filter(inst, filters, NULL,
-				      TRACEFS_FL_RESET | TRACEF_FL_CONTINUE,
-				      &errs);
-
-	if (ret < 0 && errs) {
-		while (errs[i])
-			printf("%s\n", errs[i++]);
+	for (i = 0; filters[i]; i++) {
+		/*
+		 * Note, only the first call does something
+		 * with TRACEFS_FL_RESET. It is ignored in the following
+		 * calls.
+		 */
+		ret = tracefs_function_filter(inst, filters[i], NULL,
+				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+
+		if (ret) {
+			if (errno == EINVAL)
+				printf("Filter %s did not match\n", filters[i]);
+			else
+				printf("Failed writing %s\n", filters[i]);
+		}
 	}
-	free(errs);
 
-	ret = tracefs_function_filter(inst, all, "ext4", 0, &errs);
-	if (ret < 0) {
+	ret = tracefs_function_filter(inst, "*", "ext4", 0);
+	if (ret) {
 		printf("Failed to set filters for ext4\n");
 		/* Force the function to commit previous filters */
-		tracefs_function_filter(inst, NULL, NULL, 0, &errs);
+		tracefs_function_filter(inst, NULL, NULL, 0);
 	}
 
 	tracefs_instance_destroy(inst);
diff --git a/include/tracefs.h b/include/tracefs.h
index f4775e9..0d98c10 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -155,6 +155,6 @@ enum {
 	TRACEFS_FL_CONTINUE	= (1 << 1),
 };
 
-int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
-			    const char *module, unsigned int flags, const char ***errs);
+int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
+			    const char *module, unsigned int flags);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 862db5c..165a9db 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -396,33 +396,6 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 		options->mask &= ~(1ULL << (id - 1));
 }
 
-static void add_errors(const char ***errs, const char *filter, int ret)
-{
-	const char **e;
-
-	if (!errs)
-		return;
-
-	/* Negative is passed in */
-	ret = -ret;
-	e = *errs;
-
-	/* If this previously failed to allocate stop processing */
-	if (!e && ret)
-		return;
-
-	/* Add 2, one for the new entry, and one for NULL */
-	e = realloc(e, sizeof(*e) * (ret + 2));
-	if (!e) {
-		free(*errs);
-		*errs = NULL;
-		return;
-	}
-	e[ret] = filter;
-	e[ret + 1] = NULL;
-	*errs = e;
-}
-
 struct func_list {
 	struct func_list	*next;
 	unsigned int		start;
@@ -584,7 +557,7 @@ enum match_type {
 	FILTER_WRITE,
 };
 
-static int match_filters(int fd, struct func_filter *func_filters,
+static int match_filters(int fd, struct func_filter *func_filter,
 			 const char *module, struct func_list **func_list,
 			 enum match_type type)
 {
@@ -595,7 +568,6 @@ static int match_filters(int fd, struct func_filter *func_filters,
 	int index = 0;
 	int ret = 1;
 	int mlen;
-	int i;
 
 	path = tracefs_get_tracing_file(TRACE_FILTER_LIST);
 	if (!path)
@@ -614,7 +586,6 @@ static int match_filters(int fd, struct func_filter *func_filters,
 		char *saveptr = NULL;
 		char *tok, *mtok;
 		int len = strlen(line);
-		bool first = true;
 
 		if (line[len - 1] == '\n')
 			line[len - 1] = '\0';
@@ -634,30 +605,16 @@ static int match_filters(int fd, struct func_filter *func_filters,
 		}
 		switch (type) {
 		case FILTER_CHECK:
-			/* Check, checks a list of filters */
-			for (i = 0; func_filters[i].filter; i++) {
-				/*
-				 * If a match was found, still need to
-				 * check if other filters would match
-				 * to make sure that all filters have a
-				 * match, as some filters may overlap.
-				 */
-				if (!first && func_filters[i].set)
-					continue;
-				if (match(tok, &func_filters[i])) {
-					func_filters[i].set = true;
-					if (first) {
-						first = false;
-						ret = add_func(&func_list, index);
-						if (ret)
-							goto out;
-					}
-				}
+			if (match(tok, func_filter)) {
+				func_filter->set = true;
+				ret = add_func(&func_list, index);
+				if (ret)
+					goto out;
 			}
 			break;
 		case FILTER_WRITE:
 			/* Writes only have one filter */
-			if (match(tok, func_filters)) {
+			if (match(tok, func_filter)) {
 				ret = write_filter(fd, tok, module);
 				if (ret)
 					goto out;
@@ -676,25 +633,11 @@ static int match_filters(int fd, struct func_filter *func_filters,
 	return ret;
 }
 
-static int check_available_filters(struct func_filter *func_filters,
-				   const char *module, const char ***errs,
+static int check_available_filters(struct func_filter *func_filter,
+				   const char *module,
 				   struct func_list **func_list)
 {
-	int ret;
-	int i;
-
-	ret = match_filters(-1, func_filters, module, func_list, FILTER_CHECK);
-	/* Return here if success or non filter error */
-	if (ret >= 0)
-		return ret;
-
-	/* Failed on filter, set the errors */
-	ret = 0;
-	for (i = 0; func_filters[i].filter; i++) {
-		if (!func_filters[i].set)
-			add_errors(errs, func_filters[i].filter, ret--);
-	}
-	return ret;
+	return match_filters(-1, func_filter, module, func_list, FILTER_CHECK);
 }
 
 static int set_regex_filter(int fd, struct func_filter *func_filter,
@@ -703,31 +646,17 @@ static int set_regex_filter(int fd, struct func_filter *func_filter,
 	return match_filters(fd, func_filter, module, NULL, FILTER_WRITE);
 }
 
-static int controlled_write(int fd, struct func_filter *func_filters,
-			    const char *module, const char ***errs)
+static int controlled_write(int fd, struct func_filter *func_filter,
+			    const char *module)
 {
-	int ret = 0;
-	int i;
+	const char *filter = func_filter->filter;
+	int ret;
+
+	if (func_filter->is_regex)
+		ret = set_regex_filter(fd, func_filter, module);
+	else
+		ret = write_filter(fd, filter, module);
 
-	for (i = 0; func_filters[i].filter; i++) {
-		const char *filter = func_filters[i].filter;
-		int r;
-
-		if (func_filters[i].is_regex)
-			r = set_regex_filter(fd, &func_filters[i], module);
-		else
-			r = write_filter(fd, filter, module);
-		if (r > 0) {
-			/* Not filter error */
-			if (errs) {
-				free(*errs);
-				*errs = NULL;
-			}
-			return 1;
-		}
-		if (r < 0)
-			add_errors(errs, filter, ret--);
-	}
 	return ret;
 }
 
@@ -754,43 +683,6 @@ static int init_func_filter(struct func_filter *func_filter, const char *filter)
 	return 0;
 }
 
-static void free_func_filters(struct func_filter *func_filters)
-{
-	int i;
-
-	if (!func_filters)
-		return;
-
-	for (i = 0; func_filters[i].filter; i++) {
-		regfree(&func_filters[i].re);
-	}
-}
-
-static struct func_filter *make_func_filters(const char **filters)
-{
-	struct func_filter *func_filters = NULL;
-	int i;
-
-	for (i = 0; filters[i]; i++)
-		;
-
-	if (!i)
-		return NULL;
-
-	func_filters = calloc(i + 1, sizeof(*func_filters));
-	if (!func_filters)
-		return NULL;
-
-	for (i = 0; filters[i]; i++) {
-		if (init_func_filter(&func_filters[i], filters[i]) < 0)
-			goto out_err;
-	}
-	return func_filters;
- out_err:
-	free_func_filters(func_filters);
-	return NULL;
-}
-
 static int write_number(int fd, unsigned int start, unsigned int end)
 {
 	char buf[64];
@@ -835,22 +727,19 @@ static int write_func_list(int fd, struct func_list *list)
 }
 
 /**
- * tracefs_function_filter - write to set_ftrace_filter file to trace
- * particular functions
- * @instance: ftrace instance, can be NULL for top tracing instance
- * @filters: An array of function names ending with a NULL pointer
- * @module: Module to be traced
+ * tracefs_function_filter - filter the functions that are traced
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @filter: The filter to filter what functions are to be traced
+ * @module: Module to be traced or NULL if all functions are to be examined.
  * @flags: flags on modifying the filter file
- * @errs: A pointer to array of constant strings that will be allocated
- * on negative return of this function, pointing to the filters that
- * failed.May be NULL, in which case this field will be ignored.
  *
- * The @filters is an array of strings, where each string will be used
- * to set a function or functions to be traced.
+ * @filter may be a full function name, a glob, or a regex. It will be
+ * considered a regex, if there's any characters that are not normally in
+ * function names or "*" or "?" for a glob.
  *
  * @flags:
  *   TRACEFS_FL_RESET - will clear the functions in the filter file
- *          before applying the @filters. This flag is ignored
+ *          before applying the @filter. This flag is ignored
  *          if this function is called again when the previous
  *          call had TRACEFS_FL_CONTINUE set.
  *   TRACEFS_FL_CONTINUE - will keep the filter file open on return.
@@ -860,20 +749,16 @@ static int write_func_list(int fd, struct func_list *list)
  *          function must be called without this flag for the filter
  *          to take effect.
  *
- * returns -x on filter errors (where x is number of failed filter
- * srtings) and if @errs is not NULL will be an allocated string array
- * pointing to the strings in @filters that failed and must be freed
- * with free().
- *
- * returns 1 on general errors not realted to setting the filter.
- * @errs is not set even if supplied.
- *
- * return 0 on success and @errs is not set.
+ * Returns 0 on success, 1 if there was an error but the filtering has not
+ *  yet started, -1 if there was an error but the filtering has started.
+ *  If -1 is returned and TRACEFS_FL_CONTINUE was set, then this function
+ *  needs to be called again without the TRACEFS_FL_CONTINUE flag to commit
+ *  the changes and close the filter file.
  */
-int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
-			    const char *module, unsigned int flags, const char ***errs)
+int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
+			    const char *module, unsigned int flags)
 {
-	struct func_filter *func_filters;
+	struct func_filter func_filter;
 	struct func_list *func_list = NULL;
 	char *ftrace_filter_path;
 	bool reset = flags & TRACEFS_FL_RESET;
@@ -888,9 +773,16 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	else
 		fd = &ftrace_filter_fd;
 
-	if (!filters) {
+	/*
+	 * Set EINVAL on no matching filter. But errno may still be modified
+	 * on another type of failure (allocation or opening a file).
+	 */
+	errno = EINVAL;
+
+	if (!filter) {
 		/* OK to call without filters if this is closing the opened file */
 		if (!cont && *fd >= 0) {
+			errno = 0;
 			ret = 0;
 			close(*fd);
 			*fd = -1;
@@ -898,15 +790,10 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 		goto out;
 	}
 
-	func_filters = make_func_filters(filters);
-	if (!func_filters)
+	if (init_func_filter(&func_filter, filter) < 0)
 		goto out;
 
-	/* Make sure errs is NULL to start with, realloc() depends on it. */
-	if (errs)
-		*errs = NULL;
-
-	ret = check_available_filters(func_filters, module, errs, &func_list);
+	ret = check_available_filters(&func_filter, module, &func_list);
 	if (ret)
 		goto out_free;
 
@@ -923,9 +810,11 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (*fd < 0)
 		goto out_free;
 
+	errno = 0;
+
 	ret = write_func_list(*fd, func_list);
 	if (ret > 0)
-		ret = controlled_write(*fd, func_filters, module, errs);
+		ret = controlled_write(*fd, &func_filter, module);
 
 	if (!cont) {
 		close(*fd);
@@ -934,7 +823,6 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 
  out_free:
 	free_func_list(func_list);
-	free_func_filters(func_filters);
  out:
 	pthread_mutex_unlock(&filter_lock);
 
-- 
2.29.2

