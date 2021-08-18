Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E621FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B0F60231
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 16:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhHRQRd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhHRQRd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 12:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E8EF60560;
        Wed, 18 Aug 2021 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629303418;
        bh=VQc0RfptXCLVKtxTGLQTTT9stNUY5ZU13TkQFTOoN2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=psmjm2BgQpmU/LsiS1ex+xZ3wHaJRWP0+v+OFgJYJy/5d3aMeoJH6QTUTIzeSV8Ua
         BYCyFSTs4RqZdPQUMathB9AMFu8P8Kvol1Zfcz2uRTQoHlRI1YIeNO23Ep26XhLAWU
         OgsEEi+vgRiWwyn60N/2b0iPHwEu8ZqibEoRqXo3hY2jesnd0siGgxeqXM4VFDXXAj
         cxPuL+EBPrtxOO+ELw7Ldm5W4bRxy1b8w85QFi4ifrj7HduGBYcMbTuZGyutTaU51/
         vtsA+vyzK0IuvTrJezexvTnDTEnBRt9VtxXqBYyA8jtJl71UPitaQYnhPYK4PBQA8O
         gWML7rt7t1ZfQ==
Date:   Thu, 19 Aug 2021 01:16:56 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 3/7] tracing/probe: Have traceprobe_parse_probe_arg()
 take a const arg
Message-Id: <20210819011656.dc5c02b98132bcd8f87e37bc@kernel.org>
In-Reply-To: <20210817035027.385422828@goodmis.org>
References: <20210817034255.421910614@goodmis.org>
        <20210817035027.385422828@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 16 Aug 2021 23:42:58 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The two places that call traceprobe_parse_probe_arg() allocate a temporary
> buffer to copy the argv[i] into, because argv[i] is constant and the
> traceprobe_parse_probe_arg() will modify it to do the parsing. These two
> places allocate this buffer and then free it right after calling this
> function, leaving the onus of this allocation to the caller.
> 
> As there's about to be a third user of this function that will have to do
> the same thing, instead of having the caller allocate the temporary
> buffer, simply move that allocation into the traceprobe_parse_probe_arg()
> itself, which will simplify the code of the callers.
> 

Thanks, this looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c |  9 +------
>  kernel/trace/trace_probe.c  | 47 ++++++++++++++++++++++---------------
>  kernel/trace/trace_probe.h  |  2 +-
>  kernel/trace/trace_uprobe.c |  9 +------
>  4 files changed, 31 insertions(+), 36 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 82c3b86013b2..ed1e3c2087ab 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -873,15 +873,8 @@ static int __trace_kprobe_create(int argc, const char *argv[])
>  
>  	/* parse arguments */
>  	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
> -		tmp = kstrdup(argv[i], GFP_KERNEL);
> -		if (!tmp) {
> -			ret = -ENOMEM;
> -			goto error;
> -		}
> -
>  		trace_probe_log_set_index(i + 2);
> -		ret = traceprobe_parse_probe_arg(&tk->tp, i, tmp, flags);
> -		kfree(tmp);
> +		ret = traceprobe_parse_probe_arg(&tk->tp, i, argv[i], flags);
>  		if (ret)
>  			goto error;	/* This can be -ENOMEM */
>  	}
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 15413ad7cef2..ef717b373443 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -540,26 +540,34 @@ static int __parse_bitfield_probe_arg(const char *bf,
>  }
>  
>  /* String length checking wrapper */
> -static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
> +static int traceprobe_parse_probe_arg_body(const char *argv, ssize_t *size,
>  		struct probe_arg *parg, unsigned int flags, int offset)
>  {
>  	struct fetch_insn *code, *scode, *tmp = NULL;
>  	char *t, *t2, *t3;
> +	char *arg;
>  	int ret, len;
>  
> +	arg = kstrdup(argv, GFP_KERNEL);
> +	if (!arg)
> +		return -ENOMEM;
> +
> +	ret = -EINVAL;
>  	len = strlen(arg);
>  	if (len > MAX_ARGSTR_LEN) {
>  		trace_probe_log_err(offset, ARG_TOO_LONG);
> -		return -EINVAL;
> +		goto out;
>  	} else if (len == 0) {
>  		trace_probe_log_err(offset, NO_ARG_BODY);
> -		return -EINVAL;
> +		goto out;
>  	}
>  
> +	ret = -ENOMEM;
>  	parg->comm = kstrdup(arg, GFP_KERNEL);
>  	if (!parg->comm)
> -		return -ENOMEM;
> +		goto out;
>  
> +	ret = -EINVAL;
>  	t = strchr(arg, ':');
>  	if (t) {
>  		*t = '\0';
> @@ -571,22 +579,22 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  				offset += t2 + strlen(t2) - arg;
>  				trace_probe_log_err(offset,
>  						    ARRAY_NO_CLOSE);
> -				return -EINVAL;
> +				goto out;
>  			} else if (t3[1] != '\0') {
>  				trace_probe_log_err(offset + t3 + 1 - arg,
>  						    BAD_ARRAY_SUFFIX);
> -				return -EINVAL;
> +				goto out;
>  			}
>  			*t3 = '\0';
>  			if (kstrtouint(t2, 0, &parg->count) || !parg->count) {
>  				trace_probe_log_err(offset + t2 - arg,
>  						    BAD_ARRAY_NUM);
> -				return -EINVAL;
> +				goto out;
>  			}
>  			if (parg->count > MAX_ARRAY_LEN) {
>  				trace_probe_log_err(offset + t2 - arg,
>  						    ARRAY_TOO_BIG);
> -				return -EINVAL;
> +				goto out;
>  			}
>  		}
>  	}
> @@ -598,29 +606,30 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
>  		/* The type of $comm must be "string", and not an array. */
>  		if (parg->count || (t && strcmp(t, "string")))
> -			return -EINVAL;
> +			goto out;
>  		parg->type = find_fetch_type("string");
>  	} else
>  		parg->type = find_fetch_type(t);
>  	if (!parg->type) {
>  		trace_probe_log_err(offset + (t ? (t - arg) : 0), BAD_TYPE);
> -		return -EINVAL;
> +		goto out;
>  	}
>  	parg->offset = *size;
>  	*size += parg->type->size * (parg->count ?: 1);
>  
> +	ret = -ENOMEM;
>  	if (parg->count) {
>  		len = strlen(parg->type->fmttype) + 6;
>  		parg->fmt = kmalloc(len, GFP_KERNEL);
>  		if (!parg->fmt)
> -			return -ENOMEM;
> +			goto out;
>  		snprintf(parg->fmt, len, "%s[%d]", parg->type->fmttype,
>  			 parg->count);
>  	}
>  
>  	code = tmp = kcalloc(FETCH_INSN_MAX, sizeof(*code), GFP_KERNEL);
>  	if (!code)
> -		return -ENOMEM;
> +		goto out;
>  	code[FETCH_INSN_MAX - 1].op = FETCH_OP_END;
>  
>  	ret = parse_probe_arg(arg, parg->type, &code, &code[FETCH_INSN_MAX - 1],
> @@ -628,6 +637,7 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  	if (ret)
>  		goto fail;
>  
> +	ret = -EINVAL;
>  	/* Store operation */
>  	if (!strcmp(parg->type->name, "string") ||
>  	    !strcmp(parg->type->name, "ustring")) {
> @@ -636,7 +646,6 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  		    code->op != FETCH_OP_DATA) {
>  			trace_probe_log_err(offset + (t ? (t - arg) : 0),
>  					    BAD_STRING);
> -			ret = -EINVAL;
>  			goto fail;
>  		}
>  		if ((code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
> @@ -650,7 +659,6 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  			code++;
>  			if (code->op != FETCH_OP_NOP) {
>  				trace_probe_log_err(offset, TOO_MANY_OPS);
> -				ret = -EINVAL;
>  				goto fail;
>  			}
>  		}
> @@ -672,7 +680,6 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  		code++;
>  		if (code->op != FETCH_OP_NOP) {
>  			trace_probe_log_err(offset, TOO_MANY_OPS);
> -			ret = -EINVAL;
>  			goto fail;
>  		}
>  		code->op = FETCH_OP_ST_RAW;
> @@ -687,6 +694,7 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  			goto fail;
>  		}
>  	}
> +	ret = -EINVAL;
>  	/* Loop(Array) operation */
>  	if (parg->count) {
>  		if (scode->op != FETCH_OP_ST_MEM &&
> @@ -694,13 +702,11 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  		    scode->op != FETCH_OP_ST_USTRING) {
>  			trace_probe_log_err(offset + (t ? (t - arg) : 0),
>  					    BAD_STRING);
> -			ret = -EINVAL;
>  			goto fail;
>  		}
>  		code++;
>  		if (code->op != FETCH_OP_NOP) {
>  			trace_probe_log_err(offset, TOO_MANY_OPS);
> -			ret = -EINVAL;
>  			goto fail;
>  		}
>  		code->op = FETCH_OP_LP_ARRAY;
> @@ -709,6 +715,7 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  	code++;
>  	code->op = FETCH_OP_END;
>  
> +	ret = 0;
>  	/* Shrink down the code buffer */
>  	parg->code = kcalloc(code - tmp + 1, sizeof(*code), GFP_KERNEL);
>  	if (!parg->code)
> @@ -724,6 +731,8 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  				kfree(code->data);
>  	}
>  	kfree(tmp);
> +out:
> +	kfree(arg);
>  
>  	return ret;
>  }
> @@ -745,11 +754,11 @@ static int traceprobe_conflict_field_name(const char *name,
>  	return 0;
>  }
>  
> -int traceprobe_parse_probe_arg(struct trace_probe *tp, int i, char *arg,
> +int traceprobe_parse_probe_arg(struct trace_probe *tp, int i, const char *arg,
>  				unsigned int flags)
>  {
>  	struct probe_arg *parg = &tp->args[i];
> -	char *body;
> +	const char *body;
>  
>  	/* Increment count for freeing args in error case */
>  	tp->nr_args++;
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 227d518e5ba5..42aa084902fa 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -354,7 +354,7 @@ int trace_probe_create(const char *raw_command, int (*createfn)(int, const char
>  #define TPARG_FL_MASK	GENMASK(2, 0)
>  
>  extern int traceprobe_parse_probe_arg(struct trace_probe *tp, int i,
> -				char *arg, unsigned int flags);
> +				const char *argv, unsigned int flags);
>  
>  extern int traceprobe_update_arg(struct probe_arg *arg);
>  extern void traceprobe_free_probe_arg(struct probe_arg *arg);
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 1e2a92e7607d..93ff96541971 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -684,16 +684,9 @@ static int __trace_uprobe_create(int argc, const char **argv)
>  
>  	/* parse arguments */
>  	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
> -		tmp = kstrdup(argv[i], GFP_KERNEL);
> -		if (!tmp) {
> -			ret = -ENOMEM;
> -			goto error;
> -		}
> -
>  		trace_probe_log_set_index(i + 2);
> -		ret = traceprobe_parse_probe_arg(&tu->tp, i, tmp,
> +		ret = traceprobe_parse_probe_arg(&tu->tp, i, argv[i],
>  					is_return ? TPARG_FL_RETURN : 0);
> -		kfree(tmp);
>  		if (ret)
>  			goto error;
>  	}
> -- 
> 2.30.2


-- 
Masami Hiramatsu <mhiramat@kernel.org>
