Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2045C282C2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B496221773
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D792084D;
        Mon, 11 Feb 2019 01:21:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92-RC5)
        (envelope-from <rostedt@goodmis.org>)
        id 1gt0ID-0003vY-P9; Sun, 10 Feb 2019 20:21:53 -0500
Message-Id: <20190211011807.714634783@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 10 Feb 2019 20:18:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/4] kernel-shark: Add sched_waking event for sched plugin processing
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

I was using kernel shark to examine vsock events, and noticed that when I
only enabled sched_waking events, it did not give me the wake up boxes in
the task plots. I decided to look at the code and modify it to handle it.

When doing that, I noticed that the "success" field of the event was being
used. This is an obsolete field that will hopefully someday be removed. So I
added a patch to remove that. I also did not want to just add cut and paste
code to add the sched_waking, and instead made helper functions to process
the events all the same. And finally, I added the sched_waking code.

Can you review these patches and if they are fine by you, give your
"Reviewed-by" tag. Otherwise let me know if there's an issue that I should
fix.

Thanks!

-- Steve



Tag SHA1: 746c45bb20a4c860d36c48d279286c67202248a0
Head SHA1: 746c45bb20a4c860d36c48d279286c67202248a0


Steven Rostedt (VMware) (4):
      kernel-shark: Remove testing of "success" field of wakeup events
      kernel-shark: Consolidate duplicate code of the sched_wakeup events
      kernel-shark: Remove plugin_get_rec_wakeup_pid()
      kernel-shark: Add sched_waking event processing to sched_waking

----
 kernel-shark/src/plugins/sched_events.c | 147 +++++++++++++++-----------------
 kernel-shark/src/plugins/sched_events.h |  12 ++-
 2 files changed, 76 insertions(+), 83 deletions(-)
