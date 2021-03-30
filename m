Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F74BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6B6619C7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 18:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhC3Sns (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhC3Sno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 14:43:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B56D619D2;
        Tue, 30 Mar 2021 18:35:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRJDO-003YWu-AU; Tue, 30 Mar 2021 14:35:46 -0400
Message-ID: <20210330183546.207110833@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 30 Mar 2021 14:33:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 3/4] libtracefs: Allow filter to be NULL if module is set in
 tracefs_function_filter()
References: <20210330183324.709017776@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the module is set then a NULL filter will be the same as if "*" was
passed in as filter. This will select all the functions for a given
module.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 4 +++-
 src/tracefs-tools.c                          | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index a4218b75deea..fa0f0de6f567 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -37,7 +37,9 @@ not a period, but will match any one character. To force a regular
 expression, either prefix _filter_ with a '^' or append it with a '$' as
 the _filter_ does complete matches of the functions anyway.
 
-The _filter_ may be NULL if a previous call to *tracefs_function_filter()* with
+If _module_ is set and _filter_ is NULL, this will imply the same as _filter_ being
+equal to "pass:[*]". Which will enable all functions for a given _module_. Otherwise
+the _filter_ may be NULL if a previous call to *tracefs_function_filter()* with
 the same _instance_ had *TRACEFS_FL_CONTINUE* set and this call does not. This is
 useful to simply commit the previous filters. It may also be NULL
 if *TRACEFS_FL_RESET* is set and the previous call did not have the same _instance_
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index a9a51beb02b2..82809fae3e6d 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -786,6 +786,10 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	 */
 	errno = EINVAL;
 
+	/* module set with NULL filter means to enable all functions in a module */
+	if (module && !filter)
+		filter = "*";
+
 	if (!filter) {
 		/* OK to call without filters if this is closing the opened file */
 		if (!cont && *fd >= 0) {
-- 
2.30.1


