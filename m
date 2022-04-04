Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FC9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378496AbiDDPVT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356457AbiDDPVS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A81525EB6
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95CE615FE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13562C340EE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:19:20 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:19:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Use clock local if no clock is found
 when creating buffer
Message-ID: <20220404111919.3883e905@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Using restore to put together a trace.dat file from reading trace_pipe_raw
with a cat, and copying over the tracing/events and proc/kallsyms
directory from one machine to another and running trace-cmd on it.

Here's the scenario. On a machine with just a busybox environment.

 # cd /sys/kernel/tracing/per_cpu
 # for cpu in cpu*; do
 #   cat $cpu/trace_pipe_raw > /tmp/read_${cpu} &
 # done
 # mkdir /tmp/tracing
 # cp -a /sys/kernel/tracing/events /tmp/tracing
 # cp /proc/kallsyms /tmp
 # cd tmp
 # echo 0 > /sys/kernel/tracing/tracing_on
 # tar cvzf trace-dat.tgz read_cpu* tracing kallsyms

Then on another machine:

 $ scp target:/tmp/trace-dat.tgz /tmp
 $ cd /tmp
 $ tar xvzf /tmp/trace-dat.tgz
 $ trace-cmd restore -c -o trace-head.dat -k /tmp/kallsyms -t /tmp/tracing
 $ trace-cmd restore -o trace-target.dat -i trace-head.dat read_cpu*

The above ends with a segfault because get_clock() fails and then NULL
gets passed to strlen() and crashes.

Just set it to "local" and warn about it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 73020ff1fda1..f3a203ec347f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2139,6 +2139,10 @@ out_add_buffer_option(struct tracecmd_output *handle, const char *name,
 		return NULL;
 
 	clock = get_clock(handle);
+	if (!clock) {
+		tracecmd_warning("Could not find clock, set to 'local'");
+		clock = "local";
+	}
 
 	/*
 	 * Buffer flyrecord option:
-- 
2.35.1

