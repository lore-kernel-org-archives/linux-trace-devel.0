Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1704BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF273613D4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbhDPVau (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:30:50 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:2483 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245392AbhDPVar (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 17:30:47 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 14:30:17 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 50AD120885;
        Fri, 16 Apr 2021 14:30:21 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd list: Add ftrace events to listing of events
Date:   Fri, 16 Apr 2021 17:30:18 -0400
Message-ID: <20210416213018.3890036-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416213018.3890036-1-rostedt@goodmis.org>
References: <20210416213018.3890036-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a search of events is done with trace-cmd list -e, check if any matches
the ftrace events. This is useful to get the fields and print fmt of the
events under the ftrace system.

Note, just "trace-cmd list -e" will still not list ftrace events by
default.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 52 +++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 84ee573b..81f157ac 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -139,18 +139,34 @@ static void show_event_systems(process_file_func func, char **systems)
 }
 
 
+static void match_system_events(process_file_func func, const char *system,
+				regex_t *reg)
+{
+	char **events;
+	int e;
+
+	events = tracefs_system_events(NULL, system);
+	if (!events) /* die? */
+		return;
+	for (e = 0; events[e]; e++) {
+		if (regexec(reg, events[e], 0, NULL, 0) == 0)
+			show_event(func, system, events[e]);
+	}
+	tracefs_list_free(events);
+}
+
 static void process_events(process_file_func func, const char *re)
 {
 	regex_t system_reg;
 	regex_t event_reg;
+	const char *ftrace = "ftrace";
 	char *str;
 	size_t l = strlen(re);
 	bool just_systems = true;
 	char **systems;
-	char **events;
 	char *system;
 	char *event;
-	int s, e;
+	int s;
 
 	systems = tracefs_event_systems(NULL);
 	if (!systems)
@@ -184,6 +200,19 @@ static void process_events(process_file_func func, const char *re)
 	}
 	free(str);
 
+	/*
+	 * See if this matches the special ftrace system, as ftrace is not included
+	 * in the systems list, but can get events from tracefs_system_events().
+	 */
+	if (regexec(&system_reg, ftrace, 0, NULL, 0) == 0) {
+		if (!event)
+			show_system(func, ftrace);
+		else
+			match_system_events(func, ftrace, &event_reg);
+	} else if (!just_systems) {
+		match_system_events(func, ftrace, &system_reg);
+	}
+
 	for (s = 0; systems[s]; s++) {
 
 		if (regexec(&system_reg, systems[s], 0, NULL, 0) == 0) {
@@ -191,28 +220,13 @@ static void process_events(process_file_func func, const char *re)
 				show_system(func, systems[s]);
 				continue;
 			}
-			events = tracefs_system_events(NULL, systems[s]);
-			if (!events) /* die? */
-				continue;
-			for (e = 0; events[e]; e++) {
-				if (regexec(&event_reg, events[e], 0, NULL, 0) == 0)
-					show_event(func, systems[s], events[e]);
-			}
-			tracefs_list_free(events);
+			match_system_events(func, systems[s], &event_reg);
 			continue;
 		}
 		if (just_systems)
 			continue;
 
-		events = tracefs_system_events(NULL, systems[s]);
-		if (!events) /* die? */
-			continue;
-
-		for (e = 0; events[e]; e++) {
-			if (regexec(&system_reg, events[e], 0, NULL, 0) == 0)
-				show_event(func, systems[s], events[e]);
-		}
-		tracefs_list_free(events);
+		match_system_events(func, systems[s], &system_reg);
 	}
 	tracefs_list_free(systems);
 
-- 
2.29.2

