Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2F12262B
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 21:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721250633; cv=none; b=WMNXkJ0KbyEW09PLfQ/ILIFdLiRGTn4/q8YMnR4gL3dghaiw9tUEY0EEHGrAfOk3rqJnQNGhWXQCoJN+Ws5/LopfhJPbVTmrA/2e01omL/KwiSXGko/NXO6/8YQhOjmymTQUo8jOW0UjI1DOgf6v1bC3D65y5VdHClZCvkqEZxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721250633; c=relaxed/simple;
	bh=4t7HtW+DrjIjEZqX6absiTvTX3/YPL0BxcKQWYT/oI4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTp1FkE+Ul6tkCQVWGaM0RCwcLNH9whtd1RFyc59SVxnnib84wpXEGm0DonrR8mvSrXIsUzyo24oM/SDVlPUVwXzZhaFgEJyjeNozh7mhu5btXvfHYJG4KAOQb1z2N4gt2yZ4AtHbg8g3eGvjX9/k18TRy1i03HR7We+EDGwIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC24C4AF09;
	Wed, 17 Jul 2024 21:10:32 +0000 (UTC)
Date: Wed, 17 Jul 2024 17:10:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 15/38] trace-cmd lib: check the return value of
 do_lssek() in trace_get_options()
Message-ID: <20240717171030.03117c8f@rorschach.local.home>
In-Reply-To: <20240605134054.2626953-16-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-16-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Note the subject has a typo "lssek".


On Wed,  5 Jun 2024 15:40:30 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> Check that do_lseek doesn't fail before calling malloc() with a -1
> argument.
> 
> This is flagged as an overrun error (CWE-119) by static anaysis
> because of the call to read() later, but I don't imagine that malloc
> would succeed.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-output.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 5ba0a145..35904620 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -2069,6 +2069,8 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
>  	}
>  
>  	offset = do_lseek(&out_handle, 0, SEEK_CUR);
> +	if(offset == (off_t)-1)

Nit, the above has whitespace issues:

	if (offset == (off_t)-1)

Could you resend this?

Thanks,

-- Steve

> +		goto out;
>  	buf = malloc(offset);
>  	if (!buf)
>  		goto out;

