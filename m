Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2464C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C8D361924
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhC3Sns (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhC3Sno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:43:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7C1619D6;
        Tue, 30 Mar 2021 18:35:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRJDO-003YXO-Ey; Tue, 30 Mar 2021 14:35:46 -0400
Message-ID: <20210330183546.351496716@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 30 Mar 2021 14:33:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 4/4] libtracefs: Add TRACEFS_FL_FUTURE flag for future module filtering
References: <20210330183324.709017776@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Starting in Linux v4.13, it is possible to load filters of a function for
a module before it is loaded. That is:

 # echo '*:mod:rfkill' > set_ftrace_filter
 # echo function > current_tracer
 # modprobe rfkill

And the above will enable all functions for the rfkill module to be traced
before it starts to run.

Add a TRACEFS_FL_FUTURE flag to be able to accomplish the same thing.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt |  9 ++++
 include/tracefs.h                            |  3 ++
 src/tracefs-tools.c                          | 53 +++++++++++++++++---
 3 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index fa0f0de6f567..ccf20e9671c6 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -71,6 +71,15 @@ the *TRACEFS_FL_CONTINUE* flag set for the same instance will fail if
 *TRACEFS_FL_RESET* flag is set, as the reset flag is only applicable for the
 first filter to be added before committing.
 
+*TRACEFS_FL_FUTURE* :
+If _flags_ contains *TRACEFS_FL_FUTURE* and _module_ holds a string of a module,
+then if the module is not loaded it will attemp to write the filter with the module
+in the filter file. Starting in Linux v4.13 module functions could be added to the
+filter before they are loaded. The filter will be cached, and when the module is
+loaded, the filter will be set before the module executes, allowing to trace
+init functions of a module. This will only work if the _filter_ is not a
+regular expression.
+
 RETURN VALUE
 ------------
 Returns 0 on success. If the there is an error but the filtering was not
diff --git a/include/tracefs.h b/include/tracefs.h
index 0d98c10ef325..befcc48d265d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -149,10 +149,13 @@ const char *tracefs_option_name(enum tracefs_option_id id);
 /*
  * RESET	- Reset on opening filter file (O_TRUNC)
  * CONTINUE	- Do not close filter file on return.
+ * FUTURE	- For kernels that support this feature, enable filters for
+ *		  a module that has yet to be loaded.
  */
 enum {
 	TRACEFS_FL_RESET	= (1 << 0),
 	TRACEFS_FL_CONTINUE	= (1 << 1),
+	TRACEFS_FL_FUTURE	= (1 << 2),
 };
 
 int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 82809fae3e6d..cb07b6fc1e3a 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -553,14 +553,18 @@ static void free_func_list(struct func_list *func_list)
 }
 
 enum match_type {
-	FILTER_CHECK,
-	FILTER_WRITE,
+	FILTER_CHECK	= (1 << 0),
+	FILTER_WRITE	= (1 << 1),
+	FILTER_FUTURE	= (1 << 2),
 };
 
 static int match_filters(int fd, struct func_filter *func_filter,
 			 const char *module, struct func_list **func_list,
-			 enum match_type type)
+			 int flags)
 {
+	enum match_type type = flags & (FILTER_CHECK | FILTER_WRITE);
+	bool future = flags & FILTER_FUTURE;
+	bool mod_match = false;
 	char *line = NULL;
 	size_t size = 0;
 	char *path;
@@ -602,6 +606,8 @@ static int match_filters(int fd, struct func_filter *func_filter,
 			if ((strncmp(mtok + 1, module, mlen) != 0) ||
 			    (mtok[mlen + 1] != ']'))
 				goto next;
+			if (future)
+				mod_match = true;
 		}
 		switch (type) {
 		case FILTER_CHECK:
@@ -620,6 +626,11 @@ static int match_filters(int fd, struct func_filter *func_filter,
 					goto out;
 			}
 			break;
+		default:
+			/* Should never happen */
+			ret = -1;
+			goto out;
+
 		}
 	next:
 		free(line);
@@ -630,14 +641,21 @@ static int match_filters(int fd, struct func_filter *func_filter,
 	free(line);
 	fclose(fp);
 
+	/* If there was no matches and future was set, this is a success */
+	if (future && !mod_match)
+		ret = 0;
+
 	return ret;
 }
 
 static int check_available_filters(struct func_filter *func_filter,
 				   const char *module,
-				   struct func_list **func_list)
+				   struct func_list **func_list,
+				   bool future)
 {
-	return match_filters(-1, func_filter, module, func_list, FILTER_CHECK);
+	int flags = FILTER_CHECK | (future ? FILTER_FUTURE : 0);
+
+	return match_filters(-1, func_filter, module, func_list, flags);
 }
 
 static int set_regex_filter(int fd, struct func_filter *func_filter,
@@ -748,6 +766,13 @@ static int write_func_list(int fd, struct func_list *list)
  *          may be added before they take effect. The last call of this
  *          function must be called without this flag for the filter
  *          to take effect.
+ *   TRACEFS_FL_FUTURE - only applicable if "module" is set. If no match
+ *          is made, and the module is not yet loaded, it will still attempt
+ *          to write the filter plus the module; "<filter>:mod:<module>"
+ *          to the filter file. Starting with Linux kernels 4.13, it is possible
+ *          to load the filter file with module functions for a module that
+ *          is not yet loaded, and when the module is loaded, it will then
+ *          activate the module.
  *
  * Returns 0 on success, 1 if there was an error but the filtering has not
  *  yet started, -1 if there was an error but the filtering has started.
@@ -763,10 +788,17 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	char *ftrace_filter_path;
 	bool reset = flags & TRACEFS_FL_RESET;
 	bool cont = flags & TRACEFS_FL_CONTINUE;
+	bool future = flags & TRACEFS_FL_FUTURE;
 	int open_flags;
 	int ret = 1;
 	int *fd;
 
+	/* future flag is only applicable to modules */
+	if (future && !module) {
+		errno = EINVAL;
+		return 1;
+	}
+
 	pthread_mutex_lock(&filter_lock);
 	if (instance)
 		fd = &instance->ftrace_filter_fd;
@@ -808,7 +840,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	if (init_func_filter(&func_filter, filter) < 0)
 		goto out;
 
-	ret = check_available_filters(&func_filter, module, &func_list);
+	ret = check_available_filters(&func_filter, module, &func_list, future);
 	if (ret)
 		goto out_free;
 
@@ -831,7 +863,14 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	ret = 0;
 
 	if (filter) {
-		ret = write_func_list(*fd, func_list);
+		/*
+		 * If future is set, and no functions were found, then
+		 * set it directly.
+		 */
+		if (func_list)
+			ret = write_func_list(*fd, func_list);
+		else
+			ret = 1;
 		if (ret > 0)
 			ret = controlled_write(*fd, &func_filter, module);
 	}
-- 
2.30.1


