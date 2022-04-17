Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EFAAC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 21:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiDQVP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 17:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiDQVP5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 17:15:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C97011C38
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 14:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21867B80D9D
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 21:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03CAC385A7;
        Sun, 17 Apr 2022 21:13:17 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ngCCq-004P1T-KN;
        Sun, 17 Apr 2022 17:13:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd agent: Add documentation
Date:   Sun, 17 Apr 2022 17:13:15 -0400
Message-Id: <20220417211315.1049221-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417211315.1049221-1-rostedt@goodmis.org>
References: <20220417211315.1049221-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a man page for trace-cmd agent, and also update the usage to include
the new -N option.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-agent.1.txt | 60 +++++++++++++++++++
 tracecmd/trace-usage.c                        |  1 +
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/trace-cmd/trace-cmd-agent.1.txt

diff --git a/Documentation/trace-cmd/trace-cmd-agent.1.txt b/Documentation/trace-cmd/trace-cmd-agent.1.txt
new file mode 100644
index 000000000000..ed82fcdedb26
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd-agent.1.txt
@@ -0,0 +1,60 @@
+TRACE-CMD-AGENT(1)
+==================
+
+NAME
+----
+trace-cmd-agent - Run as an agent on a machine (to be controlled by another machine)
+
+SYNOPSIS
+--------
+*trace-cmd agent* ['OPTIONS']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) agent listens over a vsocket (for virtual machines) or a TCP port
+for connections to control the tracing of the machine. The agent will then start
+tracing on the local machine and pass the data to the controlling connection.
+
+OPTIONS
+-------
+*-N* 'client'::
+    Listen over TCP instead of a vsocket. Must pass in a client host name or IP address
+    to allow connection to. It will only connect to the specified client. Note, any process
+    on that client can control the agent. Only use if the client machine is totally trusted.
+
+*-p* 'port'::
+    This option will specify the port to listen to.
+
+*-D*::
+    This options causes trace-cmd agent to go into a daemon mode and run in
+    the background.
+
+*--verbose*[='level']::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+     The level will default to "info" if one is not specified.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd listen --verbose=warning
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
+trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
+trace-cmd-split(1), trace-cmd-list(1)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 88eac10a4e75..e5ef6ea0aa97 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -330,6 +330,7 @@ static struct usage_help usage_help[] = {
 		"listen on a vsocket for trace clients",
 		" %s agent -p port[-D]\n"
 		"          Creates a vsocket to listen for clients.\n"
+		"          -N Connect to IP via TCP instead of vsockets\n"
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
 		"          --verbose 'level' Set the desired log level\n"
-- 
2.35.1

