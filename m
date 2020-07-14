Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C49BC433E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A27E2072D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbgGNVXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45211206F5;
        Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOW-004vYc-A8; Tue, 14 Jul 2020 17:23:20 -0400
Message-ID: <20200714212320.191971584@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 3/8] libtraceevent: Fix typo in tep_plugin_add_option() description
References: <20200714211929.828530560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A type "optiona" -> "optional" is fixed in description of
tep_plugin_add_option() API.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-4-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index b97d0c7e95bf..03f26c8c58d5 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -310,7 +310,7 @@ static int process_option(const char *plugin, const char *option, const char *va
 /**
  * tep_plugin_add_option - add an option/val pair to set plugin options
  * @name: The name of the option (format: <plugin>:<option> or just <option>)
- * @val: (optiona) the value for the option
+ * @val: (optional) the value for the option
  *
  * Modify a plugin option. If @val is given than the value of the option
  * is set (note, some options just take a boolean, so @val must be either
-- 
2.26.2


