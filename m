Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6143813C9B3
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 22:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721859460; cv=none; b=TWnYvHvwJhKXjYY5YuMUpRNs0R9UiZgqLGNpe8LMHVG161n4d3Xp9vkpvcxRO0SL8lBOv0B2NqEbYqL+yIi/0ZCzWc9qWxgkoGrKvT7Zh0sg5Aoh7dJ1+KgaERaspXWN9FTsbzpXeeVK6IlxCcdMs4YdnWvWXwiHIqfyXBpSc44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721859460; c=relaxed/simple;
	bh=2w+hAQB5CSUFtWfH2wb3/IhLprPFIbMXwXnmznzThV8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T1YMF43ImaxmXir8bAWNcjVr4PWnl3WcJ7cqiXM2JODItGaDh7TFgSk1epdr2/7VUsMZH3SuJqLchQlV8585X01Y4d0GjIjXouXSdxhIom3qeyPArtgRVYoFTLItWOgb9/zmUahsw86JZLbt1Dh/CzWjgMw35lZBDQ+gGKZu/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F0C32781;
	Wed, 24 Jul 2024 22:17:39 +0000 (UTC)
Date: Wed, 24 Jul 2024 18:17:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tw <tw19881113@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] Fix double free issue in event_read_print_args
Message-ID: <20240724181758.110168d9@gandalf.local.home>
In-Reply-To: <20240701022446.23492-1-tw19881113@gmail.com>
References: <20240701022446.23492-1-tw19881113@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  1 Jul 2024 10:24:46 +0800
Tw <tw19881113@gmail.com> wrote:

> The corner case is that when we encounter a invalid right argument of a condition operation.
> Currently, we free token immediately, but it will also be freed when free `arg->op.op`.
> 
> BTW, the crash calltrace as follows:

OK, so someone else sent a patch for the same bug, but the cause of the bug
ended up being something different.

https://lore.kernel.org/linux-trace-devel/20240719163242.690f4c0e@gandalf.local.home/
https://lore.kernel.org/linux-trace-devel/20240722161917.991077-1-namhyung@google.com


> 
> Program received signal SIGSEGV, Segmentation fault.
> get_meta (p=<optimized out>) at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
> 141     /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h: No such file or directory.
> (gdb) bt
>     at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/meta.h:141
>     at /home/tw/code/zig/build/stage3/lib/zig/libc/musl/src/malloc/mallocng/free.c:105
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1128
>     list@entry=0x7ff7b18768)
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:1417
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:3895
>     sys=<optimized out>)
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7824
>     size=<optimized out>, sys=sys@entry=0x7ff7ff51c0 "kvm")
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7882
>     buf=0x7ff7b0c610 "kvm_sys_access", size=549616874800, sys=0x7fffffe0b2 "me", sys@entry=0x7ff7ff51c0 "kvm")
>     at /tmp/.cache/zig/p/12207a2e4477bf4414e7df3eb2172c698ab916695a0d3eefbf16f65b0c969dd81184/src/event-parse.c:7945
>     tracing_dir=tracing_dir@entry=0x7ff7ffc660 "/sys/kernel/tracing", system=system@entry=0x7ff7ff51c0 "kvm",
>     check=false)
>     at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1062
>     system=0x7ff7ff51c0 "kvm")
>     at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1084
>     tep=tep@entry=0x7ff7ffc830, sys_names=sys_names@entry=0x0, parsing_failures=0x0,
>     parsing_failures@entry=0x7fffffe7b0)
>     at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1284
>     sys_names@entry=0x7ffffff880)
>     at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1355
>     tracing_dir=0x6500006c6f6f62 <error: Cannot access memory at address 0x6500006c6f6f62>)
>     at /tmp/.cache/zig/p/1220c1c006cbf05434d240b65f343c84f3d7f837fbef31f2cade733ec911cc3ed76b/src/tracefs-events.c:1377
> 
> Signed-off-by: Tw <tw19881113@gmail.com>
> ---
>  src/event-parse.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 9f0522c..1f51ee9 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2375,8 +2375,6 @@ process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>  
>  		/* it will set arg->op.right */
>  		type = process_cond(event, arg, tok);
> -		if (type == TEP_EVENT_ERROR)
> -			free(token);

This should be removed, but how to fix the bug for the reason it was added
in the first place must be done too.

>  
>  	} else if (strcmp(token, ">>") == 0 ||
>  		   strcmp(token, "<<") == 0 ||
> @@ -3787,7 +3785,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
>  {
>  	enum tep_event_type type = TEP_EVENT_ERROR;
>  	struct tep_print_arg *arg;
> -	char *token;
> +	char *token = NULL;

This is unneeded because token is assigned later:

		if (type == TEP_EVENT_NEWLINE) {
			type = read_token_item(event->tep, &token);
			continue;
		}

where read_token_item() has:

  static enum tep_event_type read_token_item(struct tep_handle *tep, char **tok)
  {
	enum tep_event_type type;

	for (;;) {
		type = __read_token(tep, tok);


And:

  static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
  {
	char buf[BUFSIZ];
	int ch, last_ch, quote_ch, next_ch;
	int i = 0;
	int tok_size = 0;
	enum tep_event_type type;

	*tok = NULL;

So that does the "token = NULL", and if that first if doesn't get hit in
event_read_print_args(), it then does:

		type = process_arg(event, arg, &token);

Where process_arg() is:

  static enum tep_event_type
  process_arg(struct tep_event *event, struct tep_print_arg *arg, char **tok)
  {
	enum tep_event_type type;
	char *token;

	type = read_token(event->tep, &token);

Which assigns token.

Hence, initializing "token" is not needed.

>  	int args = 0;
>  
>  	do {
> @@ -3817,6 +3815,7 @@ static int event_read_print_args(struct tep_event *event, struct tep_print_arg *
>  		if (type == TEP_EVENT_OP) {
>  			type = process_op(event, arg, &token);
>  			free_token(token);
> +			token = NULL;
>  
>  			if (consolidate_op_arg(arg) < 0)
>  				type = TEP_EVENT_ERROR;

Now this part does have the bug. But that's fixed in the links I showed.
The key thing was to look at the result of "type". It was not about freeing
token, because if the type returned was TEP_EVENT_ERROR, that
consolidate_op_arg() should never had been called.

Thanks,

-- Steve
