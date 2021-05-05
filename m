Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1978C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8806101C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhEENur (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 09:50:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:3015 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231650AbhEENuq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 09:50:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 5 May 2021 06:49:44 -0700
Received: from vypre.com (unknown [10.21.244.11])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 71A8320451;
        Wed,  5 May 2021 06:49:46 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/2] libtracefs: Update the man page for tracefs_event_enable/disable() APIs
Date:   Wed, 5 May 2021 09:49:42 -0400
Message-ID: <20210505134942.3583826-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210505134942.3583826-1-rostedt@goodmis.org>
References: <20210505134942.3583826-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Include descriptions for

 tracefs_event_enable()
 tracefs_event_disable()

in the tracefs events man page.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events.txt | 36 +++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 78c9834..3fe9199 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -14,6 +14,8 @@ SYNOPSIS
 
 char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
 char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
+int *tracefs_event_enable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_);
+int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_);
 int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
 
 --
@@ -37,6 +39,22 @@ local machine, or it may be a path to a copy of the tracefs directory
 from another machine. The last entry in the array as a NULL pointer.
 The array must be freed with _tracefs_list_free()_ API.
 
+The _tracefs_event_enable()_ function enables a given event based on
+the _system_ and _event_ passed in for the given _instance_. If _instance_
+is NULL, then the top level tracing directory is used. If _system_
+and _event_ are both NULL, then all events are enabled for the  _instance_.
+If _event_ is NULL then all events within the _system_ are enabled.
+If _system_ is NULL, then all systems are searched and any event within
+a system that matches _event_ is enabled. Both _system_ and _event_ may
+be regular expressions as defined by *regex*(3).
+
+The _tracefs_event_disable()_ function disables the events that match
+the _system_ and _event_ parameters for the given _instance_. What events
+are disable follow the same rules as _tracefs_event_enable()_ for matching
+events. That is, if _instance_ is NULL, then the top level tracing directory
+is used. If both _system_ and _event_ are NULL then all events are disabled
+for the given _instance_, and so on.
+
 The _tracefs_iterate_raw_events()_ function will read the tracefs raw
 data buffers and call the specified _callback_ function for every event it
 encounters. Events are iterated in sorted order: oldest first. An initialized
@@ -59,6 +77,14 @@ The _tracefs_event_systems()_ and __tracefs_system_events()_ functions return
 an array of strings. The last element in that array is a NULL pointer. The array
 must be freed with _tracefs_list_free()_ API. In case of an error, NULL is returned.
 
+Both _tracefs_event_enable()_ and _tracefs_event_disable()_ return 0 if they found
+any matching events (Note it does not check the previous status of the event. If
+_tracefs_event_enable()_ finds an event that is already enabled, and there are no
+other errors, then it will return 0). If an error occurs, even if other events were
+found, it will return -1 and errno will be set. If no errors occur, but no events
+are found that match the _system_ and _event_ parameters, then -1 is returned
+and errno is not set.
+
 The _tracefs_iterate_raw_events()_ function returns -1 in case of an error or
 0 otherwise.
 
@@ -102,9 +128,19 @@ struct tep_event *tep = tracefs_local_events(NULL);
 		/* Failed to initialise tep handler with local events */
 		...
 	}
+
+	errno = 0;
+	ret = tracefs_event_enable(NULL, "sched", NULL);
+	if (ret < 0 && !errno)
+		printf("Could not find 'sched' events\n");
+	tracefs_event_enable(NULL, "irq", "irq_handler_\(enter\|exit\)");
+
 	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
 		/* Error walking through the recorded raw events */
 	}
+
+	/* Disable all events */
+	tracefs_event_disable(NULL, NULL, NULL);
 	tep_free(tep);
 --
 FILES
-- 
2.29.2

