Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB521C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F7520658
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGNVXW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgGNVXW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2F620672;
        Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOW-004vag-TM; Tue, 14 Jul 2020 17:23:20 -0400
Message-ID: <20200714212320.799905852@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 7/8] libtraceevent: Fixed description of tep_add_plugin_path() API
References: <20200714211929.828530560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Changed the description of tep_add_plugin_path() API to reflect the
logic of the function. The suffix of plugin files is not hardcoded
to ".so", it depends on the custom plugin loader callback.

Link: https://lore.kernel.org/CAM9d7cgMgqFDvKhs6xwdBSMsaG=3ZG0RtxwgQDCTLGkML1MY4Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-8-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index aa868133cbdf..841e41c68ad0 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -647,8 +647,8 @@ tep_load_plugins(struct tep_handle *tep)
 /**
  * tep_add_plugin_path - Add a new plugin directory.
  * @tep: Trace event handler.
- * @path: Path to a directory. All files with extension .so in that
- *	  directory will be loaded as plugins.
+ * @path: Path to a directory. All plugin files in that
+ *	  directory will be loaded.
  *@prio: Load priority of the plugins in that directory.
  *
  * Returns -1 in case of an error, 0 otherwise.
-- 
2.26.2


