Return-Path: <SRS0=G/lh=P5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17422C282F6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA8252084A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Jan 2019 09:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfAUJUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfAUJUQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Jan 2019 04:20:16 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9322085A;
        Mon, 21 Jan 2019 09:20:14 +0000 (UTC)
Date:   Mon, 21 Jan 2019 04:19:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/7] trace-cmd: Added user configured clock to the
 record context
Message-ID: <20190121041959.1de4b1f0@vmware.local.home>
In-Reply-To: <20190116191838.32127-6-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
        <20190116191838.32127-6-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Jan 2019 21:18:36 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Store the user configured clock (if any) in the record context,
> struct common_record_context. The clock is going to be used when
> synchronizing timestamps with remote tracing machine.
> ---
>  tracecmd/trace-record.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index f7349eb..900d0d4 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -227,6 +227,7 @@ struct common_record_context {
>  	int topt;
>  	int do_child;
>  	int run_command;
> +	char *clock;
>  };
>  
>  static void add_reset_file(const char *file, const char *val, int prio)
> @@ -5183,6 +5184,7 @@ static void parse_record_options(int argc,
>  			break;
>  		case 'C':
>  			ctx->instance->clock = optarg;
> +			ctx->clock = optarg;

Hmm, this can cause an issue. The first thing I have to ask is, why
can't we use ctx->instance->clock. I'm sure the answer is that we are
adding more than one clock. But this begs the question, which clock
should be use, if there are more than one clock to add?

I think this patch is not needed. In the last patch, test if
ctx->instance->clock exists, and if not, we search the other instances
for a clock to use. Or something else that doesn't make which clock to
use ambiguous.

-- Steve

>  			break;
>  		case 'v':
>  			neg_event = 1;

