Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500F8C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 16:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3194520DD4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 16:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgFRQdW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 12:33:22 -0400
Received: from mailout2n.rrzn.uni-hannover.de ([130.75.2.113]:46099 "EHLO
        mailout2n.rrzn.uni-hannover.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728523AbgFRQdU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 12:33:20 -0400
Received: from lab-pc01.sra.uni-hannover.de (lab.sra.uni-hannover.de [130.75.33.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailout2n.rrzn.uni-hannover.de (Postfix) with ESMTPSA id E65551F4CB;
        Thu, 18 Jun 2020 18:33:14 +0200 (CEST)
From:   Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
To:     mhiramat@kernel.org
Cc:     linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, maximilian.werner96@gmail.com,
        mingo@redhat.com, rostedt@goodmis.org,
        sascha.ortmann@stud.uni-hannover.de
Subject: [PATCH v2] tracing/boottime: Fix kprobe multiple events
Date:   Thu, 18 Jun 2020 18:33:01 +0200
Message-Id: <20200618163301.25854-1-sascha.ortmann@stud.uni-hannover.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618105051.ce01a84a13bbf67b816c1363@kernel.org>
References: <20200618105051.ce01a84a13bbf67b816c1363@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix boottime kprobe events to report and abort after each failure when
adding probes.

As an example, when we try to set multiprobe kprobe events in
bootconfig like this:

ftrace.event.kprobes.vfsevents {
        probes = "vfs_read $arg1 $arg2,,
                 !error! not reported;?", // leads to error
                 "vfs_write $arg1 $arg2"
}

This will not work as expected. After 
commit da0f1f4167e3af69e ("tracing/boottime: Fix kprobe event API usage"), 
the function trace_boot_add_kprobe_event will not produce any error 
message when adding a probe fails at kprobe_event_gen_cmd_start. 
Furthermore, we continue to add probes when kprobe_event_gen_cmd_end fails
(and kprobe_event_gen_cmd_start did not fail). In this case the function 
even returns successfully when the last call to kprobe_event_gen_cmd_end
is successful.

The behaviour of reporting and aborting after failures is not
consistent.

The function trace_boot_add_kprobe_event now reports each failure and
stops adding probes immediately.

Cc: linux-kernel@i4.cs.fau.de
Co-developed-by: Maximilian Werner <maximilian.werner96@gmail.com>
Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
---
 kernel/trace/trace_boot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 9de29bb45a27..be893eb22071 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -101,12 +101,16 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
 		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
 		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
-		if (ret)
+		if (ret) {
+			pr_err("Failed to generate probe: %s\n", buf);
 			break;
+		}
 
 		ret = kprobe_event_gen_cmd_end(&cmd);
-		if (ret)
+		if (ret) {
 			pr_err("Failed to add probe: %s\n", buf);
+			break;
+		}
 	}
 
 	return ret;
-- 
2.17.1

