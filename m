Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4403AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Mar 2022 15:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiCIPzG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 10:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiCIPzF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 10:55:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9718613AA21;
        Wed,  9 Mar 2022 07:54:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 022F86164F;
        Wed,  9 Mar 2022 15:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25E1C340E8;
        Wed,  9 Mar 2022 15:54:04 +0000 (UTC)
Date:   Wed, 9 Mar 2022 10:54:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org, mtosatti <mtosatti@redhat.com>
Subject: Re: Warning when exiting osnoise tracer
Message-ID: <20220309105403.66d2b6ef@gandalf.local.home>
In-Reply-To: <eeb95928-02cf-a38c-8079-d2bbf4edb7e7@kernel.org>
References: <c898d1911f7f9303b7e14726e7cc9678fbfb4a0e.camel@redhat.com>
        <eeb95928-02cf-a38c-8079-d2bbf4edb7e7@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Mar 2022 08:25:56 +0100
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> On 3/8/22 18:30, Nicolas Saenz Julienne wrote:
> > While running next-20220307, on a system with isolated CPUs (don't know if
> > relevant but less tested code-path), I see this after killing (ctrl-C) the
> > following trace command:
> > 
> > 	trace-cmd record -e all -M 10 -p osnoise --poll
> > 
> > Note that this is *without* my recent osnoise patch.  
> 
> yeah, your patch does not hit this part of the code.
> 
> > [  129.925474] ------------[ cut here ]------------

I'm surprised that my tests did not hit this.

I've been running a lot of trace-cmd tests lately (to try and release 3.0!)
and I have osnoise tracer enabled in these tests.

Hmm, it's just a warning that doesn't appear to cause any damage. I just
tried it out, and sure enough it triggered. The problem is that my
trace-cmd tests do not check dmesg :-/  Maybe I need to change that, as I
only looked at the result of the test, and because the tests spits out a
lot of noise to dmesg, I can easily miss warnings there. I'll add a test to
look for Call Traces at the end of the test.

Thanks for the report.

-- Steve
