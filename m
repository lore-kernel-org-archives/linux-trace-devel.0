Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F362CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 21:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiCNVib (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 17:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbiCNVi3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 17:38:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245D3E0E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 14:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFFFD61314
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 21:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D598C340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 21:37:16 +0000 (UTC)
Date:   Mon, 14 Mar 2022 17:37:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd agent: Move becoming daemon after prints and
 errors
Message-ID: <20220314173714.01f226d6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When starting the agent in daemon mode, it should be done after the
connections to the vsocket, so that it can not only show the user what
port it is connected to, but also show any errors that may happen.

Once the task becomes a daemon, it will no longer print its error messages
or normal information to the console. Thus any errors that happen after
the daemon is running will go unnoticed.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-agent.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index b83d3ac1338f..a46feea3d3c7 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -236,7 +236,7 @@ static pid_t do_fork()
 	return fork();
 }
 
-static void agent_serve(unsigned int port)
+static void agent_serve(unsigned int port, bool do_daemon)
 {
 	int sd, cd, nr_cpus;
 	unsigned int cid;
@@ -255,6 +255,9 @@ static void agent_serve(unsigned int port)
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
+	if (do_daemon && daemon(1, 0))
+		die("daemon");
+
 	for (;;) {
 		cd = accept(sd, NULL, NULL);
 		if (cd < 0) {
@@ -335,8 +338,5 @@ void trace_agent(int argc, char **argv)
 	if (optind < argc-1)
 		usage(argv);
 
-	if (do_daemon && daemon(1, 0))
-		die("daemon");
-
-	agent_serve(port);
+	agent_serve(port, do_daemon);
 }
-- 
2.35.1

