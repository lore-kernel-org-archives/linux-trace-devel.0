Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08533C10F1E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 20:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLOUzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOUzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 15:55:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B266590
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 12:55:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A76C9B81BAA
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 20:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB0EC433EF;
        Thu, 15 Dec 2022 20:55:36 +0000 (UTC)
Date:   Thu, 15 Dec 2022 15:55:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ian Rogers <irogers@google.com>
Subject: [PATCH] libtracefs: Remove unneeded check of !dynevent in
 dynevent_info()
Message-ID: <20221215155534.1616b67a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The compiler was complaining about undefined behavior because
dynevent_info() was accessing the address of &dynevent->system and later
doing a if (!dynevent). But this was fixed by creating a wrapper function
that does the checks and then passes the information to this function.

But that commit forgot to remove the check of !dynevent leaving the
compiler to believe that it can still be NULL and that the undefined
behavior of &dynevent->system still exists.

Remove the if statement and make everyone happy.

Link: https://lore.kernel.org/linux-trace-devel/20221215140203.103faf50@gandalf.local.home/

Reported-by: Ian Rogers <irogers@google.com>
Fixes: aff006d4af0c7 ("libtracefs: Do not initialize with NULL offsets")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-dynevents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 48bb26a96c58..7a3c45ce25a3 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -713,9 +713,6 @@ dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 			&dynevent->address, &dynevent->format };
 	int i;
 
-	if (!dynevent)
-		return TRACEFS_DYNEVENT_UNKNOWN;
-
 	for (i = 0; i < ARRAY_SIZE(lv); i++) {
 		if (lv[i]) {
 			if (*rv[i]) {
-- 
2.35.1

