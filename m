Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D0EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Nov 2022 01:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKYBKx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 20:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKYBKw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 20:10:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08162A2;
        Thu, 24 Nov 2022 17:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7C2621D6;
        Fri, 25 Nov 2022 01:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9096C433D6;
        Fri, 25 Nov 2022 01:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669338650;
        bh=TdYed7TzESNC1tSwHb7ZJEnF2YBPikCulQMC9JlgMYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kZheonZrXzlZicETGsgJZcqON+TbANG0DHsXrMr8u21ujd279w/E1Pp6pt2PIGz/q
         PmSBeMh/LTE6jf5dPkRa41TAMIntOKCllkZH18SDkISWU9SJ0DwO149aDDmIu6LWj3
         P27epfIJAFgY0mytXA5FZeTE61HuwBMOZBGCdKIIfa1HeQuy6U/ndExeeKi0v9Knmj
         a7uDZE8wlV0mpFGfkW4T9y62Gb13hsKvJkXVzJGb8tEzrojGQTLo/44GjcWvFXRHfb
         RnsbgVbvXCwevqI8Y09+92TQZTuqdakKYJWdr0sLIMWNfkiRpBKeHAQLyLwY/papBg
         dvFUyJy15G9Iw==
Date:   Fri, 25 Nov 2022 10:10:47 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/user_events: Fix call print_fmt leak
Message-Id: <20221125101047.6772413447785430ccbf8046@kernel.org>
In-Reply-To: <20221123183248.554-1-beaub@linux.microsoft.com>
References: <20221123183248.554-1-beaub@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Nov 2022 10:32:48 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> If user_event_trace_register() fails within user_event_parse() the
> call's print_fmt member is not freed. Add kfree call to fix this.
> 
> Fixes: aa3b2b4c6692 ("user_events: Add print_fmt generation support for basic types")
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>

This looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you!

> ---
>  kernel/trace/trace_events_user.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index ae78c2d53c8a..b46844736015 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -1357,6 +1357,7 @@ static int user_event_parse(struct user_event_group *group, char *name,
>  put_user:
>  	user_event_destroy_fields(user);
>  	user_event_destroy_validators(user);
> +	kfree(user->call.print_fmt);
>  	kfree(user);
>  	return ret;
>  }
> -- 
> 2.25.1
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
