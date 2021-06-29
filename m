Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32114C11F64
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A7E861D02
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhF2C2h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhF2C2h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 22:28:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E146861CEF;
        Tue, 29 Jun 2021 02:26:10 +0000 (UTC)
Date:   Mon, 28 Jun 2021 22:26:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd split: Fix off-by-one error when calculating
 record len
Message-ID: <20210628222609.01ea12ad@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When a record has 112 or fewer bytes (28 * 4) for size, it has a 4 byte
record that contains 5 bits for the size of the event divided by 4, and 27
bits for the time delta. (0, 29, 30 31 are special values for those 5
bits.

The split logic recreates the record header for each event it copies over
from the source trace file to the destination trace file. To decide the
header, it incorrectly checked for "less than" instead of "less than or
equal to" of size "28 * 4". This caused the copying of the event to add
the extended header.

The issue happened, because of the added 4 bytes, it ended up overwriting
the end of the page. The "\0" ended at the edge and was cut off.
(There should be a better check for this as well).

Fix the header check to use the compact header for 112 byte events.

Fixes: 87d2a344a ("trace-cmd: Add split feature")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 233feb89..9b1a8d7a 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -106,7 +106,7 @@ static int write_record(struct tracecmd_input *handle,
 		return 0;
 	}
 
-	if (record->size && (record->size < 28 * 4))
+	if (record->size && (record->size <= 28 * 4))
 		len = record->size / 4;
 
 	time = (unsigned)diff;
-- 
2.29.2

