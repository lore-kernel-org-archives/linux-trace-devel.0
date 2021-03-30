Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061D6C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA50161987
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhC3AxL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhC3Awt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B49A61987;
        Tue, 30 Mar 2021 00:52:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ci-003TfP-2c; Mon, 29 Mar 2021 20:52:48 -0400
Message-ID: <20210330005247.960629718@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 05/13 v2] libtracefs: Add add_errors() helper function for control_write()
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Move the code that manages errors out of control_write() as this will be
used by other methods in setting the filters.

Link: https://lore.kernel.org/linux-trace-devel/20210323013225.012918584@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 61 ++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 02e43168a810..1348542a3419 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -389,16 +389,40 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 		options->mask &= ~(1ULL << (id - 1));
 }
 
+static void add_errors(const char ***errs, const char *filter, int ret)
+{
+	const char **e;
+
+	if (!errs)
+		return;
+
+	/* Negative is passed in */
+	ret = -ret;
+	e = *errs;
+
+	/* If this previously failed to allocate stop processing */
+	if (!e && ret)
+		return;
+
+	/* Add 2, one for the new entry, and one for NULL */
+	e = realloc(e, sizeof(*e) * (ret + 2));
+	if (!e) {
+		free(*errs);
+		*errs = NULL;
+		return;
+	}
+	e[ret] = filter;
+	e[ret + 1] = NULL;
+	*errs = e;
+}
+
 static int controlled_write(int fd, const char **filters,
 			    const char *module, const char ***errs)
 {
-	const char **temp = NULL;
-	const char **e = NULL;
 	char *each_str = NULL;
 	int write_size = 0;
 	int size = 0;
 	int ret = 0;
-	int j = 0;
 	int i;
 
 	for (i = 0; filters[i]; i++) {
@@ -412,34 +436,11 @@ static int controlled_write(int fd, const char **filters,
 		}
 		size = write(fd, each_str, write_size);
 		/* compare written bytes*/
-		if (size < write_size) {
-			if (errs) {
-				temp = realloc(e, (j + 1) * (sizeof(char *)));
-				if (!temp) {
-					free(e);
-					ret = 1;
-					goto error;
-				} else
-					e = temp;
-
-				e[j++] = filters[i];
-				ret -= 1;
-			}
-		}
+		if (size < write_size)
+			add_errors(errs, filters[i], ret--);
 		free(each_str);
 		each_str = NULL;
 	}
-	if (errs) {
-		temp = realloc(e, (j + 1) * (sizeof(char *)));
-		if (!temp) {
-			free(e);
-			ret = 1;
-			goto error;
-		} else
-			e = temp;
-		e[j] = NULL;
-		*errs = e;
-	}
  error:
 	if (each_str)
 		free(each_str);
@@ -496,6 +497,10 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (fd < 0)
 		return 1;
 
+	/* Make sure errs is NULL to start with, realloc() depends on it. */
+	if (errs)
+		*errs = NULL;
+
 	ret = controlled_write(fd, filters, module, errs);
 
 	close(fd);
-- 
2.30.1


