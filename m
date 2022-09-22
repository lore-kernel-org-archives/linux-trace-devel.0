Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB11C6FA91
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiIVA2p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiIVA2n (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F1A926E
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B90FB83344
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B55DC433D6;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr5K-0L;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/5] libtracecmd: Add a man pages for handling of time stamps
Date:   Wed, 21 Sep 2022 20:29:39 -0400
Message-Id: <20220922002940.3302285-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002940.3302285-1-rostedt@goodmis.org>
References: <20220922002940.3302285-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add to the man pages the function tracecmd_get_first_ts(), and
tracecmd_add_ts_offset().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-timestamp.txt     | 138 ++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |   4 +
 2 files changed, 142 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-timestamp.txt

diff --git a/Documentation/libtracecmd/libtracecmd-timestamp.txt b/Documentation/libtracecmd/libtracecmd-timestamp.txt
new file mode 100644
index 000000000000..8695d003965b
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-timestamp.txt
@@ -0,0 +1,138 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_get_first_ts, tracecmd_add_ts_offset - Handle time stamps from a trace file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+unsigned long long *tracecmd_get_first_ts*(struct tracecmd_input pass:[*]_handle_);
+void *tracecmd_add_ts_offset*(struct tracecmd_input pass:[*]_handle_, long long _offset_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to read tracing data from a trace file opened
+with _tracecmd_open()(3)_, _tracecmd_open_fd()(3)_ or _tracecmd_open_head()(3)_.
+
+The *tracecmd_get_first_ts()* function returns the time stamp of the first
+record in the _handle_.
+
+The *tracecmd_add_ts_offset()* function adds an offset to each of the records
+in the _handle_ that represents a trace file. This is useful for associating two
+different tracing files by their offset (for example a trace file from a host
+and a trace file from a guest that were not synchronized when created).
+
+RETURN VALUE
+------------
+The *tracecmd_get_first_ts()* function returns the timestamp of the first
+record in a trace file for the given _handle_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <trace-cmd.h>
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
+	struct tracecmd_input **handles = NULL;
+	unsigned long long ts, first_ts = 0;
+	int nr_handles = 0;
+	int i;
+
+	if (argc < 2) {
+		printf("usage: %s trace.dat [trace.dat ...]\n", argv[0]);
+		exit(-1);
+	}
+
+	for (i = 1; i < argc; i++) {
+		handles = realloc(handles, sizeof(*handles) * (nr_handles + 1));
+		if (!handles)
+			exit(-1);
+		handles[nr_handles] = tracecmd_open(argv[i], 0);
+		if (!handles[nr_handles])
+			exit(-1);
+		tracecmd_set_private(handles[nr_handles], argv[i]);
+		ts = tracecmd_get_first_ts(handles[nr_handles]);
+		if (!first_ts || ts < first_ts)
+			first_ts = ts;
+		nr_handles++;
+	}
+
+	/* Set the time stamp to start at the first record found */
+	for (i = 0; i < nr_handles; i++)
+		tracecmd_add_ts_offset(handles[i], -first_ts);
+
+	tracecmd_iterate_events_multi(handles, nr_handles, print_events, NULL);
+
+	for (i = 0; i < nr_handles; i++)
+		tracecmd_close(handles[i]);
+	free(handles);
+}
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
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
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index e9e11b32c8b6..1939c209dc34 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -30,6 +30,10 @@ Read tracing instances from a trace file:
 	const char pass:[*]*tracecmd_buffer_instance_name*(struct tracecmd_input pass:[*]_handle_, int _indx_);
 	struct tracecmd_input pass:[*]*tracecmd_buffer_instance_handle*(struct tracecmd_input pass:[*]_handle_, int _indx_);
 
+Handle time stamps from a trace file:
+	unsigned long long *tracecmd_get_first_ts*(struct tracecmd_input pass:[*]_handle_);
+	void *tracecmd_add_ts_offset*(struct tracecmd_input pass:[*]_handle_, long long _offset_);
+
 Get traceing peer information from a trace file:
 	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
 	int *tracecmd_get_guest_cpumap*(struct tracecmd_input pass:[*]_handle_, unsigned long long _trace_id_, const char pass:[*]pass:[*]_name_, int pass:[*]_vcpu_count_, const int pass:[*]pass:[*]_cpu_pid_);
-- 
2.35.1

