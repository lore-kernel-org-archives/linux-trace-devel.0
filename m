Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA17CC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 00:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871A220CC7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 00:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgAaADN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 19:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgAaADN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 19:03:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27CE120CC7;
        Fri, 31 Jan 2020 00:03:12 +0000 (UTC)
Date:   Thu, 30 Jan 2020 19:03:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, john.koepi@gmail.com
Subject: [PATCH] tools lib traceevent: Handle gcc __attribute__(()) in
 fields
Message-ID: <20200130190310.640ba01c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When CONFIG_STURCTLEAK and gcc plugins are enabled, then some macros become
expanded and displayed as part of the format fields in the event format
files. For example, the __user macro expands to __attribute__((user)) and
the field buf for the syscall trace event sys_enter_write has it added:

 # cat /sys/kernel/tracing/events/syscalls/sys_enter_write/format
name: sys_enter_write
ID: 680
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3; size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:int __syscall_nr; offset:8;       size:4; signed:1;
        field:unsigned int fd;  offset:16;      size:8; signed:0;
        field:const char __attribute__((user)) * buf;   offset:24; size:8; signed:0;
        field:size_t count;     offset:32;      size:8; signed:0;

The "__attribute__((user))" breaks the parsing of the event. This needs to
also be handled.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205857
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

Arnaldo,

Hold off on applying this, I want to hear back from the reporter (in
the bugzilla) to make sure this solves the issue for him.

-- Steve

 tools/lib/traceevent/event-parse.c | 41 ++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index beaa8b8c08ff..ffba056772d5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1477,6 +1477,47 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		/* read the rest of the type */
 		for (;;) {
 			type = read_token(&token);
+
+			/* On some configs, gcc __attribute((*)) may appear. */
+			if (type == TEP_EVENT_DELIM && strcmp(token, "(") == 0 &&
+			    last_token && strcmp(last_token, "__attribute__") == 0) {
+				char *new_token;
+
+				breakpoint();
+				if (read_expected(TEP_EVENT_DELIM, "(") < 0) {
+					free(last_token);
+					goto fail;
+				}
+				free(token);
+				if (read_expect_type(TEP_EVENT_ITEM, &token) < 0) {
+					free(last_token);
+					goto fail;
+				}
+				new_token = realloc(last_token,
+						    strlen(last_token) +
+						    strlen(token) + 5);
+				if (!new_token) {
+					free(last_token);
+					goto fail;
+				}
+				last_token = new_token;
+				strcat(last_token, "((");
+				strcat(last_token, token);
+				strcat(last_token, "))");
+				free(token);
+				token = NULL;
+
+				if (read_expected(TEP_EVENT_DELIM, ")") < 0) {
+					free(last_token);
+					goto fail;
+				}
+				if (read_expected(TEP_EVENT_DELIM, ")") < 0) {
+					free(last_token);
+					goto fail;
+				}
+				continue;
+			}
+
 			if (type == TEP_EVENT_ITEM ||
 			    (type == TEP_EVENT_OP && strcmp(token, "*") == 0) ||
 			    /*
-- 
2.20.1

