Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB884C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiKLAk5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiKLAk4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:40:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20176FBA
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A944062161
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Nov 2022 00:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABC7C433B5;
        Sat, 12 Nov 2022 00:40:53 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oteaS-009fnN-0J;
        Fri, 11 Nov 2022 19:41:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Add tracefs_event_is_enabled() API
Date:   Fri, 11 Nov 2022 19:41:28 -0500
Message-Id: <20221112004130.2305589-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221112004130.2305589-1-rostedt@goodmis.org>
References: <20221112004130.2305589-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a function that checks if an event (or events) are enabled or not.
Returns the enums:

  TRACEFS_ERROR		= -1
  TRACEFS_ALL_DISABLED	= 0
  TRACEFS_ALL_ENABLED	= 1
  TRACEFS_SOME_ENABLED	= 2

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-events.txt |  33 ++++++-
 Documentation/libtracefs.txt        |   2 +
 include/tracefs.h                   |   9 ++
 src/tracefs-events.c                | 128 ++++++++++++++++++++++++++--
 4 files changed, 162 insertions(+), 10 deletions(-)

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index f998c79b04ec..d5bd779273e2 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_event_systems, tracefs_system_events, tracefs_event_enable, tracefs_event_disable,
-tracefs_iterate_raw_events, tracefs_iterate_stop - Work with trace systems and events.
+tracefs_event_is_enabled, tracefs_iterate_raw_events, tracefs_iterate_stop - Work with trace systems and events.
 
 SYNOPSIS
 --------
@@ -12,12 +12,22 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
+enum tracefs_event_state {
+	TRACEFS_ERROR = -1,
+	TRACEFS_ALL_DISABLED = 0,
+	TRACEFS_ALL_ENABLED = 1,
+	TRACEFS_SOME_ENABLED = 2,
+};
+
 char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
 char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
 int *tracefs_event_enable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
 			   const char pass:[*]_event_);
 int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
 			    const char pass:[*]_event_);
+enum tracefs_enable_state *tracefs_event_is_enabled*(struct tracefs_instance pass:[*]_instance_,
+			 const char pass:[*]_system_, const char pass:[*]_event_);
+
 int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
 				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
 				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
@@ -61,6 +71,24 @@ events. That is, if _instance_ is NULL, then the top level tracing directory
 is used. If both _system_ and _event_ are NULL then all events are disabled
 for the given _instance_, and so on.
 
+The *tracefs_event_is_enabled()* returns if an event is enabled, a set of
+events are enabled, a system is enabled, or all events are enabled. If both
+_system_ and _event_ are NULL, then it returns the enable state of all events.
+If _system_ is not NULL and _event_ is NULL, then it will check if all the events
+in all the systems that _system_ and return the enable state of those events.
+If _system_ is NULL and _event_ is not NULL, then it will match all the events
+in all systems that match _event_ and return their enabled state. If both _system_
+and _event_ are not NULL, then it will return the enabled state of all matching
+events. The enabled state is defined as:
+
+*TRACEFS_ERROR* - An error occurred including no event were matched.
+
+*TRACEFS_ALL_DISABLED* - All matching events are disabled.
+
+*TRACEFS_ALL_ENABLED* - All matching events are enabled.
+
+*TRACEFS_SOME_ENABLED* - Some matching events were enabled while others were not.
+
 The *tracefs_iterate_raw_events()* function will read the tracefs raw
 data buffers and call the specified _callback_ function for every event it
 encounters. Events are iterated in sorted order: oldest first. An initialized
@@ -95,6 +123,9 @@ found, it will return -1 and errno will be set. If no errors occur, but no event
 are found that match the _system_ and _event_ parameters, then -1 is returned
 and errno is not set.
 
+The *tracefs_event_is_enabled()* returns the enabled status of the matching events
+or TRACEFS_ERROR on error.
+
 The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
 0 otherwise.
 
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 0081210f8951..e02974004ef8 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -53,6 +53,8 @@ Trace events:
                            const char pass:[*]_event_);
 	int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
                             const char pass:[*]_event_);
+	enum tracefs_enable_state *tracefs_event_is_enabled*(struct tracefs_instance pass:[*]_instance_,
+				 const char pass:[*]_system_, const char pass:[*]_event_);
 	int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
 	void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
 	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
diff --git a/include/tracefs.h b/include/tracefs.h
index 9f0bdc62836a..f2524b07501d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -67,8 +67,17 @@ int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
 
+enum tracefs_enable_state {
+	TRACEFS_ERROR		= -1,
+	TRACEFS_ALL_DISABLED	= 0,
+	TRACEFS_ALL_ENABLED	= 1,
+	TRACEFS_SOME_ENABLED	= 2,
+};
+
 int tracefs_event_enable(struct tracefs_instance *instance, const char *system, const char *event);
 int tracefs_event_disable(struct tracefs_instance *instance, const char *system, const char *event);
+enum tracefs_enable_state tracefs_event_is_enabled(struct tracefs_instance *instance,
+			 const char *system, const char *event);
 
 char *tracefs_error_last(struct tracefs_instance *instance);
 char *tracefs_error_all(struct tracefs_instance *instance);
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index d870241e127f..57b22964f893 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1044,9 +1044,68 @@ static bool match(const char *str, regex_t *re)
 	return regexec(re, str, 0, NULL, 0) == 0;
 }
 
+enum event_state {
+	STATE_INIT,
+	STATE_ENABLED,
+	STATE_DISABLED,
+	STATE_MIXED,
+	STATE_ERROR,
+};
+
+static int read_event_state(struct tracefs_instance *instance, const char *file,
+			    enum event_state *state)
+{
+	char *val;
+	int ret = 0;
+
+	if (*state == STATE_ERROR)
+		return -1;
+
+	val = tracefs_instance_file_read(instance, file, NULL);
+	if (!val)
+		return -1;
+
+	switch (val[0]) {
+	case '0':
+		switch (*state) {
+		case STATE_INIT:
+			*state = STATE_DISABLED;
+			break;
+		case STATE_ENABLED:
+			*state = STATE_MIXED;
+			break;
+		default:
+			break;
+		}
+		break;
+	case '1':
+		switch (*state) {
+		case STATE_INIT:
+			*state = STATE_ENABLED;
+			break;
+		case STATE_DISABLED:
+			*state = STATE_MIXED;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 'X':
+		*state = STATE_MIXED;
+		break;
+	default:
+		*state = TRACEFS_ERROR;
+		ret = -1;
+		break;
+	}
+	free(val);
+
+	return ret;
+}
+
 static int enable_disable_event(struct tracefs_instance *instance,
 				const char *system, const char *event,
-				bool enable)
+				bool enable, enum event_state *state)
 {
 	const char *str = enable ? "1" : "0";
 	char *system_event;
@@ -1056,14 +1115,18 @@ static int enable_disable_event(struct tracefs_instance *instance,
 	if (ret < 0)
 		return ret;
 
-	ret = tracefs_instance_file_write(instance, system_event, str);
+	if (state)
+		ret = read_event_state(instance, system_event, state);
+	else
+		ret = tracefs_instance_file_write(instance, system_event, str);
 	free(system_event);
 
 	return ret;
 }
 
 static int enable_disable_system(struct tracefs_instance *instance,
-				 const char *system, bool enable)
+				 const char *system, bool enable,
+				 enum event_state *state)
 {
 	const char *str = enable ? "1" : "0";
 	char *system_path;
@@ -1073,7 +1136,10 @@ static int enable_disable_system(struct tracefs_instance *instance,
 	if (ret < 0)
 		return ret;
 
-	ret = tracefs_instance_file_write(instance, system_path, str);
+	if (state)
+		ret = read_event_state(instance, system_path, state);
+	else
+		ret = tracefs_instance_file_write(instance, system_path, str);
 	free(system_path);
 
 	return ret;
@@ -1111,7 +1177,7 @@ static int make_regex(regex_t *re, const char *match)
 
 static int event_enable_disable(struct tracefs_instance *instance,
 				const char *system, const char *event,
-				bool enable)
+				bool enable, enum event_state *state)
 {
 	regex_t system_re, event_re;
 	char **systems;
@@ -1148,7 +1214,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 
 		/* Check for the short cut first */
 		if (!event) {
-			ret = enable_disable_system(instance, systems[s], enable);
+			ret = enable_disable_system(instance, systems[s], enable, state);
 			if (ret < 0)
 				break;
 			ret = 0;
@@ -1163,7 +1229,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 			if (!match(events[e], &event_re))
 				continue;
 			ret = enable_disable_event(instance, systems[s],
-						   events[e], enable);
+						   events[e], enable, state);
 			if (ret < 0)
 				break;
 			ret = 0;
@@ -1202,11 +1268,55 @@ static int event_enable_disable(struct tracefs_instance *instance,
 int tracefs_event_enable(struct tracefs_instance *instance,
 			 const char *system, const char *event)
 {
-	return event_enable_disable(instance, system, event, true);
+	return event_enable_disable(instance, system, event, true, NULL);
 }
 
 int tracefs_event_disable(struct tracefs_instance *instance,
 			  const char *system, const char *event)
 {
-	return event_enable_disable(instance, system, event, false);
+	return event_enable_disable(instance, system, event, false, NULL);
+}
+
+/**
+ * tracefs_event_is_enabled - return if the event is enabled or not
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @system: The name of the system to check
+ * @event: The name of the event to check
+ *
+ * Checks is an event or multiple events are enabled.
+ *
+ * If @system is NULL, then it will check all the systems where @event is
+ * a match.
+ *
+ * If @event is NULL, then it will check all events where @system is a match.
+ *
+ * If both @system and @event are NULL, then it will check all events
+ *
+ * Returns TRACEFS_ALL_ENABLED if all matching are enabled.
+ * Returns TRACEFS_SOME_ENABLED if some are enabled and some are not
+ * Returns TRACEFS_ALL_DISABLED if none of the events are enabled.
+ * Returns TRACEFS_ERROR if there is an error reading the events.
+ */
+enum tracefs_enable_state
+tracefs_event_is_enabled(struct tracefs_instance *instance,
+			 const char *system, const char *event)
+{
+	enum event_state state = STATE_INIT;
+	int ret;
+
+	ret = event_enable_disable(instance, system, event, false, &state);
+
+	if (ret < 0)
+		return TRACEFS_ERROR;
+
+	switch (state) {
+	case STATE_ENABLED:
+		return TRACEFS_ALL_ENABLED;
+	case STATE_DISABLED:
+		return TRACEFS_ALL_DISABLED;
+	case STATE_MIXED:
+		return TRACEFS_SOME_ENABLED;
+	default:
+		return TRACEFS_ERROR;
+	}
 }
-- 
2.35.1

