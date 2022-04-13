Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9137C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Apr 2022 21:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiDMV4T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiDMV4S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 17:56:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4617B26557
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 14:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4A3461F62
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 21:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D152C385A7
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 21:53:55 +0000 (UTC)
Date:   Wed, 13 Apr 2022 17:53:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd listen: Add documentation on vsocket usage
Message-ID: <20220413175353.692b901c@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Document the -V option for trace-cmd listen/record in both the usage and the
man pages.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
[ Depends on: https://lore.kernel.org/all/20220412042739.836516-1-rostedt@goodmis.org/ ]

 Documentation/trace-cmd/trace-cmd-listen.1.txt | 4 ++++
 Documentation/trace-cmd/trace-cmd-record.1.txt | 8 ++++++++
 tracecmd/trace-usage.c                         | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
index aa6a307f..7c6093ba 100644
--- a/Documentation/trace-cmd/trace-cmd-listen.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-listen.1.txt
@@ -26,6 +26,10 @@ OPTIONS
     This options causes trace-cmd listen to go into a daemon mode and run in
     the background.
 
+*-V*::
+    Listen on a vsocket instead. This is useful for tracing between host and
+    guest VMs.
+
 *-d* 'dir'::
     This option specifies a directory to write the data files into.
 
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 426e856b..6b8e3b4a 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -259,6 +259,14 @@ OPTIONS
     Note: This option is not supported with latency tracer plugins:
       wakeup, wakeup_rt, irqsoff, preemptoff and preemptirqsoff
 
+*-V* 'cid:port'::
+    If recording on a guest VM and the host is running *trace-cmd listen* with
+    the *-V* option as well, or if this is recording on the host, and a guest
+    in running *trace-cmd listen* with the *-V* option, then connect to the
+    listener (the same as connecting with the *-N* option via the network).
+    This has the same limitations as the *-N* option above with respect to
+    latency tracer plugins.
+
 *-t*::
     This option is used with *-N*, when there's a need to send the live data
     with TCP packets instead of UDP. Although TCP is not nearly as fast as
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 20995fab..ec637655 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -44,6 +44,7 @@ static struct usage_help usage_help[] = {
 		"          -s sleep interval between recording (in usecs) [default: 1000]\n"
 		"          -S used with --profile, to enable only events in command line\n"
 		"          -N host:port to connect to (see listen)\n"
+		"          -V cid:port to connect to via vsocket (see listen)\n"
 		"          -t used with -N, forces use of tcp in live trace\n"
 		"          -b change kernel buffersize (in kilobytes per CPU)\n"
 		"          -B create sub buffer and following events will be enabled here\n"
@@ -318,6 +319,7 @@ static struct usage_help usage_help[] = {
 		"          Creates a socket to listen for clients.\n"
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
+		"          -V listen on a vsocket instead.\n"
 		"          -o file name to use for clients.\n"
 		"          -d directory to store client files.\n"
 		"          -l logfile to write messages to.\n"
-- 
2.35.1

