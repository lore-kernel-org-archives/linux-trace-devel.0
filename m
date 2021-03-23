Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B5DC433E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A241619B1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhCWBdF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhCWBc1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 21:32:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 404B6619AD;
        Tue, 23 Mar 2021 01:32:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lOVuD-001cOI-90; Mon, 22 Mar 2021 21:32:25 -0400
Message-ID: <20210323013225.156539389@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 22 Mar 2021 21:27:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 4/7] libtracefs: Add checking of available_filter_functions to
 tracefs_function_filter()
References: <20210323012755.155237800@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of modifying the set_ftrace_filter file with a filter that
possibly does not match anything, check the available_filter_functions
file first to make sure that each filter will match something. Then if
"reset" is enabled, it wont clear the filter file and not set any
filtering, which could cause issues if the application is not expecting
all functions to be enabled.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 183 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 178 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 1348542a3419..d75cb3adcb9f 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
+#include <regex.h>
 #include <dirent.h>
 #include <limits.h>
 #include <errno.h>
@@ -416,6 +417,112 @@ static void add_errors(const char ***errs, const char *filter, int ret)
 	*errs = e;
 }
 
+struct func_filter {
+	const char		*filter;
+	regex_t			re;
+	bool			set;
+};
+
+/*
+ * Convert a glob into a regular expression.
+ */
+static char *make_regex(const char *glob)
+{
+	char *str;
+	int cnt = 0;
+	int i, j;
+
+	for (i = 0; glob[i]; i++) {
+		if (glob[i] == '*'|| glob[i] == '.')
+			cnt++;
+	}
+
+	/* '^' + ('*'->'.*' or '.' -> '\.') + '$' + '\0' */
+	str = malloc(i + cnt + 3);
+	if (!str)
+		return NULL;
+
+	str[0] = '^';
+	for (i = 0, j = 1; glob[i]; i++, j++) {
+		if (glob[i] == '*')
+			str[j++] = '.';
+		/* Dots can be part of a function name */
+		if (glob[i] == '.')
+			str[j++] = '\\';
+		str[j] = glob[i];
+	}
+	str[j++] = '$';
+	str[j] = '\0';
+	return str;
+}
+
+static bool match(const char *str, struct func_filter *func_filter)
+{
+	return regexec(&func_filter->re, str, 0, NULL, 0) == 0;
+}
+
+static int check_available_filters(struct func_filter *func_filters,
+				   const char *module, const char ***errs)
+{
+	char *line = NULL;
+	size_t size = 0;
+	char *path;
+	FILE *fp;
+	int ret = 1;
+	int mlen;
+	int i;
+
+	path = tracefs_get_tracing_file("available_filter_functions");
+	if (!path)
+		return 1;
+
+	fp = fopen(path, "r");
+	tracefs_put_tracing_file(path);
+
+	if (!fp)
+		return 1;
+
+	if (module)
+		mlen = strlen(module);
+
+	while (getline(&line, &size, fp) >= 0) {
+		char *saveptr = NULL;
+		char *tok, *mtok;
+		int len = strlen(line);
+
+		if (line[len - 1] == '\n')
+			line[len - 1] = '\0';
+		tok = strtok_r(line, " ", &saveptr);
+		if (!tok)
+			goto next;
+		if (module) {
+			mtok = strtok_r(line, " ", &saveptr);
+			if (!mtok)
+				goto next;
+			if ((strncmp(mtok + 1, module, mlen) != 0) ||
+			    (mtok[mlen + 1] != ']'))
+				goto next;
+		}
+		for (i = 0; func_filters[i].filter; i++) {
+			if (match(tok, &func_filters[i]))
+				func_filters[i].set = true;
+		}
+	next:
+		free(line);
+		line = NULL;
+		len = 0;
+	}
+	fclose(fp);
+
+	ret = 0;
+	for (i = 0; func_filters[i].filter; i++) {
+		if (!func_filters[i].set)
+			add_errors(errs, func_filters[i].filter, ret--);
+	}
+
+	return ret;
+}
+
 static int controlled_write(int fd, const char **filters,
 			    const char *module, const char ***errs)
 {
@@ -447,6 +554,62 @@ static int controlled_write(int fd, const char **filters,
 	return ret;
 }
 
+static int init_func_filter(struct func_filter *func_filter, const char *filter)
+{
+	char *str;
+	int ret;
+
+	str = make_regex(filter);
+	if (!str)
+		return -1;
+
+	ret = regcomp(&func_filter->re, str, REG_ICASE|REG_NOSUB);
+	free(str);
+
+	if (ret < 0)
+		return -1;
+
+	func_filter->filter = filter;
+	return 0;
+}
+
+static void free_func_filters(struct func_filter *func_filters)
+{
+	int i;
+
+	if (!func_filters)
+		return;
+
+	for (i = 0; func_filters[i].filter; i++) {
+		regfree(&func_filters[i].re);
+	}
+}
+
+static struct func_filter *make_func_filters(const char **filters)
+{
+	struct func_filter *func_filters = NULL;
+	int i;
+
+	for (i = 0; filters[i]; i++)
+		;
+
+	if (!i)
+		return NULL;
+
+	func_filters = calloc(i + 1, sizeof(*func_filters));
+	if (!func_filters)
+		return NULL;
+
+	for (i = 0; filters[i]; i++) {
+		if (init_func_filter(&func_filters[i], filters[i]) < 0)
+			goto out_err;
+	}
+	return func_filters;
+ out_err:
+	free_func_filters(func_filters);
+	return NULL;
+}
+
 /**
  * tracefs_function_filter - write to set_ftrace_filter file to trace
  * particular functions
@@ -478,14 +641,28 @@ static int controlled_write(int fd, const char **filters,
 int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
 			    const char *module, bool reset, const char ***errs)
 {
+	struct func_filter *func_filters;
 	char *ftrace_filter_path;
-	int ret = 0;
 	int flags;
+	int ret;
 	int fd;
 
 	if (!filters)
 		return 1;
 
+	func_filters = make_func_filters(filters);
+	if (!func_filters)
+		return 1;
+
+	/* Make sure errs is NULL to start with, realloc() depends on it. */
+	if (errs)
+		*errs = NULL;
+
+	ret = check_available_filters(func_filters, module, errs);
+	free_func_filters(func_filters);
+	if (ret)
+		return ret;
+
 	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
 	if (!ftrace_filter_path)
 		return 1;
@@ -497,10 +674,6 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (fd < 0)
 		return 1;
 
-	/* Make sure errs is NULL to start with, realloc() depends on it. */
-	if (errs)
-		*errs = NULL;
-
 	ret = controlled_write(fd, filters, module, errs);
 
 	close(fd);
-- 
2.30.1


