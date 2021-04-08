Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7241BC43460
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 462B2611AD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhDHVZT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:25:19 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:40572 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232397AbhDHVZS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:25:18 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:25:03 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 49353212B1;
        Thu,  8 Apr 2021 14:25:06 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 4/5] libtraceevent: Add the API tep_parse_saved_cmdlines()
Date:   Thu, 8 Apr 2021 17:24:59 -0400
Message-ID: <20210408212500.2058159-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408212500.2058159-1-rostedt@goodmis.org>
References: <20210408212500.2058159-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
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
 Documentation/libtraceevent-parse-files.txt | 30 ++++++++++++++-
 src/event-parse.c                           | 42 +++++++++++++++++++++
 src/event-parse.h                           |  1 +
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
index 10144d1..594cef2 100644
--- a/Documentation/libtraceevent-parse-files.txt
+++ b/Documentation/libtraceevent-parse-files.txt
@@ -3,7 +3,8 @@ libtraceevent(3)
 
 NAME
 ----
-tep_parse_kallsyms - Parses mappings of address to function names from kallsyms format file
+tep_parse_saved_cmdlines, tep_parse_kallsyms
+- Parsing functions to load mappings
 
 SYNOPSIS
 --------
@@ -11,11 +12,19 @@ SYNOPSIS
 --
 *#include <event-parse.h>*
 
+int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 --
 
 DESCRIPTION
 -----------
+*tep_parse_saved_cmdlines* is a helper function to parse content in the tracefs
+file system of the "saved_cmdlines" file (stored in a string buffer passed in by _buf_)
+and loads the mapping of the process IDs (pid) to the comm names in the
+_tep_ handler. The events store the pid and this is used to be able to show the
+process names associated to those process ids. It parses the string _buf_ that
+holds the content of saved_cmdlines and ends with a nul character ('\0').
+
 *tep_parse_kallsyms* is a helper function to parse the Linux kernel /proc/kallsyms format
 (stored in a string buffer passed in by _buf_) and load the functions into the
 _tep_ handler such that function IP addresses can be mapped to their name when
@@ -24,6 +33,9 @@ holds the content of /proc/kallsyms and ends with a nul character ('\0').
 
 RETURN VALUE
 ------------
+The *tep_parse_saved_cmdlines*() function returns 0 in case of success, or -1
+in case of an error.
+
 The *tep_parse_kallsyms*() function returns 0 in case of success, or -1
 in case of an error.
 
@@ -33,8 +45,22 @@ EXAMPLE
 --
 ...
 #include <event-parse.h>
+#include <tracefs.h>
 #include <stdlib.h>
 
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
+
 int load_kallsyms(struct tep_handle *tep)
 {
         char *line = NULL;
@@ -75,7 +101,7 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_function(3)_
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_comm(3)_, _tep_register_function(3)_
 
 AUTHOR
 ------
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

