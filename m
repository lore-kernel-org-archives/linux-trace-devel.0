Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E3EC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B2D8213F2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 18:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfCSSkM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfCSSkM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 14:40:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 376C220811;
        Tue, 19 Mar 2019 18:40:11 +0000 (UTC)
Date:   Tue, 19 Mar 2019 14:40:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Matt Helsley <mhelsley@vmware.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch
 algorithm, using vsock events.
Message-ID: <20190319144009.12f56470@gandalf.local.home>
In-Reply-To: <83964D3D-EE42-46B7-871E-7716749AB87B@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
        <20190319155536.19381-10-tstoyanov@vmware.com>
        <CAE0o1NvsHhROnXesVHT08HfPO_FC3EjxXrkfqkPsF6SB=6Z2Lg@mail.gmail.com>
        <20190319135111.0061eddb@gandalf.local.home>
        <CAE0o1NtchyejDbn_xCDjDmVLmP8vRF-Gv2SZSoigbxYR1Gc2dw@mail.gmail.com>
        <83964D3D-EE42-46B7-871E-7716749AB87B@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Mar 2019 18:29:39 +0000
Matt Helsley <mhelsley@vmware.com> wrote:
> 
> Thank you! I, for one, really appreciate folks who take the time to trim the context. When I do it, I like to mark removed parts with (including newlines)
> 
> <snip>
> 
> or
> 
> <snipped>
> 
> just so everyone knows something got removed from the quoted email.


I will say that's fine, but not a requirement. I will at most do "[..]"
but most cases, I just cut it, since it is usually pretty obvious that
something was cut.

At a minimum, I make sure there's a space where a cut is. That is:

> this is some text I keep
> and this will be cut
> and this is more text

I do

> this is some text I keep

> and this is more text

Instead of:

> this is some text I keep
> and this is more text


-- Steve
