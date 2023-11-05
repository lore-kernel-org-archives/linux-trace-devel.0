Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5DD8813;
	Sun,  5 Nov 2023 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ET/GOvTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B231C433C7;
	Sun,  5 Nov 2023 09:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699177832;
	bh=yVDAG+Wg7NzlCWgHtRHjaf+Zk9FIY44KvEALOUGTSg4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ET/GOvTwRaR0OvMf3Y9dtX2mYgIzoiXTWFznB7vyz0caFbk1ANPjNbKuylWhsSoBP
	 3MfJhS3D5m1CAx8rSIp4uqnrHnDv9owcYCE14fiHlG3LPVHcgRL7YF9o3zzDIRImWk
	 dVxcyHSgn3dc9NNXic348e2kzBmtK1ILv6p9Waph9aa++9rYGu4pfd6g5MUgZDMq1k
	 xAv4yjT+vo7zZdHjiXU749SrC7SaQLsRRejBIr9mH3rAZ5JEefM6wb4oZgAB6wnrKF
	 fER0q/rMMJWm2x6U7PWBjg+nG87iFKBqVNM5vRaq2Nr8oHmrhRz6+ypVyOYzcQXIRw
	 EzlIWBlEfGVVw==
Date: Sun, 5 Nov 2023 18:50:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ian Rogers
 <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar
 <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org,
 linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 06/48] perf dwarf-aux: Add die_get_scopes() helper
Message-Id: <20231105185027.c99fe50fb182a44ee6d259ed@kernel.org>
In-Reply-To: <20231012035111.676789-7-namhyung@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
	<20231012035111.676789-7-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 20:50:29 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> The die_get_scopes() would return the number of enclosing DIEs for the
> given address and it fills an array of DIEs like dwarf_getscopes().
> But it doesn't follow the abstract origin of inlined functions as we
> want information of the concrete instance.  This is needed to check the
> location of parameters and local variables properly.  Users can check
> the origin separately if needed.

This looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks

> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/dwarf-aux.c | 53 +++++++++++++++++++++++++++++++++++++
>  tools/perf/util/dwarf-aux.h |  3 +++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index adef2635587d..10aa32334d6f 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -1425,3 +1425,56 @@ void die_skip_prologue(Dwarf_Die *sp_die, Dwarf_Die *cu_die,
>  
>  	*entrypc = postprologue_addr;
>  }
> +
> +/* Internal parameters for __die_find_scope_cb() */
> +struct find_scope_data {
> +	/* Target instruction address */
> +	Dwarf_Addr pc;
> +	/* Number of scopes found [output] */
> +	int nr;
> +	/* Array of scopes found, 0 for the outermost one. [output] */
> +	Dwarf_Die *scopes;
> +};
> +
> +static int __die_find_scope_cb(Dwarf_Die *die_mem, void *arg)
> +{
> +	struct find_scope_data *data = arg;
> +
> +	if (dwarf_haspc(die_mem, data->pc)) {
> +		Dwarf_Die *tmp;
> +
> +		tmp = realloc(data->scopes, (data->nr + 1) * sizeof(*tmp));
> +		if (tmp == NULL)
> +			return DIE_FIND_CB_END;
> +
> +		memcpy(tmp + data->nr, die_mem, sizeof(*die_mem));
> +		data->scopes = tmp;
> +		data->nr++;
> +		return DIE_FIND_CB_CHILD;
> +	}
> +	return DIE_FIND_CB_SIBLING;
> +}
> +
> +/**
> + * die_get_scopes - Return a list of scopes including the address
> + * @cu_die: a compile unit DIE
> + * @pc: the address to find
> + * @scopes: the array of DIEs for scopes (result)
> + *
> + * This function does the same as the dwarf_getscopes() but doesn't follow
> + * the origins of inlined functions.  It returns the number of scopes saved
> + * in the @scopes argument.  The outer scope will be saved first (index 0) and
> + * the last one is the innermost scope at the @pc.
> + */
> +int die_get_scopes(Dwarf_Die *cu_die, Dwarf_Addr pc, Dwarf_Die **scopes)
> +{
> +	struct find_scope_data data = {
> +		.pc = pc,
> +	};
> +	Dwarf_Die die_mem;
> +
> +	die_find_child(cu_die, __die_find_scope_cb, &data, &die_mem);
> +
> +	*scopes = data.scopes;
> +	return data.nr;
> +}
> diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
> index 4f5d0211ee4f..f9d765f80fb0 100644
> --- a/tools/perf/util/dwarf-aux.h
> +++ b/tools/perf/util/dwarf-aux.h
> @@ -129,6 +129,9 @@ bool die_is_optimized_target(Dwarf_Die *cu_die);
>  void die_skip_prologue(Dwarf_Die *sp_die, Dwarf_Die *cu_die,
>  		       Dwarf_Addr *entrypc);
>  
> +/* Get the list of including scopes */
> +int die_get_scopes(Dwarf_Die *cu_die, Dwarf_Addr pc, Dwarf_Die **scopes);
> +
>  #ifdef HAVE_DWARF_GETLOCATIONS_SUPPORT
>  
>  /* Get byte offset range of given variable DIE */
> -- 
> 2.42.0.655.g421f12c284-goog
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
