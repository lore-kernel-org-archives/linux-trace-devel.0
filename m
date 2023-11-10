Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08EA13ADB;
	Fri, 10 Nov 2023 10:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0sq7VbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3786C433C7;
	Fri, 10 Nov 2023 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699611956;
	bh=JZISxcimReBhko2Zl99MgOPt2Pg9GAOJkrwz5NhlZNM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c0sq7VbUWBmKRB5EsVyaE60FSCiM4Y+h51KYdbHUcT/SlWL52uM24p1jdq89o25IH
	 0UbAJQv6fAeJim+u2HAPESj+eKM+lhNQfLh6MbgCd9mrCq4iI8SMe6JnRLYhjrvYXw
	 4TWG/Riaqs/UhJphFOAM7uoFKwvDwrPks7ZYbg/J85K3SR/DSS543rtxHgImO23Ssv
	 X4ArKRqbG/NxIh4Kx9yrNF64Lwe0Ih8/2KpKrb54+fIaiFMPYh1bu+/QJcRBOU6fIs
	 /U0vGU61pM4aFUar+12jbV7XVp1hxR1+Um22dzp3Gv3kJl7thkDLysfIiHIQzvQszP
	 XWBGrV1A9AmRg==
Date: Fri, 10 Nov 2023 19:25:50 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa
 <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ian Rogers
 <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar
 <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Andi Kleen <ak@linux.intel.com>,
 linux-trace-devel@vger.kernel.org, linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 09/52] perf probe: Convert to check dwarf_getcfi feature
Message-Id: <20231110192550.53b4daa1325c83da7f88417f@kernel.org>
In-Reply-To: <20231110000012.3538610-10-namhyung@kernel.org>
References: <20231110000012.3538610-1-namhyung@kernel.org>
	<20231110000012.3538610-10-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  9 Nov 2023 15:59:28 -0800
Namhyung Kim <namhyung@kernel.org> wrote:

> Now it has a feature check for the dwarf_getcfi(), use it and convert
> the code to check HAVE_DWARF_CFI_SUPPORT definition.
> 

Looks good to me!

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

> Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Makefile.config     | 5 +++++
>  tools/perf/util/probe-finder.c | 8 ++++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index 8b6cffbc4858..aa55850fbc21 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -476,6 +476,11 @@ else
>        else
>          CFLAGS += -DHAVE_DWARF_GETLOCATIONS_SUPPORT
>        endif # dwarf_getlocations
> +      ifneq ($(feature-dwarf_getcfi), 1)
> +        msg := $(warning Old libdw.h, finding variables at given 'perf probe' point will not work, install elfutils-devel/libdw-dev >= 0.142);
> +      else
> +        CFLAGS += -DHAVE_DWARF_CFI_SUPPORT
> +      endif # dwarf_getcfi
>      endif # Dwarf support
>    endif # libelf support
>  endif # NO_LIBELF
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 8d3dd85f9ff4..c8923375e30d 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -604,7 +604,7 @@ static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
>  	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
>  	if (ret <= 0 || nops == 0) {
>  		pf->fb_ops = NULL;
> -#if _ELFUTILS_PREREQ(0, 142)
> +#ifdef HAVE_DWARF_CFI_SUPPORT
>  	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
>  		   (pf->cfi_eh != NULL || pf->cfi_dbg != NULL)) {
>  		if ((dwarf_cfi_addrframe(pf->cfi_eh, pf->addr, &frame) != 0 &&
> @@ -615,7 +615,7 @@ static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
>  			free(frame);
>  			return -ENOENT;
>  		}
> -#endif
> +#endif /* HAVE_DWARF_CFI_SUPPORT */
>  	}
>  
>  	/* Call finder's callback handler */
> @@ -1140,7 +1140,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
>  
>  	pf->machine = ehdr.e_machine;
>  
> -#if _ELFUTILS_PREREQ(0, 142)
> +#ifdef HAVE_DWARF_CFI_SUPPORT
>  	do {
>  		GElf_Shdr shdr;
>  
> @@ -1150,7 +1150,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
>  
>  		pf->cfi_dbg = dwarf_getcfi(dbg->dbg);
>  	} while (0);
> -#endif
> +#endif /* HAVE_DWARF_CFI_SUPPORT */
>  
>  	ret = debuginfo__find_probe_location(dbg, pf);
>  	return ret;
> -- 
> 2.42.0.869.gea05f2083d-goog
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
