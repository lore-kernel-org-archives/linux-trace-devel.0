Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32C5C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Mar 2022 16:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbiCIQoC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbiCIQmc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 11:42:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E035D1A6143
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Mar 2022 08:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CA4761A55
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Mar 2022 16:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7ACC340F4;
        Wed,  9 Mar 2022 16:36:38 +0000 (UTC)
Date:   Wed, 9 Mar 2022 11:36:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Use the new libtracefs API to address all
 dynamic events
Message-ID: <20220309113637.11f8db4d@gandalf.local.home>
In-Reply-To: <20220309054458.636350-1-tz.stoyanov@gmail.com>
References: <20220309054458.636350-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Mar 2022 07:44:58 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The trace-cmd reset logic clears all dynamically created ftrace events.
> The current implementation lists all events that should be cleared.
> That logic is fragile, as when a new type of dynamic event is
> introduced the logic should be updated. Instead, the newly introduced
> libtracefs define should be used: TRACEFS_DYNEVENT_ALL.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Applied, thanks Tzvetomir!

-- Steve

> ---
>  tracecmd/trace-record.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 9afc1042..8d9cbac2 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5262,12 +5262,7 @@ static void clear_all_dynamic_events(void)
>  {
>  	/* Clear event probes first, as they may be attached to other dynamic event */
>  	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
> -	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE |
> -				     TRACEFS_DYNEVENT_KRETPROBE |
> -				     TRACEFS_DYNEVENT_UPROBE |
> -				     TRACEFS_DYNEVENT_URETPROBE |
> -				     TRACEFS_DYNEVENT_SYNTH,
> -				     true);
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_ALL, true);
>  }
>  
>  static void clear_func_filters(void)

