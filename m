Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FB7C433E5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E15A619B2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCWBdF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231285AbhCWBcb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 21:32:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931F1619AF;
        Tue, 23 Mar 2021 01:32:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lOVuD-001cPG-II; Mon, 22 Mar 2021 21:32:25 -0400
Message-ID: <20210323013225.451281989@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 22 Mar 2021 21:28:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 6/7] libtracefs: Allow for setting filters with regex expressions
References: <20210323012755.155237800@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

All for full "regex(3)" processing of setting functions in the
set_ftrace_filter file. Check if the filter passed in is just a glob
expression that the kernel can process, or if it is a regex that should look
at the available_filter_functions list instead.

If it is a regex, it will read the available_filter_functions and write in
each function as it finds it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 139 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 118 insertions(+), 21 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 5b12127a61d9..5e80c5e196b1 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,8 +18,9 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
-#define TRACE_CTRL	"tracing_on"
-#define TRACE_FILTER	"set_ftrace_filter"
+#define TRACE_CTRL		"tracing_on"
+#define TRACE_FILTER		"set_ftrace_filter"
+#define TRACE_FILTER_LIST	"available_filter_functions"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -421,8 +422,53 @@ struct func_filter {
 	const char		*filter;
 	regex_t			re;
 	bool			set;
+	bool			is_regex;
 };
 
+static bool is_regex(const char *str)
+{
+	int i;
+
+	for (i = 0; str[i]; i++) {
+		switch (str[i]) {
+		case 'a' ... 'z':
+		case 'A'...'Z':
+		case '_':
+		case '0'...'9':
+		case '*':
+		case '.':
+			/* Dots can be part of a function name */
+		case '?':
+			continue;
+		default:
+			return true;
+		}
+	}
+	return false;
+}
+
+static char *update_regex(const char *reg)
+{
+	int len = strlen(reg);
+	char *str;
+
+	if (reg[0] == '^' && reg[len - 1] == '$')
+		return strdup(reg);
+
+	str = malloc(len + 3);
+	if (reg[0] == '^') {
+		strcpy(str, reg);
+	} else {
+		str[0] = '^';
+		strcpy(str + 1, reg);
+		len++; /* add ^ */
+	}
+	if (str[len - 1] != '$')
+		str[len++]= '$';
+	str[len] = '\0';
+	return str;
+}
+
 /*
  * Convert a glob into a regular expression.
  */
@@ -488,8 +534,13 @@ static int write_filter(int fd, const char *filter, const char *module)
 	return 0;
 }
 
-static int check_available_filters(struct func_filter *func_filters,
-				   const char *module, const char ***errs)
+enum match_type {
+	FILTER_CHECK,
+	FILTER_WRITE,
+};
+
+static int match_filters(int fd, struct func_filter *func_filters,
+			 const char *module, enum match_type type)
 {
 	char *line = NULL;
 	size_t size = 0;
@@ -499,7 +550,7 @@ static int check_available_filters(struct func_filter *func_filters,
 	int mlen;
 	int i;
 
-	path = tracefs_get_tracing_file("available_filter_functions");
+	path = tracefs_get_tracing_file(TRACE_FILTER_LIST);
 	if (!path)
 		return 1;
 
@@ -530,39 +581,76 @@ static int check_available_filters(struct func_filter *func_filters,
 			    (mtok[mlen + 1] != ']'))
 				goto next;
 		}
-		for (i = 0; func_filters[i].filter; i++) {
-			if (match(tok, &func_filters[i]))
-				func_filters[i].set = true;
+		switch (type) {
+		case FILTER_CHECK:
+			/* Check, checks a list of filters */
+			for (i = 0; func_filters[i].filter; i++) {
+				if (match(tok, &func_filters[i]))
+					func_filters[i].set = true;
+			}
+			break;
+		case FILTER_WRITE:
+			/* Writes only have one filter */
+			if (match(tok, func_filters)) {
+				ret = write_filter(fd, tok, module);
+				if (ret)
+					goto out;
+			}
+			break;
 		}
 	next:
 		free(line);
 		line = NULL;
 		len = 0;
 	}
+ out:
+	free(line);
 	fclose(fp);
 
+	return ret;
+}
+
+static int check_available_filters(struct func_filter *func_filters,
+				   const char *module, const char ***errs)
+{
+	int ret;
+	int i;
+
+	ret = match_filters(-1, func_filters, module, FILTER_CHECK);
+	/* Return here if success or non filter error */
+	if (ret >= 0)
+		return ret;
+
+	/* Failed on filter, set the errors */
 	ret = 0;
 	for (i = 0; func_filters[i].filter; i++) {
 		if (!func_filters[i].set)
 			add_errors(errs, func_filters[i].filter, ret--);
 	}
-
 	return ret;
 }
 
-static int controlled_write(int fd, const char **filters,
+static int set_regex_filter(int fd, struct func_filter *func_filter,
+			    const char *module)
+{
+	return match_filters(fd, func_filter, module, FILTER_WRITE);
+}
+
+static int controlled_write(int fd, struct func_filter *func_filters,
 			    const char *module, const char ***errs)
 {
 	int ret = 0;
 	int i;
 
-	for (i = 0; filters[i]; i++) {
+	for (i = 0; func_filters[i].filter; i++) {
+		const char *filter = func_filters[i].filter;
 		int r;
 
-		r = write_filter(fd, filters[i], module);
-		if (r < 0) {
-			add_errors(errs, filters[i], ret--);
-		} else if (r > 0) {
+		if (func_filters[i].is_regex)
+			r = set_regex_filter(fd, &func_filters[i], module);
+		else
+			r = write_filter(fd, filter, module);
+		if (r > 0) {
 			/* Not filter error */
 			if (errs) {
 				free(*errs);
@@ -570,6 +658,8 @@ static int controlled_write(int fd, const char **filters,
 			}
 			return 1;
 		}
+		if (r < 0)
+			add_errors(errs, filter, ret--);
 	}
 	return ret;
 }
@@ -579,7 +669,11 @@ static int init_func_filter(struct func_filter *func_filter, const char *filter)
 	char *str;
 	int ret;
 
-	str = make_regex(filter);
+	if (!(func_filter->is_regex = is_regex(filter)))
+		str = make_regex(filter);
+	else
+		str = update_regex(filter);
+
 	if (!str)
 		return -1;
 
@@ -679,24 +773,27 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 		*errs = NULL;
 
 	ret = check_available_filters(func_filters, module, errs);
-	free_func_filters(func_filters);
 	if (ret)
-		return ret;
+		goto out_free;
 
+	ret = 1;
 	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
 	if (!ftrace_filter_path)
-		return 1;
+		goto out_free;
 
 	flags = reset ? O_TRUNC : O_APPEND;
 
 	fd = open(ftrace_filter_path, O_WRONLY | flags);
 	tracefs_put_tracing_file(ftrace_filter_path);
 	if (fd < 0)
-		return 1;
+		goto out_free;
 
-	ret = controlled_write(fd, filters, module, errs);
+	ret = controlled_write(fd, func_filters, module, errs);
 
 	close(fd);
 
+ out_free:
+	free_func_filters(func_filters);
+
 	return ret;
 }
-- 
2.30.1


