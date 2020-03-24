Return-Path: <SRS0=3OGB=5J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743E1C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56764208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Mar 2020 20:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgCXUKI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbgCXUJ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 16:09:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B55E20B80;
        Tue, 24 Mar 2020 20:09:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jGps4-001hRE-UT; Tue, 24 Mar 2020 16:09:56 -0400
Message-Id: <20200324200956.821799393@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 24 Mar 2020 16:08:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/3] tools lib traceevent: Add handler for __builtin_expect()
References: <20200324200845.763565368@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to move pointer checks like IS_ERR_VALUE() out of the hotpath and
into the reader path of a trace event, user space tools need to be able to
parse that. IS_ERR_VALUE() is defined as:

 #define IS_ERR_VALUE() unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)

Which eventually turns into:

  __builtin_expect(!!((unsigned long)(void *)(x) >= (unsigned long)-4095), 0)

Now the traceevent parser can handle most of that except for the
__builtin_expect(), which needs to be added.

Link: https://lore.kernel.org/linux-mm/20200320055823.27089-3-jaewon31.kim@samsung.com/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 35 ++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 010e60d5a081..5b36c589a029 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3084,6 +3084,37 @@ process_func_handler(struct tep_event *event, struct tep_function_handler *func,
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char **tok)
+{
+	enum tep_event_type type;
+	char *token = NULL;
+
+	/* Handle __builtin_expect( cond, #) */
+	type = process_arg(event, arg, &token);
+
+	if (type != TEP_EVENT_DELIM || token[0] != ',')
+		goto out_free;
+
+	free_token(token);
+
+	/* We don't care what the second parameter is of the __builtin_expect() */
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+out_free:
+	free_token(token);
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static enum tep_event_type
 process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
@@ -3128,6 +3159,10 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
+	if (strcmp(token, "__builtin_expect") == 0) {
+		free_token(token);
+		return process_builtin_expect(event, arg, tok);
+	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-- 
2.25.1


