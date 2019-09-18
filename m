Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFFBC4CECD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 223DF218AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 02:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfIRCFb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 22:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfIRCFb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 22:05:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30AD3214AF
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 02:05:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iAPLW-0000q0-97
        for linux-trace-devel@vger.kernel.org; Tue, 17 Sep 2019 22:05:30 -0400
Message-Id: <20190918020334.344561631@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 17 Sep 2019 22:03:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] trace-cmd: Update for the new trace_print_event() logic
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Porting over Tzvetomir's trace_print_event() logic to trace-cmd, I found
that it required some restructuring of the code. This was a quick work to
get it working. Please take a look at it as I probably screwed something up
(while jetlag and also doing this along with other things in parallel).

Steven Rostedt (VMware) (4):
      trace-cmd: Move extract trace_clock into trace-input.c
      trace-cmd: Separate out time diff code in trace_show_data()
      trace-cmd: Add check for trace_clock using usecs into tracecmd_parse_trace_clock()
      tools/lib/traceevent: Round up in tep_print_event() time precision

Tzvetomir Stoyanov (1):
      libtraceevent, perf tools: Changes in tep_print_event_* APIs

----
 include/trace-cmd/trace-cmd.h      |   4 +-
 include/traceevent/event-parse.h   |  29 ++--
 lib/trace-cmd/trace-input.c        |  41 ++++-
 lib/trace-cmd/trace-util.c         |  27 ----
 lib/traceevent/event-parse-api.c   |  40 -----
 lib/traceevent/event-parse-local.h |   4 -
 lib/traceevent/event-parse.c       | 324 +++++++++++++++++++++----------------
 tracecmd/trace-read.c              |  85 ++++++----
 8 files changed, 298 insertions(+), 256 deletions(-)
