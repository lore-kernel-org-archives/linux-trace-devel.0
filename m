Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E287C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49317611CC
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:46601 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 16:36:52 EDT
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 7 Apr 2021 13:21:33 -0700
Received: from vypre.com (unknown [10.21.255.158])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 8B8E0211A7;
        Wed,  7 Apr 2021 13:21:35 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Move most functionality into helper function for tracefs_function_filter()
Date:   Wed, 7 Apr 2021 16:21:24 -0400
Message-ID: <20210407202126.1870994-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407202126.1870994-1-rostedt@goodmis.org>
References: <20210407202126.1870994-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to share the code of tracefs_function_filter() for
tracefs_function_notrace(), move all its functionality out of
tracefs_function_filter() and into a new helper function called
update_filter(). Then pass in the filter file and the pointer to the file
descriptor to the set_ftrace_filter, such that tracefs_function_notrace()
could do the same with set_ftrace_notrace file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 111 ++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 50 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index cb07b6f..21a9bd3 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -744,54 +744,17 @@ static int write_func_list(int fd, struct func_list *list)
 	return 0;
 }
 
-/**
- * tracefs_function_filter - filter the functions that are traced
- * @instance: ftrace instance, can be NULL for top tracing instance.
- * @filter: The filter to filter what functions are to be traced
- * @module: Module to be traced or NULL if all functions are to be examined.
- * @flags: flags on modifying the filter file
- *
- * @filter may be a full function name, a glob, or a regex. It will be
- * considered a regex, if there's any characters that are not normally in
- * function names or "*" or "?" for a glob.
- *
- * @flags:
- *   TRACEFS_FL_RESET - will clear the functions in the filter file
- *          before applying the @filter. This will error with -1
- *          and errno of EBUSY if this flag is set and a previous
- *          call had the same instance and TRACEFS_FL_CONTINUE set.
- *   TRACEFS_FL_CONTINUE - will keep the filter file open on return.
- *          The filter is updated on closing of the filter file.
- *          With this flag set, the file is not closed, and more filters
- *          may be added before they take effect. The last call of this
- *          function must be called without this flag for the filter
- *          to take effect.
- *   TRACEFS_FL_FUTURE - only applicable if "module" is set. If no match
- *          is made, and the module is not yet loaded, it will still attempt
- *          to write the filter plus the module; "<filter>:mod:<module>"
- *          to the filter file. Starting with Linux kernels 4.13, it is possible
- *          to load the filter file with module functions for a module that
- *          is not yet loaded, and when the module is loaded, it will then
- *          activate the module.
- *
- * Returns 0 on success, 1 if there was an error but the filtering has not
- *  yet started, -1 if there was an error but the filtering has started.
- *  If -1 is returned and TRACEFS_FL_CONTINUE was set, then this function
- *  needs to be called again without the TRACEFS_FL_CONTINUE flag to commit
- *  the changes and close the filter file.
- */
-int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
-			    const char *module, unsigned int flags)
+static int update_filter(const char *filter_path, int *fd,
+			 struct tracefs_instance *instance, const char *filter,
+			 const char *module, unsigned int flags)
 {
 	struct func_filter func_filter;
 	struct func_list *func_list = NULL;
-	char *ftrace_filter_path;
 	bool reset = flags & TRACEFS_FL_RESET;
 	bool cont = flags & TRACEFS_FL_CONTINUE;
 	bool future = flags & TRACEFS_FL_FUTURE;
 	int open_flags;
 	int ret = 1;
-	int *fd;
 
 	/* future flag is only applicable to modules */
 	if (future && !module) {
@@ -800,10 +763,6 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	}
 
 	pthread_mutex_lock(&filter_lock);
-	if (instance)
-		fd = &instance->ftrace_filter_fd;
-	else
-		fd = &ftrace_filter_fd;
 
 	/* RESET is only allowed if the file is not opened yet */
 	if (reset && *fd >= 0) {
@@ -846,20 +805,15 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 
  open_file:
 	ret = 1;
-	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
-	if (!ftrace_filter_path)
-		goto out_free;
 
 	open_flags = reset ? O_TRUNC : O_APPEND;
 
 	if (*fd < 0)
-		*fd = open(ftrace_filter_path, O_WRONLY | open_flags);
-	tracefs_put_tracing_file(ftrace_filter_path);
+		*fd = open(filter_path, O_WRONLY | open_flags);
 	if (*fd < 0)
 		goto out_free;
 
 	errno = 0;
-
 	ret = 0;
 
 	if (filter) {
@@ -887,3 +841,60 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 
 	return ret;
 }
+
+/**
+ * tracefs_function_filter - filter the functions that are traced
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ * @filter: The filter to filter what functions are to be traced
+ * @module: Module to be traced or NULL if all functions are to be examined.
+ * @flags: flags on modifying the filter file
+ *
+ * @filter may be a full function name, a glob, or a regex. It will be
+ * considered a regex, if there's any characters that are not normally in
+ * function names or "*" or "?" for a glob.
+ *
+ * @flags:
+ *   TRACEFS_FL_RESET - will clear the functions in the filter file
+ *          before applying the @filter. This will error with -1
+ *          and errno of EBUSY if this flag is set and a previous
+ *          call had the same instance and TRACEFS_FL_CONTINUE set.
+ *   TRACEFS_FL_CONTINUE - will keep the filter file open on return.
+ *          The filter is updated on closing of the filter file.
+ *          With this flag set, the file is not closed, and more filters
+ *          may be added before they take effect. The last call of this
+ *          function must be called without this flag for the filter
+ *          to take effect.
+ *   TRACEFS_FL_FUTURE - only applicable if "module" is set. If no match
+ *          is made, and the module is not yet loaded, it will still attempt
+ *          to write the filter plus the module; "<filter>:mod:<module>"
+ *          to the filter file. Starting with Linux kernels 4.13, it is possible
+ *          to load the filter file with module functions for a module that
+ *          is not yet loaded, and when the module is loaded, it will then
+ *          activate the module.
+ *
+ * Returns 0 on success, 1 if there was an error but the filtering has not
+ *  yet started, -1 if there was an error but the filtering has started.
+ *  If -1 is returned and TRACEFS_FL_CONTINUE was set, then this function
+ *  needs to be called again without the TRACEFS_FL_CONTINUE flag to commit
+ *  the changes and close the filter file.
+ */
+int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
+			    const char *module, unsigned int flags)
+{
+	char *filter_path;
+	int *fd;
+	int ret;
+
+	filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
+	if (!filter_path)
+		return -1;
+
+	if (instance)
+		fd = &instance->ftrace_filter_fd;
+	else
+		fd = &ftrace_filter_fd;
+
+	ret = update_filter(filter_path, fd, instance, filter, module, flags);
+	tracefs_put_tracing_file(filter_path);
+	return ret;
+}
-- 
2.29.2

