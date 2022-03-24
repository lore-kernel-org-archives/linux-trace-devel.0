Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7666C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbiCXC7C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347900AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1081939F3;
        Wed, 23 Mar 2022 19:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C0B7B82227;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C5EC36AE2;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLC-2n;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 05/12] trace-cmd analyze: Use sched_switch event to update times
Date:   Wed, 23 Mar 2022 22:57:19 -0400
Message-Id: <20220324025726.1727204-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the sched_switch event is available, use that to figure out how long a
task is running on the CPU. It gives better accuracy than just basing it
off of events.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index dec705ce8e15..56123f9b4f86 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -270,6 +270,8 @@ static void process_switch(struct analysis_data *data,
 	cpu_task = get_cpu_task(cpu_data, pid);
 	task = cpu_task->task;
 
+	update_cpu_task_times(cpu_data, cpu_task, record->ts);
+
 	/* Fill in missing comms */
 	if (pid && data->prev_comm && !task->comm) {
 		comm = (char *)(record->data + data->prev_comm->offset);
@@ -283,6 +285,8 @@ static void process_switch(struct analysis_data *data,
 		pid = val;
 		cpu_task = get_cpu_task(cpu_data, pid);
 		task = cpu_task->task;
+		task->start_ts = record->ts;
+		cpu_data->current_pid = pid;
 
 		/* Fill in missing comms */
 		if (pid && data->next_comm && !task->comm) {
-- 
2.35.1

