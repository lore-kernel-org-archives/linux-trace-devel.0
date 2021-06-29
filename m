Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D47FC11F68
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D8161D70
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhF2UnQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhF2UnP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 16:43:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18526613B4
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Jun 2021 20:40:48 +0000 (UTC)
Date:   Tue, 29 Jun 2021 16:40:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_event_enable/disable() to not have
 open regex
Message-ID: <20210629164046.48f8b323@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Found that calling tracefs_event_enable/disable() will match all content
of the passed in strings and not just what is passed in.

That is, if you have two events, "open" and "open2", and call

 tracefs_event_enable(NULL, NULL, "open");

it will match both the "open" event as well as the "open2" event. This is
because the regex is open ended.

To fix this, add a '^' to the beginning of the match and a '$' to the end
(if they do not already exist).

Fixes: fc94d1a8 ("libtracefs: Add tracefs_event_enable/disable() API")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 0fef64f..b6d3136 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -828,6 +828,26 @@ static int enable_disable_all(struct tracefs_instance *instance,
 	return ret < 0 ? ret : 0;
 }
 
+static int make_regex(regex_t *re, const char *match)
+{
+	int len = strlen(match);
+	char str[len + 3];
+	char *p = &str[0];
+
+	if (!len || match[0] != '^')
+		*(p++) = '^';
+
+	strcpy(p, match);
+	p += len;
+
+	if (!len || match[len-1] != '$')
+		*(p++) = '$';
+
+	*p = '\0';
+
+	return regcomp(re, str, REG_ICASE|REG_NOSUB);
+}
+
 static int event_enable_disable(struct tracefs_instance *instance,
 				const char *system, const char *event,
 				bool enable)
@@ -847,12 +867,13 @@ static int event_enable_disable(struct tracefs_instance *instance,
 		goto out_free;
 
 	if (system) {
+		ret = make_regex(&system_re, system);
 		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);
 		if (ret < 0)
 			goto out_free;
 	}
 	if (event) {
-		ret = regcomp(&event_re, event, REG_ICASE|REG_NOSUB);
+		ret = make_regex(&event_re, event);
 		if (ret < 0) {
 			if (system)
 				regfree(&system_re);
-- 
2.29.2

