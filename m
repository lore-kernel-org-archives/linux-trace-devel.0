Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E7FC43460
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F48C6101C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhEENup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 09:50:45 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:3015 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232588AbhEENuo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 09:50:44 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 5 May 2021 06:49:43 -0700
Received: from vypre.com (unknown [10.21.244.11])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id B6C2920497;
        Wed,  5 May 2021 06:49:45 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/2] libtracefs: Add tracefs_event_enable/disable() API
Date:   Wed, 5 May 2021 09:49:41 -0400
Message-ID: <20210505134942.3583826-2-rostedt@goodmis.org>
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

Add the API of the following functions:

 tracefs_event_enable()
 tracefs_event_disable()

That takes a system string and an event string and enables the events that
match. Where a NULL system means (all systems) and a NULL event means all
events in the system.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:

  - free the regex of system and event if they are created.

 include/tracefs.h    |   3 +
 src/tracefs-events.c | 149 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 551c37c..73ee42b 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -55,6 +55,9 @@ int tracefs_trace_off(struct tracefs_instance *instance);
 int tracefs_trace_on_fd(int fd);
 int tracefs_trace_off_fd(int fd);
 
+int tracefs_event_enable(struct tracefs_instance *instance, const char *system, const char *event);
+int tracefs_event_disable(struct tracefs_instance *instance, const char *system, const char *event);
+
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
  * @instance: ftrace instance, can be NULL for the top instance
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 2343fc1..55316c6 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -777,3 +777,152 @@ int tracefs_fill_local_events(const char *tracing_dir,
 	return fill_local_events_system(tracing_dir, tep,
 					NULL, parsing_failures);
 }
+
+static bool match(const char *str, regex_t *re)
+{
+	return regexec(re, str, 0, NULL, 0) == 0;
+}
+
+static int enable_disable_event(struct tracefs_instance *instance,
+				const char *system, const char *event,
+				bool enable)
+{
+	const char *str = enable ? "1" : "0";
+	char *system_event;
+	int ret;
+
+	ret = asprintf(&system_event, "events/%s/%s/enable", system, event);
+	if (ret < 0)
+		return ret;
+
+	ret = tracefs_instance_file_write(instance, system_event, str);
+	free(system_event);
+
+	return ret;
+}
+
+static int enable_disable_system(struct tracefs_instance *instance,
+				 const char *system, bool enable)
+{
+	const char *str = enable ? "1" : "0";
+	char *system_path;
+	int ret;
+
+	ret = asprintf(&system_path, "events/%s/enable", system);
+	if (ret < 0)
+		return ret;
+
+	ret = tracefs_instance_file_write(instance, system_path, str);
+	free(system_path);
+
+	return ret;
+}
+
+static int enable_disable_all(struct tracefs_instance *instance,
+			      bool enable)
+{
+	const char *str = enable ? "1" : "0";
+
+	return tracefs_instance_file_write(instance, "events/enable", str);
+}
+
+static int event_enable_disable(struct tracefs_instance *instance,
+				const char *system, const char *event,
+				bool enable)
+{
+	regex_t system_re, event_re;
+	char **systems;
+	char **events = NULL;
+	int ret = -1;
+	int s, e;
+
+	/* Handle all events first */
+	if (!system && !event)
+		return enable_disable_all(instance, enable);
+
+	systems = tracefs_event_systems(NULL);
+	if (!systems)
+		goto out_free;
+
+	if (system) {
+		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);
+		if (ret < 0)
+			goto out_free;
+	}
+	if (event) {
+		ret = regcomp(&event_re, event, REG_ICASE|REG_NOSUB);
+		if (ret < 0) {
+			if (system)
+				regfree(&system_re);
+			goto out_free;
+		}
+	}
+
+	for (s = 0; systems[s]; s++) {
+		if (system && !match(systems[s], &system_re))
+			continue;
+
+		/* Check for the short cut first */
+		if (!event) {
+			ret = enable_disable_system(instance, systems[s], enable);
+			if (ret < 0)
+				break;
+			ret = 0;
+			continue;
+		}
+
+		events = tracefs_system_events(NULL, systems[s]);
+		if (!events)
+			continue; /* Error? */
+
+		for (e = 0; events[e]; e++) {
+			if (!match(events[e], &event_re))
+				continue;
+			ret = enable_disable_event(instance, systems[s],
+						   events[e], enable);
+			if (ret < 0)
+				break;
+			ret = 0;
+		}
+		tracefs_list_free(events);
+		events = NULL;
+	}
+	if (system)
+		regfree(&system_re);
+	if (event)
+		regfree(&event_re);
+
+ out_free:
+	tracefs_list_free(systems);
+	tracefs_list_free(events);
+	return ret;
+}
+
+/**
+ * tracefs_event_enable - enable specified events
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @system: A regex of a system (NULL to match all systems)
+ * @event: A regex of the event in the system (NULL to match all events)
+ *
+ * This will enable events that match the @system and @event.
+ * If both @system and @event are NULL, then it will enable all events.
+ * If @system is NULL, it will look at all systems for matching events
+ * to @event.
+ * If @event is NULL, then it will enable all events in the systems
+ * that match @system.
+ *
+ * Returns 0 on success, and -1 if it encountered an error,
+ * or if no events matched. If no events matched, then -1 is set
+ * but errno will not be.
+ */
+int tracefs_event_enable(struct tracefs_instance *instance,
+			 const char *system, const char *event)
+{
+	return event_enable_disable(instance, system, event, true);
+}
+
+int tracefs_event_disable(struct tracefs_instance *instance,
+			  const char *system, const char *event)
+{
+	return event_enable_disable(instance, system, event, false);
+}
-- 
2.29.2

