Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738BCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 01:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiCLBGT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 20:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLBGT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 20:06:19 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18F8D21D09D
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 17:05:15 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id BC4B520B7178;
        Fri, 11 Mar 2022 17:05:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC4B520B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1647047114;
        bh=euNmQSHH5y3gluru0bhw2y+0oY3Ex+z9L2wjuQNVoiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ntAuYPx7/RM1ENM/8/frO3yoBsadreUbXxatnrx2mPgnKE7jPPEzXfKNNwSN8XZdM
         KFpqeGYBEMNR2sD2ScpOMUG/z7PrDkmUJXA0mdSB+jzDVqfbRbDmSQPQOZ4wpvzlwW
         //qaBoDwME9pV2NFQwNXOSSCpUknCMuH4nII619M=
Date:   Fri, 11 Mar 2022 17:05:09 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] tracing/user_events: Limit showing event names to
 CAP_SYS_ADMIN users
Message-ID: <20220312010509.GA1931@kbox>
References: <20220312010140.1880-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312010140.1880-1-beaub@linux.microsoft.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 11, 2022 at 05:01:40PM -0800, Beau Belgrave wrote:
> Show actual names only to CAP_SYS_ADMIN capable users.
> 
> When user_events are configured to have broader write access than
> default, this allows seeing names of events from other containers, etc.
> Limit who can see the actual names to prevent event squatting or
> information leakage.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/trace_events_user.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index 2b5e9fdb63a0..fb9fb2071173 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -1480,6 +1480,9 @@ static int user_seq_show(struct seq_file *m, void *p)
>  	struct user_event *user;
>  	char status;
>  	int i, active = 0, busy = 0, flags;
> +	bool show_names;
> +
> +	show_names = capable(CAP_SYS_ADMIN);
>  
>  	mutex_lock(&reg_mutex);
>  
> @@ -1487,7 +1490,10 @@ static int user_seq_show(struct seq_file *m, void *p)
>  		status = register_page_data[user->index];
>  		flags = user->flags;
>  
> -		seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> +		if (show_names)
> +			seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> +		else
> +			seq_printf(m, "%d:<hidden>", user->index);
>  
>  		if (flags != 0 || status != 0)
>  			seq_puts(m, " #");
> 
> base-commit: 864ea0e10cc90416a01b46f0d47a6f26dc020820
> -- 
> 2.17.1

I wanted to get some comments on this. I think for scenarios where
user_events is used in a heavy cgroup environment, that we need to have
some tracing cgroup awareness.

Has this come up before? I would like to only show user_events that have
been created in the current cgroup (and below) like perf_events do for
capturing.

I would also like to get to a point where we can limit how many events
each cgroup can register under user_events.

To me, this sounds like a large feature that requires some alignment for
getting tracing cgroup aware.

Thoughts?

Thanks,
-Beau
