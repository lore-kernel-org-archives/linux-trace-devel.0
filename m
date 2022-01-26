Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A1BC5AC75
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 02:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbiAZCxL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiAZCxK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 21:53:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57978C06161C
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 18:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3B9BB81AC2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 02:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75894C340E0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 02:53:07 +0000 (UTC)
Date:   Tue, 25 Jan 2022 21:53:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Initialized func_list in
 tracefs_filter_functions()
Message-ID: <20220125215305.08cf1eb3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The variable func_list is used to create a link list and it is expected to
be NULL. This causes a crash because of the logic checks it before it gets
initialized.

Initialize func_list to NULL.

This was found by valgrind after a crash.

Fixes: c1606fb72264a ("libtracefs: Implement tracefs_filter_functions()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index ae85444b67dd..489be28a3b94 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -1237,7 +1237,7 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance)
 int tracefs_filter_functions(const char *filter, const char *module, char ***list)
 {
 	struct func_filter func_filter;
-	struct func_list *func_list, *f;
+	struct func_list *func_list = NULL, *f;
 	char **funcs = NULL;
 	int ret;
 
-- 
2.33.0

