Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A64C433E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7B461987
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhC3AxL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhC3Awt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C6861999;
        Tue, 30 Mar 2021 00:52:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ch-003Tev-U8; Mon, 29 Mar 2021 20:52:47 -0400
Message-ID: <20210330005247.820340155@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 04/13 v2] libtracefs: Move opening of file out of controlled_write()
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to try multiple methods of writing to the filter file, the opening
of the filter file needs to be in the tracefs_function_filter() call, and
allow that to be passed to multiple ways of writing to the filter.

Link: https://lore.kernel.org/linux-trace-devel/20210323013224.877520803@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 4f8bcdc299df..02e43168a810 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -389,24 +389,18 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
 		options->mask &= ~(1ULL << (id - 1));
 }
 
-static int controlled_write(const char *filter_path, const char **filters,
-			    const char *module, bool reset, const char ***errs)
+static int controlled_write(int fd, const char **filters,
+			    const char *module, const char ***errs)
 {
-	int flags = reset ? O_TRUNC : O_APPEND;
 	const char **temp = NULL;
 	const char **e = NULL;
 	char *each_str = NULL;
 	int write_size = 0;
 	int size = 0;
-	int fd = -1;
 	int ret = 0;
 	int j = 0;
 	int i;
 
-	fd = open(filter_path, O_WRONLY | flags);
-	if (fd < 0)
-		return 1;
-
 	for (i = 0; filters[i]; i++) {
 		if (module)
 			write_size = asprintf(&each_str, "%s:mod:%s ", filters[i], module);
@@ -449,7 +443,6 @@ static int controlled_write(const char *filter_path, const char **filters,
  error:
 	if (each_str)
 		free(each_str);
-	close(fd);
 	return ret;
 }
 
@@ -486,6 +479,8 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 {
 	char *ftrace_filter_path;
 	int ret = 0;
+	int flags;
+	int fd;
 
 	if (!filters)
 		return 1;
@@ -494,7 +489,16 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	if (!ftrace_filter_path)
 		return 1;
 
-	ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
+	flags = reset ? O_TRUNC : O_APPEND;
+
+	fd = open(ftrace_filter_path, O_WRONLY | flags);
 	tracefs_put_tracing_file(ftrace_filter_path);
+	if (fd < 0)
+		return 1;
+
+	ret = controlled_write(fd, filters, module, errs);
+
+	close(fd);
+
 	return ret;
 }
-- 
2.30.1


