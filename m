Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FFBC4CED2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29F921881
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfIRCFc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF54D214AF
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLX-0000sT-32
        for linux-trace-devel@vger.kernel.org; Tue, 17 Sep 2019 22:05:31 -0400
Message-Id: <20190918020530.974032887@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] tools/lib/traceevent: Round up in tep_print_event() time precision
References: <20190918020334.344561631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When testing the output of the old trace-cmd compared to the one that uses
the updated tep_print_event() logic, it was different in that the time stamp
precision in the old format would round up to the nearest precision, where
as the new logic truncates. Bring back the old method of rounding up.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index d1085aab9c43..7fbbbccab78a 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5527,8 +5527,10 @@ static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
 	if (divstr && isdigit(*(divstr + 1)))
 		div = atoi(divstr + 1);
 	time = record->ts;
-	if (div)
+	if (div) {
+		time += div / 2;
 		time /= div;
+	}
 	pr = prec;
 	while (pr--)
 		p10 *= 10;
-- 
2.20.1


