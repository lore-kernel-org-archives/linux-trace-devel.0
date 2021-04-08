Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC2CC43461
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C25A610E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhDHVmR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:42:17 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:11123 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhDHVmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:42:17 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:42:01 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 4C31D212DB;
        Thu,  8 Apr 2021 14:42:05 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 3/5] libtraceevent: Add the API tep_parse_kallsyms()
Date:   Thu, 8 Apr 2021 17:41:58 -0400
Message-ID: <20210408214200.2063946-4-rostedt@goodmis.org>
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

Currently, trace-cmd has a tracecmd_parse_proc_kallsyms() function that
reads a string that holds the content of /proc/kallsyms and then passes
the function mapping it reads into the tep handler.

There's no reason for this to be specific to trace-cmd as other
applications can easily save /proc/kallsyms, or just read it directly and
then pass it to the tep handler.

Add the same functionality to libtraceevent as tep_parse_kallsyms().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-parse-files.txt | 97 +++++++++++++++++++++
 src/event-parse.c                           | 68 +++++++++++++++
 src/event-parse.h                           |  1 +
 3 files changed, 166 insertions(+)
 create mode 100644 Documentation/libtraceevent-parse-files.txt

diff --git a/Documentation/libtraceevent-parse-files.txt b/Documentation/libtraceevent-parse-files.txt
new file mode 100644
index 0000000..10144d1
--- /dev/null
+++ b/Documentation/libtraceevent-parse-files.txt
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
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_register_function(3)_
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

