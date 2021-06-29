Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB30C11F64
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF4661D0B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2CnK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhF2CnK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:10 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD4561D13;
        Tue, 29 Jun 2021 02:40:43 +0000 (UTC)
Date:   Mon, 28 Jun 2021 22:40:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd split: Assert if the calculated record size is
 too big
Message-ID: <20210628224042.0ecc2030@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

With a discovery of a bug that caused a record to be written passed the
end of a page (and this was a possible memory corruption bug), check that
the calculated length is no bigger than the record it is copying. If it
is, then crash, as this can cause the data to write pass the allocated
page.

Now that bug would crash on the split command with:

  Bad calculation of record len (expect:116 actual:120)

Link: https://lore.kernel.org/linux-trace-devel/20210628222609.01ea12ad@oasis.local.home/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 9b1a8d7a..775611c1 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -118,6 +118,9 @@ static int write_record(struct tracecmd_input *handle,
 
 	if (!len) {
 		len = record->size + 4;
+		if ((len + 4) > record->record_size)
+			die("Bad calculation of record len (expect:%d actual:%d)",
+			    record->record_size, len + 4);
 		*(unsigned *)ptr = tep_read_number(pevent, &len, 4);
 		ptr += 4;
 		index += 4;
-- 
2.29.2

