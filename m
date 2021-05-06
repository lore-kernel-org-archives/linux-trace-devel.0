Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D394C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 16:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F7A6113D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 16:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhEFQxI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 12:53:08 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:5919 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236091AbhEFQxI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 12:53:08 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 6 May 2021 09:52:05 -0700
Received: from vypre.com (unknown [10.21.244.124])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 2F3692036B;
        Thu,  6 May 2021 09:52:08 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 3/4] trace-cmd list: Add match_system_events() helper function
Date:   Thu, 6 May 2021 12:52:02 -0400
Message-ID: <20210506165203.3889058-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210506165203.3889058-1-rostedt@goodmis.org>
References: <20210506165203.3889058-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Remove the duplicate code that matches all events for a given system and
replace it with a helper function called match_system_events().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index a0d743fb..1b32af17 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -140,6 +140,21 @@ static void show_event_systems(process_file_func func, char **systems, int flags
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
@@ -149,10 +164,9 @@ static void process_events(process_file_func func, const char *re, int flags)
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
@@ -193,28 +207,13 @@ static void process_events(process_file_func func, const char *re, int flags)
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

