Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A08AC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 03:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 223F520863
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 03:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbfB1DMy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 22:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbfB1DMx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 22:12:53 -0500
Received: from vmware.local.home (unknown [208.91.3.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDC3218AE;
        Thu, 28 Feb 2019 03:12:52 +0000 (UTC)
Date:   Wed, 27 Feb 2019 22:12:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Jones <tonyj@suse.de>
Cc:     linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-perf-users@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Michael Sartain <mikesart@fastmail.com>
Subject: Re: [PATCH] tools lib traceevent: Fix buffer overflow in arg_eval
Message-ID: <20190227221250.74996869@vmware.local.home>
In-Reply-To: <20190228015532.8941-1-tonyj@suse.de>
References: <20190228015532.8941-1-tonyj@suse.de>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Feb 2019 17:55:32 -0800
Tony Jones <tonyj@suse.de> wrote:

> Fix buffer overflow observed when running perf test.
> 
> The overflow is when trying to evaluate "1ULL << (64 - 1)" which
> is resulting in -9223372036854775808 which overflows the 20 character
> buffer.
> 
> If is possible this bug has been reported before but I still don't
> see any fix checked in:
> 
> See: https://www.spinics.net/lists/linux-perf-users/msg07714.html
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Tony Jones <tonyj@suse.de>

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

I have to say I've let this slide and it is not the first time a patch
went out with this fix. But this one has the correct fix because we
should use a buffer with a multiple of 4. Anyway, Tony I believe was
the first to report this anyway.

For reference we have:

I first heard about Tony's complaint on a post to linux-perf-users on Jan 18.

But then we had after that:

 Michael Sartain reported it on 1/24 (and fixed by Tzvetomir)
 https://lore.kernel.org/linux-trace-devel/20190125102014.19600-1-tstoyanov@vmware.com/
 
It was later fixed again by Mathias Krause
 https://lore.kernel.org/linux-trace-devel/20190223122404.21137-1-minipli@googlemail.com/

But since Tony was first to report it, and we discussed that it should
be 24 bytes, I would say this is the patch to take.

Again, sorry for not getting this acknowledged earlier and everyone doing
the same thing multiple times. :-/

Arnaldo, please take this patch. But also add:

Reported-by: Michael Sartain <mikesart@fastmail.com>
Reported-by: Mathias Krause <minipli@googlemail.com>

Thanks,

-- Steve


> ---
>  tools/lib/traceevent/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c
> b/tools/lib/traceevent/event-parse.c index abd4fa5d3088..87494c7c619d
> 100644 --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2457,7 +2457,7 @@ static int arg_num_eval(struct tep_print_arg
> *arg, long long *val) static char *arg_eval (struct tep_print_arg
> *arg) {
>  	long long val;
> -	static char buf[20];
> +	static char buf[24];
>  
>  	switch (arg->type) {
>  	case TEP_PRINT_ATOM:

