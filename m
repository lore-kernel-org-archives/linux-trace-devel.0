Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC40C433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F7522D6E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbgGVBSa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbgGVBR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352B022D06;
        Wed, 22 Jul 2020 01:17:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3ON-005sGc-4T; Tue, 21 Jul 2020 21:17:55 -0400
Message-ID: <20200722011755.014613924@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 18/23 v3] tools lib traceevent: Fix typo in tep_plugin_add_option() description
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A typo "optiona" -> "optional" is fixed in description of
tep_plugin_add_option() API.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-4-tz.stoyanov@gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200716092014.2613403-4-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index a39eeb6ef1f2..f8d253a61970 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
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


