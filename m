Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4825CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiCNRGv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiCNRGv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:06:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB83D1E0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:05:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 377B260EC2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C5FC340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:05:39 +0000 (UTC)
Date:   Mon, 14 Mar 2022 13:05:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Have -q not print empty CPUs
Message-ID: <20220314130537.644c0689@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Do not print that a CPU contains no data if the -q option is present.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 643dd807c575..aa40d2451ab6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2720,7 +2720,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 	list_head_init(&cpu_data->compress.cache);
 
 	if (!cpu_data->size) {
-		printf("CPU %d is empty\n", cpu);
+		tracecmd_info("CPU %d is empty", cpu);
 		return 0;
 	}
 
-- 
2.35.1

