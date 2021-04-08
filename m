Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B84BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 19:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 074A461103
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 19:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhDHTNC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 15:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbhDHTNC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 15:13:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750E9610C7
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 19:12:50 +0000 (UTC)
Date:   Thu, 8 Apr 2021 15:12:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add the API tep_parse_saved_cmdlines()
Message-ID: <20210408151248.572b50e1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently, trace-cmd has a tracecmd_parse_cmdlines() function that
reads a string that holds the content of saved_cmdlines from the tracefs
file system, and then passes the pid to comm mapping to the tep handler.

There's no reason for this to be specific to trace-cmd as other
applications can easily read the saved_cmdlines with the tracefs API and
then pass it to the tep handler.

Add the same functionality to libtraceevent as tep_parse_saved_cmdlines().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-parse_saved_cmdlines.txt    | 86 +++++++++++++++++++
 src/event-parse.c                             | 42 +++++++++
 src/event-parse.h                             |  1 +
 3 files changed, 129 insertions(+)
 create mode 100644 Documentation/libtraceevent-parse_saved_cmdlines.txt

diff --git a/Documentation/libtraceevent-parse_saved_cmdlines.txt b/Documentation/libtraceevent-parse_saved_cmdlines.txt
new file mode 100644
index 0000000..6c8313a
--- /dev/null
+++ b/Documentation/libtraceevent-parse_saved_cmdlines.txt
@@ -0,0 +1,86 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_saved_cmdlines - Parses mappings of process IDs (pids) to the process names
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+--
+
+DESCRIPTION
+-----------
+*tep_parse_saved_cmdlines* is a helper function to parse content in the tracefs
+file system of the "saved_cmdlines" file (stored in a string buffer passed in by _buf_)
+and loads the mapping of the process IDs (pid) to the comm names in the
+_tep_ handler. The events store the pid and this is used to be able to show the
+process names associated to those process ids. It parses the string _buf_ that
+holds the content of saved_cmdlines and ends with a nul character ('\0').
+
+RETURN VALUE
+------------
+The *tep_parse_saved_cmdlines*() function returns 0 in case of success, or -1
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+...
+#include <event-parse.h>
+#include <tracefs.h>
+#include <stdlib.h>
+
+int load_cmdlines(struct tep_handle *tep)
+{
+        char *buf = NULL;
+        int r;
+
+        buf = tracefs_instance_file_read(NULL, "saved_cmdlines", NULL);
+        if (!buf)
+                return -1;
+        r = tep_parse_saved_cmdlines(tep, buf);
+        free(buf);
+        return r;
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_comm(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, coauthor of *libtraceevent*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/src/event-parse.c b/src/event-parse.c
index 6bf293d..0d12ec4 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -387,6 +387,48 @@ int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 	return _tep_register_comm(tep, comm, pid, true);
 }
 
+/**
+ * tep_parse_saved_cmdlines - parse the comms from the saved_cmdlines file
+ * @tep: a handle to the trace event parser
+ * @buf: A string buffer that holds the content of saved_cmdlines and ends with '\0'
+ *
+ * This is a helper function to parse the comms in the tracefs saved_cmdlines
+ * file (stored in a string buffer) and load the comms into the @tep handler
+ * such that comm name matches an process ID (pid). This is used to show
+ * the names of the processes as the events only hold the pid.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int tep_parse_saved_cmdlines(struct tep_handle *tep, const char *buf)
+{
+	char *copy;
+	char *comm;
+	char *line;
+	char *next = NULL;
+	int pid;
+	int ret = -1;
+	int n;
+
+	copy = strdup(buf);
+	if (!copy)
+		return -1;
+
+	line = strtok_r(copy, "\n", &next);
+	while (line) {
+		errno = 0;
+		n = sscanf(line, "%d %m[^\n]s", &pid, &comm);
+		if (errno || n != 2 || !comm)
+			goto out;
+		tep_register_comm(tep, comm, pid);
+		free(comm);
+		line = strtok_r(NULL, "\n", &next);
+	}
+	ret = 0;
+ out:
+	free(copy);
+	return ret;
+}
+
 struct func_map {
 	unsigned long long		addr;
 	char				*func;
diff --git a/src/event-parse.h b/src/event-parse.h
index 3fbd3c4..078b202 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -439,6 +439,7 @@ int tep_set_function_resolver(struct tep_handle *tep,
 void tep_reset_function_resolver(struct tep_handle *tep);
 int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_parse_saved_cmdlines(struct tep_handle *tep, const char *buf);
 int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
-- 
2.29.2

