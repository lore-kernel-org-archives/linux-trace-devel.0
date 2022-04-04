Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97263C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiDDPUM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356457AbiDDPUL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0320B3CA60
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED26614DD
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD168C340EE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:18:13 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:18:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Do not read if cpu is greater than cpus
Message-ID: <20220404111812.2b3753df@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Fix tracecmd_read_data() to not read a cpu if it is greater than the
number of CPUs recorded.

As tracecmd_cpus() returns the number of CPUs found in the system which
can be greater than the number of CPUs stored in the buffer, it is likely
that a caller will pass in a CPU number that is greater than the stored
array of cpu_data.

In this case return NULL otherwise it will access beyond the cpu_data
array.

Fixes: 8724996990021 ("trace-cmd library: Read extended BUFFER option")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b8705ce364d1..425c6077d88e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2462,6 +2462,9 @@ tracecmd_read_data(struct tracecmd_input *handle, int cpu)
 {
 	struct tep_record *record;
 
+	if (cpu >= handle->cpus)
+		return NULL;
+
 	record = tracecmd_peek_data(handle, cpu);
 	handle->cpu_data[cpu].next = NULL;
 	if (record) {
-- 
2.35.1

