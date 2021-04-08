Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F44EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28BC761132
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhDHViL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhDHViK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:38:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785E861132
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 21:37:58 +0000 (UTC)
Date:   Thu, 8 Apr 2021 17:37:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Use libtraceevent for parsing tracefs files
Message-ID: <20210408173756.765be387@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that libtraceevent has the functionality to parse and load the
mappings of kallsyms, saved_cmdlines and printk_formats, use them instead
of having the functionality in libtracecmd.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  3 -
 lib/trace-cmd/trace-input.c                   |  6 +-
 lib/trace-cmd/trace-util.c                    | 91 -------------------
 tracecmd/trace-read.c                         |  5 +-
 4 files changed, 6 insertions(+), 99 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2673990a..42e739fa 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -27,9 +27,6 @@
 
 #define TSCNSEC_CLOCK	"tsc2nsec"
 
-void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
-void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
-void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
 struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7b25e92c..f36793e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -743,7 +743,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	}
 	buf[size] = 0;
 
-	tracecmd_parse_proc_kallsyms(pevent, buf, size);
+	tep_parse_kallsyms(pevent, buf);
 
 	free(buf);
 
@@ -775,7 +775,7 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 	buf[size] = 0;
 
-	tracecmd_parse_ftrace_printk(handle->pevent, buf, size);
+	tep_parse_printk_formats(handle->pevent, buf);
 
 	free(buf);
 
@@ -2970,7 +2970,7 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	if (read_data_and_size(handle, &cmdlines, &size) < 0)
 		return -1;
 	cmdlines[size] = 0;
-	tracecmd_parse_cmdlines(pevent, cmdlines, size);
+	tep_parse_saved_cmdlines(pevent, cmdlines);
 	free(cmdlines);
 
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index db7bead6..d7bfe2d6 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -103,97 +103,6 @@ bool tracecmd_get_debug(void)
 	return debug;
 }
 
-void tracecmd_parse_cmdlines(struct tep_handle *pevent,
-			     char *file, int size __maybe_unused)
-{
-	char *comm;
-	char *line;
-	char *next = NULL;
-	int pid;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		sscanf(line, "%d %m[^\n]s", &pid, &comm);
-		tep_register_comm(pevent, comm, pid);
-		free(comm);
-		line = strtok_r(NULL, "\n", &next);
-	}
-}
-
-void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
-			 char *file, unsigned int size __maybe_unused)
-{
-	unsigned long long addr;
-	char *func;
-	char *line;
-	char *next = NULL;
-	char *mod;
-	char ch;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		int func_start, func_end = 0;
-		int mod_start, mod_end = 0;
-		int n;
-
-		mod = NULL;
-		errno = 0;
-		n = sscanf(line, "%16llx %c %n%*s%n%*1[\t][%n%*s%n",
-			   &addr, &ch, &func_start, &func_end, &mod_start, &mod_end);
-		if (errno) {
-			perror("sscanf");
-			return;
-		}
-
-		if (n != 2 || !func_end)
-			return;
-
-		func = line + func_start;
-		/*
-		 * Hacks for
-		 *  - arm arch that adds a lot of bogus '$a' functions
-		 *  - x86-64 that reports per-cpu variable offsets as absolute
-		 */
-		if (func[0] != '$' && ch != 'A' && ch != 'a') {
-			line[func_end] = 0;
-			if (mod_end) {
-				mod = line + mod_start;
-				/* truncate the extra ']' */
-				line[mod_end - 1] = 0;
-			}
-			tep_register_function(pevent, func, addr, mod);
-		}
-
-		line = strtok_r(NULL, "\n", &next);
-	}
-}
-
-void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
-			 char *file, unsigned int size __maybe_unused)
-{
-	unsigned long long addr;
-	char *printk;
-	char *line;
-	char *next = NULL;
-	char *addr_str;
-	char *fmt;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		addr_str = strtok_r(line, ":", &fmt);
-		if (!addr_str) {
-			warning("printk format with empty entry");
-			break;
-		}
-		addr = strtoull(addr_str, NULL, 16);
-		/* fmt still has a space, skip it */
-		printk = strdup(fmt+1);
-		line = strtok_r(NULL, "\n", &next);
-		tep_register_print_string(pevent, printk, addr);
-		free(printk);
-	}
-}
-
 /**
  * tracecmd_add_id - add an int to the event id list
  * @list: list to add the id to
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 1b99db1d..d962b671 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1413,12 +1413,13 @@ static void add_functions(struct tep_handle *pevent, const char *file)
 	if (ret < 0)
 		die("Can't stat file %s", file);
 
-	buf = malloc(st.st_size);
+	buf = malloc(st.st_size + 1);
 	if (!buf)
 		die("Failed to allocate for function buffer");
 	read_file_fd(fd, buf, st.st_size);
+	buf[st.st_size] = '\0';
 	close(fd);
-	tracecmd_parse_proc_kallsyms(pevent, buf, st.st_size);
+	tep_parse_kallsyms(pevent, buf);
 	free(buf);
 }
 
-- 
2.29.2

