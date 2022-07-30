Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C797C19F2B
	for <linux-trace-devel@archiver.kernel.org>; Sat, 30 Jul 2022 00:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiG3Ayw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiG3Ayw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 20:54:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ECE72EF6
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 17:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5590EB82A26
        for <linux-trace-devel@vger.kernel.org>; Sat, 30 Jul 2022 00:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B5FC433C1;
        Sat, 30 Jul 2022 00:54:47 +0000 (UTC)
Date:   Fri, 29 Jul 2022 20:54:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Do not use instance from trace context
Message-ID: <20220729205438.7c1932dd@rorschach.local.home>
In-Reply-To: <CAK-6q+g2q4drxRC=5075Oy2Qh2C1pszF9fC1gRi0O90JJ49YPw@mail.gmail.com>
References: <20220729040116.175015-1-tz.stoyanov@gmail.com>
        <20220729165048.77f03fc7@rorschach.local.home>
        <CAK-6q+g2q4drxRC=5075Oy2Qh2C1pszF9fC1gRi0O90JJ49YPw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Jul 2022 17:48:08 -0400
Alexander Aring <aahringo@redhat.com> wrote:

> >
> > Bah, I kept getting confused by when to use instance vs ctx->instance,
> > and I guess I messed this one up.  
> 
> I tested it and it seems to fix the problem..., so if it's not to late:
> 
> Tested-by: Alexander Aring <aahringo@redhat.com>

Not too late. I haven't downloaded the patch from patchwork yet (nor my
other patches).

> 
> I am not sure what I should expect from the PTP time synchronization
> over IP capable interfaces (it never worked for me) but I need to say
> it is significantly slower than kvm time synchronization with vsock
> and I am using only virtual interfaces. On the agents I get a couple
> of:

Well, kvm time synchronization doesn't do much between the host and
guest. And I'm looking at making it do even less. That's because the
kvm synchronization is just "read the offset and shift of the guest
from the host and do the calculations via the reader (trace-cmd
report or kernelshark)". But the P2P is sending packets back and forth
between the host and guest and trying to figure out the round trip
latency.

> 
> CPU 1: 787 events lost
> CPU 5: 3059 events lost
> ...
> 
> the result looks to me like garbage too, my lock states do not make
> any sense...(maybe related due the events lost?)

This should be investigated.

> 
> However I think we should move this discussion to bugzilla?
> 

Sure.

-- Steve
