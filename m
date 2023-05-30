Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A4AC77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 05:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjE3FrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 01:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjE3FrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 01:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2162E5
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 22:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EE8361DCE
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 05:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6EFC433EF;
        Tue, 30 May 2023 05:47:14 +0000 (UTC)
Date:   Tue, 30 May 2023 01:47:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtracefs: Do not allow tracefs_synth_set_instance() on
 created synth
Message-ID: <20230530014711.6c8b3b16@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If tracefs_synth_create() is called on a synthetic event descriptor, do
not let its instance change after that. Currently
tracefs_synth_set_instance() returns success when called on a created
instance, where it has no effect. Make it fail in such cases.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 1e3df6c67d7e..ecfce7442176 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -748,6 +748,7 @@ struct name_hash {
  * @start_parens: Current parenthesis level for start event
  * @end_parens: Current parenthesis level for end event
  * @new_format: onmatch().trace(synth_event,..) or onmatch().synth_event(...)
+ * @created: Set if tracefs_synth_create() was called on this; cleared on destroy()
  */
 struct tracefs_synth {
 	struct tracefs_instance *instance;
@@ -778,6 +779,7 @@ struct tracefs_synth {
 	char			arg_name[16];
 	int			arg_cnt;
 	bool			new_format;
+	bool			created;
 };
 
  /*
@@ -2207,7 +2209,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
  */
 int tracefs_synth_set_instance(struct tracefs_synth *synth, struct tracefs_instance *instance)
 {
-	if (!synth)
+	if (!synth || synth->created)
 		return -1;
 	synth->instance = instance;
 	return 0;
@@ -2271,6 +2273,8 @@ int tracefs_synth_create(struct tracefs_synth *synth)
 	if (ret < 0)
 		goto remove_start_hist;
 
+	synth->created = true;
+
 	return 0;
 
  remove_start_hist:
@@ -2334,6 +2338,9 @@ int tracefs_synth_destroy(struct tracefs_synth *synth)
 
 	ret = tracefs_dynevent_destroy(synth->dyn_event, true);
 
+	if (!ret)
+		synth->created = false;
+
 	return ret ? -1 : 0;
 }
 
-- 
2.39.2

