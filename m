Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFDCC7EE25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjFGSCA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjFGSB7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 14:01:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02461FC3
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3028C639A3
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A50C433D2;
        Wed,  7 Jun 2023 18:01:57 +0000 (UTC)
Date:   Wed, 7 Jun 2023 14:01:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH v2] trace-cmd test: Quiet valgrind from reporting forked
 children
Message-ID: <20230607140153.161b43a0@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

valgrind triggers its reports when the application exits. If the application
does a fork() and the child exits, it will still trigger a report saying that
the memory that was currently allocated by the parent has leaked.

To prevent this, call execl() on a shell script that will simply exit with the
proper error code. This will keep valgrind from producing a report on the
child for the memory that is still allocated by the parent.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230607135256.41a9ab6b@gandalf.local.home/

  - test "/bin/sh" too, as not all systems have "/usr/bin/sh"

 utest/tracecmd-utest.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 34fed1e1..6ba2318e 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -131,6 +131,7 @@ static int pipe_it(int *ofd, int *efd, int (*func)(void *),
 		goto fail;
 
 	if (!pid) {
+		char shret[32];
 
 		close(obrass[0]);
 		close(STDOUT_FILENO);
@@ -143,6 +144,23 @@ static int pipe_it(int *ofd, int *efd, int (*func)(void *),
 			exit(-1);
 
 		ret = func(data);
+
+		/*
+		 * valgrind triggers its reports when the application
+		 * exits. If the application does a fork() and the child
+		 * exits, it will still trigger the valgrind report for
+		 * all the allocations that were not freed by the parent.
+		 *
+		 * To prevent valgrind from triggering, do an execl() on
+		 * a basic shell that will simply exit with the return value.
+		 * This will quiet valgrind from reporting memory that has
+		 * been allocated by the parent up to here.
+		 */
+		snprintf(shret, 32, "exit %d", ret);
+		execl("/usr/bin/sh", "/usr/bin/sh", "-c", shret, NULL);
+		execl("/bin/sh", "/bin/sh", "-c", shret, NULL);
+
+		/* If the above execl() fails, simply do an exit */
 		exit(ret);
 	}
 
-- 
2.35.1

