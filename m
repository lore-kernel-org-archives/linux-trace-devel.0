Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD21C4167D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbiBWAaq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiBWAao (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA24855BE7
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E60FB81DA1
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA3C340F8;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGf-JV;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 09/11] libtracefs: Add man pages for tracefs_event_file_*() functions
Date:   Tue, 22 Feb 2022 19:30:10 -0500
Message-Id: <20220223003012.1334741-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the following functions to the man pages:
   tracefs_event_get_file()
   tracefs_event_file_read()
   tracefs_event_file_write()
   tracefs_event_file_append()
   tracefs_event_file_clear()
   tracefs_event_file_exists()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events-file.txt | 217 +++++++++++++++++++++++
 Documentation/libtracefs.txt             |  11 ++
 2 files changed, 228 insertions(+)
 create mode 100644 Documentation/libtracefs-events-file.txt

diff --git a/Documentation/libtracefs-events-file.txt b/Documentation/libtracefs-events-file.txt
new file mode 100644
index 000000000000..5102cc5e6859
--- /dev/null
+++ b/Documentation/libtracefs-events-file.txt
@@ -0,0 +1,217 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_event_get_file, tracefs_event_file_read, tracefs_event_file_write, tracefs_event_file_append,
+tracefs_event_file_clear, tracefs_event_file_exists - Work with trace event files.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]*tracefs_event_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_);
+char pass:[*]*tracefs_event_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			      const char pass:[*]_file_, int pass:[*]_psize_);
+int *tracefs_event_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_, const char pass:[*]_str_);
+int *tracefs_event_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			      const char pass:[*]_file_, const char pass:[*]_str_);
+int *tracefs_event_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_);
+bool *tracefs_event_file_exists*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			       const char pass:[*]_file_)
+
+--
+
+DESCRIPTION
+-----------
+These are functions for accessing tracefs event specific files.
+These functions act similar to the tracefs instance file functions
+but are easier to get to if the system and events are known before hand.
+
+The *tracefs_event_get_file()* returns the full path of the _file_ for
+the given _system_ and _event_ that is within the given _instance_.
+If _instance_ is NULL, then the file for the _event_ for the top level
+instance is returned. Note, there is no check to see if the file actually
+exists or even if the system and event exist. It only creates the path
+name for such an event if it did exist. This acts similar to the
+*tracefs_instance_get_file*(3), but is to be used to get to event files
+if the _system_ and _event_ are already known.
+
+The *tracefs_event_file_read()* reads the content for the _event_ _file_
+for the given _instance_ or the top level instance if _instance_ is
+NULL. The content of the file is returned and _psize_ is set to the amount
+of data that was read. The returned content must be freed with *free*(3).
+This acts similar to the *tracefs_instance_file_read*(3), but is
+to be used to read the event file if the _system_ and _event_ are already
+known.
+
+The *tracefs_event_file_write()* writes _str_ to the _event_ _file_.
+It will truncate anything that is already in that file. 
+This acts similar to the *tracefs_instance_file_write*(3), but is
+to be used to read the event file if the _system_ and _event_ are already
+known.
+
+The *tracefs_event_file_append()* appends _str_ to the _event_ _file_.
+It will not clear out the file as it writes _sting_.
+This acts similar to the *tracefs_instance_file_append*(3), but is
+to be used to read the event file if the _system_ and _event_ are already
+known.
+
+The *tracefs_event_file_clear()* clears the content of the _event_ _file_.
+This acts similar to the *tracefs_instance_file_clear*(3), but is
+to be used to read the event file if the _system_ and _event_ are already
+known.
+
+The *tracefs_event_file_exists()* returns true if the _event_ _file_
+exists, and false otherwise. This acts similar to the *tracefs_instance_file_exists*(3),
+but is to be used to read the event file if the _system_ and _event_ are already
+known.
+
+RETURN VALUE
+------------
+*tracefs_event_get_file()* returns the path of the given _system_/_event_ _file_ on
+success and NULL on error. The return value must be freed with *tracefs_put_tracing_file*(3).
+
+*tracefs_event_file_read()* reads the content of the _system_/_event_ _file_ or
+NULL on error. The return pointer must be freed with *free*(3).
+
+*tracefs_event_file_write()* and *tracefs_event_file_append()* returns the number of
+bytes written to the _system_/_event_ _file_ or negative on error.
+
+*tracefs_event_file_clear()* returns zero on success and -1 on error.
+
+*tracefs_event_file_exists()* returns true if the _system_/_event_ _file_ exists for
+the given _instance_ (or top level if _instance_ is NULL) or false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+int main(int argc, char **argv)
+{
+	char *system;
+	char *event;
+	char *file;
+	char *cmd = NULL;
+	char *buf;
+	char *str;
+	char ch = 'r';
+	int size;
+
+	if (argc < 4) {
+		printf("usage: %s sytem event file [(-a|-w) write | -c]\n"
+		       "   reads the system/event file or writes if [write is supplied]\n",
+		       argv[0]);
+		exit(0);
+	}
+
+	system = argv[1];
+	event = argv[2];
+	file = argv[3];
+	if (argc > 4)
+		cmd = argv[4];
+
+	if (!tracefs_event_file_exists(NULL, system, event, file)) {
+		fprintf(stderr, "File %s/%s/%s does not exist\n",
+				system, event, file);
+		exit(-1);
+	}
+
+	if (cmd) {
+		if (cmd[0] != '-')
+			ch = cmd[0];
+		else
+			ch = cmd[1];
+		if (!ch)
+			ch = 'c';
+	}
+
+	switch (ch) {
+	case 'r':
+		buf = tracefs_event_file_read(NULL, system, event, file, &size);
+		if (buf)
+			printf("%s", buf);
+		else
+			fprintf(stderr, "Failed to read %s/%s/%s\n",
+				system, event, file);
+		free(buf);
+		break;
+	case 'w':
+	case 'a':
+		if (argc < 6) {
+			fprintf(stderr, "%s command requires something to write\n",
+				ch == 'w' ? "write" : "append");
+			exit(-1);
+		}
+		if (ch == 'w')
+			size = tracefs_event_file_write(NULL, system, event, file, argv[5]);
+		else
+			size = tracefs_event_file_append(NULL, system, event, file, argv[5]);
+		if (size < 0) {
+			fprintf(stderr, "Failed to write '%s' to %s/%s/%s\n",
+					argv[5], system, event, file);
+			exit(-1);
+		}
+		break;
+	case 'c':
+		if (tracefs_event_file_clear(NULL, system, event, file) < 0) {
+			fprintf(stderr, "Failed to clear %s/%s/%s\n",
+				system, event, file);
+			exit(-1);
+		}
+		break;
+	default:
+		fprintf(stderr, "Unknown command '%c'\n", ch);
+		exit(-1);
+	}
+	exit(0);
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
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
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
+Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 44629e32d202..82cb5744b7b9 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -57,6 +57,17 @@ Trace events:
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
 	int *tracefs_load_cmdlines*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
+	char pass:[*]*tracefs_event_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_);
+	char pass:[*]*tracefs_event_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			      const char pass:[*]_file_, int pass:[*]_psize_);
+	int *tracefs_event_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_, const char pass:[*]_str_);
+	int *tracefs_event_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			      const char pass:[*]_file_, const char pass:[*]_str_);
+	int *tracefs_event_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
+			     const char pass:[*]_file_);
+	bool *tracefs_event_file_exists*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
 
 Event filters:
 	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
-- 
2.34.1

