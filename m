Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCB1C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE048610D1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhDHVmT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:42:19 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:11124 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232563AbhDHVmS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:42:18 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:42:03 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id AC12C212E7;
        Thu,  8 Apr 2021 14:42:06 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 5/5] libtraceevent: Add the API tep_parse_printk_formats()
Date:   Thu, 8 Apr 2021 17:42:00 -0400
Message-ID: <20210408214200.2063946-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408214200.2063946-1-rostedt@goodmis.org>
References: <20210408214200.2063946-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently, trace-cmd has a tracecmd_parse_ftrace_printk() function that
reads a string that holds the content of printk_formats from the tracefs
file system, and then passes the address of the printk strings mappings
to the tep handler.

There's no reason for this to be specific to trace-cmd as other
applications can easily read the printk_formats with the tracefs API and
then pass it to the tep handler.

Add the same functionality to libtraceevent as tep_parse_printk_formats().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-parse-files.txt | 30 +++++++++++-
 src/event-parse.c                           | 51 +++++++++++++++++++++
 src/event-parse.h                           |  1 +
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
index 594cef2..211f4f4 100644
--- a/Documentation/libtraceevent-parse-files.txt
+++ b/Documentation/libtraceevent-parse-files.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_parse_saved_cmdlines, tep_parse_kallsyms
+tep_parse_saved_cmdlines, tep_parse_printk_formats, tep_parse_kallsyms
 - Parsing functions to load mappings
 
 SYNOPSIS
@@ -13,6 +13,7 @@ SYNOPSIS
 *#include <event-parse.h>*
 
 int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
 --
 
@@ -25,6 +26,14 @@ _tep_ handler. The events store the pid and this is used to be able to show the
 process names associated to those process ids. It parses the string _buf_ that
 holds the content of saved_cmdlines and ends with a nul character ('\0').
 
+*tep_parse_printk_formats* is a helper function to parse content in the tracefs
+file system of the "printk_formats" file (stored in a string buffer passed in by _buf_)
+and loads the mapping of addresses of strings that may be referenced by events.
+Events only store the address of constant strings in the kernel, and the mapping
+of their address to the string is exported to user space in the printk_formats
+file. It parses the string _buf_ that holds the content of printk_formats and
+ends with a nul character ('\0').
+
 *tep_parse_kallsyms* is a helper function to parse the Linux kernel /proc/kallsyms format
 (stored in a string buffer passed in by _buf_) and load the functions into the
 _tep_ handler such that function IP addresses can be mapped to their name when
@@ -36,6 +45,9 @@ RETURN VALUE
 The *tep_parse_saved_cmdlines*() function returns 0 in case of success, or -1
 in case of an error.
 
+The *tep_parse_printk_formats*() function returns 0 in case of success, or -1
+in case of an error.
+
 The *tep_parse_kallsyms*() function returns 0 in case of success, or -1
 in case of an error.
 
@@ -61,6 +73,19 @@ int load_cmdlines(struct tep_handle *tep)
         return r;
 }
 
+int load_print_strings(struct tep_handle *tep)
+{
+        char *buf = NULL;
+        int r;
+
+        buf = tracefs_instance_file_read(NULL, "printk_formats", NULL);
+        if (!buf)
+                return -1;
+        r = tep_parse_printk_formats(tep, buf);
+        free(buf);
+        return r;
+}
+
 int load_kallsyms(struct tep_handle *tep)
 {
         char *line = NULL;
@@ -101,7 +126,8 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_comm(3)_, _tep_register_function(3)_
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_comm(3)_, _tep_register_function(3)_,
+_tep_register_print_string_(3)
 
 AUTHOR
 ------
diff --git a/src/event-parse.c b/src/event-parse.c
index 0d12ec4..cec4ad1 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -913,6 +913,57 @@ void tep_print_printk(struct tep_handle *tep)
 	}
 }
 
+/**
+ * tep_parse_printk_formats - Parse the address to strings
+ * @tep: a handle to the trace event parser
+ * @buf: A string buffer that holds the content of printk_formats and ends with '\0'
+ *
+ * This is a helper function to parse the address to printk formats in
+ * the kernel. Some events use %s to a kernel address that holds a constant
+ * string. The printk_formats file has a mapping of these addresses to the
+ * strings that are in the kernel. This parses the content of that file
+ * and registers those strings and their addresses so that the parsing of
+ * events can display the string as the event only has the address of the string.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int tep_parse_printk_formats(struct tep_handle *tep, const char *buf)
+{
+	unsigned long long addr;
+	char *copy;
+	char *printk;
+	char *line;
+	char *next = NULL;
+	char *addr_str;
+	char *fmt;
+	int ret = -1;
+
+	copy = strdup(buf);
+	if (!copy)
+		return -1;
+
+	line = strtok_r(copy, "\n", &next);
+	while (line) {
+		addr_str = strtok_r(line, ":", &fmt);
+		if (!addr_str) {
+			tep_warning("printk format with empty entry");
+			break;
+		}
+		addr = strtoull(addr_str, NULL, 16);
+		/* fmt still has a space, skip it */
+		printk = strdup(fmt+1);
+		if (!printk)
+			goto out;
+		line = strtok_r(NULL, "\n", &next);
+		tep_register_print_string(tep, printk, addr);
+		free(printk);
+	}
+	ret = 0;
+ out:
+	free(copy);
+	return ret;
+}
+
 static struct tep_event *alloc_event(void)
 {
 	return calloc(1, sizeof(struct tep_event));
diff --git a/src/event-parse.h b/src/event-parse.h
index 078b202..05b156b 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -443,6 +443,7 @@ int tep_parse_saved_cmdlines(struct tep_handle *tep, const char *buf);
 int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
+int tep_parse_printk_formats(struct tep_handle *tep, const char *buf);
 int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr);
 bool tep_is_pid_registered(struct tep_handle *tep, int pid);
-- 
2.29.2

