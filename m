Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96268C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 13:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C43020752
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 13:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgEDNlZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 09:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgEDNlZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 09:41:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A13420752;
        Mon,  4 May 2020 13:41:24 +0000 (UTC)
Date:   Mon, 4 May 2020 09:41:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] trace-cmd: Add "main" in the output of trace-cmd
 stat when displaying main instance
Message-ID: <20200504094121.65a733b6@gandalf.local.home>
In-Reply-To: <20200504062711.107867-3-tz.stoyanov@gmail.com>
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
 <20200504062711.107867-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 May 2020 09:27:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> By default, "trace-cmd stat" command prints status of the main ftrace instance. When more
> instances are configured, the user could be confused which status is displayed.

Hmm, I'm not so big on this one. Has anyone complained about it? We never
actually gave a name to the top level. In fact, it can get more confusing
if someone were to create an instance called "main" then it would get even
more confusing.

I think the better answer is to just move the instance reporting to the
end, and not at the beginning. That would make more sense. I was thinking
of recommending that when I first applied the patch, but now I think it
should be done.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-stat.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
> index c5057978..dcf2789c 100644
> --- a/tracecmd/trace-stat.c
> +++ b/tracecmd/trace-stat.c
> @@ -920,8 +920,10 @@ static void stat_instance(struct buffer_instance *instance)
>  			printf("---------------\n");
>  		printf("Instance: %s\n",
>  			tracefs_instance_get_name(instance->tracefs));
> -	} else
> +	} else {
>  		report_instances();
> +		printf("\nInstance: main\n\n");
> +	}
>  
>  	report_plugin(instance);
>  	report_events(instance);

