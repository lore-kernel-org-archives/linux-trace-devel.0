Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B2EC7EE23
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Jun 2023 21:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjFEVaW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjFEVaD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 17:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E743FA
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jun 2023 14:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D48628B4
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jun 2023 21:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7779C433EF
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jun 2023 21:30:00 +0000 (UTC)
Date:   Mon, 5 Jun 2023 17:29:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs Documentation: Add missing prototypes in top
 level man page
Message-ID: <20230605172959.24f87989@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The top level libtracefs man page was missing the prototypes for:

	tracefs_find_cid_pid()
	tracefs_instance_find_cid_pid()
	tracefs_time_conversion()
	tracefs_instance_tracers()

Add them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 9bdffc2672d1..1ab7419e6d04 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -131,6 +131,7 @@ Trace options:
 
 Ftrace tracers:
 	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+	char pass:[**] *tracefs_instance_tracers*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_tracer_available*(const char pass:[*]_tracing_dir_, const char pass:[*]_tracer_);
 	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_);
 	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_, const char pass:[*]_name_);
@@ -300,6 +301,10 @@ Recording of trace_pipe_raw files:
 	int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
 	int *tracefs_cpu_pipe*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
 
+Helper functions for guest tracing:
+	char pass:[*]*tracefs_find_cid_pid*(int _cid_);
+	char pass:[*]*tracefs_instance_find_cid_pid*(struct tracefs_instance pass:[*]_instance_, int _cid_);
+	int *tracefs_time_conversion*(int _cpu_, int pass:[*]_shift_, int pass:[*]_multi_, long long pass:[*]offset);
 --
 
 DESCRIPTION
-- 
2.39.2

