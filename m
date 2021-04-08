Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A36C43600
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 18:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C3A60C3E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 18:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhDHSa4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 14:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhDHSaZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 14:30:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5281C61108
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 18:30:13 +0000 (UTC)
Date:   Thu, 8 Apr 2021 14:30:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add the API tep_parse_kallsyms()
Message-ID: <20210408143011.5bf80d65@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently, trace-cmd has a tracecmd_parse_proc_kallsyms() function that
reads a string that holds the content of /proc/kallsyms and then passes
the function mapping it reads into the tep handler.

There's no reason for this to be specific to trace-cmd as other
applications can easily save /proc/kallsyms, or just read it directly and
then pass it to the tep handler.

Add the same functionality to libtraceevent as tep_parse_kallsyms().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-parse_kallsyms.txt          | 97 +++++++++++++++++++
 src/event-parse.c                             | 68 +++++++++++++
 src/event-parse.h                             |  1 +
 3 files changed, 166 insertions(+)
 create mode 100644 Documentation/libtraceevent-parse_kallsyms.txt

diff --git a/Documentation/libtraceevent-parse_kallsyms.txt b/Documentation/libtraceevent-parse_kallsyms.txt
new file mode 100644
index 0000000..0d6f015
--- /dev/null
+++ b/Documentation/libtraceevent-parse_kallsyms.txt
@@ -0,0 +1,97 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_kallsyms - Parses mappings of address to function names from kallsyms format file
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+--
+
+DESCRIPTION
+-----------
+*tep_parse_kallsyms* is a helper function to parse the Linux kernel /proc/kallsyms format
+(stored in a string buffer passed in by _buf_) and load the functions into the
+_tep_ handler such that function IP addresses can be mapped to their name when
+parsing events with %pS in the print format field. It parses the string _buf_ that
+holds the content of /proc/kallsyms and ends with a nul character ('\0').
+
+RETURN VALUE
+------------
+The *tep_parse_kallsyms*() function returns 0 in case of success, or -1
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+...
+#include <event-parse.h>
+#include <stdlib.h>
+
+int load_kallsyms(struct tep_handle *tep)
+{
+        char *line = NULL;
+        char *buf = NULL;
+        size_t sz = 0;
+        FILE *fp;
+        int len = 0;
+        int r;
+
+        fp = fopen("/proc/kallsyms", "r");
+        while ((r = getline(&line, &sz, fp)) >= 0) {
+                buf = realloc(buf, len + r + 1);
+                memcpy(buf + len, line, r);
+                len += r;
+        }
+        free(line);
+        fclose(fp);
+        if (!buf)
+                return -1;
+        buf[len] = 0;
+
+        r = tep_parse_kallsyms(tep, buf);
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
+_libtraceevent(3)_, _trace-cmd(1)_
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
index 7c1f4cb..6bf293d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -640,6 +640,74 @@ out_free:
 	return -1;
 }
 
+/**
+ * tep_parse_kallsyms - load functions from a read of /proc/kallsyms
+ * @tep: a handle to the trace event parser
+ * @kallsyms: A string buffer that holds the content of /proc/kallsyms and ends with '\0'
+ *
+ * This is a helper function to parse the Linux kernel /proc/kallsyms
+ * format (stored in a string buffer) and load the functions into
+ * the @tep handler such that function IP addresses can be mapped to
+ * their name when parsing events with %pS in the print format field.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms)
+{
+	unsigned long long addr;
+	char *copy;
+	char *func;
+	char *line;
+	char *next = NULL;
+	char *mod;
+	char ch;
+	int ret = -1;
+
+	copy = strdup(kallsyms);
+	if (!copy)
+		return -1;
+
+	line = strtok_r(copy, "\n", &next);
+	while (line) {
+		int func_start, func_end = 0;
+		int mod_start, mod_end = 0;
+		int n;
+
+		mod = NULL;
+		errno = 0;
+		n = sscanf(line, "%16llx %c %n%*s%n%*1[\t][%n%*s%n",
+			   &addr, &ch, &func_start, &func_end, &mod_start, &mod_end);
+		if (errno)
+			goto out;
+
+		if (n != 2 || !func_end)
+			goto out;
+
+		func = line + func_start;
+		/*
+		 * Hacks for
+		 *  - arm arch that adds a lot of bogus '$a' functions
+		 *  - x86-64 that reports per-cpu variable offsets as absolute
+		 */
+		if (func[0] != '$' && ch != 'A' && ch != 'a') {
+			line[func_end] = 0;
+			if (mod_end) {
+				mod = line + mod_start;
+				/* truncate the extra ']' */
+				line[mod_end - 1] = 0;
+			}
+			tep_register_function(tep, func, addr, mod);
+		}
+
+		line = strtok_r(NULL, "\n", &next);
+	}
+	ret = 0;
+ out:
+	free(copy);
+
+	return ret;
+}
+
 /**
  * tep_print_funcs - print out the stored functions
  * @tep: a handle to the trace event parser context
diff --git a/src/event-parse.h b/src/event-parse.h
index a67ad9a..3fbd3c4 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -439,6 +439,7 @@ int tep_set_function_resolver(struct tep_handle *tep,
 void tep_reset_function_resolver(struct tep_handle *tep);
 int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_parse_kallsyms(struct tep_handle *tep, const char *kallsyms);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *tep, const char *fmt,
-- 
2.29.2

