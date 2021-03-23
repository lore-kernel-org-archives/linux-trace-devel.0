Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E2CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D070619A1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 01:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhCWBdF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhCWBcb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 21:32:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6335A619A8;
        Tue, 23 Mar 2021 01:32:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lOVuD-001cOm-Df; Mon, 22 Mar 2021 21:32:25 -0400
Message-ID: <20210323013225.303716095@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 22 Mar 2021 21:28:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 5/7] libtracefs: Add write_filter() helper function
References: <20210323012755.155237800@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Wrap the writing of the filter into the filter file in a helper function
such that it can be used in more places.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 58 ++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index d75cb3adcb9f..5b12127a61d9 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -461,6 +461,33 @@ static bool match(const char *str, struct func_filter *func_filter)
 	return regexec(&func_filter->re, str, 0, NULL, 0) == 0;
 }
 
+/*
+ * Return 0 on success, -1 error writing, 1 on other errors.
+ */
+static int write_filter(int fd, const char *filter, const char *module)
+{
+	char *each_str = NULL;
+	int write_size;
+	int size;
+
+	if (module)
+		write_size = asprintf(&each_str, "%s:mod:%s ", filter, module);
+	else
+		write_size = asprintf(&each_str, "%s ", filter);
+
+	if (write_size < 0)
+		return 1;
+
+	size = write(fd, each_str, write_size);
+	free(each_str);
+
+	/* compare written bytes*/
+	if (size < write_size)
+		return -1;
+
+	return 0;
+}
+
 static int check_available_filters(struct func_filter *func_filters,
 				   const char *module, const char ***errs)
 {
@@ -526,31 +553,24 @@ static int check_available_filters(struct func_filter *func_filters,
 static int controlled_write(int fd, const char **filters,
 			    const char *module, const char ***errs)
 {
-	char *each_str = NULL;
-	int write_size = 0;
-	int size = 0;
 	int ret = 0;
 	int i;
 
 	for (i = 0; filters[i]; i++) {
-		if (module)
-			write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
-		else
-			write_size = asprintf(&each_str, "%s ", filters[i]);
-		if (write_size < 0) {
-			ret = 1;
-			goto error;
-		}
-		size = write(fd, each_str, write_size);
-		/* compare written bytes*/
-		if (size < write_size)
+		int r;
+
+		r = write_filter(fd, filters[i], module);
+		if (r < 0) {
 			add_errors(errs, filters[i], ret--);
-		free(each_str);
-		each_str = NULL;
+		} else if (r > 0) {
+			/* Not filter error */
+			if (errs) {
+				free(*errs);
+				*errs = NULL;
+			}
+			return 1;
+		}
 	}
- error:
-	if (each_str)
-		free(each_str);
 	return ret;
 }
 
-- 
2.30.1


