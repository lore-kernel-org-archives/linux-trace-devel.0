Return-Path: <SRS0=u2KR=BJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0300C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 15:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D507F206F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 15:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgG3PRw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 11:17:52 -0400
Received: from alt13.smtp-out.videotron.ca ([135.19.0.26]:24965 "EHLO
        alt12.smtp-out.videotron.ca" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726353AbgG3PRv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 11:17:51 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2020 11:17:51 EDT
Received: from localhost.localdomain ([192.226.245.209])
        by Videotron with SMTP
        id 1A52kEoPBhH1B1A53kEauU; Thu, 30 Jul 2020 11:02:50 -0400
X-Authority-Analysis: v=2.3 cv=NIqrBHyg c=1 sm=1 tr=0
 a=ArMVbEtQkEv2v9ei/Xv1Bw==:117 a=ArMVbEtQkEv2v9ei/Xv1Bw==:17 a=7d_E57ReAAAA:8
 a=INfwVe45x8SIc9xGMEMA:9 a=jhqOcbufqs7Y1TYCrUUU:22
From:   Philippe Duplessis-Guindon <pduplessis@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Philippe Duplessis-Guindon <pduplessis@efficios.com>
Subject: [PATCH] tools lib traceevent: Fix memory leak in process_dynamic_array_len
Date:   Thu, 30 Jul 2020 11:02:36 -0400
Message-Id: <20200730150236.5392-1-pduplessis@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKrvZMAmVn6rM7Dd8RTQ/XAWR2HUC/p4IgR+Ar2GqqfkRH9865DguEo8WNInMJezOSotzt8dgJ29q+NJ5awPdkBhIFtuqsu01f6tg+4T2tAiLbddyrfs
 78/8NmXa2Ky80VQxmI8t64cUPL7DOh/Ivpmbp8RaKq+iBZmhq9c/2a6PU+onDTOn8vNIXz1WEOWkO7DYmi65a3iPpKP3tKVhWRa8cKgaTYe6zqgs86m37o7/
 keBUO0OwByHMzPTk4snSfOn/9arqNSBg3utM9JtnrwM=
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I compiled with AddressSanitizer and I had these memory leaks while I
was using the tep_parse_format function:

    Direct leak of 28 byte(s) in 4 object(s) allocated from:
        #0 0x7fb07db49ffe in __interceptor_realloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10dffe)
        #1 0x7fb07a724228 in extend_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:985
        #2 0x7fb07a724c21 in __read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1140
        #3 0x7fb07a724f78 in read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1206
        #4 0x7fb07a725191 in __read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1291
        #5 0x7fb07a7251df in read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1299
        #6 0x7fb07a72e6c8 in process_dynamic_array_len /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:2849
        #7 0x7fb07a7304b8 in process_function /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3161
        #8 0x7fb07a730900 in process_arg_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3207
        #9 0x7fb07a727c0b in process_arg /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1786
        #10 0x7fb07a731080 in event_read_print_args /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3285
        #11 0x7fb07a731722 in event_read_print /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3369
        #12 0x7fb07a740054 in __tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6335
        #13 0x7fb07a74047a in __parse_event /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6389
        #14 0x7fb07a740536 in tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6431
        #15 0x7fb07a785acf in parse_event ../../../src/fs-src/fs.c:251
        #16 0x7fb07a785ccd in parse_systems ../../../src/fs-src/fs.c:284
        #17 0x7fb07a786fb3 in read_metadata ../../../src/fs-src/fs.c:593
        #18 0x7fb07a78760e in ftrace_fs_source_init ../../../src/fs-src/fs.c:727
        #19 0x7fb07d90c19c in add_component_with_init_method_data ../../../../src/lib/graph/graph.c:1048
        #20 0x7fb07d90c87b in add_source_component_with_initialize_method_data ../../../../src/lib/graph/graph.c:1127
        #21 0x7fb07d90c92a in bt_graph_add_source_component ../../../../src/lib/graph/graph.c:1152
        #22 0x55db11aa632e in cmd_run_ctx_create_components_from_config_components ../../../src/cli/babeltrace2.c:2252
        #23 0x55db11aa6fda in cmd_run_ctx_create_components ../../../src/cli/babeltrace2.c:2347
        #24 0x55db11aa780c in cmd_run ../../../src/cli/babeltrace2.c:2461
        #25 0x55db11aa8a7d in main ../../../src/cli/babeltrace2.c:2673
        #26 0x7fb07d5460b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

The token variable in the process_dynamic_array_len function is
allocated in the read_expect_type function, but is not freed before
calling the read_token function.

Free the token variable before calling read_token in order to plug the
leak.

Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>
---
 tools/lib/traceevent/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5b36c589a029..ba4f33804af1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2861,6 +2861,7 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
 	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
 		goto out_err;
 
+	free_token(token);
 	type = read_token(&token);
 	*tok = token;
 
-- 
2.25.1

