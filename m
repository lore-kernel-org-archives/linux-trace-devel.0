Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469D6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiFHQcV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343489AbiFHQcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F9F2D5144
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06E761985
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208BBC341C4;
        Wed,  8 Jun 2022 16:31:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyyb3-001mfO-4Z;
        Wed, 08 Jun 2022 12:31:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd stat: List synthetic events in the system
Date:   Wed,  8 Jun 2022 12:31:52 -0400
Message-Id: <20220608163152.425352-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608163152.425352-1-rostedt@goodmis.org>
References: <20220608163152.425352-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

List the synthetic events that are defined.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 285960de6e0a..391a05ffcec9 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -818,6 +818,11 @@ static void report_uprobes(struct buffer_instance *instance)
 	report_probes(instance, "uprobe_events", "Uprobe events");
 }
 
+static void report_synthetic(struct buffer_instance *instance)
+{
+	report_probes(instance, "synthetic_events", "Synthetic events");
+}
+
 static void report_traceon(struct buffer_instance *instance)
 {
 	char *str;
@@ -859,6 +864,7 @@ static void stat_instance(struct buffer_instance *instance, bool opt)
 	report_file(instance, "tracing_max_latency", "0", "Max Latency: ");
 	report_kprobes(instance);
 	report_uprobes(instance);
+	report_synthetic(instance);
 	report_file(instance, "set_event_pid", "", "Filtered event PIDs:\n");
 	report_file(instance, "set_event_notrace_pid", "", "Filtered notrace event PIDs:\n");
 	report_file(instance, "set_ftrace_pid", "no pid",
-- 
2.35.1

