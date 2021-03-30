Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAA3C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B59619A5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhC3AxM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhC3Awt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88F461997;
        Tue, 30 Mar 2021 00:52:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ch-003TeR-Ps; Mon, 29 Mar 2021 20:52:47 -0400
Message-ID: <20210330005247.685321870@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 03/13 v2] libtracefs: Fix notations of tracefs_function_filter() and module
 parameter
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Highlight the function name and encapsulate each '*' with a "pass:[*]" to
not have the creation of the man pages interpret them as bold annotations.

Also remove the tracefs_instance_free(), as tracefs_instance_destroy() is
called and that frees the instance.

The description in the man page for tracefs_function_filter() left out
that NULL is a suitable value for the modules parameter, meaning that all
functions will be examined for a match of one of the filters.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index 9351788dd1a1..c0c89f372c21 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -11,7 +11,7 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
+int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]pass:[*]_filters_, const char pass:[*]_module_, bool _reset_, const char pass:[*]pass:[*]pass:[*]_errs_);
 --
 
 DESCRIPTION
@@ -24,7 +24,7 @@ _instance_ , that can be NULL for the top level tracing.
 _filters_, which is an array of the strings that represent a list of filters that should
 be applied to define what functions are to be traced and The array must end
 with a NULL pointer.
-_module_ , name of the module to be traced.
+_module_ , name of the module to be traced (or NULL for all functions),
 _reset_ if set will clear the current set of filters and then apply the
 filter list, otherwise the list of filters are added to the current set of
 filters,
@@ -61,7 +61,7 @@ int main(int argc, char *argv[])
 	int i = 0;
 
 	if (!inst) {
-		/* Error creating new trace instance*/
+		/* Error creating new trace instance */
 	}
 
 	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
@@ -71,7 +71,6 @@ int main(int argc, char *argv[])
 			printf("%s\n", errs[i++]);
 	}
 
-	tracefs_instance_free(inst);
 	tracefs_instance_destroy(inst);
 	free(errs);
 	return 0;
-- 
2.30.1


