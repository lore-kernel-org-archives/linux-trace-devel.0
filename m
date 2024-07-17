Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D01EA71
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 20:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721248063; cv=none; b=k6sXjGVVS4D8EJ2UpbzBkcAj4sHqpdz/FfWVnIDNaoDT5hR81LbeZdqQNVJRkXSTON9Dz/uW5PT82Vp/N9GPQKra8Ohqh9f4eOrUFREdMkuyvNB4KKf9X6oOn6itQ+UD/Nv7ZGIV+WsZuQlZuLd68XsxthU944H01Aiq3TRPiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721248063; c=relaxed/simple;
	bh=J/OWQyo92giRnavqsBKszmwu4Zj1TiqfyEBwb8x92kE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUoeRG8Q6C93tQca1DIYCKKyyrY+Fm6wWKfDRwD/AY8UdW34yax7EUH0ikoCmdv0vAI1LmUML2uQKtIldmCDNY25IjuDQhvY5JrAYbSmzmCOJzJgSaaTcgho5lr/YaU2ae7Nnn1lDzXaQ9f4Z+Knk3iRnsNcBzNx9Dl++NKJtrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0165C2BD10;
	Wed, 17 Jul 2024 20:27:42 +0000 (UTC)
Date: Wed, 17 Jul 2024 16:27:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 06/38] trace-cmd lib: prevent a memory leak in
 handle_options()
Message-ID: <20240717162741.030d8df0@rorschach.local.home>
In-Reply-To: <20240605134054.2626953-7-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-7-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:21 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> Free buf in the error path.
> 
> Fixes a RESOURCE_LEAK error (CWE-772)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-input.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index ce4ecf43..2cf0d1c1 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -4030,7 +4030,7 @@ static int handle_options(struct tracecmd_input *handle)
>  		}
>  		ret = do_read_check(handle, buf, size);
>  		if (ret)
> -			goto out;
> +			goto out_free;
>  
>  		switch (option) {
>  		case TRACECMD_OPTION_DATE:
> @@ -4084,7 +4084,7 @@ static int handle_options(struct tracecmd_input *handle)
>  							     buf + 8, 4);
>  			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
>  			if (ret < 0)
> -				goto out;
> +				goto out_free;
>  			tracecmd_enable_tsync(handle, true);
>  			break;
>  		case TRACECMD_OPTION_CPUSTAT:
> @@ -4093,7 +4093,7 @@ static int handle_options(struct tracecmd_input *handle)
>  					   handle->cpustats_size + size + 1);
>  			if (!cpustats) {
>  				ret = -ENOMEM;
> -				goto out;
> +				goto out_free;
>  			}
>  			memcpy(cpustats + handle->cpustats_size, buf, size);
>  			handle->cpustats_size += size;
> @@ -4104,7 +4104,7 @@ static int handle_options(struct tracecmd_input *handle)
>  		case TRACECMD_OPTION_BUFFER_TEXT:
>  			ret = handle_buffer_option(handle, option, buf, size);
>  			if (ret < 0)
> -				goto out;
> +				goto out_free;
>  			break;
>  		case TRACECMD_OPTION_TRACECLOCK:
>  			tracecmd_parse_trace_clock(handle, buf, size);
> @@ -4183,6 +4183,8 @@ static int handle_options(struct tracecmd_input *handle)
>  
>  	ret = 0;
>  

The for (;;) loop ends with a free(buf) and then in the next iteration it can do:

		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
			break;

> +out_free:
> +	free(buf);

Which will cause this to do a double free.

I'm going to not pull this patch.

-- Steve


>  out:
>  	if (compress)
>  		in_uncompress_reset(handle);

