Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC76C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E79D4610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhHSEEZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSEEZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:04:25 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59ED0610FA;
        Thu, 19 Aug 2021 04:03:49 +0000 (UTC)
Date:   Thu, 19 Aug 2021 00:03:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] tracing: Add a probe that attaches to trace
 events
Message-ID: <20210819000342.615e68c7@oasis.local.home>
In-Reply-To: <20210819125652.bb6b980cf0ef04e0158bc564@kernel.org>
References: <20210817034255.421910614@goodmis.org>
        <20210817035028.190000494@goodmis.org>
        <20210819112920.a2fbfdc812967c2743953fd0@kernel.org>
        <20210818233757.686cd7c8@oasis.local.home>
        <20210819125652.bb6b980cf0ef04e0158bc564@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Aug 2021 12:56:52 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > static bool find_event_probe(const char *group, const char *event)
> > {
> > 	struct dyn_event *ev;
> > 	struct trace_eprobe *ep;
> > 
> > 	for_each_dyn_event(ev) {
> > 		if (ev->ops != &eprobe_dyn_event_ops)
> > 			continue;
> > 		
> > 		ep = to_trace_eprobe(ev);
> > 		if (strcmp(ep->tp.event->class.system, group) == 0 &&
> > 		    strcmp(ep->tp.event->call.name, event) == 0)
> > 			return true;
> > 	}
> > 	return false;
> > }  
> 
> Yeah, but I think this should be done with event_mutex, shouldn't it?

Probably. I noticed that it was updated under the dyn_event_ops_mutex,
and thought that was enough protection. But I now see the lockdep
assert on the event_mutex in the other functions.

Is there ever a case where this list is updated without
dyn_event_ops_mutex held?

-- Steve
