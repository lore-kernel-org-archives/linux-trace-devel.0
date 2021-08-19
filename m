Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA919C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2DFE610E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhHSE3P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSE3O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DDE3610F7;
        Thu, 19 Aug 2021 04:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629347319;
        bh=p9NzOxCV/btEU+5yS82CIhibr0aCy/0hTSORrFFPbls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFj7qkNCf5bJ+QYIegctpyVLrpZlPcyf7PoTOF/NthuJgPHWDreomqygw3+5982g3
         2MxS1fiIwmSDaBWrUMXmBGJS1qFbOvsgbKFrln1MRi17K88JehU2UlTtm8nKNdu69E
         NWDOoI7CCSEDKVqe63pWrh/1yI7YfIAnGIwLxMNmYlilowt3fO6tI0EpfF3O63gs4j
         DYhu9qur85+dtNf2LyAqvjOw6Og7SoHTbqV3zI26PEakbiyeeN4pq0+USnjiodmkTS
         Xfq33q33/DCvke6FGRy9tjTIVffmQI/SO3+8R97tf6z5G1ookDBnI9sf+JSDPHjGGH
         Sl+TXf53Latrg==
Date:   Thu, 19 Aug 2021 13:28:36 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 7/7] tracing: Add a probe that attaches to trace
 events
Message-Id: <20210819132836.fb3b0eb399971c37a05606dd@kernel.org>
In-Reply-To: <20210819000342.615e68c7@oasis.local.home>
References: <20210817034255.421910614@goodmis.org>
        <20210817035028.190000494@goodmis.org>
        <20210819112920.a2fbfdc812967c2743953fd0@kernel.org>
        <20210818233757.686cd7c8@oasis.local.home>
        <20210819125652.bb6b980cf0ef04e0158bc564@kernel.org>
        <20210819000342.615e68c7@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Aug 2021 00:03:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 19 Aug 2021 12:56:52 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > static bool find_event_probe(const char *group, const char *event)
> > > {
> > > 	struct dyn_event *ev;
> > > 	struct trace_eprobe *ep;
> > > 
> > > 	for_each_dyn_event(ev) {
> > > 		if (ev->ops != &eprobe_dyn_event_ops)
> > > 			continue;
> > > 		
> > > 		ep = to_trace_eprobe(ev);
> > > 		if (strcmp(ep->tp.event->class.system, group) == 0 &&
> > > 		    strcmp(ep->tp.event->call.name, event) == 0)
> > > 			return true;
> > > 	}
> > > 	return false;
> > > }  
> > 
> > Yeah, but I think this should be done with event_mutex, shouldn't it?
> 
> Probably. I noticed that it was updated under the dyn_event_ops_mutex,
> and thought that was enough protection. But I now see the lockdep
> assert on the event_mutex in the other functions.
> 
> Is there ever a case where this list is updated without
> dyn_event_ops_mutex held?

dyn_event_ops_mutex is for the "dyn_event_ops_list" which manages
the list of "struct dyn_event_operations" (e.g. kprobe, uprobe, synthetic).

In kernel/trace/trace_dynevent.c, you can see,

/* Protected by event_mutex */
LIST_HEAD(dyn_event_list);

:)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
