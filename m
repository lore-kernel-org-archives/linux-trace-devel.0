Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37E0C433E5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D025619AB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhC3AxO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3Aws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871F66024A;
        Tue, 30 Mar 2021 00:52:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ch-003TdS-GZ; Mon, 29 Mar 2021 20:52:47 -0400
Message-ID: <20210330005247.397966909@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 01/13 v2] libtracefs: An API to set the filtering of functions
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

This new API will write the function filters into the
set_ftrace_filter file.

tracefs_function_filter()

https://bugzilla.kernel.org/show_bug.cgi?id=210643

Link: https://lore.kernel.org/linux-trace-devel/1616171938-18914-1-git-send-email-sameeruddin.shaik8@gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20210323013224.729594322@goodmis.org

Acked-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |   3 +-
 src/tracefs-tools.c | 111 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 05bd0ef4d404..9477fdb14c5a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -145,5 +145,6 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
 const char *tracefs_option_name(enum tracefs_option_id id);
-
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
+			    const char *module, bool reset, const char ***errs);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index e2dfc7b8acff..4f8bcdc299df 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -18,6 +18,7 @@
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
+#define TRACE_FILTER	"set_ftrace_filter"
 
 static const char * const options_map[] = {
 	"unknown",
@@ -387,3 +388,113 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 	if (options && id > TRACEFS_OPTION_INVALID)
 		options->mask &= ~(1ULL << (id - 1));
 }
+
+static int controlled_write(const char *filter_path, const char **filters,
+			    const char *module, bool reset, const char ***errs)
+{
+	int flags = reset ? O_TRUNC : O_APPEND;
+	const char **temp = NULL;
+	const char **e = NULL;
+	char *each_str = NULL;
+	int write_size = 0;
+	int size = 0;
+	int fd = -1;
+	int ret = 0;
+	int j = 0;
+	int i;
+
+	fd = open(filter_path, O_WRONLY | flags);
+	if (fd < 0)
+		return 1;
+
+	for (i = 0; filters[i]; i++) {
+		if (module)
+			write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
+		else
+			write_size = asprintf(&each_str, "%s ", filters[i]);
+		if (write_size < 0) {
+			ret = 1;
+			goto error;
+		}
+		size = write(fd, each_str, write_size);
+		/* compare written bytes*/
+		if (size < write_size) {
+			if (errs) {
+				temp = realloc(e, (j + 1) * (sizeof(char *)));
+				if (!temp) {
+					free(e);
+					ret = 1;
+					goto error;
+				} else
+					e = temp;
+
+				e[j++] = filters[i];
+				ret -= 1;
+			}
+		}
+		free(each_str);
+		each_str = NULL;
+	}
+	if (errs) {
+		temp = realloc(e, (j + 1) * (sizeof(char *)));
+		if (!temp) {
+			free(e);
+			ret = 1;
+			goto error;
+		} else
+			e = temp;
+		e[j] = NULL;
+		*errs = e;
+	}
+ error:
+	if (each_str)
+		free(each_str);
+	close(fd);
+	return ret;
+}
+
+/**
+ * tracefs_function_filter - write to set_ftrace_filter file to trace
+ * particular functions
+ * @instance: ftrace instance, can be NULL for top tracing instance
+ * @filters: An array of function names ending with a NULL pointer
+ * @module: Module to be traced
+ * @reset: set to true to reset the file before applying the filter
+ * @errs: A pointer to array of constant strings that will be allocated
+ * on negative return of this function, pointing to the filters that
+ * failed.May be NULL, in which case this field will be ignored.
+ *
+ * The @filters is an array of strings, where each string will be used
+ * to set a function or functions to be traced.
+ *
+ * If @reset is true, then all functions in the filter are cleared
+ * before adding functions from @filters. Otherwise, the functions set
+ * by @filters will be appended to the filter file
+ *
+ * returns -x on filter errors (where x is number of failed filter
+ * srtings) and if @errs is not NULL will be an allocated string array
+ * pointing to the strings in @filters that failed and must be freed
+ * with free().
+ *
+ * returns 1 on general errors not realted to setting the filter.
+ * @errs is not set even if supplied.
+ *
+ * return 0 on success and @errs is not set.
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters,
+			    const char *module, bool reset, const char ***errs)
+{
+	char *ftrace_filter_path;
+	int ret = 0;
+
+	if (!filters)
+		return 1;
+
+	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
+	if (!ftrace_filter_path)
+		return 1;
+
+	ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
+	tracefs_put_tracing_file(ftrace_filter_path);
+	return ret;
+}
-- 
2.30.1


