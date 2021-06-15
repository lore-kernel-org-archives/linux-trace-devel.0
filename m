Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD89BC48BE5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jun 2021 15:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C01306148E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jun 2021 15:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhFOQAq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 12:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233170AbhFOP7p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 11:59:45 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 263A6608FE;
        Tue, 15 Jun 2021 15:57:40 +0000 (UTC)
Date:   Tue, 15 Jun 2021 11:57:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Philippe Proulx <pproulx@efficios.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [lttng-dev] Usage example of libbabeltrace (babeltrace2) to
 read CTF traces from a GUI
Message-ID: <20210615115738.46818ace@oasis.local.home>
In-Reply-To: <CAB4xu_1H-4gdandyRx+F0nb1g+sLKatx=oJdzQspM+3hJXoYhA@mail.gmail.com>
References: <1119833442.5505.1623700847146.JavaMail.zimbra@efficios.com>
        <CAB4xu_1H-4gdandyRx+F0nb1g+sLKatx=oJdzQspM+3hJXoYhA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ Adding linux-trace-devel too ]

On Tue, 15 Jun 2021 11:13:41 -0400
Philippe Proulx <pproulx@efficios.com> wrote:

> On Mon, Jun 14, 2021 at 4:01 PM Mathieu Desnoyers via lttng-dev
> <lttng-dev@lists.lttng.org> wrote:
> >
> > Hi Philippe, Hi Jeremie,
> >
> > Steven is interested to use libbabeltrace as a CTF trace reader in the KernelShark
> > project. It's a GUI which shows Linux kernel traces.
> >
> > He notices that most of the documented usage examples of the libbabeltrace API
> > focus on use-cases where a custom trace format is converted into CTF.
> >
> > I know that the babeltrace2 program is the main user of libbabeltrace at this
> > point, and that it reads CTF as source.
> >
> > For using libbabeltrace as CTF reader for a GUI, what would be the best examples
> > to look at as starting point ? Perhaps the babeltrace2 binary, or just adapt a
> > smaller example program and change the custom trace format source to "ctf.fs" ?
> > Or anything else ?  
> 
> Hello,
> 
> Unfortunately, the Babeltrace 2 C API documentation [1] doesn't offer a
> graph building example at the moment.
> 
> Therefore, indeed, the "best" example would be the babeltrace2(1) CLI
> (see `src/cli`), although I understand that it's a very generic example
> which can be overwhelming to explore.
> 
> However, note that instead of instantiating an existing sink component
> class (as found in a plugin), you'll want to make your own sink
> component class to get access to each event message while also
> controlling the graph operations. Using
> bt_graph_add_simple_sink_component() [2] would be a good start.
> 
> I can cook a minimal working example in the following days.

That would be great, thanks!

-- Steve

> 
> Phil
> 
> [1]: https://babeltrace.org/docs/v2.0/libbabeltrace2/
> [2]: https://babeltrace.org/docs/v2.0/libbabeltrace2/group__api-graph.html#gaa8432f03a967d01b764fb1bc959c8e89
> 
> >
> > Thanks,
> >
> > Mathieu
> >
> > --
> > Mathieu Desnoyers
> > EfficiOS Inc.
> > http://www.efficios.com
> > _______________________________________________
> > lttng-dev mailing list
> > lttng-dev@lists.lttng.org
> > https://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev  

