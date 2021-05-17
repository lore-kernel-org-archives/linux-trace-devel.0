Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DA9C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 12:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AE96100C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 12:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhEQM4B convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 08:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhEQM4B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 08:56:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968316100C;
        Mon, 17 May 2021 12:54:44 +0000 (UTC)
Date:   Mon, 17 May 2021 08:54:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/7] Final fixes before KS 2.0
Message-ID: <20210517085442.6be8723f@gandalf.local.home>
In-Reply-To: <1edacb8d-3ad3-73c4-fdd5-09baa908d404@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
        <20210514140109.5615e1a2@gandalf.local.home>
        <1edacb8d-3ad3-73c4-fdd5-09baa908d404@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 May 2021 13:22:34 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 14.05.21 г. 21:01, Steven Rostedt wrote:
> > On Fri, 14 May 2021 15:18:19 +0300
> > "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> >   
> >> Yordan Karadzhov (VMware) (7):
> >>    kernel-shark: Preserve markers when appending data
> >>    kernel-shark: Preserve open graphs when appending data
> >>    kernel-shark: Clear before loading new session
> >>    kernel-shark: Better handling of plugins when appending data file
> >>    kernel-shark: Do draw the combo point of the mark
> >>    kernel-shark: Check if "trace_seq" was destroyed before using it
> >>    kernel-shark: Quiet the warning printing from libtraceevent
> >>
> >>     
> > 
> > After applying and testing out this patch set, I realized that the appended
> > file does not have any of its CPUs plotted after it is loaded.  
> 
> Yes, this is how it works right now. No new plots are added when you 
> append trace file.
> 
> Do you think it will be to show all CPU plots from the new trace file?
> 

Yeah, I think it is better to see something than nothing.

I don't think there's an issue with showing it. Although, if you could
automate the kvm combo to be selected by default on appending a file, then
you wouldn't need to show the cpu plots of the guest.

-- Steve
