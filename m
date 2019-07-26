Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B351C7618F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 21:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10E5E22C7E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 21:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGZVAF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 17:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfGZVAF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 17:00:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054D022BE8;
        Fri, 26 Jul 2019 21:00:03 +0000 (UTC)
Date:   Fri, 26 Jul 2019 17:00:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20190726170002.13bbfbf5@gandalf.local.home>
In-Reply-To: <20190726205544.yffnsfsnji362jk7@alap3.anarazel.de>
References: <20181005122225.522155df@gandalf.local.home>
        <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
        <20190726091200.0d1e1f01@gandalf.local.home>
        <20190726205544.yffnsfsnji362jk7@alap3.anarazel.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Jul 2019 13:55:44 -0700
Andres Freund <andres@anarazel.de> wrote:

> How about my proposal to instead change the loops in
> trace-event-{python,perl}.c, the only callers of trace_find_next_event,
> to be something akin to
> 
> [idx_type_for_tep_get_event] event_count = tep_get_events_count(pevent);
> for ([idx_type_for_tep_get_event] idx = 0; idx < event_count; idx++)
> {
> 	struct tep_event *event = tep_get_events(...);
> 
> }
> 
> and just removing trace_find_next_event()? It's not a nice API imo, and
> seems unnecessary given that the events aren't a linked list anymore.

Yep, go for it :-)


> 
> 
> > Care to send a formal patch?  
> 
> Will do.

Thanks!

-- Steve
