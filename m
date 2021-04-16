Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50316C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C9B613B0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhDPVaq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:30:46 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:57465 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245258AbhDPVaq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 17:30:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 14:30:16 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id A027F20887;
        Fri, 16 Apr 2021 14:30:20 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd list: Use tracefs to help find events for -e
Date:   Fri, 16 Apr 2021 17:30:17 -0400
Message-ID: <20210416213018.3890036-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416213018.3890036-1-rostedt@goodmis.org>
References: <20210416213018.3890036-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the user specifies -e and wants to search for events, use the tracefs
helper functions tracefs_event_systems() and tracefs_system_events() to
find the matching events.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c |   6 +-
 tracecmd/trace-list.c       | 136 ++++++++++++++++++++++++++++++++++--
 2 files changed, 135 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 991abd5f..a540ab24 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1234,9 +1234,11 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 			ts -= handle->tsc_calc.offset;
 			ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
 		} else {
-			tracecmd_warning("Timestamp $llu is before the initial offset %llu, set it to 0",
+			tracecmd_warning("Timestamp %llu is before the initial offset %llu\n"
+					 "\tSetting offset to 0",
 					 ts, handle->tsc_calc.offset);
-			ts = 0;
+			handle->tsc_calc.offset = 0;
+			ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
 		}
 	}
 
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 63216b43..84ee573b 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -105,6 +105,122 @@ static void process_file_re(process_file_func func,
 	regfree(&reg);
 }
 
+static void show_event(process_file_func func, const char *system, const char *event)
+{
+	char *buf;
+	int ret;
+
+	ret = asprintf(&buf, "%s:%s", system, event);
+	if (ret < 0)
+		die("Can not allocate event");
+	func(buf, strlen(buf));
+	free(buf);
+}
+
+static void show_system(process_file_func func, const char *system)
+{
+	char **events;
+	int e;
+
+	events = tracefs_system_events(NULL, system);
+	if (!events) /* die? */
+		return;
+
+	for (e = 0; events[e]; e++)
+		show_event(func, system, events[e]);
+}
+
+static void show_event_systems(process_file_func func, char **systems)
+{
+	int s;
+
+	for (s = 0; systems[s]; s++)
+		show_system(func, systems[s]);
+}
+
+
+static void process_events(process_file_func func, const char *re)
+{
+	regex_t system_reg;
+	regex_t event_reg;
+	char *str;
+	size_t l = strlen(re);
+	bool just_systems = true;
+	char **systems;
+	char **events;
+	char *system;
+	char *event;
+	int s, e;
+
+	systems = tracefs_event_systems(NULL);
+	if (!systems)
+		return process_file_re(func, "available_events", re);
+
+	if (!re || l == 0) {
+		show_event_systems(func, systems);
+		return;
+	}
+
+	str = strdup(re);
+	if (!str)
+		die("Can not allocate momory for regex");
+
+	system = strtok(str, ":");
+	event = strtok(NULL, "");
+
+	if (regcomp(&system_reg, system, REG_ICASE|REG_NOSUB))
+		die("invalid regex '%s'", system);
+
+	if (event) {
+		if (regcomp(&event_reg, event, REG_ICASE|REG_NOSUB))
+			die("invalid regex '%s'", event);
+	} else {
+		/*
+		 * If the regex ends with ":", then event would be null,
+		 * but we do not want to match events.
+		 */
+		if (re[l-1] != ':')
+			just_systems = false;
+	}
+	free(str);
+
+	for (s = 0; systems[s]; s++) {
+
+		if (regexec(&system_reg, systems[s], 0, NULL, 0) == 0) {
+			if (!event) {
+				show_system(func, systems[s]);
+				continue;
+			}
+			events = tracefs_system_events(NULL, systems[s]);
+			if (!events) /* die? */
+				continue;
+			for (e = 0; events[e]; e++) {
+				if (regexec(&event_reg, events[e], 0, NULL, 0) == 0)
+					show_event(func, systems[s], events[e]);
+			}
+			tracefs_list_free(events);
+			continue;
+		}
+		if (just_systems)
+			continue;
+
+		events = tracefs_system_events(NULL, systems[s]);
+		if (!events) /* die? */
+			continue;
+
+		for (e = 0; events[e]; e++) {
+			if (regexec(&system_reg, events[e], 0, NULL, 0) == 0)
+				show_event(func, systems[s], events[e]);
+		}
+		tracefs_list_free(events);
+	}
+	tracefs_list_free(systems);
+
+	regfree(&system_reg);
+	if (event)
+		regfree(&event_reg);
+}
+
 static int show_file_write(char *buf, int len)
 {
 	return fwrite(buf, 1, len, stdout);
@@ -210,24 +326,34 @@ static int event_format_write(char *fbuf, int len)
 	return 0;
 }
 
+static int event_name(char *buf, int len)
+{
+	printf("%s\n", buf);
+
+	return 0;
+}
+
 
 static void show_event_filter_re(const char *re)
 {
-	process_file_re(event_filter_write, "available_events", re);
+	process_events(event_filter_write, re);
 }
 
 
 static void show_event_trigger_re(const char *re)
 {
-	process_file_re(event_trigger_write, "available_events", re);
+	process_events(event_trigger_write, re);
 }
 
-
 static void show_event_format_re(const char *re)
 {
-	process_file_re(event_format_write, "available_events", re);
+	process_events(event_format_write, re);
 }
 
+static void show_event_names_re(const char *re)
+{
+	process_events(event_name, re);
+}
 
 static void show_events(const char *eventre, int flags)
 {
@@ -244,7 +370,7 @@ static void show_events(const char *eventre, int flags)
 		else if (flags & SHOW_EVENT_TRIGGER)
 			show_event_trigger_re(eventre);
 		else
-			show_file_re("available_events", eventre);
+			show_event_names_re(eventre);
 	} else
 		show_file("available_events");
 }
-- 
2.29.2

