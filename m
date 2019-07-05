Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D34C46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 16:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C6F2184C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 16:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfGEQOY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 12:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbfGEQOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 12:14:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5336E216FD;
        Fri,  5 Jul 2019 16:14:23 +0000 (UTC)
Date:   Fri, 5 Jul 2019 12:14:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH] trace-cmd: Add git version string to trace-cmd --version
 output
Message-ID: <20190705121421.17af9096@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Commit d74f3845ddebf0 ("trace-cmd: Make the version defines part of
tc-version.h") created a VERSION_GIT define to include in the trace.dat
file. It would also be helpful to have this displayed with the --version
option too.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-usage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 406384c4..2532d92a 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -314,8 +314,8 @@ void usage(char **argv)
 	p = basename(arg);
 
 	printf("\n"
-	       "%s version %s\n\n"
-	       "usage:\n", p, VERSION_STRING);
+	       "%s version %s (%s)\n\n"
+	       "usage:\n", p, VERSION_STRING, VERSION_GIT);
 
 	if (argv[1])
 		help = find_help(argv[1]);
-- 
2.20.1

