Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82928C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbiDQSgg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiDQSge (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFE91C92B
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E3DA60C82
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE89C385AD;
        Sun, 17 Apr 2022 18:33:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9id-004NGc-PR;
        Sun, 17 Apr 2022 14:33:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 5/5] trace-cmd listen: Add documentation on vsocket usage
Date:   Sun, 17 Apr 2022 14:33:54 -0400
Message-Id: <20220417183354.1042657-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417183354.1042657-1-rostedt@goodmis.org>
References: <20220417183354.1042657-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Document the -V option for trace-cmd listen/record in both the usage and the
man pages.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-listen.1.txt | 4 ++++
 Documentation/trace-cmd/trace-cmd-record.1.txt | 8 ++++++++
 tracecmd/trace-usage.c                         | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
index aa6a307ff3b7..7c6093ba5354 100644
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
index 426e856bf74a..6b8e3b4ad364 100644
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
index 20995fabed73..ec6376557394 100644
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

