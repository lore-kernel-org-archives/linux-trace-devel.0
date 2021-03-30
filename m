Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1DFC433E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E145A61968
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhC3Snt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhC3Sno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:43:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC70619D3;
        Tue, 30 Mar 2021 18:35:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRJDO-003YWQ-5r; Tue, 30 Mar 2021 14:35:46 -0400
Message-ID: <20210330183546.058728551@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 30 Mar 2021 14:33:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 2/4] libtracefs: Allow filter be NULL if RESET flag is set
References: <20210330183324.709017776@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the TRACEFS_FL_RESET flag is set, and the instance has yet to be
opened, the filter parameter can be NULL. This will allow simply resetting
the filter (clearing it).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 27 ++++++++++++++------
 src/tracefs-tools.c                          | 15 ++++++++---
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index a022a2196b75..a4218b75deea 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -37,6 +37,12 @@ not a period, but will match any one character. To force a regular
 expression, either prefix _filter_ with a '^' or append it with a '$' as
 the _filter_ does complete matches of the functions anyway.
 
+The _filter_ may be NULL if a previous call to *tracefs_function_filter()* with
+the same _instance_ had *TRACEFS_FL_CONTINUE* set and this call does not. This is
+useful to simply commit the previous filters. It may also be NULL
+if *TRACEFS_FL_RESET* is set and the previous call did not have the same _instance_
+and *TRACEFS_FL_CONTINUE* set. This is useful to just clear the filter.
+
 FLAGS
 -----
 
@@ -102,20 +108,25 @@ int main(int argc, char *argv[])
 {
 	struct tracefs_instance *inst = tracefs_instance_create(INST);
 	int ret;
-	int reset = TRACEFS_FL_RESET;
 	int i;
 
 	if (!inst) {
 		/* Error creating new trace instance */
 	}
 
+	/* First reset the filter */
+	ret = tracefs_function_filter(inst, NULL, NULL,
+				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
+	if (ret) {
+		printf("Failed to reset the filter\n");
+		/* Make sure it is closed, -1 means filter was started */
+		if (ret < 0)
+			tracefs_function_filter(inst, NULL, NULL, 0);
+	}
+
 	for (i = 0; filters[i]; i++) {
-		/*
-		 * Only the first call can have TRACEFS_FL_RESET set
-		 * while TRACEFS_FL_CONTINUE is set.
-		 */
 		ret = tracefs_function_filter(inst, filters[i], NULL,
-				      reset | TRACEFS_FL_CONTINUE);
+					      TRACEFS_FL_CONTINUE);
 
 		if (ret) {
 			if (errno == EINVAL)
@@ -123,7 +134,6 @@ int main(int argc, char *argv[])
 			else
 				printf("Failed writing %s\n", filters[i]);
 		}
-		reset = 0;
 	}
 
 	ret = tracefs_function_filter(inst, "*", "ext4", 0);
@@ -133,8 +143,9 @@ int main(int argc, char *argv[])
 		tracefs_function_filter(inst, NULL, NULL, 0);
 	}
 
+ out:
 	tracefs_instance_destroy(inst);
-	return 0;
+	return ret;
 }
 --
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 5719ddf66982..a9a51beb02b2 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -794,6 +794,10 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 			close(*fd);
 			*fd = -1;
 		}
+		/* Also OK to call if reset flag is set */
+		if (reset)
+			goto open_file;
+
 		goto out;
 	}
 
@@ -804,6 +808,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	if (ret)
 		goto out_free;
 
+ open_file:
 	ret = 1;
 	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
 	if (!ftrace_filter_path)
@@ -819,9 +824,13 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 
 	errno = 0;
 
-	ret = write_func_list(*fd, func_list);
-	if (ret > 0)
-		ret = controlled_write(*fd, &func_filter, module);
+	ret = 0;
+
+	if (filter) {
+		ret = write_func_list(*fd, func_list);
+		if (ret > 0)
+			ret = controlled_write(*fd, &func_filter, module);
+	}
 
 	if (!cont) {
 		close(*fd);
-- 
2.30.1


