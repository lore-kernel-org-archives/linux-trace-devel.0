Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A0AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Feb 2022 17:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242225AbiBORKC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 12:10:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242240AbiBORKB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 12:10:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C32711ACCF
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 09:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE9E61425
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 17:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E97C340EB;
        Tue, 15 Feb 2022 17:09:50 +0000 (UTC)
Date:   Tue, 15 Feb 2022 12:09:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix use of uninitialized variable
Message-ID: <20220215120948.4bd0802b@gandalf.local.home>
In-Reply-To: <20220202214646.553872-1-irogers@google.com>
References: <20220202214646.553872-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Feb 2022 13:46:46 -0800
Ian Rogers <irogers@google.com> wrote:

> Caught by clang's -Wsometimes-uninitialized and accepting the suggested
> fix:
> 
> lib/trace-cmd/trace-input.c:4325:6: error: variable 'sec' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>         if (handle->file_state >= start_state) {
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/trace-cmd/trace-input.c:4336:6: note: uninitialized use occurs here
>         if (sec)
>             ^~~
> lib/trace-cmd/trace-input.c:4325:2: note: remove the 'if' if its condition is always true
>         if (handle->file_state >= start_state) {
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/trace-cmd/trace-input.c:4311:26: note: initialize the variable 'sec' to silence this warning
>         struct file_section *sec;
>                                 ^
>                                  = NULL

-ENOSOB

  ;-)

-- Steve

> ---
>  lib/trace-cmd/trace-input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index ecb5682..57bd4ee 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -4308,7 +4308,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
>  			  enum tracecmd_file_states start_state,
>  			  enum tracecmd_file_states end_state)
>  {
> -	struct file_section *sec;
> +	struct file_section *sec = NULL;
>  	int ret;
>  
>  	if (!start_state)

