Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4462C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6533261417
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhDVVSp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:18:45 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:51684 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237048AbhDVVSp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:18:45 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 22 Apr 2021 14:18:05 -0700
Received: from vypre.com (unknown [10.21.244.251])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id F1BD9203F0;
        Thu, 22 Apr 2021 14:18:08 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Nicolas Sterchele <nicolas@sterchelen.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 3/3] trace-cmd list: Add ftrace events to listing of events
Date:   Thu, 22 Apr 2021 17:18:03 -0400
Message-ID: <20210422211803.862397-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210422211803.862397-1-rostedt@goodmis.org>
References: <20210422211803.862397-1-rostedt@goodmis.org>
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
 tracecmd/trace-list.c | 51 +++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 3e9e2713..048a7e5d 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -140,19 +140,34 @@ static void show_event_systems(process_file_func func, char **systems, int flags
 		show_system(func, systems[s], flags);
 }
 
+static void match_system_events(process_file_func func, const char *system,
+				regex_t *reg, int flags)
+{
+	char **events;
+	int e;
+
+	events = tracefs_system_events(NULL, system);
+	if (!events) /* die? */
+		return;
+	for (e = 0; events[e]; e++) {
+		if (regexec(reg, events[e], 0, NULL, 0) == 0)
+			show_event(func, system, events[e], flags);
+	}
+	tracefs_list_free(events);
+}
 
 static void process_events(process_file_func func, const char *re, int flags)
 {
+	const char *ftrace = "ftrace";
 	regex_t system_reg;
 	regex_t event_reg;
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
@@ -186,6 +201,19 @@ static void process_events(process_file_func func, const char *re, int flags)
 	}
 	free(str);
 
+	/*
+	 * See if this matches the special ftrace system, as ftrace is not included
+	 * in the systems list, but can get events from tracefs_system_events().
+	 */
+	if (regexec(&system_reg, ftrace, 0, NULL, 0) == 0) {
+		if (!event)
+			show_system(func, ftrace, flags);
+		else
+			match_system_events(func, ftrace, &event_reg, flags);
+	} else if (!just_systems) {
+		match_system_events(func, ftrace, &system_reg, flags);
+	}
+
 	for (s = 0; systems[s]; s++) {
 
 		if (regexec(&system_reg, systems[s], 0, NULL, 0) == 0) {
@@ -193,28 +221,13 @@ static void process_events(process_file_func func, const char *re, int flags)
 				show_system(func, systems[s], flags);
 				continue;
 			}
-			events = tracefs_system_events(NULL, systems[s]);
-			if (!events) /* die? */
-				continue;
-			for (e = 0; events[e]; e++) {
-				if (regexec(&event_reg, events[e], 0, NULL, 0) == 0)
-					show_event(func, systems[s], events[e], flags);
-			}
-			tracefs_list_free(events);
+			match_system_events(func, systems[s], &event_reg, flags);
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
-				show_event(func, systems[s], events[e], flags);
-		}
-		tracefs_list_free(events);
+		match_system_events(func, systems[s], &system_reg, flags);
 	}
 	tracefs_list_free(systems);
 
-- 
2.29.2

