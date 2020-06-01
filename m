Return-Path: <SRS0=rFKH=7O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8896C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 18:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD97D207D0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 18:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgFASgr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 14:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgFASgq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 14:36:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6602073B;
        Mon,  1 Jun 2020 18:36:44 +0000 (UTC)
Date:   Mon, 1 Jun 2020 14:36:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>
Cc:     linux-trace-devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Ftrace plugin for Babeltrace2
Message-ID: <20200601143643.7f30b068@oasis.local.home>
In-Reply-To: <2053437111.45156.1591029910431.JavaMail.zimbra@efficios.com>
References: <2053437111.45156.1591029910431.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 1 Jun 2020 12:45:10 -0400 (EDT)
Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:

> Hi everyone,
> 
> 
> My name is Philippe and I am an intern at EfficiOs for the summer. This email is

Hi Philippe!

I believe we met before. Correct me if I'm wrong.

> 
> to inform you about my summer project, ask for recommendations and your opinion.
> 
> 
> My project will consist of implementing a Babeltrace2 [1] plugin to be able to consume
> 
> ftrace traces. The plugin will act as a source component in the babeltrace2 graph system.

This is awesome!

> 
> 
> I was wondering if you can give me your first thoughts about this project, and
> 
> any advice on where to find information to begin with, since I am new to ftrace.
> 
> I have already read the doc [2][3][4], but I was wondering if there are more resources
> 
> that could help me with my work.
> 
> 
> Also, I was wondering which version of libtraceevent I should use. The one in the kernel,
> 
> or the one in the trace-cmd repo? My guess would be to take the one in trace-cmd since
> 
> there are more recent commits, but I am asking just to make sure.

Well it shouldn't matter, as I try to keep the two insync, but because
of the current environment (COVID-19 and all), I've been falling behind.

There's talk in moving it out of both the kernel and trace-cmd and make
libtraceevent a stand alone library. But that will take some
coordination.

> 
> 
> The major focus of the project will be to match ftrace concepts to babeltrace 2
> 
> internal representation.
> 
> 
> [1] https://babeltrace.org/
> 
> [2] https://github.com/torvalds/linux/tree/master/tools/lib/traceevent/Documentation
> 
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/tree/Documentation
> 
> [4] https://www.kernel.org/doc/Documentation/trace/ftrace.txt
> 


Ideally, we would like to get KernelShark to use babeltrace as well, to
increase what it can read.

Thanks for reaching out. If there's anything else you need, please feel
free to ask.

-- Steve
