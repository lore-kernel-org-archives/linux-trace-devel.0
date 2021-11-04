Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41689C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B14B61216
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhKDRHR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:07:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54228 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhKDRHQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:07:16 -0400
Received: from localhost.localdomain (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 26E4020B9D55;
        Thu,  4 Nov 2021 10:04:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 26E4020B9D55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045478;
        bh=u0Kk1SK7VFx8h82jgK7DUE3vAjNt9dA4ghfQF6nvzo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOV6e2c14hkCAOBPian+JWrOtcRebVjDSTjvBn/JrqVhjxSeK9ywpaSs7c0O1DJrI
         9VapVU6c/u/LSPhlDOyMJi3kwBCe9bFnvyc3Zb330Nk09u7B3qbdFCWM56lfPuDMVt
         sTmZBTdJH3zADnjWhw6MRbJyBXDsDRXCVBY+kLmA=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v4 04/10] user_events: Handle matching arguments from dyn_events
Date:   Thu,  4 Nov 2021 10:04:27 -0700
Message-Id: <20211104170433.2206-5-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211104170433.2206-1-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ensures that when dynamic events requests a match with arguments that
they match what is in the user_event.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 67 +++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 479a9ced3281..cd78cc481557 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -662,13 +662,78 @@ static int user_event_free(struct dyn_event *ev)
 	return destroy_user_event(user);
 }
 
+static int user_field_match(struct ftrace_event_field *field, int argc,
+			    const char **argv, int *iout)
+{
+	char field_name[256];
+	char arg_name[256];
+	int len, pos, i = *iout;
+	bool colon = false;
+
+	if (i >= argc)
+		return false;
+
+	len = sizeof(arg_name);
+	pos = 0;
+
+	for (; i < argc; ++i) {
+		if (i != *iout)
+			pos += snprintf(arg_name + pos, len - pos, " ");
+
+		pos += snprintf(arg_name + pos, len - pos, argv[i]);
+
+		if (strchr(argv[i], ';')) {
+			++i;
+			colon = true;
+			break;
+		}
+	}
+
+	len = sizeof(field_name);
+	pos = 0;
+
+	pos += snprintf(field_name + pos, len - pos, field->type);
+	pos += snprintf(field_name + pos, len - pos, " ");
+	pos += snprintf(field_name + pos, len - pos, field->name);
+
+	if (colon)
+		pos += snprintf(field_name + pos, len - pos, ";");
+
+	*iout = i;
+
+	return strcmp(arg_name, field_name) == 0;
+}
+
+static bool user_fields_match(struct user_event *user, int argc,
+			      const char **argv)
+{
+	struct ftrace_event_field *field, *next;
+	struct list_head *head = &user->fields;
+	int i = 0;
+
+	list_for_each_entry_safe_reverse(field, next, head, link)
+		if (!user_field_match(field, argc, argv, &i))
+			return false;
+
+	if (i != argc)
+		return false;
+
+	return true;
+}
+
 static bool user_event_match(const char *system, const char *event,
 			     int argc, const char **argv, struct dyn_event *ev)
 {
 	struct user_event *user = container_of(ev, struct user_event, devent);
+	bool match;
 
-	return strcmp(EVENT_NAME(user), event) == 0 &&
+	match = strcmp(EVENT_NAME(user), event) == 0 &&
 		(!system || strcmp(system, USER_EVENTS_SYSTEM) == 0);
+
+	if (match && argc > 0)
+		match = user_fields_match(user, argc, argv);
+
+	return match;
 }
 
 static struct dyn_event_operations user_event_dops = {
-- 
2.17.1

