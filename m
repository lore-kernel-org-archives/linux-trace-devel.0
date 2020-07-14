Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144A9C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EF22074A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D0F206F0;
        Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOW-004vY6-5T; Tue, 14 Jul 2020 17:23:20 -0400
Message-ID: <20200714212320.046471564@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 2/8] libtraceevent: Handle strdup() error in parse_option_name()
References: <20200714211929.828530560@goodmis.org>
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

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index c11636cea380..b97d0c7e95bf 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
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


