Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EA9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Mar 2022 07:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiC3HEX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 03:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238127AbiC3HET (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 03:04:19 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25363E1240;
        Wed, 30 Mar 2022 00:02:33 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 30 Mar
 2022 15:02:32 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 30 Mar
 2022 15:02:31 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     Haowen Bai <baihaowen@meizu.com>,
        <linux-trace-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtla/osnoise: avoid NULL pointer dereference on out
Date:   Wed, 30 Mar 2022 15:02:28 +0800
Message-ID: <1648623748-8833-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-124.meizu.com (172.16.1.124) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

record is NULL and go out but dereference record->trace.

report by coccicheck:
tools/tracing/rtla/src/osnoise_top.c:650:31-36: ERROR:
record is NULL but dereferenced.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 tools/tracing/rtla/src/osnoise_top.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 72c2fd6..8cb185e 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -572,7 +572,7 @@ int osnoise_top_main(int argc, char **argv)
 	retval = osnoise_top_apply_config(tool, params);
 	if (retval) {
 		err_msg("Could not apply config\n");
-		goto out_top;
+		goto out_top_pre;
 	}
 
 	trace = &tool->trace;
@@ -580,14 +580,14 @@ int osnoise_top_main(int argc, char **argv)
 	retval = enable_osnoise(trace);
 	if (retval) {
 		err_msg("Failed to enable osnoise tracer\n");
-		goto out_top;
+		goto out_top_pre;
 	}
 
 	if (params->set_sched) {
 		retval = set_comm_sched_attr("osnoise/", &params->sched_param);
 		if (retval) {
 			err_msg("Failed to set sched parameters\n");
-			goto out_top;
+			goto out_top_pre;
 		}
 	}
 
@@ -597,7 +597,7 @@ int osnoise_top_main(int argc, char **argv)
 		record = osnoise_init_trace_tool("osnoise");
 		if (!record) {
 			err_msg("Failed to enable the trace instance\n");
-			goto out_top;
+			goto out_top_pre;
 		}
 
 		if (params->events) {
@@ -648,6 +648,7 @@ int osnoise_top_main(int argc, char **argv)
 
 out_top:
 	trace_events_destroy(&record->trace, params->events);
+out_top_pre:
 	params->events = NULL;
 	osnoise_free_top(tool->data);
 	osnoise_destroy_tool(record);
-- 
2.7.4

