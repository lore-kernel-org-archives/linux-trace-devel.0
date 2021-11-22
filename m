Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24234C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhKVXxP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:15 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32629 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhKVXxP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:15 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:05 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 9357020348;
        Mon, 22 Nov 2021 15:50:07 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 06/11] libtracefs: Add new API tracefs_dynevent_get()
Date:   Mon, 22 Nov 2021 18:49:51 -0500
Message-ID: <20211122234956.788401-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add tracefs_dynevent_get() that allows the user to look for a single
event, and not have to get all events in the system.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-dynevents.txt | 10 ++++++
 include/tracefs.h                      |  2 ++
 src/tracefs-dynevents.c                | 45 ++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index 89b2e92..a374651 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -20,6 +20,7 @@ int *tracefs_dynevent_destroy*(struct tracefs_dynevent pass:[*]_devent_, bool _f
 int *tracefs_dynevent_destroy_all*(unsigned int _types_, bool _force_);
 void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
 void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+struct tracefs_dynevent pass:[*]*tracefs_dynevent_get*(enum tracefs_dynevent_type _type_, const char pass:[*]_system_, const char pass:[*]_event_);
 struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
 enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
 --
@@ -39,6 +40,12 @@ types *tracefs_dynevent_type*, that will be removed. If _types_ is 0, dynamic ev
 will be removed.  If _force_ is true, the function will attempt to disable all events in all trace
 instances, before removing the dynamic events.
 
+The *tracefs_dynevent_get*() function allocates and returns a single instance of a dynamic
+event that matches the given *type*, *system* and *event* that is passed to it. NULL is returned
+if there is no match. The returned event is what is found in the system, and must be freed
+with *tracefs_dynevent_free*(). If *system* is NULL, then the first *event* of any system
+of the given type that has the name of *event* will be returned.
+
 The *tracefs_dynevent_get_all*() function allocates and returns an array of pointers to dynamic
 events of given types that exist in the system. The last element of the array is a NULL pointer.
 The array must be freed with *tracefs_dynevent_list_free*(). If there are no events a NULL pointer is
@@ -70,6 +77,9 @@ RETURN VALUE
 *tracefs_dynevent_destroy*() and *tracefs_dynevent_destroy_all*() return 0 on success, or -1 on
 error. If _force_ is enabled, the functions may fail on disabling the events.
 
+*tracefs_dynevent_get*() function returns an allocated dynamic event from the system that matches
+the type, system and event given.
+
 *tracefs_dynevent_get_all*() function returns allocated array of pointers to dynamic events, or NULL
 in case of an error or in case there are no events in the system. That array must be freed by
 *tracefs_dynevent_list_free*().
diff --git a/include/tracefs.h b/include/tracefs.h
index 81efe87..2ced45c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -257,6 +257,8 @@ void tracefs_dynevent_free(struct tracefs_dynevent *devent);
 void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
 struct tracefs_dynevent **
 tracefs_dynevent_get_all(unsigned int types, const char *system);
+struct tracefs_dynevent *
+tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system, const char *event);
 enum tracefs_dynevent_type
 tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 		      char **event, char **prefix, char **addr, char **format);
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 0f7cccd..ea07d13 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -596,6 +596,51 @@ error:
 	return NULL;
 }
 
+/**
+ * tracefs_dynevent_get - return a single dynamic event if it exists
+ * @type; Dynamic event type
+ * @system: Get events from that system only. May be NULL.
+ * @event: Get event of the system type (may not be NULL)
+ *
+ * Returns the dynamic event of the given @type and @system for with the @event
+ * name. If @system is NULL, it will return the first dynamic event that it finds
+ * that matches the @event name.
+ *
+ * The returned event must be freed with tracefs_dynevent_free().
+ * NULL is returned if no event match is found, or other error.
+ */
+struct tracefs_dynevent *
+tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system,
+		     const char *event)
+{
+	struct tracefs_dynevent **events;
+	struct tracefs_dynevent *devent = NULL;
+	int count;
+	int i;
+
+	if (!event) {
+		errno = -EINVAL;
+		return NULL;
+	}
+
+	count = get_all_dynevents(type, system, &events);
+	if (count <= 0)
+		return NULL;
+
+	for (i = 0; i < count; i++) {
+		if (strcmp(events[i]->event, event) == 0)
+			break;
+	}
+	if (i < count) {
+		devent = events[i];
+		events[i] = NULL;
+	}
+
+	tracefs_dynevent_list_free(events);
+
+	return devent;
+}
+
 /**
  * tracefs_dynevent_destroy_all - removes all dynamic events of given types from the system
  * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
-- 
2.31.1

