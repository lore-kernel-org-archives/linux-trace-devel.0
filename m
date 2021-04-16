Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75429C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 18:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527456023C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 18:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbhDPSRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236112AbhDPSRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 14:17:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C3EA611AB
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 18:17:22 +0000 (UTC)
Date:   Fri, 16 Apr 2021 14:17:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Add --full to show print fmt of an event
Message-ID: <20210416141720.57a7963d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's several times I want to see the print fmt from the event's format
file, and there's no way to do that with trace-cmd list -e. Add a --full
option to display the entire format file of an event, including the print
fmt, which can be useful as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-list.1.txt |  5 ++-
 tracecmd/trace-list.c                        | 39 ++++++++++++--------
 tracecmd/trace-usage.c                       |  1 +
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index 0ad62643..a5c6b16c 100644
--- a/Documentation/trace-cmd/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-list.1.txt
@@ -26,7 +26,10 @@ OPTIONS
     trace-cmd list -e '^sys.*'
 
 *-F*::
-    Used with *-e* 'regex' to show those events formats.
+    Used with *-e* 'regex' to show the fields of the event.
+
+*--full*::
+    Used with *-F* which will show the "print fmt" of the event along with the fields.
 
 *-l*::
     Used with *-e* 'regex' to show those events filters.
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 4615b322..e292664e 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -44,6 +44,7 @@ enum {
 	SHOW_EVENT_FORMAT		= 1 << 0,
 	SHOW_EVENT_FILTER		= 1 << 1,
 	SHOW_EVENT_TRIGGER		= 1 << 2,
+	SHOW_EVENT_FULL			= 1 << 3,
 };
 
 
@@ -56,10 +57,10 @@ void show_file(const char *name)
 	tracefs_put_tracing_file(path);
 }
 
-typedef int (*process_file_func)(char *buf, int len);
+typedef int (*process_file_func)(char *buf, int len, int flags);
 
 static void process_file_re(process_file_func func,
-			    const char *name, const char *re)
+			    const char *name, const char *re, int flags)
 {
 	regex_t reg;
 	char *path;
@@ -84,7 +85,7 @@ static void process_file_re(process_file_func func,
 		strcpy(&str[l-1], "\n*$");
 
 	if (regcomp(&reg, str, REG_ICASE|REG_NOSUB))
-		die("invalid function regex '%s'", re);
+		die("invalid function regex '%s'", re, flags);
 
 	free(str);
 
@@ -97,7 +98,7 @@ static void process_file_re(process_file_func func,
 	do {
 		n = getline(&buf, &l, fp);
 		if (n > 0 && regexec(&reg, buf, 0, NULL, 0) == 0)
-			func(buf, n);
+			func(buf, n, flags);
 	} while (n > 0);
 	free(buf);
 	fclose(fp);
@@ -105,14 +106,14 @@ static void process_file_re(process_file_func func,
 	regfree(&reg);
 }
 
-static int show_file_write(char *buf, int len)
+static int show_file_write(char *buf, int len, int flags)
 {
 	return fwrite(buf, 1, len, stdout);
 }
 
 static void show_file_re(const char *name, const char *re)
 {
-	process_file_re(show_file_write, name, re);
+	process_file_re(show_file_write, name, re, 0);
 }
 
 static char *get_event_file(const char *type, char *buf, int len)
@@ -144,7 +145,7 @@ static char *get_event_file(const char *type, char *buf, int len)
 	return file;
 }
 
-static int event_filter_write(char *buf, int len)
+static int event_filter_write(char *buf, int len, int flags)
 {
 	char *file;
 
@@ -161,7 +162,7 @@ static int event_filter_write(char *buf, int len)
 	return 0;
 }
 
-static int event_trigger_write(char *buf, int len)
+static int event_trigger_write(char *buf, int len, int flags)
 {
 	char *file;
 
@@ -178,14 +179,17 @@ static int event_trigger_write(char *buf, int len)
 	return 0;
 }
 
-static int event_format_write(char *fbuf, int len)
+static int event_format_write(char *fbuf, int len, int flags)
 {
 	char *file = get_event_file("format", fbuf, len);
 	char *buf = NULL;
 	size_t l;
 	FILE *fp;
+	bool full;
 	int n;
 
+	full = flags & SHOW_EVENT_FULL;
+
 	/* The get_event_file() crops system in fbuf */
 	printf("system: %s\n", fbuf);
 
@@ -198,7 +202,7 @@ static int event_format_write(char *fbuf, int len)
 	do {
 		n = getline(&buf, &l, fp);
 		if (n > 0) {
-			if (strncmp(buf, "print fmt", 9) == 0)
+			if (!full && strncmp(buf, "print fmt", 9) == 0)
 				break;
 			fwrite(buf, 1, n, stdout);
 		}
@@ -213,19 +217,19 @@ static int event_format_write(char *fbuf, int len)
 
 static void show_event_filter_re(const char *re)
 {
-	process_file_re(event_filter_write, "available_events", re);
+	process_file_re(event_filter_write, "available_events", re, 0);
 }
 
 
 static void show_event_trigger_re(const char *re)
 {
-	process_file_re(event_trigger_write, "available_events", re);
+	process_file_re(event_trigger_write, "available_events", re, 0);
 }
 
 
-static void show_event_format_re(const char *re)
+static void show_event_format_re(const char *re, int flags)
 {
-	process_file_re(event_format_write, "available_events", re);
+	process_file_re(event_format_write, "available_events", re, flags);
 }
 
 
@@ -236,7 +240,7 @@ static void show_events(const char *eventre, int flags)
 
 	if (eventre) {
 		if (flags & SHOW_EVENT_FORMAT)
-			show_event_format_re(eventre);
+			show_event_format_re(eventre, flags);
 
 		else if (flags & SHOW_EVENT_FILTER)
 			show_event_filter_re(eventre);
@@ -453,7 +457,6 @@ static void show_plugins(void)
 	tep_free(pevent);
 }
 
-
 void trace_list(int argc, char **argv)
 {
 	int events = 0;
@@ -536,6 +539,10 @@ void trace_list(int argc, char **argv)
 					tracecmd_set_debug(true);
 					break;
 				}
+				if (strcmp(argv[i], "--full") == 0) {
+					flags |= SHOW_EVENT_FULL;
+					break;
+				}
 				fprintf(stderr, "list: invalid option -- '%s'\n",
 					argv[i]);
 			default:
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3faa287b..567a91cb 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -322,6 +322,7 @@ static struct usage_help usage_help[] = {
 		" %s list [-e [regex]][-t][-o][-f [regex]]\n"
 		"          -e list available events\n"
 		"            -F show event format\n"
+		"            --full show the print fmt with -F\n"
 		"            -R show event triggers\n"
 		"            -l show event filters\n"
 		"          -t list available tracers\n"
-- 
2.29.2

