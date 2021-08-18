Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDACC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C002561130
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhHRQPC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhHRQPC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 12:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4157C610A6;
        Wed, 18 Aug 2021 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629303267;
        bh=M4fViFsDheGAVXE3lelMyjnLJiidp4fcelthY5ppsqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fa80ZueNBvFywHKPLMuhPGIbyHSybxlDsIshUzqqyy1eWEqefColDk446gwOnlawn
         xjBuC2bgDBs7yth3vgi/9PGOXSIwUBNBXv51XzbwgebW4t94IZE9pUGjNtd1F8pZrv
         TJopAHRWxOVrhO8ElTbJRz+2Ph893lMYPpdKFVh6UsNM9RpGhYzkqQhCjlZ7S/rRfN
         7YXOAiAvPrJ6eAsQKu4a8uwulkPvSx3QOrRhmOs+6JMnttt7vam9yFnJy5sOFU9kfD
         fjX0ycBuaeourlh1F2zHfLZ/2urWYSvDTS/ncOi+se4MWANB99RrnxcVlIDAZ4wE6k
         qo9+ThRbgDmoA==
Date:   Thu, 19 Aug 2021 01:14:24 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 2/7] tracing: Have dynamic events have a ref counter
Message-Id: <20210819011424.1d109c7492a672d259f9ac95@kernel.org>
In-Reply-To: <20210817035027.174869074@goodmis.org>
References: <20210817034255.421910614@goodmis.org>
        <20210817035027.174869074@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 16 Aug 2021 23:42:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> As dynamic events are not created by modules, if something is attached to
> one, calling "try_module_get()" on its "mod" field, is not going to keep
> the dynamic event from going away.
> 
> Since dynamic events do not need the "mod" pointer of the event structure,
> make a union out of it in order to save memory (there's one structure for
> each of the thousand+ events in the kernel), and have any event with the
> DYNAMIC flag set to use a ref counter instead.
> 
> Link: https://lore.kernel.org/linux-trace-devel/20210813004448.51c7de69ce432d338f4d226b@kernel.org/
> 

This looks good to me, just one nitpick.

[..]
> +
> +static inline void trace_event_put_ref(struct trace_event_call *call)
> +{
> +	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
> +		return trace_event_dyn_put_ref(call);
> +	else
> +		return module_put(call->module);

You don't need to return for void function.

Except for this,
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!



-- 
Masami Hiramatsu <mhiramat@kernel.org>
