Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBAAC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245150AbiFHQcU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245715AbiFHQcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB51C2D4712
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D068F61983
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7BDC3411E;
        Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyyb3-001mfL-3v;
        Wed, 08 Jun 2022 12:31:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd stat: Show PIDs in set_ftrace_notrace_pid
Date:   Wed,  8 Jun 2022 12:31:51 -0400
Message-Id: <20220608163152.425352-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608163152.425352-1-rostedt@goodmis.org>
References: <20220608163152.425352-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

List the PIDs that are not to be traced by the function tracers that are
listed in the set_ftrace_notrace_pid.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 4250f46a32d5..285960de6e0a 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -863,6 +863,8 @@ static void stat_instance(struct buffer_instance *instance, bool opt)
 	report_file(instance, "set_event_notrace_pid", "", "Filtered notrace event PIDs:\n");
 	report_file(instance, "set_ftrace_pid", "no pid",
 		    "Filtered function tracer PIDs:\n");
+	report_file(instance, "set_ftrace_notrace_pid", "no pid",
+		    "Filtered function tracer notrace PIDs:\n");
 	if (opt) {
 		printf("\nOptions:\n");
 		show_options("   ", instance);
-- 
2.35.1

