Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2A4CCA481
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245709AbiFHQcW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343517AbiFHQcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD912D29C1
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05F061978
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14532C34116;
        Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyyb3-001mfI-3N;
        Wed, 08 Jun 2022 12:31:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd stat: Show set_event_notrace_pid entries
Date:   Wed,  8 Jun 2022 12:31:50 -0400
Message-Id: <20220608163152.425352-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608163152.425352-1-rostedt@goodmis.org>
References: <20220608163152.425352-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have trace-cmd stat list the PIDs that are in the set_event_notrace_pid.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208813
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 4c3dc6494922..4250f46a32d5 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -860,6 +860,7 @@ static void stat_instance(struct buffer_instance *instance, bool opt)
 	report_kprobes(instance);
 	report_uprobes(instance);
 	report_file(instance, "set_event_pid", "", "Filtered event PIDs:\n");
+	report_file(instance, "set_event_notrace_pid", "", "Filtered notrace event PIDs:\n");
 	report_file(instance, "set_ftrace_pid", "no pid",
 		    "Filtered function tracer PIDs:\n");
 	if (opt) {
-- 
2.35.1

