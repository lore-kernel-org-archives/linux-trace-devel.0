Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99502C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA1061175
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhDZPu7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233829AbhDZPu6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:50:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C76B6135D;
        Mon, 26 Apr 2021 15:50:16 +0000 (UTC)
Date:   Mon, 26 Apr 2021 11:50:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210426115014.34db8808@gandalf.local.home>
In-Reply-To: <f7b417bf1604145b216156036d06f93585f7316d.camel@suse.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
        <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
        <20210422160313.2eee1f77@gandalf.local.home>
        <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
        <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
        <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
        <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
        <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
        <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
        <20210426084408.581364d9@gandalf.local.home>
        <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
        <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
        <20210426105111.288280bb@gandalf.local.home>
        <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
        <f7b417bf1604145b216156036d06f93585f7316d.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 17:38:09 +0200
Dario Faggioli <dfaggioli@suse.com> wrote:

> Yeah, that was kind of my point. Any VMEnter, from any of the vCPUs
> will give us a PID, the one of a vCPU thread. From that PID, we can
> look up the PID of the process that created the vCPU (although, I don't
> know how, except scanning).

But that's implementation specific to the creation of the VM. Can we rely
on that?

> 
> With the PID of the creating process you can tell (e.g., still from
> /proc) the number of the vm-fd, and we have everything to reach TSC
> offsets in debugfs... Isn't that so?

I'm not sure what you mean here.

> 
> What about the vhost cid and port? If they're on the command line (as
> they are for QEMU), of course we have them in /proc too. IDK if crossvm
> (and other VMMs) also have them on the  command line, though.

If possible, I'd like to avoid parsing cmdlines. We can do that for now if
the user uses libvirt and just passes the name of the guest:

 -A Fedora21

But if you pass the vsock id:

 -A guest@3:823

then all bets are off, as we do not know what implementation is running the
guest. The most robust way would be to use the trace events of the sched
wake ups as I mentioned. This way, when trace-cmd talks with the guest
agent, we can follow the wake ups and find which thread is communicating
with the guest on behalf of trace-cmd. This removes all reliance on the
user space implementation.

BTW, when checking wake ups, you need to ignore any wake up that is done in
an interrupt. As those may not be related to the communication to the guest.

-- Steve
