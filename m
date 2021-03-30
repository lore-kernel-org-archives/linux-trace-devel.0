Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3B8C433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE12B61985
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhC3Snt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232893AbhC3Sno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:43:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 373F161924;
        Tue, 30 Mar 2021 18:35:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRJDO-003YVv-0v; Tue, 30 Mar 2021 14:35:46 -0400
Message-ID: <20210330183545.906539717@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 30 Mar 2021 14:33:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 1/4] libtracefs: Only allow RESET flag if file is not already opened
References: <20210330183324.709017776@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Only allow the flags to have TRACEFS_FL_RESET set in
tracefs_function_filter() if the previous call with the same instance did
not have the TRACEFS_FL_CONTINUE set.

The RESET flag means to reset the filter, and since it can only do that
when the file is opened, it does not make sense to have it set. It also is
dangerous to simply close (and commit previous changes) if it is set and
the file is already opened. The only rational solution is to fail the
call in this case.

Link: https://lore.kernel.org/linux-trace-devel/20210330105250.0a7105a1@gandalf.local.home/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 24 ++++++++++++--------
 src/tracefs-tools.c                          | 13 ++++++++---
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 5631ff75d54e..a022a2196b75 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -45,9 +45,10 @@ The _flags_ parameter may have the following set, or be zero.
 *TRACEFS_FL_RESET* :
 If _flags_ contains *TRACEFS_FL_RESET*, then it will clear the filters that
 are currently set before applying _filter_. Otherwise, _filter_ is added to
-the current set of filters already enabled. This flag is ignored if a
+the current set of filters already enabled. If this flag is set and the
 previous call to tracefs_function_filter() had the same _instance_ and the
-*TRACEFS_FL_CONTINUE* flag was set.
+*TRACEFS_FL_CONTINUE* flag was set, then the function will fail with a
+return of -1 and errno set to EBUSY.
 
 *TRACEFS_FL_CONTINUE* :
 If _flags_ contains *TRACEFS_FL_CONTINUE*, then _filter_ will not take
@@ -58,9 +59,9 @@ commit all the filters.
 It can be called multiple times to add more filters. A call without this
 flag set will commit the changes before returning (if the _filter_ passed in
 successfully matched). A tracefs_function_filter() call after one that had
-the *TRACEFS_FL_CONTINUE* flag set for the same instance will ignore the
-*TRACEFS_FL_RESET* flag, as the reset flag is only applicable for the first
-filters to be added before committing.
+the *TRACEFS_FL_CONTINUE* flag set for the same instance will fail if
+*TRACEFS_FL_RESET* flag is set, as the reset flag is only applicable for the
+first filter to be added before committing.
 
 RETURN VALUE
 ------------
@@ -79,6 +80,10 @@ ERRORS
 
 *EINVAL* The filter is invalid or did not match any functions.
 
+*EBUSY* The previous call of *tracefs_function_filter*() was called
+with the same instance and *TRACEFS_FL_CONTINUE* set and the current call
+had *TRACEFS_FL_RESET* set.
+
 Other errors may also happen caused by internal system calls.
 
 EXAMPLE
@@ -97,6 +102,7 @@ int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = tracefs_instance_create(INST);
 	int ret;
+	int reset = TRACEFS_FL_RESET;
 	int i;
 
 	if (!inst) {
@@ -105,12 +111,11 @@ int main(int argc, char *argv[])
 
 	for (i = 0; filters[i]; i++) {
 		/*
-		 * Note, only the first call does something
-		 * with TRACEFS_FL_RESET. It is ignored in the following
-		 * calls.
+		 * Only the first call can have TRACEFS_FL_RESET set
+		 * while TRACEFS_FL_CONTINUE is set.
 		 */
 		ret = tracefs_function_filter(inst, filters[i], NULL,
-				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+				      reset | TRACEFS_FL_CONTINUE);
 
 		if (ret) {
 			if (errno == EINVAL)
@@ -118,6 +123,7 @@ int main(int argc, char *argv[])
 			else
 				printf("Failed writing %s\n", filters[i]);
 		}
+		reset = 0;
 	}
 
 	ret = tracefs_function_filter(inst, "*", "ext4", 0);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 165a9dbd8a02..5719ddf66982 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -739,9 +739,9 @@ static int write_func_list(int fd, struct func_list *list)
  *
  * @flags:
  *   TRACEFS_FL_RESET - will clear the functions in the filter file
- *          before applying the @filter. This flag is ignored
- *          if this function is called again when the previous
- *          call had TRACEFS_FL_CONTINUE set.
+ *          before applying the @filter. This will error with -1
+ *          and errno of EBUSY if this flag is set and a previous
+ *          call had the same instance and TRACEFS_FL_CONTINUE set.
  *   TRACEFS_FL_CONTINUE - will keep the filter file open on return.
  *          The filter is updated on closing of the filter file.
  *          With this flag set, the file is not closed, and more filters
@@ -773,6 +773,13 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	else
 		fd = &ftrace_filter_fd;
 
+	/* RESET is only allowed if the file is not opened yet */
+	if (reset && *fd >= 0) {
+		errno = EBUSY;
+		ret = -1;
+		goto out;
+	}
+
 	/*
 	 * Set EINVAL on no matching filter. But errno may still be modified
 	 * on another type of failure (allocation or opening a file).
-- 
2.30.1


