Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF39111A8
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721242233; cv=none; b=RXgF8c0zqAsxpfkshS7j2rjBk1FnSfEtObUxD6cqzeYZQW7Zryf3lvwsptVjo3SAaRi6P18B3s12vBcHZ3XnI2xSHF0TRqYW5O/prIEx0yRys40e1ovpPNie8ifqLpx51eDve+SkNIb33u7hMs5T8NoUQbRoSu2rCjH7mST6eHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721242233; c=relaxed/simple;
	bh=t6dSuAkrRWREX5kp1Rc7yDN6txgXXVa0c2ZyqnBlUKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JynB1rPjNtPiEdy2LU/mk0HEh4pzO3nkQKqWqNibn0fYxU3uyq8IRvnHzcCKpMQFH9sPVZd5fdYYnQla4t7pwhyWjDwDGkuFs1HUsMMxXv6tQsLwdx6Bjt2xRoOjHglSB5rfHZCOjUwN+tKBpL7jdhmXZThKNJDDecUbJ49UGLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC6FC2BD10;
	Wed, 17 Jul 2024 18:50:30 +0000 (UTC)
Date: Wed, 17 Jul 2024 14:50:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org, junxiao.bi@oracle.com
Subject: Re: [PATCH v2 2/2] trace-cmd: Add ftrace options for the fgraph
 retval feature
Message-ID: <20240717145028.73683d09@rorschach.local.home>
In-Reply-To: <20240521213730.67993-3-jianfeng.w.wang@oracle.com>
References: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
	<20240521213730.67993-3-jianfeng.w.wang@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 May 2024 14:37:30 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> Add two internal options for fgraph: fgraph:retval-skip and
> fgraph:retval-hex. By default, trace-cmd will print each function's
> return value at the function_graph exit point, if the kernel supports
> the fgraph-retval feature. If users want to skip the output of
> functions' return values, then set fgraph:retval-skip. Alternatively,
> users can set fgraph:retval-hex to force the return values to be
> printed in hex format.
> 
> Here are example commands:
> > trace-cmd report -O fgraph:retval-skip
> > trace-cmd report -O fgraph:retval-hex  

I would like to see a -O fgraph:retval-dec

As by default most is shown in hex, having an option to do that would
be great.

-- Steve


> 
> Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
> ---
>  lib/trace-cmd/trace-ftrace.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
> index 2b4e49a5..d2378833 100644
> --- a/lib/trace-cmd/trace-ftrace.c
> +++ b/lib/trace-cmd/trace-ftrace.c
> @@ -26,6 +26,18 @@ struct tep_plugin_option trace_ftrace_options[] = {
>  		.description =
>  		"Show the depth of each entry",
>  	},
> +	{
> +		.name = "retval-skip",
> +		.plugin_alias = "fgraph",
> +		.description =
> +		"Skip printing function retval in function graph",
> +	},
> +	{
> +		.name = "retval-hex",
> +		.plugin_alias = "fgraph",
> +		.description =
> +		"Print function retval in hex at function exit in function graph",
> +	},
>  	{
>  		.name = NULL,
>  	}
> @@ -33,6 +45,8 @@ struct tep_plugin_option trace_ftrace_options[] = {
>  
>  static struct tep_plugin_option *fgraph_tail = &trace_ftrace_options[0];
>  static struct tep_plugin_option *fgraph_depth = &trace_ftrace_options[1];
> +static struct tep_plugin_option *fgraph_retval_skip = &trace_ftrace_options[2];
> +static struct tep_plugin_option *fgraph_retval_hex = &trace_ftrace_options[3];
>  
>  static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
>  {
> @@ -235,8 +249,8 @@ print_graph_entry_leaf(struct trace_seq *s,
>  		ret = trace_seq_printf(s, " (%lld)", depth);
>  
>  	/* Return Value */
> -	if (ret && fgraph_retval_supported) {
> -		if (!IS_LINUX_ERR_VALUE(retval))
> +	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
>  			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
>  		else
>  			ret = trace_seq_printf(s, " (ret=%lld)", retval);
> @@ -385,8 +399,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
>  		trace_seq_printf(s, " (%lld)", depth);
>  
>  	/* Return Value */
> -	if (fgraph_retval_supported) {
> -		if (!IS_LINUX_ERR_VALUE(retval))
> +	if (fgraph_retval_supported && !fgraph_retval_skip->set) {
> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
>  			trace_seq_printf(s, " (ret=0x%llx)", retval);
>  		else
>  			trace_seq_printf(s, " (ret=%lld)", retval);

