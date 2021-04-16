Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC18C43462
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47898610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbhDPRYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:24:01 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:24135 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233606AbhDPRYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 13:24:01 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 10:23:31 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 41DEE20454;
        Fri, 16 Apr 2021 10:23:35 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd stat: Update the usage and man pages
Date:   Fri, 16 Apr 2021 13:23:30 -0400
Message-ID: <20210416172331.3870833-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416172331.3870833-1-rostedt@goodmis.org>
References: <20210416172331.3870833-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

trace-cmd stat takes some options (-B and -t, as well as -h), but the
usage and the man pages do not display them.

Also, since 'h' was not included in the getopt(), it failed to be called.
Fix that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-stat.1.txt | 12 +++++++++++-
 tracecmd/trace-stat.c                        |  2 +-
 tracecmd/trace-usage.c                       |  4 +++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-stat.1.txt b/Documentation/trace-cmd/trace-cmd-stat.1.txt
index e5fccce9..1be9e609 100644
--- a/Documentation/trace-cmd/trace-cmd-stat.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stat.1.txt
@@ -7,7 +7,7 @@ trace-cmd-stat - show the status of the tracing (ftrace) system
 
 SYNOPSIS
 --------
-*trace-cmd stat*
+*trace-cmd stat* ['OPTIONS']
 
 DESCRIPTION
 -----------
@@ -45,6 +45,16 @@ system. The status that it shows is:
 
 *Error log:* Dump the content of ftrace error_log file.
 
+OPTIONS
+-------
+*-B* 'buffer-name'::
+    Display the status of a given buffer instance. May be specified more than once
+    to display the status of multiple instances.
+
+*-t*::
+    If *-B* is also specified, show the status of the top level tracing directory
+    as well as the instance(s).
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 31127872..e640a9e5 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -875,7 +875,7 @@ void trace_stat (int argc, char **argv)
 	init_top_instance();
 
 	for (;;) {
-		c = getopt(argc-1, argv+1, "tB:");
+		c = getopt(argc-1, argv+1, "htB:");
 		if (c == -1)
 			break;
 		switch (c) {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 98247074..094c6397 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -258,7 +258,9 @@ static struct usage_help usage_help[] = {
 	{
 		"stat",
 		"show the status of the running tracing (ftrace) system",
-		" %s stat"
+		" %s stat [-B buf][-t]"
+		"          -B show the status of a instance buffer\n"
+		"          -t show the top level status along with buffer specified by -B\n"
 	},
 	{
 		"split",
-- 
2.29.2

