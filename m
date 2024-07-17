Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2C1CAA6
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721248288; cv=none; b=cy1jCJANY0DB1NiwbJ4FDjJEOnwR2tHPyd09mFzCvAZYHjYcaxgq+Xk1N2S4X1CldMBU8wsMUabHJc4mKGi1sPVEcX4iM96X6BuIxivv8gO7SjjY976JGOBf+MxG6is/3H4FpUL2LeAwNPSBW83YxcTPLmop92o3yVMB1s0VBws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721248288; c=relaxed/simple;
	bh=qKTXGUawzssCEsyES3od2qKiphcyHvwSclrJuvms/mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZXqH5t+oMNBbRx/hqeU5vROj/WVxu2C9zAgJ78Hi7xYSL4QVHs3v2D3BxkXkKsTyBaBs7TzbuEQ5H/7RHeaZlMTBSM0KfVJLaPbnGQJe5+YPIAgQm0aXkNwZ4/GsaHuJsIyjFgFsBlfp79WtUTC9JD++61KE0VJgW7NoWKGy2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7986C32782;
	Wed, 17 Jul 2024 20:31:26 +0000 (UTC)
Date: Wed, 17 Jul 2024 16:31:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 08/38] trace-cmd lib: prevent a memory leak in
 create_event_list_item()
Message-ID: <20240717163119.0c3e816c@rorschach.local.home>
In-Reply-To: <20240605134054.2626953-9-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-9-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:23 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> Free ptr if malloc() fails.
> 
> Fixes a RESOURCE_LEAK error (CWE-772)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-output.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 59498edc..4a9ecc5d 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -955,7 +955,8 @@ create_event_list_item(struct tracecmd_output *handle,
>  	free(str);
>  	return;
>   err_mem:
> -	 tracecmd_warning("Insufficient memory");
> +	free(ptr);
> +	tracecmd_warning("Insufficient memory");

This function starts with:

	char *ptr;
	char *str;

	str = strdup(list->glob);
	if (!str)
		goto err_mem;

Where ptr is not defined yet.

I'm going to skip this patch.

-- Steve

>  }
>  
>  static int read_ftrace_files(struct tracecmd_output *handle, bool compress)

