Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D471C32771
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 01:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiIVBsq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 21:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiIVBsp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 21:48:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47111A2602
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 18:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A8D6CE200D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC01FC433D6;
        Thu, 22 Sep 2022 01:48:39 +0000 (UTC)
Date:   Wed, 21 Sep 2022 21:49:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zebediah Figura <zfigura@codeweavers.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Message-ID: <20220921214941.0d297d5d@gandalf.local.home>
In-Reply-To: <20220901205638.3247090-1-zfigura@codeweavers.com>
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  1 Sep 2022 15:56:38 -0500
Zebediah Figura <zfigura@codeweavers.com> wrote:

> From: Zeb Figura <zfigura@codeweavers.com>
> 
> This is already supported and works as expected; allow the option to be
> specified.

Hi Zeb,

I'd love to accept this patch, but I need you to add your "Signed-off-by"
tag.

  See https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tree/DCO

You can either resend the patch, or reply with it here.

Thanks!

-- Steve

> ---
>  tracecmd/trace-record.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 3442e9b..70fb187 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6648,7 +6648,6 @@ static void parse_record_options(int argc,
>  		case OPT_compression:
>  			cmd_check_die(ctx, CMD_start, *(argv+1), "--compression");
>  			cmd_check_die(ctx, CMD_set, *(argv+1), "--compression");
> -			cmd_check_die(ctx, CMD_extract, *(argv+1), "--compression");
>  			cmd_check_die(ctx, CMD_stream, *(argv+1), "--compression");
>  			cmd_check_die(ctx, CMD_profile, *(argv+1), "--compression");
>  			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&

