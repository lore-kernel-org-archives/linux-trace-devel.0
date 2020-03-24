Return-Path: <SRS0=3OGB=5J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB75C54FCF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0677208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgCXUJ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbgCXUJ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 16:09:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D91162070A;
        Tue, 24 Mar 2020 20:09:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jGps4-001hQi-Pn; Tue, 24 Mar 2020 16:09:56 -0400
Message-Id: <20200324200956.663647256@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 24 Mar 2020 16:08:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/3] tools lib traceevent: Handle __attribute__((user)) in field names
References: <20200324200845.763565368@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Commit c61f13eaa1ee1 ("gcc-plugins: Add structleak for more stack
initialization") added "__attribute__((user))" to the user when stackleak
detector is enabled. This now appears in the field format of system call
trace events for system calls that have user buffers. The
"__attribute__((user))" breaks the parsing in libtraceevent. That needs to
be handled.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 39 +++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index eec96c31ea9e..010e60d5a081 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1444,6 +1444,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	enum tep_event_type type;
 	char *token;
 	char *last_token;
+	char *delim = " ";
 	int count = 0;
 	int ret;
 
@@ -1504,13 +1505,49 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
-					ret = append(&field->type, " ", last_token);
+					ret = append(&field->type, delim, last_token);
 					free(last_token);
 					if (ret < 0)
 						goto fail;
 				} else
 					field->type = last_token;
 				last_token = token;
+				delim = " ";
+				continue;
+			}
+
+			/* Handle __attribute__((user)) */
+			if ((type == TEP_EVENT_DELIM) &&
+			    strcmp("__attribute__", last_token) == 0 &&
+			    token[0] == '(') {
+				int depth = 1;
+				int ret;
+
+				ret = append(&field->type, " ", last_token);
+				ret |= append(&field->type, "", "(");
+				if (ret < 0)
+					goto fail;
+
+				delim = " ";
+				while ((type = read_token(&token)) != TEP_EVENT_NONE) {
+					if (type == TEP_EVENT_DELIM) {
+						if (token[0] == '(')
+							depth++;
+						else if (token[0] == ')')
+							depth--;
+						if (!depth)
+							break;
+						ret = append(&field->type, "", token);
+						delim = "";
+					} else {
+						ret = append(&field->type, delim, token);
+						delim = " ";
+					}
+					if (ret < 0)
+						goto fail;
+					free(last_token);
+					last_token = token;
+				}
 				continue;
 			}
 			break;
-- 
2.25.1


