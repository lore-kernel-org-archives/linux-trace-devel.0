Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EC8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 16:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349716AbiAaQgv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 11:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380521AbiAaQgu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 11:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28707C06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 08:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA91BB82BA1
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64FDC340F0;
        Mon, 31 Jan 2022 16:36:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nEZfa-00BYaj-QF;
        Mon, 31 Jan 2022 11:36:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtracefs: Initialized func_list in tracefs_filter_functions()
Date:   Mon, 31 Jan 2022 11:36:39 -0500
Message-Id: <20220131163642.2754485-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131163642.2754485-1-rostedt@goodmis.org>
References: <20220131163642.2754485-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

