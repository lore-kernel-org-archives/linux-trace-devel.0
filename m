Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E42DC11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 284B76140A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhGBEAF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 00:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhGBEAE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 00:00:04 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9C16140A
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 03:57:33 +0000 (UTC)
Date:   Thu, 1 Jul 2021 23:57:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add man pages for tracefs_error_*() functions
Message-ID: <20210701235731.26c5441c@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a man page for the following functions:

    tracefs_error_last()
    tracefs_error_all()
    tracefs_error_clear()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-error.txt | 132 +++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)
 create mode 100644 Documentation/libtracefs-error.txt

diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
new file mode 100644
index 0000000..3f6a154
--- /dev/null
+++ b/Documentation/libtracefs-error.txt
@@ -0,0 +1,132 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_error_last, tracefs_error_all, tracefs_error_clear -
+functions to read and clear the tracefs error log.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
+char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_error_clear*(struct tracefs_instance pass:[*]_instance_);
+--
+
+DESCRIPTION
+-----------
+The *tracefs_error_last*() returns the last error message in the tracefs
+error log. Several actions that require proper syntax written into the
+tracefs file system may produce error messages in the error log. This
+function will show the most recent error in the error log.
+
+The *tracefs_error_all*() returns all messages saved in the error log.
+Note, this may not be all messages that were ever produced, as the kernel
+only keeps a limited amount of messages, and older ones may be discarded
+by the kernel.
+
+The *tracefs_error_clear*() will clear the error log.
+
+RETURN VALUE
+------------
+Both *tracefs_error_last*() and *tracefs_error_all*() will return an allocated
+string an error exists in the log, otherwise NULL is returned. If an error
+occurs, errno will be set, otherwise if there is no error messages to display
+then errno is not touched.
+
+*tracefs_error_clear*() returns 0 on success or -1 on error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+
+#include <tracefs/tracefs.h>
+
+int main (int argc, char **argv, char **env)
+{
+	char *system = NULL;
+	char *kprobe;
+	char *format;
+	char *addr;
+	int arg = 1;
+	int ret;
+
+	if (argc < 4) {
+		printf("usage: %s [system] kprobe addr fmt\n", argv[0]);
+		exit(-1);
+	}
+
+	if (argc > 5)
+		system = argv[arg++];
+
+	kprobe = argv[arg++];
+	addr = argv[arg++];
+	format = argv[arg++];
+
+	tracefs_error_clear(NULL);
+	tracefs_kprobe_clear_probe(system, kprobe, true);
+
+	ret = tracefs_kprobe_raw(system, kprobe, addr, format);
+	if (ret < 0) {
+		char *err;
+
+		perror("Failed creating kprobe");
+		errno = 0;
+		err = tracefs_error_last(NULL);
+		if (err)
+			fprintf(stderr, "%s\n", err);
+		else if (errno)
+			perror("Failed reading error log");
+		free(err);
+	}
+
+	exit(ret);
+}
+--
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
2.31.1

