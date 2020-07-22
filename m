Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3E5C43459
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3E4207DD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgGVBS3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbgGVBR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA84022CA1;
        Wed, 22 Jul 2020 01:17:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OM-005sG6-W6; Tue, 21 Jul 2020 21:17:55 -0400
Message-ID: <20200722011754.869289038@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 17/23 v3] tools lib traceevent: Handle strdup() error in parse_option_name()
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Modified internal function parse_option_name() to return error and handle
that error in function callers in case strdup() fails.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-3-tz.stoyanov@gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200716092014.2613403-3-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index aa6f43290cd3..a39eeb6ef1f2 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -254,7 +254,7 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
 	}
 }
 
-static void parse_option_name(char **option, char **plugin)
+static int parse_option_name(char **option, char **plugin)
 {
 	char *p;
 
@@ -265,8 +265,9 @@ static void parse_option_name(char **option, char **plugin)
 		*p = '\0';
 		*option = strdup(p + 1);
 		if (!*option)
-			return;
+			return -1;
 	}
+	return 0;
 }
 
 static struct tep_plugin_option *
@@ -325,7 +326,8 @@ int tep_plugin_add_option(const char *name, const char *val)
 	if (!option_str)
 		return -ENOMEM;
 
-	parse_option_name(&option_str, &plugin);
+	if (parse_option_name(&option_str, &plugin) < 0)
+		return -ENOMEM;
 
 	/* If the option exists, update the val */
 	for (op = trace_plugin_options; op; op = op->next) {
-- 
2.26.2


