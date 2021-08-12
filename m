Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CEEC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 18:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D49761077
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 18:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhHLSoe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhHLSoe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 14:44:34 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BDCA6103A
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 18:44:08 +0000 (UTC)
Date:   Thu, 12 Aug 2021 14:44:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove -d option from libtracefs-sql sqlhist
 example
Message-ID: <20210812144401.3a5a5499@oasis.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The sqlhist example code does not delete the synthetic event, and the -d
option is ignored. It was added by mistake from copying from other example
code.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 91c99d7..35ccaf5 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -309,7 +309,6 @@ static void usage(char **argv)
 		"  -n name - name of synthetic event 'Anonymous' if left off\n"
 		"  -t dir - use dir instead of /sys/kernel/tracing\n"
 		"  -e - execute the commands to create the synthetic event\n"
-		"  -d - delete the synthetic event that would be created\n"
 		"  -f file - read sql lines from file otherwise from the command line\n"
 		"            if file is '-' then read from standard input.\n",
 		argv[0]);
@@ -383,7 +382,7 @@ int main (int argc, char **argv)
 	int i;
 
 	for (;;) {
-		c = getopt(argc, argv, "ht:f:edn:");
+		c = getopt(argc, argv, "ht:f:en:");
 		if (c == -1)
 			break;
 
-- 
2.31.1

