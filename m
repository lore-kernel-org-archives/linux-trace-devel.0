Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81721C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 20:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B17B218AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 20:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732645AbfISUvW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 16:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfISUvV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 16:51:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D983C208C0;
        Thu, 19 Sep 2019 20:51:20 +0000 (UTC)
Date:   Thu, 19 Sep 2019 16:51:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH] tools/lib/traceevent: Round up in tep_print_event() time
 precision
Message-ID: <20190919165119.5efa5de6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
 tools/lib/traceevent/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index bb22238debfe..eb84fbb49e4d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5517,8 +5517,10 @@ static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
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

