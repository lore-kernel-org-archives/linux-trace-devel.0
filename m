Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445DCC47409
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 171582467C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 17:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgAVRYM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgAVRYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 12:24:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E432467B;
        Wed, 22 Jan 2020 17:24:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1iuJje-000hz2-So; Wed, 22 Jan 2020 12:24:10 -0500
Message-Id: <20200122172410.772509268@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 22 Jan 2020 12:22:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 5/5] trace-cmd: Remove unused trace_util function declarations
References: <20200122172247.539894616@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Due to conflict resolutions, pulling in a patch to add VM tracing protocol
messages also accidentally pulled in old declarations that were previously
deleted. This caused ctracecmd.so python helper to reference them and fail
to load python modules because of their absence.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: 8790da96c26d ("trace-cmd: Add VM tracing protocol messages")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 1f5a98b3f7af..35e2a32c5e30 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -398,17 +398,6 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
-int trace_util_add_options(const char *name, struct tep_plugin_option *options);
-void trace_util_remove_options(struct tep_plugin_option *options);
-int trace_util_add_option(const char *name, const char *val);
-int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
-			    int (*load_plugin)(struct tep_handle *pevent,
-					       const char *path,
-					       const char *name,
-					       void *data),
-			    void *data);
-struct tep_plugin_option *trace_util_read_plugin_options(void);
-void trace_util_free_options(struct tep_plugin_option *options);
 char **trace_util_find_plugin_files(const char *suffix);
 void trace_util_free_plugin_files(char **files);
 
-- 
2.24.1


