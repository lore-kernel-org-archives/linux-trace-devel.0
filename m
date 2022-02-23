Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECDBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 04:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiBWEVP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbiBWEVO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 23:21:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2244C7B2
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 20:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 697D36090C
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 04:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80895C340E7
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 04:20:46 +0000 (UTC)
Date:   Tue, 22 Feb 2022 23:20:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Use tracefs_warning() for tracefs_sql() errors
Message-ID: <20220222232045.129e3b6c@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of hard coding fprintf() into the library, use tracefs_warning()
to allow the application control the output.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 016f3eb23725..ac4903c4d346 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -134,7 +134,7 @@ __hidden void sql_parse_error(struct sqlhist_bison *sb, const char *text,
 
 	trace_seq_init(&s);
 	if (!s.buffer) {
-		fprintf(stderr, "Error allocating internal buffer\n");
+		tracefs_warning("Error allocating internal buffer\n");
 		return;
 	}
 
@@ -1097,7 +1097,7 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
 	case FILTER_BIN_AND:	cmp = TRACEFS_COMPARE_AND; break;
 	case FILTER_STR_CMP:	cmp = TRACEFS_COMPARE_RE; break;
 	default:
-		fprintf(stderr, "Error invalid filter type '%d'", filter->type);
+		tracefs_warning("Error invalid filter type '%d'", filter->type);
 		return ERANGE;
 	}
 
-- 
2.34.1

