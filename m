Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558CAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 03:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF0861994
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 03:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhJAD5B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 23:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230374AbhJAD5A (ORCPT
        <rfc822;linux-trace-devel@VGER.KERNEL.ORG>);
        Thu, 30 Sep 2021 23:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57EC16187D;
        Fri,  1 Oct 2021 03:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633060516;
        bh=21soSlt93X3yO9I2bU30OaXXEIOAnp4hrIPktZiO9Xc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M+E225WOpeEoKoAMhf1ya47EOH2wF6Euv+oM1Jl51kX3aez93lAhR2qgdtIyO696a
         Yd8vvlnezIrzOwLYPf/dIzW45Fgcq7MJl5ZY3OBExb/QYlJyGLVbQLKrtjNhppV4fT
         USzm51Sb+2iD4ibhI7H6krnaxKRJQV5bTB5XQUgxY6YuBphyoxNO1YNMIQx2ebL2UB
         9mBGMmfiyKjVRiiOiiCWrF9M/2yfd5lJhinhx+ZMuJ1IH24WuLq4tl4CmHuqv/G6en
         5IJsFJu0elWjtUZotp9pKRUJMdQvXqPzEaB1TjV4b4tjzQDFC6w9TxVRwoXCsUgpSS
         ezO8Q4OYGGsFQ==
Date:   Fri, 1 Oct 2021 12:55:13 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@VGER.KERNEL.ORG, rostedt@goodmis.org,
        zanussi@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] synth_events: Do not block other dyn_event systems
 during create
Message-Id: <20211001125513.cf40fa1a3188416582666f66@kernel.org>
In-Reply-To: <20210930223821.11025-1-beaub@linux.microsoft.com>
References: <20210930223821.11025-1-beaub@linux.microsoft.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Beau,

On Thu, 30 Sep 2021 15:38:21 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> synth_events is returning -EINVAL if the dyn_event create command does
> not contain ' \t'. This prevents other systems from getting called back.
> synth_events needs to return -ECANCELED in these cases when the command
> is not targeting the synth_event system.

Thanks for clean up the synthetic event!
This looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

So now are you trying to reuse synth event for user event?
Then I think you need to register a new dyn_event ops so
that histogram will not submit the event.

BTW, how do you filter an event written by a user process?
Will you add an array of event id for the file data structure?

Thank you,

> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/trace_events_synth.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
> index 9315fc03e303..08b7ea639cea 100644
> --- a/kernel/trace/trace_events_synth.c
> +++ b/kernel/trace/trace_events_synth.c
> @@ -2051,6 +2051,13 @@ static int create_synth_event(const char *raw_command)
>  
>  	last_cmd_set(raw_command);
>  
> +	name = raw_command;
> +
> +	/* Don't try to process if not our system */
> +	if (name[0] != 's' || name[1] != ':')
> +		return -ECANCELED;
> +	name += 2;
> +
>  	p = strpbrk(raw_command, " \t");
>  	if (!p) {
>  		synth_err(SYNTH_ERR_INVALID_CMD, 0);
> @@ -2059,12 +2066,6 @@ static int create_synth_event(const char *raw_command)
>  
>  	fields = skip_spaces(p);
>  
> -	name = raw_command;
> -
> -	if (name[0] != 's' || name[1] != ':')
> -		return -ECANCELED;
> -	name += 2;
> -
>  	/* This interface accepts group name prefix */
>  	if (strchr(name, '/')) {
>  		len = str_has_prefix(name, SYNTH_SYSTEM "/");
> -- 
> 2.17.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
