Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C37A2D616;
	Sat,  4 Nov 2023 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4NrV/C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C48C433C7;
	Sat,  4 Nov 2023 10:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699095128;
	bh=JAQzfnL7a2XNBBwy0ihLXq/4JX6Tfc5YeXjkF7JEm9s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t4NrV/C/8GIF+0H0zbZtQPYxVDEDCMLd4m+FsVXa1Rj+XWpC22zaSCG8QXRjYLjA9
	 of9cchfnYtFBK0W5RasRZpy77ydRhq0H+hBkOk6YKNInyZPHlpedAe5Z2foH5DNu7A
	 NKESoqXC1rol9dNinnXBD4gy2KLN99lMVw+KHWHgIBvLSimfrfi4S+gge536BlBNR/
	 PDDs5YQqjKMPTUTWA0HqvLDyO/sRdMTKvbipwuTyzvqDinmrXqUNrkiqEj9oS4Olda
	 XN18veNqzgZy9yJYiwpivh35AM4ZG9Fx8l7V5hAfPPPEQqcVOkE+6Rd3uI8gJSHOAp
	 88nhJ+44DN7dA==
Date: Sat, 4 Nov 2023 19:52:02 +0900
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
Subject: Re: [PATCH 04/48] perf dwarf-aux: Fix die_get_typename() for void *
Message-Id: <20231104195202.e8c300fcdc3938e2bf13f5cf@kernel.org>
In-Reply-To: <20231012035111.676789-5-namhyung@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
	<20231012035111.676789-5-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 20:50:27 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> The die_get_typename() is to return a C-like type name from DWARF debug
> entry and it follows data type if the target entry is a pointer type.
> But I found void pointers don't have the type attribte to follow and
> then the function returns an error for that case.  This results in a
> broken type string for void pointer types.
> 
> For example, the following type entries are pointer types.
> 
>  <1><48c>: Abbrev Number: 4 (DW_TAG_pointer_type)
>     <48d>   DW_AT_byte_size   : 8
>     <48d>   DW_AT_type        : <0x481>
>  <1><491>: Abbrev Number: 211 (DW_TAG_pointer_type)
>     <493>   DW_AT_byte_size   : 8
>  <1><494>: Abbrev Number: 4 (DW_TAG_pointer_type)
>     <495>   DW_AT_byte_size   : 8
>     <495>   DW_AT_type        : <0x49e>
> 
> The first one at offset 48c and the third one at offset 494 have type
> information.  Then they are pointer types for the referenced types.
> But the second one at offset 491 doesn't have the type attribute.

This looks good to me!

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/dwarf-aux.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 2941d88f2199..4849c3bbfd95 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -1090,7 +1090,14 @@ int die_get_typename(Dwarf_Die *vr_die, struct strbuf *buf)
>  		return strbuf_addf(buf, "%s%s", tmp, name ?: "");
>  	}
>  	ret = die_get_typename(&type, buf);
> -	return ret ? ret : strbuf_addstr(buf, tmp);
> +	if (ret < 0) {
> +		/* void pointer has no type attribute */
> +		if (tag == DW_TAG_pointer_type && ret == -ENOENT)
> +			return strbuf_addf(buf, "void*");
> +
> +		return ret;
> +	}
> +	return strbuf_addstr(buf, tmp);
>  }
>  
>  /**
> -- 
> 2.42.0.655.g421f12c284-goog
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
