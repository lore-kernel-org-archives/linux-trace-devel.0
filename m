Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418CBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2426320772
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGHUaT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGHUaS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415D220739
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jul 2020 20:30:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGht-004NO5-9Z
        for linux-trace-devel@vger.kernel.org; Wed, 08 Jul 2020 16:30:17 -0400
Message-ID: <20200708203017.175213296@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] trace-cmd: Explicitly state what trace-cmd report -f does
References: <20200708202850.764168067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The current man page and usage of trace-cmd report is confusing when it
comes to the -f option. This option will list all the functions in the
trace.dat file that have a address to name mapping. As it currently is
stated, it may confuse users in thinking that it will list the functions
that have been traced. But this is not the case.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207069
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd-report.1.txt | 4 +++-
 tracecmd/trace-usage.c               | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd-report.1.txt
index 87f4d7a1b046..66e96da7c3fa 100644
--- a/Documentation/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd-report.1.txt
@@ -27,7 +27,9 @@ OPTIONS
     versa.
 
 *-f*::
-    This outputs the list of functions that have been recorded in the file.
+    This outputs the list of all functions that have been mapped in the trace.dat file.
+    Note, this list may contain functions that may not appear in the trace, as
+    it is the list of mappings to translate function addresses into function names.
 
 *-P*::
     This outputs the list of "trace_printk()" data. The raw trace data points
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ada44c68eb00..85c635125617 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -191,7 +191,7 @@ static struct usage_help usage_help[] = {
 		"           [-G]\n"
 		"          -i input file [default trace.dat]\n"
 		"          -e show file endianess\n"
-		"          -f show function list\n"
+		"          -f show function mapping list\n"
 		"          -P show printk list\n"
 		"          -E show event files stored\n"
 		"          -F filter to filter output on\n"
-- 
2.26.2


