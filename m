Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244A8C433E9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DC8619A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhC3AxP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhC3Awu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E679F61987;
        Tue, 30 Mar 2021 00:52:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ci-003TiL-Us; Mon, 29 Mar 2021 20:52:48 -0400
Message-ID: <20210330005248.836930575@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 11/13 v2] libtracefs: Add pthread_mutex_lock() around tracefs_function_filter()
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to make tracefs_function_filter() thread safe, add a pthread
mutex around the entire function to only let one thread access it at a
time.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6d03b4856a63..7e191e207867 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -13,6 +13,7 @@
 #include <regex.h>
 #include <dirent.h>
 #include <limits.h>
+#include <pthread.h>
 #include <errno.h>
 
 #include "tracefs.h"
@@ -22,6 +23,8 @@
 #define TRACE_FILTER		"set_ftrace_filter"
 #define TRACE_FILTER_LIST	"available_filter_functions"
 
+static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;
+
 static const char * const options_map[] = {
 	"unknown",
 	"annotate",
@@ -867,15 +870,16 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
 	char *ftrace_filter_path;
 	bool reset = flags & TRACEFS_FL_RESET;
 	int open_flags;
-	int ret;
+	int ret = 1;
 	int fd;
 
+	pthread_mutex_lock(&filter_lock);
 	if (!filters)
-		return 1;
+		goto out;
 
 	func_filters = make_func_filters(filters);
 	if (!func_filters)
-		return 1;
+		goto out;
 
 	/* Make sure errs is NULL to start with, realloc() depends on it. */
 	if (errs)
@@ -906,6 +910,8 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char **filt
  out_free:
 	free_func_list(func_list);
 	free_func_filters(func_filters);
+ out:
+	pthread_mutex_unlock(&filter_lock);
 
 	return ret;
 }
-- 
2.30.1


