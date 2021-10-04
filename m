Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391D6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 170A261357
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Oct 2021 15:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhJDPtj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235078AbhJDPti (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 11:49:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC11361357;
        Mon,  4 Oct 2021 15:47:49 +0000 (UTC)
Date:   Mon, 4 Oct 2021 11:47:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 10/21] trace-cmd library: Fix possible memory leak in
 read_event_files()
Message-ID: <20211004114748.02f33119@gandalf.local.home>
In-Reply-To: <20210914131232.3964615-11-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
        <20210914131232.3964615-11-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 Sep 2021 16:12:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some error paths in read_event_files() may lead to a memory leak.
> Improved the error handling of this internal function to avoid it.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 39 ++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 94fd8693..32358ce9 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -645,7 +645,7 @@ out:
>  static int read_event_files(struct tracecmd_input *handle, const char *regex)
>  {
>  	unsigned long long size;
> -	char *system;
> +	char *system = NULL;
>  	regex_t spreg;
>  	regex_t epreg;
>  	regex_t *sreg = NULL;
> @@ -670,13 +670,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
>  			return -1;
>  	}
>  
> -	if (read4(handle, &systems) < 0)
> -		return -1;
> +	ret = read4(handle, &systems);
> +	if (ret < 0)
> +		goto out;
>  
>  	for (i = 0; i < systems; i++) {
>  		system = read_string(handle);
> -		if (!system)
> -			return -1;
> +		if (!system) {
> +			ret = -1;
> +			goto out;
> +		}
>  
>  		sys_printed = 0;
>  		print_all = 0;
> @@ -703,39 +706,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
>  			}
>  		}
>  
> -		if (read4(handle, &count) < 0)
> -			goto failed;
> +		ret = read4(handle, &count);
> +		if (ret < 0)
> +			goto out;
>  
>  		for (x=0; x < count; x++) {
> -			if (read8(handle, &size) < 0)
> -				goto failed;
> +			ret = read8(handle, &size);
> +			if (ret < 0)
> +				goto out;
>  
>  			ret = read_event_file(handle, system, size,
>  					      print_all, &sys_printed,
>  					      reg);
>  			if (ret < 0)
> -				goto failed;
> +				goto out;
>  		}
>  		free(system);
> -	}
> -
> -	if (sreg) {
> -		regfree(sreg);
> -		regfree(ereg);
> +		system = NULL;
>  	}

Nit, I would have placed "system = NULL;" outside the loop as it gets set
first thing in the loop, but that's just my preference ;-)

Other than that, the patch looks good. No need to update it.

-- Steve


>  
>  	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
> -
> -	return 0;
> -
> - failed:
> +	ret = 0;
> + out:
>  	if (sreg) {
>  		regfree(sreg);
>  		regfree(ereg);
>  	}
>  
>  	free(system);
> -	return -1;
> +	return ret;
>  }
>  
>  static int read_proc_kallsyms(struct tracecmd_input *handle)

