Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A055886
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721256920; cv=none; b=kDGsIwW6qb7txsg7NPph/aePvQPvcGlpI5HrtfznYz1e1Jb4E/WQQV4kNkIvNJBdz4uMY9pptlwFJdxnLBl+mekO1iLxSbKHys4g+NIqCkUBA//WWvE3VJZO30RPqlbputzAdI0jaPF5d3kqn4YSM+5qb4pXzI9LBqRkegF5AiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721256920; c=relaxed/simple;
	bh=zb2tzD9vXqnqjVrZQ9BeqZW7OjcUn5rYqfVm9Sz9eco=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QrAoizw2XwD3V/Iiihg/uMtfJkwZfRKbjY/t44gxNcgWvwoj2Hti+nbR5AguoEZP80SP61PqPXI1picsQ7R/AjZMrcBT2MR4RXdzgI6Ex1vNBUuzh+K50pOjohaP0X80r0/V95rRBLUXURGHnxDJvKXb/L3RI09VTZGu9y/J/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837A1C2BD10;
	Wed, 17 Jul 2024 22:55:19 +0000 (UTC)
Date: Wed, 17 Jul 2024 18:55:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 22/38] trace-cmd dump: prevent buffer overrun in
 dump_clock()
Message-ID: <20240717185521.0589659e@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-23-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-23-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Note, please start the subject with a capital letter:

  trace-cmd dump: Prevent buffer overrun in dump_clock()

On Wed,  5 Jun 2024 15:40:37 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> The clock isn't big enough to hold the string with the null
> terminating character. Worse, clock[size], which is out of range, is
> set to 0. Allocate a big enough buffer.
> 
> Fixes an OVERRUN error (CWE-119)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  tracecmd/trace-dump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
> index 11c1baf1..c0a282c9 100644
> --- a/tracecmd/trace-dump.c
> +++ b/tracecmd/trace-dump.c
> @@ -961,7 +961,7 @@ static void dump_clock(int fd)
>  	}
>  	if (read_file_number(fd, &size, 8))
>  		die("cannot read clock size");
> -	clock = calloc(1, size);
> +	clock = calloc(1, size+1);

Also we follow the Linux kernel syntax. Please add spaces.

	clock = calloc(1, size + 1);

Care to resend. I'll skip this patch as well.

Thanks,

-- Steve



>  	if (!clock)
>  		die("cannot allocate clock %lld bytes", size);
>  

