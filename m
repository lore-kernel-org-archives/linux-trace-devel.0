Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2D1C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 12:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJUMc7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 08:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJUMc6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 08:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB522608FE;
        Fri, 21 Oct 2022 05:32:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386EF61E88;
        Fri, 21 Oct 2022 12:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E228C433D6;
        Fri, 21 Oct 2022 12:32:55 +0000 (UTC)
Date:   Fri, 21 Oct 2022 08:32:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     richard clark <richard.xnu.clark@gmail.com>
Cc:     bristot@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question about 'for_each_kernel_tracepoint(...)' function
Message-ID: <20221021083254.3c879824@rorschach.local.home>
In-Reply-To: <CAJNi4rPPDp0xeEmqMBqX-pBqgAX7Biivyd+P_zhC7Y0-K3W0VQ@mail.gmail.com>
References: <CAJNi4rM0K=-wgJrS0iLMkam77JTO7oRxcP9VkHGbuTiVGBovMA@mail.gmail.com>
        <20221020111439.76e72230@gandalf.local.home>
        <CAJNi4rMVUzfZJPge=ncaULD87wLQ4TwWS=oKDuC1hZMoWi0OjA@mail.gmail.com>
        <20221020221255.5b3dffe1@gandalf.local.home>
        <CAJNi4rPPDp0xeEmqMBqX-pBqgAX7Biivyd+P_zhC7Y0-K3W0VQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 21 Oct 2022 11:51:20 +0800
richard clark <richard.xnu.clark@gmail.com> wrote:

> On Fri, Oct 21, 2022 at 10:12 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 21 Oct 2022 09:43:14 +0800
> > richard clark <richard.xnu.clark@gmail.com> wrote:
> >
> >  
> > > Ah, as you can see that I did it, but the result is not what I
> > > expected :-). Help?  
> >
> > Looking at the code, I see it does indeed only look at builtin tracepoints.  
> 
> What the logic behind is not to implement a function like
> 'for_each_tracepoints' instead of 'for_each_kernel_tracepoint' to find
> all the TPs defined by both builtin kernel and external kernel
> modules, just like we can find all the kernel symbols and exported
> symbols from external module?

Why? It's not needed upstream. If you push your code upstream and it's
something to get accepted, then we can think about adding that.

> 
> >
> > But if you want one module to have access to the tracepoints of another,
> > then you can have the first one export it.
> >
> > EXPORT_SYMBOL_TRACEPOINT_GPL(function_event_a);
> >
> > And then module b should have access to it.
> >  
> Yes, but module b needs to register a new probe call back function for
> the new TPs defined by module a in my case, so first it needs to find
> the TPs defined by module a. Any comments?

No, because I have no idea what you are doing or why you need this.

-- Steve
