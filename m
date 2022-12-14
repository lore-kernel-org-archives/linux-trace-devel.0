Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1168C10F1B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 03:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiLNDRM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 22:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbiLNDQ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 22:16:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A4A27928
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 19:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26B0EB8163A
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 03:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD03C433EF;
        Wed, 14 Dec 2022 03:16:53 +0000 (UTC)
Date:   Tue, 13 Dec 2022 22:16:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas Raillard <douglas.raillard@arm.com>,
        Valentin Schneider <vschneid@redhat.com>
Subject: [PATCH] libtraceevent: Calculate dynamic size for dynamic fields as
 well as arrays
Message-ID: <20221213221651.0d36897a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From 3a1c06828b67a31de01491a400fdc20674a0f95f Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Tue, 13 Dec 2022 22:14:22 -0500
Subject: [PATCH] libtraceevent: Calculate dynamic size for dynamic fields as
 well as arrays

With the new "cpumask_t" field, which is dynamic and is denoted with
"__data_loc", it needs to be processed as dynamic in size, and not as
static.

When calculating the field size, check for both the field being an array
as well as being dynamic, as it can be dynamic without being an array.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index d1363a5826d5..8ec95a2ac069 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1927,7 +1927,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 		free_token(token);
 
-		if (field->flags & TEP_FIELD_IS_ARRAY) {
+		if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC)) {
 			if (field->arraylen)
 				field->elementsize = field->size / field->arraylen;
 			else if (field->flags & TEP_FIELD_IS_DYNAMIC)
-- 
2.35.1

