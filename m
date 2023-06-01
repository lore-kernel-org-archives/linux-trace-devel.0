Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131AFC7EE23
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jun 2023 12:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjFAMsb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 08:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjFAMsa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 08:48:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B534F123
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 05:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52344611E3
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 12:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F995C433D2;
        Thu,  1 Jun 2023 12:48:27 +0000 (UTC)
Date:   Thu, 1 Jun 2023 08:48:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH] libtraceevent: Handel printf '%+d" case
Message-ID: <20230601084823.43e68c0f@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The print prasing does not handle '%+d' and prints ">+<d" instead. The '+' is a
valid printf specifier. Make sure to handle it.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217339
Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 12c6f56..b4191eb 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5179,10 +5179,9 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 				ls = 2;
 				goto process_again;
 			case '0' ... '9':
-				goto process_again;
 			case '.':
-				goto process_again;
 			case '#':
+			case '+':
 				goto process_again;
 			case 'z':
 			case 'Z':
@@ -6443,6 +6442,7 @@ static int parse_arg_format(struct tep_print_parse **parse,
 		case '.':
 		case '0' ... '9':
 		case '-':
+		case '+':
 			break;
 		case '*':
 			/* The argument is the length. */
-- 
2.35.1

