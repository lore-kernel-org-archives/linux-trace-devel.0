Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4706BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299BD610A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhHSSH6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSSH5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 14:07:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1148C6109F;
        Thu, 19 Aug 2021 18:07:20 +0000 (UTC)
Date:   Thu, 19 Aug 2021 14:07:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 38/87] trace-cmd library: Fix possible memory leak in
 read_ftrace_files()
Message-ID: <20210819140714.3f538176@oasis.local.home>
In-Reply-To: <20210729050959.12263-39-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-39-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:10 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_ftrace_files() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.

This looks more like a normal fix. Can it be moved to the front of the
queue? As it can be applied outside this patch set.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 0ced15a8..b36df98b 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -720,25 +720,28 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
>  		}
>  	}
>  
> -	if (read4(handle, &count) < 0)
> -		return -1;
> +	ret = read4(handle, &count);
> +	if (ret < 0)
> +		goto out;
>  
>  	for (i = 0; i < count; i++) {
> -		if (read8(handle, &size) < 0)
> -			return -1;
> +		ret = read8(handle, &size);
> +		if (ret < 0)
> +			goto out;
>  		ret = read_ftrace_file(handle, size, print_all, ereg);
>  		if (ret < 0)
> -			return -1;
> +			goto out;
>  	}
>  
> +	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
> +	ret = 0;
> +out:
>  	if (sreg) {
>  		regfree(sreg);
>  		regfree(ereg);
>  	}
>  
> -	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
> -
> -	return 0;
> +	return ret;
>  }
>  
>  static int read_event_files(struct tracecmd_input *handle, const char *regex)

