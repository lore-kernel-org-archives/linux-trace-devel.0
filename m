Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D529DC433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 01:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B48A2221F0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592445064;
	bh=hsD8rEWgNzJQVshX0lx5pB7GQ9Y4hZ3wbaRlnnuycxI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=0/JDmYsL+6Uq1ueLwAnb0yJN6P7DSxQLim2JqQOHHPRy6v7WEf1jZKaQdSER7wZYL
	 J+xXPBHd4fb2Nk50L2JVu6LEzXzIkkehRxtSZOHvufVKgmMfwokEreNW90NgHcNOKR
	 DgYhfFoTcyh9nlUJl45kzepesKKWajY9BLGReyIg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbgFRBu7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731646AbgFRBu4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 21:50:56 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDDD322205;
        Thu, 18 Jun 2020 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592445055;
        bh=hsD8rEWgNzJQVshX0lx5pB7GQ9Y4hZ3wbaRlnnuycxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTE+D4UbUcEkUSMktV4ESXw4EIEzIOD6H0gorecjoVPo/NCOAK0S7MJPdzPbaPD30
         vCuOSYNxu6jFgtFv+weatEHa28lHxUrpTm/yWwt2EuwKv7ldq/dqZ94lFq6+UyI9tg
         JZzjiI9BChv95Mdd+umax1KbG4dXUzdpcuYsEKNQ=
Date:   Thu, 18 Jun 2020 10:50:51 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de,
        Maximilian Werner <maximilian.werner96@gmail.com>
Subject: Re: [PATCH] tracing/boottime: Fix kprobe multiple events
Message-Id: <20200618105051.ce01a84a13bbf67b816c1363@kernel.org>
In-Reply-To: <20200617140817.17161-1-sascha.ortmann@stud.uni-hannover.de>
References: <20200617140817.17161-1-sascha.ortmann@stud.uni-hannover.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Wed, 17 Jun 2020 16:08:17 +0200
Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de> wrote:

> Fix boottime kprobe events to add multiple events even if one fails
> and report probe generation failures.
> 
> As an example, when we try to set multiprobe kprobe events in
> bootconfig like this:
> 
> ftrace.event.kprobes.vfsevents {
> 	probes = "vfs_read $arg1 $arg2,,
>                  !error! not reported;?", // leads to error
> 		 "vfs_write $arg1 $arg2"
> }
> 
> this will not work like expected. After commit
> da0f1f4167e3af69e1d8b32d6d65195ddd2bfb64 ("tracing/boottime:
> Fix kprobe event API usage"), the function
> trace_boot_add_kprobe_event will not produce any error message,
> aborting the function and stopping subsequent probes from getting
> installed when adding a probe fails at kprobe_event_gen_cmd_start.

Ah, good catch!
Indeed, I missed the error message.

> Furthermore, probes continue when kprobe_event_gen_cmd_end fails
> (and kprobe_event_gen_cmd_start did not fail). In this case the
> function even returns successfully when the last call to
> kprobe_event_gen_cmd_end is successful.
> 
> The behaviour of reporting and aborting after failures is not
> consistent.

OK. And for more consistency, we should abort the loop if we hit any
error instead of continuing, because if trace_boot_add_kprobe_event()
returns an error code, the rest of event settings are skipped.
(See trace_boot_init_one_event())

> 
> The function trace_boot_add_kprobe_event now continues even when
> one of the multiple events fails. Each failure is now reported
> individually. Since the function can only return one result to the
> caller, the function returns now the last failure (or none, if
> nothing fails).
> 
> Cc: linux-kernel@i4.cs.fau.de
> Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
> Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
> ---
>  kernel/trace/trace_boot.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 9de29bb45a27..dbb50184e060 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -95,18 +95,24 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
>  	struct xbc_node *anode;
>  	char buf[MAX_BUF_LEN];
>  	const char *val;
> +	int error = 0;
>  	int ret = 0;
>  
>  	xbc_node_for_each_array_value(node, "probes", anode, val) {
>  		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
>  
> -		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
> -		if (ret)
> -			break;
> +		error = kprobe_event_gen_cmd_start(&cmd, event, val);
> +		if (error) {
> +			pr_err("Failed to generate probe: %s\n", buf);
> +			ret = error;
> +			continue;

so, could you break here?

> +		}
>  
> -		ret = kprobe_event_gen_cmd_end(&cmd);
> -		if (ret)
> +		error = kprobe_event_gen_cmd_end(&cmd);
> +		if (error) {
>  			pr_err("Failed to add probe: %s\n", buf);
> +			ret = error;

And here.

> +		}
>  	}
>  
>  	return ret;
> -- 
> 2.17.1
> 

Thank you!


-- 
Masami Hiramatsu <mhiramat@kernel.org>
