Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD6D33997
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 20:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721249505; cv=none; b=QYPXv0iIHaYh67ire+SxCfObMEkvfQB0ewLrS59sfuTnK9/SVf83B58KJMe3mM2Xv8SD58vIos3QqpTxTxxsyoAPckGodT/IF/u8dbUf5kSwNR9fH+gA7rCH3phNY9krnbRG1tStc5yJb0U3sFYWxmBpbldspS8nTChgtMp2COI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721249505; c=relaxed/simple;
	bh=G7jnedZBjXMBCr6jqHHX90zpasKmtitZYSHtGCS8lc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LunwPvoK8n8wygTyNnlzA/pX9E5zWs4Z9ExAGyv0Y5nLp/fs37HAOXagQz/dWd4euR6rPf2Bjs6r1N1YbmabGWmyTIoX0+a9j9UVCOhqeekwvavdOpqh9wr0PTGkX7+sJVjCPGP/WjFtgz68dZeMms97ENBVtJ/aCUp2ZB+39rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C8DC2BD10;
	Wed, 17 Jul 2024 20:51:44 +0000 (UTC)
Date: Wed, 17 Jul 2024 16:51:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 13/38] trace-cmd record: prevent a memory leak in
 show_error()
Message-ID: <20240717165143.7259d261@rorschach.local.home>
In-Reply-To: <20240605134054.2626953-14-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-14-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:28 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> In show_error() the pointer p is used for several functions. At some
> point it is used to contain the error log file. It's not freed before
> being replaced by the result of read_file(path), which is not freed
> either. Free p in both case.

This isn't that big of a deal as this is just an application that is
about to exit anyway. But I'm fine with freeing it. That said:

> 
> Fixes a RESOURCE_LEAK error (CWE-772)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  tracecmd/trace-record.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index f05a58d1..3e29f922 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -2364,13 +2364,16 @@ static void show_error(const char *file,
> const char *type) goto read_file;
>  		}
>  		read_error_log(p);
> +		free(p);
>  		goto out;
>  	}
>  
>   read_file:
>  	p = read_file(path);
> -	if (p)
> +	if (p) {
>  		printf("%s", p);
> +		free(p);
> +	}
>  
>   out:

It would be much cleaner to just add:

	free(p);

here, and remove the above two calls.

>  	printf("Failed %s of %s\n", type, file);

I'll skip this patch too.

-- Steve
