Return-Path: <SRS0=HVYc=ZP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31ACC432C0
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6B7D20726
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 16:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKWQmh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 11:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbfKWQmh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 11:42:37 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE6F2070E;
        Sat, 23 Nov 2019 16:42:35 +0000 (UTC)
Date:   Sat, 23 Nov 2019 11:42:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Improve /proc/kallsyms parsing
Message-ID: <20191123113810.46819667@oasis.local.home>
In-Reply-To: <20191123084130027.IPKB.12758.ppp.dion.ne.jp@dmta0005.auone-net.jp>
References: <20191123084130027.IPKB.12758.ppp.dion.ne.jp@dmta0005.auone-net.jp>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 23 Nov 2019 17:41:29 +0900
Kusanagi Kouichi <slash@ac.auone-net.jp> wrote:

> - Use the stricter format string.
> - Avoid allocating memory.
> - Check sscanf return value.
> 

Hi Kusanagi,

Thanks for the patch, small comment below.

> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> ---
>  lib/trace-cmd/trace-util.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 8aa3b6c..ef8e4f7 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -80,39 +80,40 @@ void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
>  	char *func;
>  	char *line;
>  	char *next = NULL;
> -	char *addr_str;
>  	char *mod;
>  	char ch;
>  
>  	line = strtok_r(file, "\n", &next);
>  	while (line) {
> +		int n, func_start, func_end = 0, mod_start, mod_end = 0;

Small nit. I usually prefer to not have so many variables defined on
one line. Something more like this:

		int func_start, func_end = 0;
		int mod_start, mod_end = 0;
		int n;

Just easier to review.

The rest looks good. I'll play with it to see if there's any instances
that it doesn't work.

Thanks!

-- Steve


> +
>  		mod = NULL;
>  		errno = 0;
> -		sscanf(line, "%ms %c %ms\t[%ms",
> -			     &addr_str, &ch, &func, &mod);
> +		n = sscanf(line, "%16llx %c %n%*s%n%*1[\t][%n%*s%n",
> +			   &addr, &ch, &func_start, &func_end, &mod_start, &mod_end);
> 		if (errno) {
> -			free(addr_str);
> -			free(func);
> -			free(mod);
>  			perror("sscanf");
>  			return;
>  		}
> -		addr = strtoull(addr_str, NULL, 16);
> -		free(addr_str);
>  
> -		/* truncate the extra ']' */
> -		if (mod)
> -			mod[strlen(mod) - 1] = 0;
> +		if (n != 2 || !func_end)
> +			return;
>  
> +		func = line + func_start;
>  		/*
>  		 * Hacks for
>  		 *  - arm arch that adds a lot of bogus '$a' functions
>  		 *  - x86-64 that reports per-cpu variable offsets as absolute */
> -		if (func[0] != '$' && ch != 'A' && ch != 'a')
> +		if (func[0] != '$' && ch != 'A' && ch != 'a') {
> +			line[func_end] = 0;
> +			if (mod_end) {
> +				mod = line + mod_start;
> +				/* truncate the extra ']' */
> +				line[mod_end - 1] = 0;
> +			}
>  			tep_register_function(pevent, func, addr, mod);
> -		free(func);
> -		free(mod);
> +		}
>  
>  		line = strtok_r(NULL, "\n", &next);
>  	}

