Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA3F4A0A
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 01:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721265405; cv=none; b=U/Id/TifWKzWfHatce3Q6ep7L6mTFKLepMF6lzzx4czW88MjXpggseRZrFL7QfnzFF6VoYgwKglacvTP4AU7i+W9nyg/Ltdw1Aa57mi9iLx+8CRIxL/zhrDB7cSE2umoXChSfCKHCGHmGhabUUB6SkG4sXWo1srvMql60sO5GKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721265405; c=relaxed/simple;
	bh=EZHymM1F8irt7C4Exe2gUSPztOOtm/a7V96HJ19y7ho=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HshRcALrpAIVVWxYzucNcf6spehtwsjaUKb4FZF6RfZum8z/dKcq2bHod5BTeCg4ptlokit9fyRMw8fMnlz+D+sebaStOt23RBzhp4kPKzEoeBdRg5yTc+0OFnOlNzsth3xO+lxNEBqA81vOzi8WN6EHtlvI864KmEsCUJfurWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DB8C2BD10;
	Thu, 18 Jul 2024 01:16:44 +0000 (UTC)
Date: Wed, 17 Jul 2024 21:16:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 32/38] trace-cmd lib: prevent memory leak in
 tracecmd_create_event_hook()
Message-ID: <20240717211647.2de08075@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-33-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-33-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:47 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> Free hook in the error path.
> 
> Fixes a RESOURCE_LEAK error (CWE-772)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  lib/trace-cmd/trace-hooks.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
> index a58b5356..47f25fb3 100644
> --- a/lib/trace-cmd/trace-hooks.c
> +++ b/lib/trace-cmd/trace-hooks.c
> @@ -151,6 +151,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
>  
>  invalid_tok:
>  	tracecmd_warning("Invalid hook format '%s'", arg);

Should we also have:

	free(hook->str);

here too?

-- Steve

> +	free(hook);
>  	return NULL;
>  }
>  

