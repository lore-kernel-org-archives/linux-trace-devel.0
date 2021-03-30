Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1811C433E8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B829261987
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC3AxN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhC3Aws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC1F61996;
        Tue, 30 Mar 2021 00:52:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2ch-003Tdx-LN; Mon, 29 Mar 2021 20:52:47 -0400
Message-ID: <20210330005247.542845271@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 02/13 v2] libtracefs: Document function_filter API
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>

Added documentation for the below API:
tracefs_function_filter()

Link: https://lore.kernel.org/linux-trace-devel/1616719420-6747-1-git-send-email-sameeruddin.shaik8@gmail.com

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
[ Cleaned up some white space issues - S.R ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 120 +++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100644 Documentation/libtracefs-function-filter.txt

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
new file mode 100644
index 000000000000..9351788dd1a1
--- /dev/null
+++ b/Documentation/libtracefs-function-filter.txt
@@ -0,0 +1,120 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_function_filter - Function to limit kernel functions that are traced
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
+--
+
+DESCRIPTION
+-----------
+This function can be used to limit the Linux kernel functions that were
+traced by the function and function-graph tracers
+
+It will take
+_instance_ , that can be NULL for the top level tracing.
+_filters_, which is an array of the strings that represent a list of filters that should
+be applied to define what functions are to be traced and The array must end
+with a NULL pointer.
+_module_ , name of the module to be traced.
+_reset_ if set will clear the current set of filters and then apply the
+filter list, otherwise the list of filters are added to the current set of
+filters,
+_errs_, is a pointer to an array of strings, which will be allocated if
+any of filters fail to match any available function, If _errs_ is NULL, it will
+be ignored.
+
+returns 0  on success, 1 or -x (where x is an integer) on error.
+
+RETURN VALUE
+------------
+return 0 on success, if there is error, it will return 1 for general errors or
+negative number -x(x denotes number of failed filters), if there are any failed filters.
+
+In case of negative return value, errs have to be checked and must be freed
+using the free()
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+#define INST "dummy"
+
+const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
+
+int main(int argc, char *argv[])
+{
+	struct tracefs_instance *inst = tracefs_instance_create(INST);
+	const char **errs = NULL;
+	bool reset = 1;
+	int ret;
+	int i = 0;
+
+	if (!inst) {
+		/* Error creating new trace instance*/
+	}
+
+	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
+
+	if (ret < 0 && errs) {
+		while (errs[i])
+			printf("%s\n", errs[i++]);
+	}
+
+	tracefs_instance_free(inst);
+	tracefs_instance_destroy(inst);
+	free(errs);
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.1


