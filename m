Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFE2C2D0;
	Sat,  4 Nov 2023 10:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlNk1U0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F89C433BA;
	Sat,  4 Nov 2023 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699095574;
	bh=KcH3qtrbrngsmcLmJ9FlXeAJy5bZDec5KEhDaAEVk3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AlNk1U0oZ3ISi8TOWwssSrRJFs0B7YQBch4HvrDq0LyHReYD+ZnwydQYjBSTU9lxU
	 nuywVDYZjKtOBsCdP37kdVQIgRGwOxOkvXD3W7x0CFxmEn02yOybwaA4mkwI3gkMF+
	 AOFzXbuO5hhXov/xwQwxw9zXQlCmXKyYgyYZsQQ5S0odfCLgsCz8CZiIKmInROVyLC
	 5d36LB6GadaTQgNQ/Jnt3/ae5pSHEF34h3WshVtgFl2qcbwl9aFzlSbDKfz01/70f5
	 INZ2RnOyKJUueoa/rUU+XzEpIhvxnfFzsgsZFsfiEBHFNRZTmj+p/hMlgdko8Hh2pm
	 IjRk0wt/2NWWg==
Date: Sat, 4 Nov 2023 19:59:29 +0900
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
Subject: Re: [PATCH 05/48] perf dwarf-aux: Move #ifdef code to the header
 file
Message-Id: <20231104195929.d229225a0dc6242ba8c8a517@kernel.org>
In-Reply-To: <20231012035111.676789-6-namhyung@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
	<20231012035111.676789-6-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 20:50:28 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> It's a usual convention that the conditional code is handled in a header
> file.  As I'm planning to add some more of them, let's move the current
> code to the header first.

OK, looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks,

> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/dwarf-aux.c |  7 -------
>  tools/perf/util/dwarf-aux.h | 19 +++++++++++++++++--
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 4849c3bbfd95..adef2635587d 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -1245,13 +1245,6 @@ int die_get_var_range(Dwarf_Die *sp_die, Dwarf_Die *vr_die, struct strbuf *buf)
>  out:
>  	return ret;
>  }
> -#else
> -int die_get_var_range(Dwarf_Die *sp_die __maybe_unused,
> -		      Dwarf_Die *vr_die __maybe_unused,
> -		      struct strbuf *buf __maybe_unused)
> -{
> -	return -ENOTSUP;
> -}
>  #endif
>  
>  /*
> diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
> index 7ec8bc1083bb..4f5d0211ee4f 100644
> --- a/tools/perf/util/dwarf-aux.h
> +++ b/tools/perf/util/dwarf-aux.h
> @@ -121,7 +121,6 @@ int die_get_typename(Dwarf_Die *vr_die, struct strbuf *buf);
>  
>  /* Get the name and type of given variable DIE, stored as "type\tname" */
>  int die_get_varname(Dwarf_Die *vr_die, struct strbuf *buf);
> -int die_get_var_range(Dwarf_Die *sp_die, Dwarf_Die *vr_die, struct strbuf *buf);
>  
>  /* Check if target program is compiled with optimization */
>  bool die_is_optimized_target(Dwarf_Die *cu_die);
> @@ -130,4 +129,20 @@ bool die_is_optimized_target(Dwarf_Die *cu_die);
>  void die_skip_prologue(Dwarf_Die *sp_die, Dwarf_Die *cu_die,
>  		       Dwarf_Addr *entrypc);
>  
> -#endif
> +#ifdef HAVE_DWARF_GETLOCATIONS_SUPPORT
> +
> +/* Get byte offset range of given variable DIE */
> +int die_get_var_range(Dwarf_Die *sp_die, Dwarf_Die *vr_die, struct strbuf *buf);
> +
> +#else /*  HAVE_DWARF_GETLOCATIONS_SUPPORT */
> +
> +static inline int die_get_var_range(Dwarf_Die *sp_die __maybe_unused,
> +				    Dwarf_Die *vr_die __maybe_unused,
> +				    struct strbuf *buf __maybe_unused)
> +{
> +	return -ENOTSUP;
> +}
> +
> +#endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT */
> +
> +#endif /* _DWARF_AUX_H */
> -- 
> 2.42.0.655.g421f12c284-goog
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
