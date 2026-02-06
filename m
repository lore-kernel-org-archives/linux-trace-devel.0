Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5045A26ED37
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Feb 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390096; cv=none; b=pksIeonzgVTn9j+JOKcAjml9rj/iFB4A6JtqAogMpQep8mAFEEGBGBx/3k7Om7fjMk3zPgUpPkhi/rb/iNQbUMO0DqVWWehc5hAXvaf0awTEKKsVSaLd0vOfh71ctDlJJ8AabIW1o33WleFfQAb8Xgno6WTsmN+NYJiyxBQaNnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390096; c=relaxed/simple;
	bh=a/XgbQ1RdEwxKA7wTJ8zJir8/cW7YTKByxGVPCaUIoY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDc/aRLcBpJcw7ZyWS/g+3xO3PZQovQwqNi++JMHw7OrdS9XyGfRT4Vnbw7E6uzs/mGI5NhE0un2Nh5nDnLHIfzmDVqB29l4ifyCdmcRFr8SgzmuXV5lJ0AaRPJ06ZtGiHr6CbHCtRDeAmwb9e6/F4nphDZRqJLUMPMUb/TdTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D64DC0F5F;
	Fri,  6 Feb 2026 15:01:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 3555920024;
	Fri,  6 Feb 2026 15:01:33 +0000 (UTC)
Date: Fri, 6 Feb 2026 10:02:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Donglin Peng <dolinux.peng@gmail.com>
Cc: mhiramat@kernel.org, linux-trace-devel@vger.kernel.org, Donglin Peng
 <pengdonglin@xiaomi.com>
Subject: Re: [PATCH RESEND] libtraceevent: Pretty print function parameters
 of enum-type
Message-ID: <20260206100211.78193ec0@gandalf.local.home>
In-Reply-To: <20260206091512.2127246-1-dolinux.peng@gmail.com>
References: <20260206091512.2127246-1-dolinux.peng@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3555920024
X-Stat-Signature: ik7az5u7a5omeet9nmaxt1779azwjacf
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/vZqRVYhPGF76O541W/EUglRaGf6K8BPk=
X-HE-Tag: 1770390093-938062
X-HE-Meta: U2FsdGVkX19fyCKDC0/HUQ2K3a7AUY69y8V7gTOAWZ2mtt9DyPUHdT/rbhVq1NJXDlfJB/JzNU7XClODxhw1m5XEAU/cBcar7NdbVrTGiQ3r11MXnlrJP7bpXG0wqb++H5ZDONvFv3uqBeNUQzQ6Hir6u5SqEpq45I1oC9Ebn/Ozv5NeHxKc9MHRifSSFj224HF8d9mkGcA4siwDbZwCSqC5cvQR+S4ynZ2oyzQuMVXoFifdyWUMbgIAjVFhl1YZOvWCWuEBdUBxcI4HlLIQjmDdDpEHNRGyAybf2wkJ8HF2z6+jbmHoD6CfcHMA8XdheULNXQjLnJVOyEGz20zbNZhWCH5iwO8/PRYy7iTSXlfpl5ysIVn4ec3WSZtBUIg+Q2Z7W83SvLVezRhjYkANQbXh8OpN6RHajjtlLrhujeOBYV0gNaLTXMw1pAeSjSHI/YdfgxdSKCU=

On Fri,  6 Feb 2026 17:15:12 +0800
Donglin Peng <dolinux.peng@gmail.com> wrote:

> From: Donglin Peng <pengdonglin@xiaomi.com>

Hi Donglin,

> 
> The tep_btf_print_args() function currently prints values of
> enum parameters in decimal format, which reduces readability.
> 
> Utilize the BTF information to resolve enum type parameters
> and print their symbolic names where possible. This enhances
> the trace log readability by displaying meaningful identifiers
> instead of raw numbers.
> 
> Before:
> mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5, val=320)
> 
> After:
> mod_memcg_lruvec_state(lruvec=0xffff88800c18a540, idx=5 [NR_SLAB_RECLAIMABLE_B], val=320)
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Donglin Peng <pengdonglin@xiaomi.com>
> ---
>  src/trace-btf.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/src/trace-btf.c b/src/trace-btf.c
> index 859b0860ce2a..85f5fefb4d3b 100644
> --- a/src/trace-btf.c
> +++ b/src/trace-btf.c
> @@ -32,6 +32,16 @@ struct tep_btf {
>  #define REALLOC_SIZE (1 << 10)
>  #define REALLOC_MASK (REALLOC_SIZE - 1)
>  
> +#define for_each_enum(i, enum_type, member)			\
> +	for (i = 0, member = btf_enum(enum_type);		\
> +	     i < BTF_INFO_VLEN(enum_type->info);		\
> +	     i++, member++)


You can make the above into:

 #define for_each_enum(enum_type, member)			\
	for (int __i = 0, member = btf_enum(enum_type);		\
	     __i < BTF_INFO_VLEN((enum_type)->info);		\
	     __i++, member++)

Then you don't need to pass in the counter "i".

(also it's good to put parenthesis around "enum_type").

> +
> +static inline struct btf_enum *btf_enum(const struct btf_type *t)
> +{
> +	return (struct btf_enum *)(t + 1);
> +}
> +
>  static const char *btf_name(struct tep_btf *btf, int off)
>  {
>  	if (off < btf->hdr->str_len)
> @@ -546,10 +556,11 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>  	struct tep_btf *btf = tep->btf;
>  	struct btf_type *type = tep_btf_find_func(btf, func);
>  	struct btf_param *param;
> +	struct btf_enum *enump;
>  	unsigned long long arg;
>  	unsigned int encode;
>  	const char *param_name;
> -	int a, p, x, nr;
> +	int a, p, x, nr, i;

And the above doesn't need to be changed.

Thanks,

-- Steve

>  
>  	if (!func)
>  		return -1;
> @@ -628,6 +639,13 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
>  			break;
>  		case BTF_KIND_ENUM:
>  			trace_seq_printf(s, "%lld", arg);
> +			for_each_enum(i, t, enump) {
> +				if (arg == enump->val) {
> +					trace_seq_printf(s, " [%s]",
> +						btf_name(btf, enump->name_off));
> +					break;
> +				}
> +			}
>  			break;
>  		default:
>  			/* This does not handle complex arguments */

