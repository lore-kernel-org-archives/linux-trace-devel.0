Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367DDC48BDF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jun 2021 18:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D825611CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jun 2021 18:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhFOSRs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 14:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhFOSRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 14:17:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27ECE611CE
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Jun 2021 18:15:43 +0000 (UTC)
Date:   Tue, 15 Jun 2021 14:15:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: libtracefs: Implement tracefs_filter_functions()
Message-ID: <20210615141541.08685845@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

Add a new function that allows the user to get a list of functions that are
available to be filtered. This is useful to see if a function is available
before trying to add a kprobe to it. It can also be used to see what
architecture the code is being run on.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 746be37..ac43d9b 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -5,6 +5,7 @@ NAME
 ----
 tracefs_function_filter - Function to limit kernel functions that are traced
 tracefs_function_notrace - Function to filter kernel functions that not to be traced
+tracefs_filter_functions - Function to list the functions that are available for filtering
 
 SYNOPSIS
 --------
@@ -14,6 +15,7 @@ SYNOPSIS
 
 int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
 int *tracefs_function_notrace*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
+int *tracefs_filter_functions*(const char pass:[*]_filter_, const char pass:[*]_module_, char pass:[*]pass:[*]pass:[*]_list_);
 --
 
 DESCRIPTION
@@ -31,7 +33,12 @@ _module_, to limit the filtering on a specific module (or NULL to filter on all
 _flags_ which holds control knobs on how the filters will be handled (see *FLAGS*)
 section below.
 
-The _filter may be either a straight match of a
+The *tracefs_filter_functions* returns a list of functions that can be filtered on
+via the _filter_ and _module_ that are supplied. If both _filter_ and _module_ are
+NULL then, all available functions that can be filtered is returned.
+On success, _list_ must be freed with *tracefs_list_free()*(3).
+
+The _filter_ may be either a straight match of a
 function, a glob or regex(3). A glob is where 'pass:[*]' matches zero or more
 characters, '?' will match zero or one character, and '.' only matches a
 period. If the _filter_ is determined to be a regex (where it contains
@@ -86,7 +93,9 @@ regular expression.
 
 RETURN VALUE
 ------------
-Returns 0 on success. If the there is an error but the filtering was not
+
+For _tracefs_function_filter_() and _tracefs_function_notrace()_ a
+return of 0 means success. If the there is an error but the filtering was not
 started, then 1 is returned. If filtering was started but an error occurs,
 then -1 is returned. The state of the filtering may be in an unknown state.
 
@@ -94,6 +103,12 @@ If *TRACEFS_FL_CONTINUE* was set, and 0 or -1 was returned, then another call
 to tracefs_function_filter() must be done without *TRACEFS_FL_CONTINUE* set
 in order to commit (and close) the filtering.
 
+For _tracefs_filter_functions_(), a return of 0 means success, and the _list_
+parameter is filled with a list of function names that matched _filter_ and
+_module_. _list_ is a string array, where the last string pointer in the
+array is NULL. The _list_ must be freed with _tracefs_list_free()_.
+On failure, a negative is returned, and _list_ is ignored.
+
 ERRORS
 ------
 
@@ -122,6 +137,7 @@ static const char *filters[] = { "run_init_process", "try_to_run_init_process",
 int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = tracefs_instance_create(INST);
+	char **func_list;
 	int ret;
 	int i;
 
@@ -129,6 +145,15 @@ int main(int argc, char *argv[])
 		/* Error creating new trace instance */
 	}
 
+	if (tracefs_filter_functions("*lock*", NULL, &func_list) < 0) {
+		printf("Failed to read filter functions\n");
+		goto out;
+	}
+	printf("Ignoring the following functions:\n");
+	for (i = 0; func_list[i]; i++)
+		printf("  %s\n", func_list[i]);
+	tracefs_free_list(func_list);
+
 	/* Do not trace any function with the word "lock" in it */
 	ret = tracefs_function_notrace(inst, "*lock*", NULL, TRACEFS_FL_RESET);
 	if (ret) {
diff --git a/include/tracefs.h b/include/tracefs.h
index e29b550..44a41d5 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -179,6 +179,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 			    const char *module, unsigned int flags);
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
 			     const char *module, unsigned int flags);
+int tracefs_filter_functions(const char *filter, const char *module, char ***list);
 
 
 /* Control library logs */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0cbb56d..cb23b68 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -378,6 +378,7 @@ bool tracefs_option_mask_is_set(const struct tracefs_options_mask *options,
 
 struct func_list {
 	struct func_list	*next;
+	char			*func;
 	unsigned int		start;
 	unsigned int		end;
 };
@@ -521,6 +522,25 @@ static int add_func(struct func_list ***next_func_ptr, unsigned int index)
 	return add_func(next_func_ptr, index);
 }
 
+static int add_func_str(struct func_list ***next_func_ptr, const char *func)
+{
+	struct func_list **next_func = *next_func_ptr;
+	struct func_list *func_list = *next_func;
+
+	if (!func_list) {
+		func_list = calloc(1, sizeof(*func_list));
+		if (!func_list)
+			return -1;
+		func_list->func = strdup(func);
+		if (!func_list->func)
+			return -1;
+		*next_func = func_list;
+		return 0;
+	}
+	*next_func_ptr = &func_list->next;
+	return add_func_str(next_func_ptr, func);
+}
+
 static void free_func_list(struct func_list *func_list)
 {
 	struct func_list *f;
@@ -528,6 +548,7 @@ static void free_func_list(struct func_list *func_list)
 	while (func_list) {
 		f = func_list;
 		func_list = f->next;
+		free(f->func);
 		free(f);
 	}
 }
@@ -536,6 +557,7 @@ enum match_type {
 	FILTER_CHECK	= (1 << 0),
 	FILTER_WRITE	= (1 << 1),
 	FILTER_FUTURE	= (1 << 2),
+	SAVE_STRING	= (1 << 2),
 };
 
 static int match_filters(int fd, struct func_filter *func_filter,
@@ -543,6 +565,7 @@ static int match_filters(int fd, struct func_filter *func_filter,
 			 int flags)
 {
 	enum match_type type = flags & (FILTER_CHECK | FILTER_WRITE);
+	bool save_str = flags & SAVE_STRING;
 	bool future = flags & FILTER_FUTURE;
 	bool mod_match = false;
 	char *line = NULL;
@@ -593,7 +616,10 @@ static int match_filters(int fd, struct func_filter *func_filter,
 		case FILTER_CHECK:
 			if (match(tok, func_filter)) {
 				func_filter->set = true;
-				ret = add_func(&func_list, index);
+				if (save_str)
+					ret = add_func_str(&func_list, tok);
+				else
+					ret = add_func(&func_list, index);
 				if (ret)
 					goto out;
 			}
@@ -638,6 +664,16 @@ static int check_available_filters(struct func_filter *func_filter,
 	return match_filters(-1, func_filter, module, func_list, flags);
 }
 
+
+static int list_available_filters(struct func_filter *func_filter,
+				   const char *module,
+				   struct func_list **func_list)
+{
+	int flags = FILTER_CHECK | SAVE_STRING;
+
+	return match_filters(-1, func_filter, module, func_list, flags);
+}
+
 static int set_regex_filter(int fd, struct func_filter *func_filter,
 			    const char *module)
 {
@@ -912,3 +948,60 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
 	tracefs_put_tracing_file(filter_path);
 	return ret;
 }
+
+/**
+ * tracefs_filter_functions - return a list of available functons that can be filtered
+ * @filter: The filter to filter what functions to list (can be NULL for all)
+ * @module: Module to be traced or NULL if all functions are to be examined.
+ * @list: The list to return the list from (freed by tracefs_list_free() on success)
+ *
+ * Returns a list of function names that match @filter and @module. If both
+ * @filter and @module is NULL, then all available functions that can be filtered
+ * will be returned. (Note, there can be duplicates, if there are more than
+ * one function with the same name.
+ *
+ * On success, zero is returned, and @list contains a list of functions that were
+ * found, and must be freed with tracefs_list_free().
+ * On failure, a negative number is returned, and @list is ignored.
+ */
+int tracefs_filter_functions(const char *filter, const char *module, char ***list)
+{
+	struct func_filter func_filter;
+	struct func_list *func_list, *f;
+	char **funcs = NULL;
+	int cnt = 0;
+	int ret;
+
+	if (!filter)
+		filter = ".*";
+
+	ret = init_func_filter(&func_filter, filter);
+	if (ret < 0)
+		return ret;
+
+	ret = list_available_filters(&func_filter, module, &func_list);
+	if (ret < 0)
+		goto out;
+
+	ret = -1;
+	for (f = func_list; f; f = f->next) {
+		char **tmp;
+
+		tmp = realloc(funcs, sizeof(*funcs) * (cnt + 2));
+		if (!tmp) {
+			tracefs_list_free(funcs);
+			goto out;
+		}
+		tmp[cnt++] = f->func;
+		tmp[cnt] = NULL;
+		f->func = NULL;
+		funcs = tmp;
+	}
+
+	*list = funcs;
+	ret = 0;
+out:
+	regfree(&func_filter.re);
+	free_func_list(func_list);
+	return ret;
+}
