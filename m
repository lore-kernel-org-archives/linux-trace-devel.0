Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3635C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8606D611CC
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:53808 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233158AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 7 Apr 2021 13:21:34 -0700
Received: from vypre.com (unknown [10.21.255.158])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 5CD3B211A8;
        Wed,  7 Apr 2021 13:21:36 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Add tracefs_function_notrace() API
Date:   Wed, 7 Apr 2021 16:21:25 -0400
Message-ID: <20210407202126.1870994-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407202126.1870994-1-rostedt@goodmis.org>
References: <20210407202126.1870994-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the API of tracefs_function_notrace() that is identical to how
tracefs_function_filter() works, but will work with the set_ftrace_notrace
filter file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 19 ++++++++---
 include/tracefs-local.h                      |  1 +
 include/tracefs.h                            |  3 ++
 src/tracefs-instance.c                       |  1 +
 src/tracefs-tools.c                          | 33 ++++++++++++++++++++
 5 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index ccf20e9..746be37 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -4,6 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_function_filter - Function to limit kernel functions that are traced
+tracefs_function_notrace - Function to filter kernel functions that not to be traced
 
 SYNOPSIS
 --------
@@ -12,15 +13,18 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
+int *tracefs_function_notrace*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
 --
 
 DESCRIPTION
 -----------
-This function can be used to limit the Linux kernel functions that would be
-traced by the function and function-graph tracers
+*tracefs_function_filter* and *tracefs_function_notrace* can be used to limit the
+Linux kernel functions that would be traced by the function and function-graph tracers.
+The *tracefs_function_filter* defines a list of functions that can be traced.
+The *tracefs_function_notrace* defines a list of functions that will not be traced.
+If a function is in both lists, it will not be traced.
 
-It will take an
-_instance_ , that can be NULL for the top level tracing,
+They take an _instance_ , that can be NULL for the top level tracing,
 _filter_, a string that represents a filter that should
 be applied to define what functions are to be traced,
 _module_, to limit the filtering on a specific module (or NULL to filter on all functions),
@@ -125,6 +129,13 @@ int main(int argc, char *argv[])
 		/* Error creating new trace instance */
 	}
 
+	/* Do not trace any function with the word "lock" in it */
+	ret = tracefs_function_notrace(inst, "*lock*", NULL, TRACEFS_FL_RESET);
+	if (ret) {
+		printf("Failed to set the notrace filter\n");
+		goto out;
+	}
+
 	/* First reset the filter */
 	ret = tracefs_function_filter(inst, NULL, NULL,
 				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 73ec113..060de7e 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -19,6 +19,7 @@ struct tracefs_instance {
 	char	*name;
 	int	flags;
 	int	ftrace_filter_fd;
+	int	ftrace_notrace_fd;
 };
 
 /* Can be overridden */
diff --git a/include/tracefs.h b/include/tracefs.h
index befcc48..70b7ebe 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -160,4 +160,7 @@ enum {
 
 int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
 			    const char *module, unsigned int flags);
+int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
+			     const char *module, unsigned int flags);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index bf2fabf..9f45624 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -44,6 +44,7 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
 	}
 
 	instance->ftrace_filter_fd = -1;
+	instance->ftrace_notrace_fd = -1;
 
 	return instance;
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 21a9bd3..b41806b 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -21,10 +21,12 @@
 
 #define TRACE_CTRL		"tracing_on"
 #define TRACE_FILTER		"set_ftrace_filter"
+#define TRACE_NOTRACE		"set_ftrace_notrace"
 #define TRACE_FILTER_LIST	"available_filter_functions"
 
 /* File descriptor for Top level set_ftrace_filter  */
 static int ftrace_filter_fd = -1;
+static int ftrace_notrace_fd = -1;
 static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static const char * const options_map[] = {
@@ -898,3 +900,34 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	tracefs_put_tracing_file(filter_path);
 	return ret;
 }
+
+/**
+ * tracefs_function_notrace - filter the functions that are not to be traced
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @filter: The filter to filter what functions are not to be traced
+ * @module: Module to be traced or NULL if all functions are to be examined.
+ * @flags: flags on modifying the filter file
+ *
+ * See tracefs_function_filter, as this has the same functionality but
+ * for adding to the "notrace" filter.
+ */
+int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
+			     const char *module, unsigned int flags)
+{
+	char *filter_path;
+	int *fd;
+	int ret;
+
+	filter_path = tracefs_instance_get_file(instance, TRACE_NOTRACE);
+	if (!filter_path)
+		return -1;
+
+	if (instance)
+		fd = &instance->ftrace_notrace_fd;
+	else
+		fd = &ftrace_notrace_fd;
+
+	ret = update_filter(filter_path, fd, instance, filter, module, flags);
+	tracefs_put_tracing_file(filter_path);
+	return ret;
+}
-- 
2.29.2

