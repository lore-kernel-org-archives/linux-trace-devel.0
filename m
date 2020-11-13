Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4ECC388F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2B822242
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgKMOZw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbgKMOZw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 09:25:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D6F22226;
        Fri, 13 Nov 2020 14:25:51 +0000 (UTC)
Date:   Fri, 13 Nov 2020 09:25:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>
Subject: Re: [PATCH] trace-cmd libtraceevent: Fix bprint '#' parsing
Message-ID: <20201113092550.349af46e@gandalf.local.home>
In-Reply-To: <20201113132953.2371-1-vincent.whitchurch@axis.com>
References: <20201113132953.2371-1-vincent.whitchurch@axis.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Nov 2020 14:29:53 +0100
Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:

> Fix handling of '#' in bprint format specifiers.
> 
> For example, with this:
> 
>  trace_printk("jiffies %lu pending %#x\n", jiffies, pending);
> 
> Before:
> 
>   bprint: __do_softirq: jiffies 4294919108 pending x
>   ...
>   bprint: [FAILED TO PARSE] ip=... fmt=... buf=ARRAY[]
> 
> After:
> 
>   bprint: __do_softirq: jiffies 4294919108 pending 0x4
>   ...
>   bprint: __do_softirq: jiffies 4294919109 pending 0x4

Thanks Vincent!

Note, I'll be adding this to both the trace-cmd tree and the
libtraceevent.git repo (I need to update the website to reflect this).

  git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git

-- Steve


> 
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
>  lib/traceevent/event-parse.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
> index 06fa3dd..a62d2f7 100644
> --- a/lib/traceevent/event-parse.c
> +++ b/lib/traceevent/event-parse.c
> @@ -4456,6 +4456,8 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
>  				goto process_again;
>  			case '.':
>  				goto process_again;
> +			case '#':
> +				goto process_again;
>  			case 'z':
>  			case 'Z':
>  				ls = 1;

