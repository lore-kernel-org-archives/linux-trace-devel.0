Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227BD2BB05
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jul 2024 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721421156; cv=none; b=BI/Q/dSvPoNB7T3NXRZb+b6JaCj9I6RfqTDyhTbeZ3E30RNyGG/SYZmu3gigfCxbyIG2e7Dbg1xg9NBVme4UiGXwUmAGgXwOfHlJqidQa+sscDrUeQEPuhZxEGXaQHblpnq2HjDrZ4e9w+bIukLoMVDUATB8/slITbp/EPH3Wpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721421156; c=relaxed/simple;
	bh=UN0jnWNCXx289nJ+bQWmeUJENTZ7sWAMJhYi2I2xK3I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHsUPHb49SS2YaZ/Ks9mM/iM20lEJeXWO6ecUC570zaJ+ys17SeW1ZjwHJWK+XmiJYnbtJNke2vNoAHyKJNfYn5dcDFxjVUgly2RREA0Cql9DofwMvnQZjZ4Lcz4c3iseRjqRg7GIO6r15dZnrsvAT3x84t4sAXcHg4Ohd+Zcoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45764C4AF0E;
	Fri, 19 Jul 2024 20:32:35 +0000 (UTC)
Date: Fri, 19 Jul 2024 16:32:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Subject: Re: [PATCH] libtraceevent: Fix a double free in process_op()
Message-ID: <20240719163242.690f4c0e@gandalf.local.home>
In-Reply-To: <20240626033949.1017381-1-namhyung@google.com>
References: <20240626033949.1017381-1-namhyung@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Jun 2024 20:39:49 -0700
Namhyung Kim <namhyung@gmail.com> wrote:

> When process_cond() failed, it freed the token but didn't reset the
> arg->op.op to NULL.  So it tried to free the arg->op.op again from
> free_arg() from the caller and resulted in a double free.
> 
> Signed-off-by: Namhyung Kim <namhyung@google.com>
> ---
>  src/event-parse.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 9f0522c..c327917 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2375,8 +2375,11 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>  
>  		/* it will set arg->op.right */
>  		type = process_cond(event, arg, tok);
> -		if (type == TEP_EVENT_ERROR)
> -			free(token);
> +		if (type == TEP_EVENT_ERROR) {
> +			/* arg->op.op (= token) will be freed at out_free */
> +			arg->op.op = NULL;
> +			goto out_free;
> +		}
>  
>  	} else if (strcmp(token, ">>") == 0 ||
>  		   strcmp(token, "<<") == 0 ||

Hmm, so this fixes:

76a0eb8d5a20c ("libtraceevent: Fix event-parse memory leak in process_cond")

Which added:

+               if (type == TEP_EVENT_ERROR)
+                       free(token);

because of a memory leak. But if token is arg->op, and we should be freeing
that arg, how did it end up being a leak?

Because args->op.left is allocated. Whatever frees that, should also have
freed args->op.op.

I'm getting a feeling that we are missing the real bug.

Perhaps the real fix was:

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c8d9e4..c7ffad116c3f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2375,8 +2375,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 
 		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
-		if (type == TEP_EVENT_ERROR)
-			free(token);
 
 	} else if (strcmp(token, ">>") == 0 ||
 		   strcmp(token, "<<") == 0 ||
@@ -2587,6 +2585,9 @@ static int alloc_and_process_delim(struct tep_event *event, char *next_token,
 	if (type == TEP_EVENT_OP) {
 		type = process_op(event, field, &token);
 
+		if (type == TEP_EVENT_ERROR)
+			goto out_error;
+
 		if (consolidate_op_arg(field) < 0)
 			type = TEP_EVENT_ERROR;
 
-- Steve
