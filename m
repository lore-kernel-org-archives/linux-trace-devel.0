Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A7AC4321E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKOEIH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiKOEIE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:08:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930C010B54
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35DB7B8167D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C117CC43470;
        Tue, 15 Nov 2022 04:07:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ounFX-00AJ6l-2Q;
        Mon, 14 Nov 2022 23:08:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/4] libtracefs: Split out iterator functions from man page
Date:   Mon, 14 Nov 2022 23:08:36 -0500
Message-Id: <20221115040838.2456632-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115040838.2456632-1-rostedt@goodmis.org>
References: <20221115040838.2456632-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

With preparation to add more APIs that deals with
tracefs_iterate_raw_events(), split it out of the generic event man pages
so that it can have its own set without going over the max of 9 APIs per
man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events.txt   |  32 +-----
 Documentation/libtracefs-iterator.txt | 144 ++++++++++++++++++++++++++
 2 files changed, 145 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/libtracefs-iterator.txt

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index d5bd779273e2..90c54b8c79da 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_event_systems, tracefs_system_events, tracefs_event_enable, tracefs_event_disable,
-tracefs_event_is_enabled, tracefs_iterate_raw_events, tracefs_iterate_stop - Work with trace systems and events.
+tracefs_event_is_enabled - Work with trace systems and events.
 
 SYNOPSIS
 --------
@@ -27,13 +27,6 @@ int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const ch
 			    const char pass:[*]_event_);
 enum tracefs_enable_state *tracefs_event_is_enabled*(struct tracefs_instance pass:[*]_instance_,
 			 const char pass:[*]_system_, const char pass:[*]_event_);
-
-int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
-				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
-				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
-				 void pass:[*]_callback_context_);
-void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
-
 --
 
 DESCRIPTION
@@ -89,26 +82,6 @@ events. The enabled state is defined as:
 
 *TRACEFS_SOME_ENABLED* - Some matching events were enabled while others were not.
 
-The *tracefs_iterate_raw_events()* function will read the tracefs raw
-data buffers and call the specified _callback_ function for every event it
-encounters. Events are iterated in sorted order: oldest first. An initialized
-_tep_ handler is required (See *tracefs_local_events*(3)). If _instance_ is
-NULL, then the toplevel tracefs buffer is used, otherwise the buffer for
-the corresponding _instance_ is read. To filter only on a subset of CPUs,
-_cpus_ and _cpu_size_ may be set to only call _callback_ with events that
-occurred on the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
-function will be called for all events, and _cpu_size_ is ignored. The
-_callback_ function will be called with the following parameters: A
-pointer to a struct tep_event that corresponds to the type of event the
-record is; The record representing the event; The CPU that the event
-occurred on; and a pointer to user specified _callback_context_. If the _callback_
-returns non-zero, the iteration stops.
-
-Use *tracefs_iterate_stop()* to force a executing *tracefs_iterate_raw_events()*
-to halt. This can be called from either a callback that is called by
-the iterator (even though a return of non-zero will stop it), or from another
-thread.
-
 RETURN VALUE
 ------------
 The *tracefs_event_systems()* and *tracefs_system_events()* functions return
@@ -126,9 +99,6 @@ and errno is not set.
 The *tracefs_event_is_enabled()* returns the enabled status of the matching events
 or TRACEFS_ERROR on error.
 
-The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
-0 otherwise.
-
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
new file mode 100644
index 000000000000..a291f8f169ba
--- /dev/null
+++ b/Documentation/libtracefs-iterator.txt
@@ -0,0 +1,144 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_iterate_raw_events, tracefs_iterate_stop - Iterate over events in the ring buffer
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
+				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
+				 void pass:[*]_callback_context_);
+void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
+
+--
+
+DESCRIPTION
+-----------
+Trace iterator over raw events.
+
+The *tracefs_iterate_raw_events()* function will read the tracefs raw
+data buffers and call the specified _callback_ function for every event it
+encounters. Events are iterated in sorted order: oldest first. An initialized
+_tep_ handler is required (See *tracefs_local_events*(3)). If _instance_ is
+NULL, then the toplevel tracefs buffer is used, otherwise the buffer for
+the corresponding _instance_ is read. To filter only on a subset of CPUs,
+_cpus_ and _cpu_size_ may be set to only call _callback_ with events that
+occurred on the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
+function will be called for all events, and _cpu_size_ is ignored. The
+_callback_ function will be called with the following parameters: A
+pointer to a struct tep_event that corresponds to the type of event the
+record is; The record representing the event; The CPU that the event
+occurred on; and a pointer to user specified _callback_context_. If the _callback_
+returns non-zero, the iteration stops.
+
+Use *tracefs_iterate_stop()* to force a executing *tracefs_iterate_raw_events()*
+to halt. This can be called from either a callback that is called by
+the iterator (even though a return of non-zero will stop it), or from another
+thread.
+
+RETURN VALUE
+------------
+The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+char **systems = tracefs_event_systems(NULL);
+
+	if (systems) {
+		int i = 0;
+		/* Got registered trace systems from the top trace instance */
+		while (systems[i]) {
+			char **events = tracefs_system_events(NULL, systems[i]);
+			if (events) {
+				/* Got registered events in system[i] from the top trace instance */
+				int j = 0;
+
+				while (events[j]) {
+					/* Got event[j] in system[i] from the top trace instance */
+					j++;
+				}
+				tracefs_list_free(events);
+			}
+			i++;
+		}
+		tracefs_list_free(systems);
+	}
+....
+static int records_walk(struct tep_event *tep, struct tep_record *record, int cpu, void *context)
+{
+	/* Got recorded event on cpu */
+	return 0;
+}
+...
+struct tep_handle *tep = tracefs_local_events(NULL);
+
+	if (!tep) {
+		/* Failed to initialise tep handler with local events */
+		...
+	}
+
+	errno = 0;
+	ret = tracefs_event_enable(NULL, "sched", NULL);
+	if (ret < 0 && !errno)
+		printf("Could not find 'sched' events\n");
+	tracefs_event_enable(NULL, "irq", "irq_handler_\(enter\|exit\)");
+
+	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
+		/* Error walking through the recorded raw events */
+	}
+
+	/* Disable all events */
+	tracefs_event_disable(NULL, NULL, NULL);
+	tep_free(tep);
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
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
2.35.1

