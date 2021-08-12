Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34E1C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 15:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1E036103A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 15:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhHLPH1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 11:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232351AbhHLPH0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 11:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E137D6044F;
        Thu, 12 Aug 2021 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628780821;
        bh=XmC/v8fVf6n7JtViHjG801eSHPt0/24C/EjG3TQ/RJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cbqADnnCUks4q+pfDCiAwsKjcs+jKFV2htk7CKHjCv6rOu+APnC7IG80Rk6jX2Iuj
         tgYiR40R3RRfG2rRCAUwHSQX87Qs5pRcM6kHokCXUmg/ydVCgjycsQ3qUPoxayksJk
         qDxOM70CXS/oAo21jaUWbOny9uqnjHtZaQKJxf4rDjoakGuj0WCFqAX9wyDCx7qleY
         rJltz+jT7u7Dmk8TGycfBrgl5KY75bpUj6z8F128Vfv3kHJOnAi6VPE4dlBmDM+acV
         I7L5OCga2h4mOccvWxyGdBn1LD5ntXbzEIQMvmMPJt/W5lS9/r+30NhqCjP4jekWxe
         eAFJeuDTErMkg==
Date:   Fri, 13 Aug 2021 00:06:59 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210813000659.48eafbcfeeaa30adcc8a5363@kernel.org>
In-Reply-To: <20210812094439.56303efa@oasis.local.home>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
        <20210812203110.3c82c040104e0fb488912ee1@kernel.org>
        <20210812094439.56303efa@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 09:44:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 12 Aug 2021 20:31:10 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > Yes, anyway we need a way to find loops on histogram/eprobe at last.  
> > 
> > BTW, what about using similar machanism of "current_kprobe()" to detect
> > the reccursion? As an easy way, prepare a static per-cpu pointer which sets
> > the current eprobe and if the eprobe handler detects that is already set,
> > it may warn (or silently ignore) and reject it.
> > (Of course it is better to detect the loop when user sets the hist-trigger
> > by reverse link)
> 
> Thinking more about this, I believe there is a use case for synthetic
> event on a eprobe. Basically:
> 
>   normal_event -> eprobe (extracts struct data into $dat) -> onmax($dat) -> synthetic event
> 
> But I can not come up with any use case of:
> 
>   eprobe -> synthetic event -> eprobe
> 
> or
> 
>   synthetic event -> eprobe -> synthetic event
> 
> That's because once you have an eprobe, you can extract what you want,
> and once you have that synthetic event, you can get the data you want.
> 
> Maybe we should prevent the above and allow one eprobe on a synthetic
> event and one synthetic event on an eprobe.
> 
> Or just don't prevent it at all, and let the user shoot themselves in
> the foot ;-)
> 
> The more I think about this, I'm thinking we just let them shoot
> themselves if they want to.

I agree. Or, at least we can prevent the loop at runtime as I said.
BTW, does synthetic event itself detect and prevent loops? I think
the key point is always synthetic event, so if the loop detector
is implemented, it should be done on the synthetic event.

> 
> But I still agree that eprobes should not be attached to kprobes or
> uprobes directly (although they may be able to be attached to a
> synthetic event that is attached to one!)

Yes.

Thank you,


> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
