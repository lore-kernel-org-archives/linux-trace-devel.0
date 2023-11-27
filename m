Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D293FE24;
	Mon, 27 Nov 2023 19:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2sQ4S3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DB7C433C8;
	Mon, 27 Nov 2023 19:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701111961;
	bh=jWZG1gBzG2n4l5Z6e4uA8a6o/3Y9U1UeH9V99Lsj3XU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2sQ4S3++0vD3owjSxy+rU/Z/MxDCUYSOhOax/B8u4Nky8F+g3qW2ib8HWqGWU787
	 DKA3+FWmNonPEc7GKSoEJR0dFniiRefwkM+w2aBaY8p+2xzfGMrZDTfwaFuOWzxJp/
	 7BgT4Om8tkWLMaz9J1xaiK6KwK1pM37kHBSZfIMtDkDDhy+zNFG70oEx/F7hqwGAlx
	 l7/kUJK3pcWdRdbyiWZTMKkWViLr8VGn/yHDa7rVFzmahVZEgrvbh4hf9l+OOFVoTN
	 8DxGDpsto4qHF4sHuLK+To9NVwgRuK048qNdg06REWPqaaDVyiIpFoXLZoZ9a/x2Dm
	 jI3sXbjxXGZKA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
	id C7FD040094; Mon, 27 Nov 2023 16:05:58 -0300 (-03)
Date: Mon, 27 Nov 2023 16:05:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephane Eranian <eranian@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-toolchains@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 02/48] perf annotate: Check if operand has multiple regs
Message-ID: <ZWTolqh/ORTho4FR@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
 <20231012035111.676789-3-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012035111.676789-3-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com

Em Wed, Oct 11, 2023 at 08:50:25PM -0700, Namhyung Kim escreveu:
> It needs to check all possible information in an instruction.  Let's add
> a field indicating if the operand has multiple registers.  I'll be used
> to search type information like in an array access on x86 like:
> 
>   mov    0x10(%rax,%rbx,8), %rcx
>              -------------
>                  here

Cherry picked this patch.

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/annotate.c | 36 ++++++++++++++++++++++++++++++++++++
>  tools/perf/util/annotate.h |  2 ++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 211636e65b03..605298410ed4 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -85,6 +85,8 @@ struct arch {
>  	struct		{
>  		char comment_char;
>  		char skip_functions_char;
> +		char register_char;
> +		char memory_ref_char;
>  	} objdump;
>  };
>  
> @@ -188,6 +190,8 @@ static struct arch architectures[] = {
>  		.insn_suffix = "bwlq",
>  		.objdump =  {
>  			.comment_char = '#',
> +			.register_char = '%',
> +			.memory_ref_char = '(',
>  		},
>  	},
>  	{
> @@ -566,6 +570,34 @@ static struct ins_ops lock_ops = {
>  	.scnprintf = lock__scnprintf,
>  };
>  
> +/*
> + * Check if the operand has more than one registers like x86 SIB addressing:
> + *   0x1234(%rax, %rbx, 8)
> + *
> + * But it doesn't care segment selectors like %gs:0x5678(%rcx), so just check
> + * the input string after 'memory_ref_char' if exists.
> + */
> +static bool check_multi_regs(struct arch *arch, const char *op)
> +{
> +	int count = 0;
> +
> +	if (arch->objdump.register_char == 0)
> +		return false;
> +
> +	if (arch->objdump.memory_ref_char) {
> +		op = strchr(op, arch->objdump.memory_ref_char);
> +		if (op == NULL)
> +			return false;
> +	}
> +
> +	while ((op = strchr(op, arch->objdump.register_char)) != NULL) {
> +		count++;
> +		op++;
> +	}
> +
> +	return count > 1;
> +}
> +
>  static int mov__parse(struct arch *arch, struct ins_operands *ops, struct map_symbol *ms __maybe_unused)
>  {
>  	char *s = strchr(ops->raw, ','), *target, *comment, prev;
> @@ -593,6 +625,8 @@ static int mov__parse(struct arch *arch, struct ins_operands *ops, struct map_sy
>  	if (ops->source.raw == NULL)
>  		return -1;
>  
> +	ops->source.multi_regs = check_multi_regs(arch, ops->source.raw);
> +
>  	target = skip_spaces(++s);
>  	comment = strchr(s, arch->objdump.comment_char);
>  
> @@ -613,6 +647,8 @@ static int mov__parse(struct arch *arch, struct ins_operands *ops, struct map_sy
>  	if (ops->target.raw == NULL)
>  		goto out_free_source;
>  
> +	ops->target.multi_regs = check_multi_regs(arch, ops->target.raw);
> +
>  	if (comment == NULL)
>  		return 0;
>  
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index 9d8b4199e3bd..e33a55431bad 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -39,12 +39,14 @@ struct ins_operands {
>  		s64	offset;
>  		bool	offset_avail;
>  		bool	outside;
> +		bool	multi_regs;
>  	} target;
>  	union {
>  		struct {
>  			char	*raw;
>  			char	*name;
>  			u64	addr;
> +			bool	multi_regs;
>  		} source;
>  		struct {
>  			struct ins	    ins;
> -- 
> 2.42.0.655.g421f12c284-goog
> 

-- 

- Arnaldo
