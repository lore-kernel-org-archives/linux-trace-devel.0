Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C50186A
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 01:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721267447; cv=none; b=T3Q+vtGPapWP5jGg5VqeXiQy8ruskSMCkzl1y2DnE+bS6u0Xxl9AZCt2YDD9j0jvq5/8XrkkVn30Fmr5QgsC73Eu+BjFPRgQY76PEpO/WxghKDEOxJABELMXDqbGMgzWttkyhSiqNTJHX16MsfveFjLCSF5calDqxbOLY1RTbfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721267447; c=relaxed/simple;
	bh=3VKjqNV7uOFcRq+Me0RUTNK4IJ142AXj29MtUSXtf34=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBfqqNYtiAs7bWNmwxJQiAPFLQDtyWXrVm9NPrgN3qJCKPA94CL5FDNusnxZt0r6DHOAT9lCmnb6j2SlTiTxdohcmlf1SkpkyxE3NElW7kVIqjfBk9499PaSs43Gp3+MJRnMOiv/GPe+x3DWDMaRzWz5pCDLGR1H1FdRmb/MkrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F889C2BD10;
	Thu, 18 Jul 2024 01:50:47 +0000 (UTC)
Date: Wed, 17 Jul 2024 21:50:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 33/38] trace-cmd record: prevent memory corruption in
 parse_record_options()
Message-ID: <20240717215050.07a16e34@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-34-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-34-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:48 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> In parse_record_options() we can end up using a deleted instance after
> options have been parsed. This can be triggered by the following
> command:
> $ trace-cmd record -v -e block -B foo  ls
> 
> We probably need a proper to avoid to end up in this situation, but in
> the mean time, check that the current instance isn't marked for
> deletion before calling remove_instances(). That at least prevent an
> hard to debug memory corruption bug.
> 
> Fixes a USE_AFTER_FREE error (CWE-416)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  tracecmd/trace-record.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 770e775b..dc3e5285 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6909,6 +6909,8 @@ static void parse_record_options(int argc,
>  		}
>  	}
>  
> +	if (ctx->instance->delete)
> +		die("Instance to be deleted is still used");

This looks to only be an issue for record. Deletion of instances should
only be for the trace-cmd set command.

>  	remove_instances(del_list);
>  
>  	/* If --date is specified, prepend it to all guest VM flags */

I'll add this patch:

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4e9ac598..1527be11 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6748,7 +6748,8 @@ static void parse_record_options(int argc,
 			ctx->instance = allocate_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
-			ctx->instance->delete = negative;
+			if (IS_CMDSET(ctx))
+				ctx->instance->delete = negative;
 			negative = 0;
 			if (ctx->instance->delete) {
 				ctx->instance->next = del_list;

Which should fix the issue as well.

Thanks,

-- Steve
