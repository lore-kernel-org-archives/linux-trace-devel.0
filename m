Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4519195
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 00:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721261279; cv=none; b=L4sgtBtIMwpJPDjnwBaL53o0nxqmjQbOnA3yVZO6JiKj6QnRIX0G6cNT047AXf7fv3b8TVbCoo5OBVpAm/S/1rIxMnpRarjSW9adyhscPafXDmZ35Fs+V0iyO4rcVIgYgFU7swAZaSq/SNXJj6y2Qdkf2iPNxh8u+tn5B6L8nTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721261279; c=relaxed/simple;
	bh=LHuFz6uMHB7sok5AeoTPYgUKR/zOBa0P0i4d3FyMGv0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIZVQFsS0BxK022G/bbR1najUiOFjf+o7hu9d4VIjUm6NE8cJ98puJNKenLZ8bbdo92KD8ZGyx8o0iAcqouwPGNeszJvcdtW21UCp2vhWBW+Vu+se5wjdrg8iypXIwG9OW0Sj6zb9n63oeOULwhZ1Rq9ZEDW4D7F+LDxKR6XFiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F919C2BD10;
	Thu, 18 Jul 2024 00:07:59 +0000 (UTC)
Date: Wed, 17 Jul 2024 20:08:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 23/38] trace-cmd lib: prevent buffer overrun in
 read_string()
Message-ID: <20240717200802.0123038a@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-24-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-24-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:38 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:


> 
> Fixes an OVERRUN error (CWE-119)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-input.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 3284dbd4..c485acea 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -447,15 +447,13 @@ static char *read_string(struct tracecmd_input *handle)
>  		str = realloc(str, size);

Hmm, the above is a memory leak if it fails. That should be:

		tmp = realloc(str, size);
		if (!tmp) {
			free(str);
			return NULL;
		}
		str = tmp;

Not to do with your patch, but I think this code is generally wrong. :-/

Let's say BUFSIZ = 1024, and a string is 1124 in size, including the '\0'.

That is str[1123] = '\0'.

The loop would end with:

	size = 1024; i = 99;

	size += i + 1; // size = 1124;


>  		if (!str)
>  			return NULL;
> -		memcpy(str + (size - i), buf, i);
> -		str[size] = 0;
> +		memcpy(str + (size - i), buf, i + 1);

size - i = 1025

I think this is wrong, as we should be copying to str + 1024, and not str + 1025.

This should be fixed, but has nothing to do with this particular patch.

Thanks,

-- Steve


>  	} else {
>  		size = i + 1;
>  		str = malloc(size);
>  		if (!str)
>  			return NULL;
> -		memcpy(str, buf, i);
> -		str[i] = 0;
> +		memcpy(str, buf, i + 1);
>  	}
>  
>  	return str;

