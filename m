Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A01C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1994661352
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFVNYP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 09:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229835AbhFVNYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 09:24:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4DC6113E;
        Tue, 22 Jun 2021 13:21:58 +0000 (UTC)
Date:   Tue, 22 Jun 2021 09:21:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 06/40] trace-cmd: Add APIs for library initialization
 and free
Message-ID: <20210622092157.2f24f062@gandalf.local.home>
In-Reply-To: <CAPpZLN4ehDqxqeqSFraDCqb8BFF9LFynjcym-PzQJk=iBwAOBw@mail.gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
        <20210610113426.257931-7-tz.stoyanov@gmail.com>
        <20210621212711.4f7469bc@oasis.local.home>
        <CAPpZLN4ehDqxqeqSFraDCqb8BFF9LFynjcym-PzQJk=iBwAOBw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Jun 2021 09:41:20 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> I was missing that API when I worked on the host-guest time synch
> algorithms, to initialize the library time synchronization context. I
> decided to introduce a new API, for initializing only that part of the
> library - tracecmd_tsync_init(), as this functionality will not be
> used commonly. Now with the compression changes, there is a need for
> an API for initializing the library compression context. As this

I don't see that, but I'll reply to the other email on my thoughts there.

> functionality will be used in almost all use cases, I think it makes
> sense to introduce this global tracecmd_lib_init() API, instead of
> something like  tracecmd_lib_compression_init(). Personally I do not
> like the approach to have init APIs for different parts of the
> library, especially in case of widely used functionality. This will
> complicate the usage and will force the users to know the library
> internals. I would even suggest to remove the tracecmd_tsync_init()
> API and to init time sync context in the tracecmd_lib_init().

The tsync_init() is a specific functionality and only for recording, but a
lib_init() sounds very generic, and something that needs to be run if
needed or not.

I still don't see the need for it.

-- Steve
