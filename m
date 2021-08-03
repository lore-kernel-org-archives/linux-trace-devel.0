Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8873FC43216
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A8B6105A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 16:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbhHCQs1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbhHCQsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 12:48:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 234DE60EC0;
        Tue,  3 Aug 2021 16:48:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxaP-002uUm-2S; Tue, 03 Aug 2021 12:48:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 5/7] libtracefs: Split up libtracefs-synth man page
Date:   Tue,  3 Aug 2021 12:48:09 -0400
Message-Id: <20210803164811.693731-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803164811.693731-1-rostedt@goodmis.org>
References: <20210803164811.693731-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The man page for the synthetic event functions has more than 9, which
causes errors when creating them. Create a libtracefs-synth2.txt file and
move the descriptions of tracefs_synth_create(), tracefs_synth_destroy()
and tracefs_synth_show() to it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth.txt  |  31 +---
 Documentation/libtracefs-synth2.txt | 239 ++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/libtracefs-synth2.txt

diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 47e93bd42674..77076e1aa5e2 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -4,8 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_synth_init, tracefs_synth_add_match_field, tracefs_synth_add_compare_field, tracefs_synth_add_start_field,
-tracefs_synth_add_end_field, tracefs_synth_append_start_filter, tracefs_synth_append_end_filter, tracefs_synth_create,
-tracefs_synth_destroy, tracefs_synth_free, tracefs_synth_show - Creation of synthetic events
+tracefs_synth_add_end_field, tracefs_synth_append_start_filter, tracefs_synth_append_end_filter, tracefs_synth_free,
+- Creation of a synthetic event descriptor
 
 SYNOPSIS
 --------
@@ -47,14 +47,7 @@ int tracefs_synth_append_end_filter(struct tracefs_synth pass:[*]synth,
 				    const char pass:[*]field,
 				    enum tracefs_synth_compare compare,
 				    const char pass:[*]val);
-int tracefs_synth_create(struct tracefs_instance pass:[*]instance,
-			 struct tracefs_synth pass:[*]synth);
-int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
-			  struct tracefs_synth pass:[*]synth);
-void tracefs_synth_free(struct tracefs_synth pass:[*]synth);
-int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pass:[*]instance,
-		       struct tracefs_synth pass:[*]synth);
-
+-void tracefs_synth_free(struct tracefs_synth pass:[*]synth);
 --
 
 DESCRIPTION
@@ -78,7 +71,7 @@ delta in microseconds. This is used as the example below.
 
 *tracefs_synth_init*() allocates and initializes a synthetic event.
 It does not create the synthetic event, but supplies the minimal information
-to do so. See *tracefs_synth_create*() below for how to create the synthetic
+to do so. See *tracefs_synth_create*(3) for how to create the synthetic
 event in the system. It requires a _tep_ handler that can be created by
 *tracefs_local_events*(3) for more information. The _name_ holds the name
 of the synthetic event that will be created. The _start_system is the name
@@ -162,22 +155,9 @@ _field_, _compare_, and _val_ are ignored unless _type_ is equal to
 *tracefs_synth_append_end_filter*() is the same as *tracefs_synth_append_start_filter* but
 filters on the ending event.
 
-*tracefs_synth_create*() creates the synthetic event in the system in the system
-in the _instance_ provided. Note, synthetic events apply across all instances,
-but some creation requires histograms to be established, which are local to
-instances.
-
-*tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop
-the running of it in the given _instance_, but if its running in another instance
-this may fail as busy.
-
 *tracefs_synth_free*() frees the allocated descriptor returned by
 *tracefs_synth_init*().
 
-*tracefs_synth_show*() acts like *tracefs_synth_create*(), but instead of creating
-the synthetic event in the given _instance_, it will write the echo commands to
-manually create it in the _seq_ given.
-
 RETURN VALUE
 ------------
 *tracefs_synth_init*() returns an allocated struct tracefs_synth descriptor
@@ -330,6 +310,9 @@ FILES
 
 SEE ALSO
 --------
+_tracefs_synth_create_(3),
+_tracefs_synth_destroy_(3),
+_tracfes_synth_show_(3),
 _libtracefs(3)_,
 _libtraceevent(3)_,
 _trace-cmd(1)_,
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
new file mode 100644
index 000000000000..41680d5b9cba
--- /dev/null
+++ b/Documentation/libtracefs-synth2.txt
@@ -0,0 +1,239 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_show - Creation of synthetic events
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_synth_create(struct tracefs_instance pass:[*]instance,
+			 struct tracefs_synth pass:[*]synth);
+int tracefs_synth_destroy(struct tracefs_instance pass:[*]instance,
+			  struct tracefs_synth pass:[*]synth);
+int tracefs_synth_show(struct trace_seq pass:[*]seq, struct tracefs_instance pass:[*]instance,
+		       struct tracefs_synth pass:[*]synth);
+
+--
+
+DESCRIPTION
+-----------
+Synthetic events are dynamic events that are created by matching
+two other events which triggers a synthetic event. One event is the starting
+event which some field is recorded, and when the second event is executed,
+if it has a field (or fields) that matches the starting event's field (or fields)
+then it will trigger the synthetic event. The field values other than the matching
+fields may be passed from the starting event to the end event to perform calculations
+on, or to simply pass as a parameter to the synthetic event.
+
+One common use case is to set "sched_waking" as the starting event. This event is
+triggered when a process is awoken. Then set "sched_switch" as the ending event.
+This event is triggered when a new task is scheduled on the CPU. By setting
+the "common_pid" of both events as the matching fields, the time between the
+two events is considered the wake up latency of that process. Use *TRACEFS_TIMESTAMP*
+as a field for both events to calculate the delta in nanoseconds, or use
+*TRACEFS_TIMESTAMP_USECS" as the compare fields for both events to calculate the
+delta in microseconds. This is used as the example below.
+
+*tracefs_synth_create*() creates the synthetic event in the system in the system
+in the _instance_ provided. Note, synthetic events apply across all instances,
+but some creation requires histograms to be established, which are local to
+instances.
+
+*tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop
+the running of it in the given _instance_, but if its running in another instance
+this may fail as busy.
+
+*tracefs_synth_show*() acts like *tracefs_synth_create*(), but instead of creating
+the synthetic event in the given _instance_, it will write the echo commands to
+manually create it in the _seq_ given.
+
+RETURN VALUE
+------------
+Returns zero on success or -1 on error.
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EPERM* Not run as root user when required.
+
+*EINVAL* Either a parameter is not valid (NULL when it should not be)
+  or a field that is not compatible for calculations.
+
+*ENODEV* An event or one of its fields is not found.
+
+*EBADE* The fields of the start and end events are not compatible for
+  either matching or comparing.
+
+*ENOMEM* not enough memory is available.
+
+And more errors may have happened from the system calls to the system.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <tracefs.h>
+
+#define start_event "sched_waking"
+#define start_field "pid"
+
+#define end_event "sched_switch"
+#define end_field "next_pid"
+
+#define match_name "pid"
+
+static struct tracefs_synth *synth;
+
+static void make_event(void)
+{
+	struct tep_handle *tep;
+
+	/* Load all events from the system */
+	tep = tracefs_local_events(NULL);
+
+	/* Initialize the synthetic event */
+	synth = tracefs_synth_init(tep, "wakeup_lat",
+				   NULL, start_event,
+				   NULL, end_event,
+				   start_field, end_field,
+				   match_name);
+
+	/* The tep is no longer needed */
+	tep_free(tep);
+
+
+	/* Save the "prio" field as "prio" from the start event */
+	tracefs_synth_add_start_field(synth, "prio", NULL);
+
+	/* Save the "next_comm" as "comm" from the end event */
+	tracefs_synth_add_end_field(synth, "next_comm", "comm");
+
+	/* Save the "prev_prio" as "prev_prio" from the end event */
+	tracefs_synth_add_end_field(synth, "prev_prio", NULL);
+
+	/*
+	 * Take a microsecond time difference between end and start
+	 * and record as "delta"
+	 */
+	tracefs_synth_add_compare_field(synth, TRACEFS_TIMESTAMP_USECS,
+					TRACEFS_TIMESTAMP_USECS,
+					TRACEFS_SYNTH_DELTA_END, "delta");
+
+	/* Only record if start event "prio" is less than 100 */
+	tracefs_synth_append_start_filter(synth, TRACEFS_FILTER_COMPARE,
+					  "prio", TRACEFS_COMPARE_LT, "100");
+
+	/*
+	 * Only record if end event "next_prio" is less than 50
+	 * or the previous task's prio was not greater than or equal to 100.
+	 *   next_prio < 50 || !(prev_prio >= 100)
+	 */
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_COMPARE,
+					"next_prio", TRACEFS_COMPARE_LT, "50");
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_OR, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_NOT, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_OPEN_PAREN, NULL, 0, NULL);
+	tracefs_synth_append_end_filter(synth, TRACEFS_FILTER_COMPARE,
+					"prev_prio", TRACEFS_COMPARE_GE, "100");
+	/*
+	 * Note, the above only added: "next_prio < 50 || !(prev_prio >= 100"
+	 * That's because, when the synth is executed, the remaining close parenthesis
+	 * will be added. That is, the string will end up being:
+	 * "next_prio < 50 || !(prev_prio >= 100)" when one of tracefs_sync_create()
+	 * or tracefs_sync_show() is run.
+	 */
+}
+
+/* Display how to create the synthetic event */
+static void show_event(void)
+{
+	struct trace_seq s;
+
+	trace_seq_init(&s);
+
+	tracefs_synth_show(&s, NULL, synth);
+	trace_seq_terminate(&s);
+	trace_seq_do_printf(&s);
+	trace_seq_destroy(&s);
+}
+
+int main (int argc, char **argv)
+{
+	make_event();
+
+	if (argc > 1) {
+		if (!strcmp(argv[1], "create")) {
+			/* Create the synthetic event */
+			tracefs_synth_create(NULL, synth);
+		} else if (!strcmp(argv[1], "delete")) {
+			/* Delete the synthetic event */
+			tracefs_synth_destroy(NULL, synth);
+		} else {
+			printf("usage: %s [create|delete]\n", argv[0]);
+			exit(-1);
+		}
+	} else
+		show_event();
+
+	tracefs_synth_free(synth);
+
+	return 0;
+}
+--
+
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_,
+_tracefs_hist_alloc(3)_,
+_tracefs_hist_free(3)_,
+_tracefs_hist_add_key(3)_,
+_tracefs_hist_add_value(3)_,
+_tracefs_hist_add_name(3)_,
+_tracefs_hist_start(3)_,
+_tracefs_hist_destory(3)_,
+_tracefs_hist_add_sort_key(3)_,
+_tracefs_hist_sort_key_direction(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.2

