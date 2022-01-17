Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC93C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 23:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiAQXWQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:22:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiAQXWQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 18:22:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4537B80EEF
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 23:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C89C36AEC;
        Mon, 17 Jan 2022 23:22:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9bKG-006fYx-A5;
        Mon, 17 Jan 2022 18:22:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Split up libtracefs-synth2.txt man page
Date:   Mon, 17 Jan 2022 18:22:09 -0500
Message-Id: <20220117232210.1589656-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117232210.1589656-1-rostedt@goodmis.org>
References: <20220117232210.1589656-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man page generation appears to not allow more than 9 functions to be
described before it starts spitting out errors. As libtracefs-synth2.txt
has 14 functions (and it did not even include tracefs_synth_save() to make
it 15), split out the functions:

  tracefs_synth_echo_cmd()
  tracefs_synth_get_start_hist()
  tracefs_synth_get_name()
  tracefs_synth_raw_fmt()
  tracefs_synth_show_event()
  tracefs_synth_show_start_hist()
  tracefs_synth_show_end_hist()
  tracefs_synth_get_event()

into their own man page: libtracefs-synth-info.txt

And this makes the errors for libtracefs-synth2.txt go away.

Also add some documentation about how tracefs_synth_create() needs
tracefs_synth_alloc() to create the synthetic event first.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth-info.txt | 298 ++++++++++++++++++++++++
 Documentation/libtracefs-synth.txt      |  14 ++
 Documentation/libtracefs-synth2.txt     |  82 ++-----
 3 files changed, 333 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/libtracefs-synth-info.txt

diff --git a/Documentation/libtracefs-synth-info.txt b/Documentation/libtracefs-synth-info.txt
new file mode 100644
index 000000000000..1bfee20608d3
--- /dev/null
+++ b/Documentation/libtracefs-synth-info.txt
@@ -0,0 +1,298 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_synth_echo_cmd, tracefs_synth_get_start_hist, tracefs_synth_get_name,
+tracefs_synth_raw_fmt, tracefs_synth_show_event, tracefs_synth_show_start_hist, tracefs_synth_show_end_hist,
+tracefs_synth_get_event - Retrieve data of synthetic events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_synth_echo_cmd*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+struct tracefs_hist pass:[*]*tracefs_synth_get_start_hist*(struct tracefs_synth pass:[*]_synth_);
+
+const char pass:[*]*tracefs_synth_get_name*(struct tracefs_synth pass:[*]_synth_);
+int *tracefs_synth_raw_fmt*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_event*(struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_start_hist*(struct tracefs_synth pass:[*]_synth_);
+const char pass:[*]*tracefs_synth_show_end_hist*(struct tracefs_synth pass:[*]_synth_);
+struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
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
+*TRACEFS_TIMESTAMP_USECS* as the compare fields for both events to calculate the
+delta in microseconds. This is used as the example below.
+
+See *tracefs_synth_alloc*(3) for allocation of synthetic events, and
+*tracefs_synth_create*() for creating the synthetic event on the system.
+
+*tracefs_synth_echo_cmd*() acts like *tracefs_synth_create*(), but instead of creating
+the synthetic event in the system, it will write the echo commands to manually create
+it in the _seq_ given.
+
+*tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
+the histogram used to create the synthetic event.
+
+[verse]
+--
+enum tracefs_synth_handler {
+	*TRACEFS_SYNTH_HANDLE_MATCH*,
+	*TRACEFS_SYNTH_HANDLE_MAX*,
+	*TRACEFS_SYNTH_HANDLE_CHANGE*,
+};
+--
+
+*tracefs_synth_get_name*() returns the name of the synthetic event or NULL on error.
+The returned string belongs to the synth event object and is freed with the event
+by *tracefs_synth_free*().
+
+*tracefs_synth_raw_fmt*() writes the raw format strings (dynamic event and histograms) of
+the synthetic event in the _seq_ given.
+
+*tracefs_synth_show_event*() returns the format of the dynamic event used by the synthetic
+event or NULL on error. The returned string belongs to the synth event object and is freed
+with the event by *tracefs_synth_free*().
+
+*tracefs_synth_show_start_hist*() returns the format of the start histogram used by the
+synthetic event or NULL on error. The returned string belongs to the synth event object
+and is freed with the event by *tracefs_synth_free*().
+
+*tracefs_synth_show_end_hist*() returns the format of the end histogram used by the
+synthetic event or NULL on error. The returned string belongs to the synth event object
+and is freed with the event by *tracefs_synth_free*().
+
+The *tracefs_synth_get_event*() function returns a tep event, describing the given synthetic
+event. The API detects any newly created or removed dynamic events. The returned pointer to
+tep event is controlled by @tep and must not be freed.
+
+RETURN VALUE
+------------
+*tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
+and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
+
+The *tracefs_synth_get_event*() function returns a pointer to a tep event or NULL in case of an
+error or if the requested synthetic event is missing. The returned pointer to tep event is
+controlled by @tep and must not be freed.
+
+All other functions return zero on success or -1 on error.
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
+See *tracefs_sql*(3) for a more indepth use of some of this code.
+
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
+	synth = tracefs_synth_alloc(tep, "wakeup_lat",
+				    NULL, start_event,
+				    NULL, end_event,
+				    start_field, end_field,
+				    match_name);
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
+	 * or tracefs_sync_echo_cmd() is run.
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
+	tracefs_synth_echo_cmd(&s, synth);
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
+			tracefs_synth_create(synth);
+		} else if (!strcmp(argv[1], "delete")) {
+			/* Delete the synthetic event */
+			tracefs_synth_destroy(synth);
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
+_tracefs_hist_alloc_2d(3)_,
+_tracefs_hist_alloc_nd(3)_,
+_tracefs_hist_free(3)_,
+_tracefs_hist_add_key(3)_,
+_tracefs_hist_add_value(3)_,
+_tracefs_hist_add_name(3)_,
+_tracefs_hist_start(3)_,
+_tracefs_hist_destory(3)_,
+_tracefs_hist_add_sort_key(3)_,
+_tracefs_hist_sort_key_direction(3)_
+_tracefs_synth_alloc(3)_
+_tracefs_synth_add_match_field(3)_
+_tracefs_synth_add_compare_field(3)_
+_tracefs_synth_add_start_field(3)_
+_tracefs_synth_add_end_field(3)_
+_tracefs_synth_append_start_filter(3)_
+_tracefs_synth_append_end_filter(3)_
+_tracefs_synth_free(3)_
+_tracefs_synth_create(3)_
+_tracefs_synth_destroy(3)_
+_tracefs_synth_complete(3)_
+_tracefs_synth_trace(3)_
+_tracefs_synth_snapshot(3)_
+_tracefs_synth_save(3)_
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
diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index fe28060a2fe5..e847d6d3e9d7 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -327,6 +327,20 @@ _tracefs_hist_start(3)_,
 _tracefs_hist_destory(3)_,
 _tracefs_hist_add_sort_key(3)_,
 _tracefs_hist_sort_key_direction(3)_
+_tracefs_synth_create(3)_
+_tracefs_synth_destroy(3)_
+_tracefs_synth_complete(3)_
+_tracefs_synth_trace(3)_
+_tracefs_synth_snapshot(3)_
+_tracefs_synth_save(3)_
+_tracefs_synth_echo_cmd(3)_
+_tracefs_synth_get_start_hist(3)_
+_tracefs_synth_get_name(3)_
+_tracefs_synth_raw_fmt(3)_
+_tracefs_synth_show_event(3)_
+_tracefs_synth_show_start_hist(3)_
+_tracefs_synth_show_end_hist(3)_
+_tracefs_synth_get_event(3)_
 
 AUTHOR
 ------
diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
index a6009bf02584..c7da04872668 100644
--- a/Documentation/libtracefs-synth2.txt
+++ b/Documentation/libtracefs-synth2.txt
@@ -3,10 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
-tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
-tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
-tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_synth_get_event
+tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_complete,
+tracefs_synth_trace, tracefs_synth_snapshot, tracefs_synth_save
 - Creation of synthetic events
 
 SYNOPSIS
@@ -17,9 +15,7 @@ SYNOPSIS
 
 int *tracefs_synth_create*(struct tracefs_synth pass:[*]_synth_);
 int *tracefs_synth_destroy*(struct tracefs_synth pass:[*]_synth_);
-int *tracefs_synth_echo_cmd*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
 bool *tracefs_synth_complete*(struct tracefs_synth pass:[*]_synth_);
-struct tracefs_hist pass:[*]*tracefs_synth_get_start_hist*(struct tracefs_synth pass:[*]_synth_);
 
 int *tracefs_synth_trace*(struct tracefs_synth pass:[*]_synth_,
 			enum tracefs_synth_handler _type_, const char pass:[*]_var_);
@@ -28,13 +24,6 @@ int *tracefs_synth_snapshot*(struct tracefs_synth pass:[*]_synth_,
 int *tracefs_synth_save*(struct tracefs_synth pass:[*]_synth_,
 		       enum tracefs_synth_handler _type_, const char pass:[*]_var_,
 		       char pass:[**]_save_fields_);
-const char pass:[*]*tracefs_synth_get_name*(struct tracefs_synth pass:[*]_synth_);
-int *tracefs_synth_raw_fmt*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
-const char pass:[*]*tracefs_synth_show_event*(struct tracefs_synth pass:[*]_synth_);
-const char pass:[*]*tracefs_synth_show_start_hist*(struct tracefs_synth pass:[*]_synth_);
-const char pass:[*]*tracefs_synth_show_end_hist*(struct tracefs_synth pass:[*]_synth_);
-struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
-
 --
 
 DESCRIPTION
@@ -57,30 +46,15 @@ as a field for both events to calculate the delta in nanoseconds, or use
 delta in microseconds. This is used as the example below.
 
 *tracefs_synth_create*() creates the synthetic event in the system. The synthetic events apply
-across all instances.
+across all instances. A synthetic event must be created with *tracefs_synth_alloc*(3) before
+it can be created.
 
 *tracefs_synth_destroy*() destroys the synthetic event. It will attempt to stop the running of it in
 its instance (top by default), but if its running in another instance this may fail as busy.
 
-*tracefs_synth_echo_cmd*() acts like *tracefs_synth_create*(), but instead of creating
-the synthetic event in the system, it will write the echo commands to manually create
-it in the _seq_ given.
-
 *tracefs_synth_complete*() returns true if the synthetic event _synth_ has both
 a starting and ending event.
 
-*tracefs_synth_get_start_hist*() returns a struct tracefs_hist descriptor describing
-the histogram used to create the synthetic event.
-
-[verse]
---
-enum tracefs_synth_handler {
-	*TRACEFS_SYNTH_HANDLE_MATCH*,
-	*TRACEFS_SYNTH_HANDLE_MAX*,
-	*TRACEFS_SYNTH_HANDLE_CHANGE*,
-};
---
-
 *tracefs_synth_trace*() Instead of doing just a trace on matching of the start and
 end events, do the _type_ handler where *TRACEFS_SYNTH_HANDLE_MAX* will do a trace
 when the given variable _var_ hits a new max for the matching keys. Or
@@ -100,39 +74,9 @@ then save the given _save_fields_ list. The fields will be stored in the histogr
 "hist" file of the event that can be retrieved with *tracefs_event_file_read*(3).
 _var_ must be one of the _name_ elements used in *tracefs_synth_add_end_field*(3).
 
-*tracefs_synth_get_name*() returns the name of the synthetic event or NULL on error.
-The returned string belongs to the synth event object and is freed with the event
-by *tracefs_synth_free*().
-
-*tracefs_synth_raw_fmt*() writes the raw format strings (dynamic event and histograms) of
-the synthetic event in the _seq_ given.
-
-*tracefs_synth_show_event*() returns the format of the dynamic event used by the synthetic
-event or NULL on error. The returned string belongs to the synth event object and is freed
-with the event by *tracefs_synth_free*().
-
-*tracefs_synth_show_start_hist*() returns the format of the start histogram used by the
-synthetic event or NULL on error. The returned string belongs to the synth event object
-and is freed with the event by *tracefs_synth_free*().
-
-*tracefs_synth_show_end_hist*() returns the format of the end histogram used by the
-synthetic event or NULL on error. The returned string belongs to the synth event object
-and is freed with the event by *tracefs_synth_free*().
-
-The *tracefs_synth_get_event*() function returns a tep event, describing the given synthetic
-event. The API detects any newly created or removed dynamic events. The returned pointer to
-tep event is controlled by @tep and must not be freed.
-
 RETURN VALUE
 ------------
-*tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
-and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
-
-The *tracefs_synth_get_event*() function returns a pointer to a tep event or NULL in case of an
-error or if the requested synthetic event is missing. The returned pointer to tep event is
-controlled by @tep and must not be freed.
-
-All other functions return zero on success or -1 on error.
+All functions return zero on success or -1 on error.
 
 ERRORS
 ------
@@ -294,6 +238,22 @@ _tracefs_hist_start(3)_,
 _tracefs_hist_destory(3)_,
 _tracefs_hist_add_sort_key(3)_,
 _tracefs_hist_sort_key_direction(3)_
+_tracefs_synth_alloc(3)_
+_tracefs_synth_add_match_field(3)_
+_tracefs_synth_add_compare_field(3)_
+_tracefs_synth_add_start_field(3)_
+_tracefs_synth_add_end_field(3)_
+_tracefs_synth_append_start_filter(3)_
+_tracefs_synth_append_end_filter(3)_
+_tracefs_synth_free(3)_
+_tracefs_synth_echo_cmd(3)_
+_tracefs_synth_get_start_hist(3)_
+_tracefs_synth_get_name(3)_
+_tracefs_synth_raw_fmt(3)_
+_tracefs_synth_show_event(3)_
+_tracefs_synth_show_start_hist(3)_
+_tracefs_synth_show_end_hist(3)_
+_tracefs_synth_get_event(3)_
 
 AUTHOR
 ------
-- 
2.33.0

