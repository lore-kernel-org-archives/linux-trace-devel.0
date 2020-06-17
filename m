Return-Path: <SRS0=X5V/=76=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EAEC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 14:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658E821556
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 14:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgFQOOD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 10:14:03 -0400
Received: from mailout2n.rrzn.uni-hannover.de ([130.75.2.113]:39520 "EHLO
        mailout2n.rrzn.uni-hannover.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgFQOOD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 10:14:03 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 10:14:02 EDT
Received: from lab-pc01.sra.uni-hannover.de (lab.sra.uni-hannover.de [130.75.33.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailout2n.rrzn.uni-hannover.de (Postfix) with ESMTPSA id D0C281F477;
        Wed, 17 Jun 2020 16:08:26 +0200 (CEST)
From:   Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
To:     linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com,
        linux-trace-devel@vger.kernel.org,
        Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>,
        linux-kernel@i4.cs.fau.de,
        Maximilian Werner <maximilian.werner96@gmail.com>
Subject: [PATCH] tracing/boottime: Fix kprobe multiple events
Date:   Wed, 17 Jun 2020 16:08:17 +0200
Message-Id: <20200617140817.17161-1-sascha.ortmann@stud.uni-hannover.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix boottime kprobe events to add multiple events even if one fails
and report probe generation failures.

As an example, when we try to set multiprobe kprobe events in
bootconfig like this:

ftrace.event.kprobes.vfsevents {
	probes = "vfs_read $arg1 $arg2,,
                 !error! not reported;?", // leads to error
		 "vfs_write $arg1 $arg2"
}

this will not work like expected. After commit
da0f1f4167e3af69e1d8b32d6d65195ddd2bfb64 ("tracing/boottime:
Fix kprobe event API usage"), the function
trace_boot_add_kprobe_event will not produce any error message,
aborting the function and stopping subsequent probes from getting
installed when adding a probe fails at kprobe_event_gen_cmd_start.
Furthermore, probes continue when kprobe_event_gen_cmd_end fails
(and kprobe_event_gen_cmd_start did not fail). In this case the
function even returns successfully when the last call to
kprobe_event_gen_cmd_end is successful.

The behaviour of reporting and aborting after failures is not
consistent.

The function trace_boot_add_kprobe_event now continues even when
one of the multiple events fails. Each failure is now reported
individually. Since the function can only return one result to the
caller, the function returns now the last failure (or none, if
nothing fails).

Cc: linux-kernel@i4.cs.fau.de
Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
---
 kernel/trace/trace_boot.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 9de29bb45a27..dbb50184e060 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -95,18 +95,24 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
 	struct xbc_node *anode;
 	char buf[MAX_BUF_LEN];
 	const char *val;
+	int error = 0;
 	int ret = 0;
 
 	xbc_node_for_each_array_value(node, "probes", anode, val) {
 		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
-		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
-		if (ret)
-			break;
+		error = kprobe_event_gen_cmd_start(&cmd, event, val);
+		if (error) {
+			pr_err("Failed to generate probe: %s\n", buf);
+			ret = error;
+			continue;
+		}
 
-		ret = kprobe_event_gen_cmd_end(&cmd);
-		if (ret)
+		error = kprobe_event_gen_cmd_end(&cmd);
+		if (error) {
 			pr_err("Failed to add probe: %s\n", buf);
+			ret = error;
+		}
 	}
 
 	return ret;
-- 
2.17.1

