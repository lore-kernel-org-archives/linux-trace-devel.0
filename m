Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE87EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD77D610E5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKBN1y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231176AbhKBN1r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 09:27:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A73610D2;
        Tue,  2 Nov 2021 13:25:12 +0000 (UTC)
Date:   Tue, 2 Nov 2021 09:25:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 01/12] libtracefs: Add new internal APIs for dynamic
 events
Message-ID: <20211102092510.63bcf875@gandalf.local.home>
In-Reply-To: <CAPpZLN58N_B+WjoDHbSnD0xG-s6tOY49SdKFHNqohzPUVKybZw@mail.gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
        <20211101090904.81454-2-tz.stoyanov@gmail.com>
        <6eb04d9b-54f5-77a6-1be8-adea54e710cf@gmail.com>
        <CAPpZLN58N_B+WjoDHbSnD0xG-s6tOY49SdKFHNqohzPUVKybZw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Nov 2021 06:33:36 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > > +
> > > +#define DYNEVENTS_EVENTS "dynamic_events"
> > > +#define KPROBE_EVENTS "kprobe_events"  
> >
> > A definition of KPROBE_EVENTS already exists in /utest/tracefs-utest.c and src/tracefs-kprobes.c
> >
> > Isn't better to move the whole group of definitions of filenames to include/tracefs-local.h?  
> 
> The unit test should use only the official library API, defined in
> tracefs.h. We could move these defines in the official API header, but
> I think these should be internal to the library.

Agreed. In fact, if one day the name changes (which is highly unlikely) we
want the unit tests to fail on that ;-)

-- Steve
