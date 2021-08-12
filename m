Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BDBC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 13:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18FA860FD7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 13:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhHLNpM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 09:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhHLNpM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 09:45:12 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4B561059;
        Thu, 12 Aug 2021 13:44:46 +0000 (UTC)
Date:   Thu, 12 Aug 2021 09:44:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-ID: <20210812094439.56303efa@oasis.local.home>
In-Reply-To: <20210812203110.3c82c040104e0fb488912ee1@kernel.org>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
        <20210812203110.3c82c040104e0fb488912ee1@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 20:31:10 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > Yes, anyway we need a way to find loops on histogram/eprobe at last.  
> 
> BTW, what about using similar machanism of "current_kprobe()" to detect
> the reccursion? As an easy way, prepare a static per-cpu pointer which sets
> the current eprobe and if the eprobe handler detects that is already set,
> it may warn (or silently ignore) and reject it.
> (Of course it is better to detect the loop when user sets the hist-trigger
> by reverse link)

Thinking more about this, I believe there is a use case for synthetic
event on a eprobe. Basically:

  normal_event -> eprobe (extracts struct data into $dat) -> onmax($dat) -> synthetic event

But I can not come up with any use case of:

  eprobe -> synthetic event -> eprobe

or

  synthetic event -> eprobe -> synthetic event

That's because once you have an eprobe, you can extract what you want,
and once you have that synthetic event, you can get the data you want.

Maybe we should prevent the above and allow one eprobe on a synthetic
event and one synthetic event on an eprobe.

Or just don't prevent it at all, and let the user shoot themselves in
the foot ;-)

The more I think about this, I'm thinking we just let them shoot
themselves if they want to.

But I still agree that eprobes should not be attached to kprobes or
uprobes directly (although they may be able to be attached to a
synthetic event that is attached to one!)

-- Steve
