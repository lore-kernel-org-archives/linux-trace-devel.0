Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD214C32771
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIVA2p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIVA2o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CFB9FA98
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19308CE1EF4
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD4C43470;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr5N-0P;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/5] libtracecmd: Add documentation on tracecmd_set/get_private()
Date:   Wed, 21 Sep 2022 20:29:40 -0400
Message-Id: <20220922002940.3302285-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002940.3302285-1-rostedt@goodmis.org>
References: <20220922002940.3302285-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracecmd_set_private() and tracecmd_get_private() functions were not
in the man pages. Add them, and also add a working example for the
tracecmd_open() (and other) function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-files.txt         | 72 ++++++++++++-------
 Documentation/libtracecmd/libtracecmd.txt     |  2 +
 2 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-files.txt b/Documentation/libtracecmd/libtracecmd-files.txt
index 382603efd50d..f8292cb4cbd5 100644
--- a/Documentation/libtracecmd/libtracecmd-files.txt
+++ b/Documentation/libtracecmd/libtracecmd-files.txt
@@ -4,7 +4,7 @@ libtracecmd(3)
 NAME
 ----
 tracecmd_open, tracecmd_open_fd, tracecmd_open_head, tracecmd_init_data,
-tracecmd_close - Open and close a trace file.
+tracecmd_close, tracecmd_set_private, tracecmd_get_private - Open and close a trace file.
 
 SYNOPSIS
 --------
@@ -17,6 +17,8 @@ struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_, int _flags_);
 struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_, int _flags_);
 int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
 void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
+void *tracecmd_set_private*(struct tracecmd_input pass:[*]_handle_, void pass:[*]_data_);
+void pass:[*]*tracecmd_get_private*(struct tracecmd_input pass:[*]_handle_);
 --
 
 DESCRIPTION
@@ -55,6 +57,12 @@ The *tracecmd_close()* function frees a _handle_, pointer to tracecmd_input
 structure, previously allocated with *tracecmd_open()*, *tracecmd_open_fd()*
 or *tracecmd_open_head()* APIs.
 
+The *tracecmd_set_private()* function allows to add specific _data_ to the
+_handle_ that can be retrieved later.
+
+The *tracecmd_get_private()* function will retrieve the _data_ set by
+*tracecmd_set_private()* for the given _handle_.
+
 RETURN VALUE
 ------------
 The *tracecmd_open()*, *tracecmd_open_fd()* and *tracecmd_open_head()*
@@ -66,6 +74,8 @@ when *tracecmd_close()* is called to close it, that fd will be closed also.
 The *tracecmd_init_data()* function returns -1 in case of an error or
 0 otherwise.
 
+The *tracecmd_get_private()* returns the _data_ set by *tracecmd_set_private()*.
+
 EXAMPLE
 -------
 [source,c]
@@ -75,32 +85,46 @@ a trace file, which can be used depending on the use case.
 
 1. Open and initialise the trace file in а single step:
 
+#include <stdlib.h>
 #include <trace-cmd.h>
-...
-struct tracecmd_input *handle = tracecmd_open("trace.dat");
-	if (!handle) {
-		/* Failed to open trace.dat file */
-	}
-...
-	/* Read tracing data from the file, using the handle */
-...
-	tracecmd_close(handle);
-...
-int fd;
-	fd = = open("trace.dat", O_RDONLY);
-	if (fd < 0) {
-		/* Failed to open trace file for reading */
-	}
-	handle = tracecmd_open_fd(fd);
-	if (!handle) {
-		close(fd);
-		/* Failed to initialise handler for reading the trace file */
+
+static int print_events(struct tracecmd_input *handle, struct tep_record *record, int cpu, void *data)
+{
+	static struct trace_seq seq;
+	struct tep_handle *tep = tracecmd_get_tep(handle);
+	const char *file = tracecmd_get_private(handle);
+
+	if (!seq.buffer)
+		trace_seq_init(&seq);
+
+	trace_seq_reset(&seq);
+	trace_seq_printf(&seq, "%s: ", file);
+	tep_print_event(tep, &seq, record, "%6.1000d [%03d] %s-%d %s: %s\n",
+			TEP_PRINT_TIME, TEP_PRINT_CPU, TEP_PRINT_COMM, TEP_PRINT_PID,
+			TEP_PRINT_NAME, TEP_PRINT_INFO);
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct tracecmd_input *handle;
+
+	if (argc < 2) {
+		printf("usage: %s trace.dat\n", argv[0]);
+		exit(-1);
 	}
-...
-	/* Read tracing data from the file, using the handle */
-...
+
+	handle = tracecmd_open(argv[i], 0);
+	if (!handle)
+		exit(-1);
+
+	tracecmd_set_private(handles[nr_handles], argv[i]);
+	tracecmd_iterate_events(handles, NULL, 0, print_events, NULL);
+
 	tracecmd_close(handle);
-...
+}
 
 2. Open and initialise the trace file in two steps. This allows to perform
 some processing based on metadata, read from the file, before initialising
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index 1939c209dc34..141fec5d379c 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -16,6 +16,8 @@ Open and close trace file:
 	struct tracecmd_input pass:[*]*tracecmd_open_fd*(int _fd_, int _flags_);
 	struct tracecmd_input pass:[*]*tracecmd_open_head*(const char pass:[*]_file_, int _flags_);
 	void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
+	void *tracecmd_set_private*(struct tracecmd_input pass:[*]_handle_, void pass:[*]_data_);
+	void pass:[*]*tracecmd_get_private*(struct tracecmd_input pass:[*]_handle_);
 
 Read tracing records from a trace file:
 	int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
-- 
2.35.1

