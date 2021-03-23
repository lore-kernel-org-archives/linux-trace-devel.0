Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F413C433E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F78E619B1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhCWBdE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231562AbhCWBcb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 21:32:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B33B1619AE;
        Tue, 23 Mar 2021 01:32:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lOVuD-001cPk-N8; Mon, 22 Mar 2021 21:32:25 -0400
Message-ID: <20210323013225.595028176@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 22 Mar 2021 21:28:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 7/7] libtracefs: Add indexing to set functions in
 tracefs_function_filter()
References: <20210323012755.155237800@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Starting in Linux kernel 5.1, it is possible to write the index of the
available_filter_functions (where the first function is 1), which is a
much faster way to set functions than with the glob expressions. By
finding the matches of the available_filter_functions and using the index
of the function, this can make the function call of
tracefs_function_filter() return much faster.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 123 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 7 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 5e80c5e196b1..f97703d5e317 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -418,6 +418,12 @@ static void add_errors(const char ***errs, const char *filter, int ret)
 	*errs = e;
 }
 
+struct func_list {
+	struct func_list	*next;
+	unsigned int		start;
+	unsigned int		end;
+};
+
 struct func_filter {
 	const char		*filter;
 	regex_t			re;
@@ -534,18 +540,54 @@ static int write_filter(int fd, const char *filter, const char *module)
 	return 0;
 }
 
+static int add_func(struct func_list ***next_func_ptr, unsigned int index)
+{
+	struct func_list **next_func = *next_func_ptr;
+	struct func_list *func_list = *next_func;
+
+	if (!func_list) {
+		func_list = calloc(1, sizeof(*func_list));
+		if (!func_list)
+			return -1;
+		func_list->start = index;
+		func_list->end = index;
+		*next_func = func_list;
+		return 0;
+	}
+
+	if (index == func_list->end + 1) {
+		func_list->end = index;
+		return 0;
+	}
+	*next_func_ptr = &func_list->next;
+	return add_func(next_func_ptr, index);
+}
+
+static void free_func_list(struct func_list *func_list)
+{
+	struct func_list *f;
+
+	while (func_list) {
+		f = func_list;
+		func_list = f->next;
+		free(f);
+	}
+}
+
 enum match_type {
 	FILTER_CHECK,
 	FILTER_WRITE,
 };
 
 static int match_filters(int fd, struct func_filter *func_filters,
-			 const char *module, enum match_type type)
+			 const char *module, struct func_list **func_list,
+			 enum match_type type)
 {
 	char *line = NULL;
 	size_t size = 0;
 	char *path;
 	FILE *fp;
+	int index = 0;
 	int ret = 1;
 	int mlen;
 	int i;
@@ -567,12 +609,16 @@ static int match_filters(int fd, struct func_filter *func_filters,
 		char *saveptr = NULL;
 		char *tok, *mtok;
 		int len = strlen(line);
+		bool first = true;
 
 		if (line[len - 1] == '\n')
 			line[len - 1] = '\0';
 		tok = strtok_r(line, " ", &saveptr);
 		if (!tok)
 			goto next;
+
+		index++;
+
 		if (module) {
 			mtok = strtok_r(line, " ", &saveptr);
 			if (!mtok)
@@ -585,8 +631,23 @@ static int match_filters(int fd, struct func_filter *func_filters,
 		case FILTER_CHECK:
 			/* Check, checks a list of filters */
 			for (i = 0; func_filters[i].filter; i++) {
-				if (match(tok, &func_filters[i]))
+				/*
+				 * If a match was found, still need to
+				 * check if other filters would match
+				 * to make sure that all filters have a
+				 * match, as some filters may overlap.
+				 */
+				if (!first && func_filters[i].set)
+					continue;
+				if (match(tok, &func_filters[i])) {
 					func_filters[i].set = true;
+					if (first) {
+						first = false;
+						ret = add_func(&func_list, index);
+						if (ret)
+							goto out;
+					}
+				}
 			}
 			break;
 		case FILTER_WRITE:
@@ -611,12 +672,13 @@ static int match_filters(int fd, struct func_filter *func_filters,
 }
 
 static int check_available_filters(struct func_filter *func_filters,
-				   const char *module, const char ***errs)
+				   const char *module, const char ***errs,
+				   struct func_list **func_list)
 {
 	int ret;
 	int i;
 
-	ret = match_filters(-1, func_filters, module, FILTER_CHECK);
+	ret = match_filters(-1, func_filters, module, func_list, FILTER_CHECK);
 	/* Return here if success or non filter error */
 	if (ret >= 0)
 		return ret;
@@ -633,7 +695,7 @@ static int check_available_filters(struct func_filter *func_filters,
 static int set_regex_filter(int fd, struct func_filter *func_filter,
 			    const char *module)
 {
-	return match_filters(fd, func_filter, module, FILTER_WRITE);
+	return match_filters(fd, func_filter, module, NULL, FILTER_WRITE);
 }
 
 static int controlled_write(int fd, struct func_filter *func_filters,
@@ -724,6 +786,49 @@ static struct func_filter *make_func_filters(const char **filters)
 	return NULL;
 }
 
+static int write_number(int fd, unsigned int start, unsigned int end)
+{
+	char buf[64];
+	unsigned int i;
+	int n, ret;
+
+	for (i = start; i <= end; i++) {
+		n = snprintf(buf, 64, "%d ", i);
+		ret = write(fd, buf, n);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * This will try to write the first number, if that fails, it
+ * will assume that it is not supported and return 1.
+ * If the first write succeeds, but a following write fails, then
+ * the kernel does support this, but something else went wrong,
+ * in this case, return -1.
+ */
+static int write_func_list(int fd, struct func_list *list)
+{
+	int ret;
+
+	if (!list)
+		return 0;
+
+	ret = write_number(fd, list->start, list->end);
+	if (ret)
+		return 1; // try a different way
+	list = list->next;
+	while (list) {
+		ret = write_number(fd, list->start, list->end);
+		if (ret)
+			return -1;
+		list = list->next;
+	}
+	return 0;
+}
+
 /**
  * tracefs_function_filter - write to set_ftrace_filter file to trace
  * particular functions
@@ -756,6 +861,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 			    const char *module, bool reset, const char ***errs)
 {
 	struct func_filter *func_filters;
+	struct func_list *func_list = NULL;
 	char *ftrace_filter_path;
 	int flags;
 	int ret;
@@ -772,7 +878,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (errs)
 		*errs = NULL;
 
-	ret = check_available_filters(func_filters, module, errs);
+	ret = check_available_filters(func_filters, module, errs, &func_list);
 	if (ret)
 		goto out_free;
 
@@ -788,11 +894,14 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (fd < 0)
 		goto out_free;
 
-	ret = controlled_write(fd, func_filters, module, errs);
+	ret = write_func_list(fd, func_list);
+	if (ret > 0)
+		ret = controlled_write(fd, func_filters, module, errs);
 
 	close(fd);
 
  out_free:
+	free_func_list(func_list);
 	free_func_filters(func_filters);
 
 	return ret;
-- 
2.30.1


