Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB16C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95E3A6135D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhDZPcI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233674AbhDZPcH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:32:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2847E6135A;
        Mon, 26 Apr 2021 15:31:25 +0000 (UTC)
Date:   Mon, 26 Apr 2021 11:31:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210426113123.3aae06c4@gandalf.local.home>
In-Reply-To: <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
        <20210422154830.52f3e4f5@gandalf.local.home>
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
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 18:02:58 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > As it was thread 129042 that called kvm_entry, it's the thread that is
> > mapped to vcpu 0 of the guest we are tracing.  
> 
> For a complete mapping, some handshake logic should be implemented -
> to force the guest to use all its CPUs, and to ensure we have the
> mapping for each vCPU.

Don't we already run something on all threads? Or do we not do that for the
KVM sync?

> The other approach could be to look in /proc - the relation between
> KVM thread 129042 and the VM process is there.

What would you be looking for?

-- Steve
