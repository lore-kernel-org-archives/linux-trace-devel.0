Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924014266;
	Fri, 10 Nov 2023 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHwKi/Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F3DC433C7;
	Fri, 10 Nov 2023 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699611996;
	bh=n76Je2umvcSaid71IZlTqqdp2GtgwGMCUH+EilvbftA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cHwKi/IupLycs7qVNViSUZCNF2EdE8w0A3oyLL1gg8pMn7PY2KwYk+96d9QTz6HLj
	 5GN2CRrmBrtBhCIzZ/1hUdFmns1GU0kTyq5Raoh1uDlrZ0BSNQktYp3IQlw3VxHyuZ
	 34ZJDWTFir+mD4B+zblKcUCX105moXRE8YeStOxymxNV6VbBIsp3ZB7X4bHMk4oCZF
	 w6k+xuAysc0P392yIUhrRoItqIOZBSgwAgLObvox1d8RAeYeTAUpd1VVft+rc4S6Ot
	 PHNG1i9rwEi9wBGvjerGpKMmgY9hOe5k/bkwIEzy1r64a40jKa0xKSET61n8K8qYlz
	 yiYwcsMrU+dog==
Date: Fri, 10 Nov 2023 19:26:30 +0900
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
Subject: Re: [PATCH 08/52] perf build: Add feature check for dwarf_getcfi()
Message-Id: <20231110192630.fd212e5f98049f1cf9cea72f@kernel.org>
In-Reply-To: <20231110000012.3538610-9-namhyung@kernel.org>
References: <20231110000012.3538610-1-namhyung@kernel.org>
	<20231110000012.3538610-9-namhyung@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  9 Nov 2023 15:59:27 -0800
Namhyung Kim <namhyung@kernel.org> wrote:

> The dwarf_getcfi() is available on libdw 0.142+.  Instead of just
> checking the version number, it'd be nice to have a config item to check
> the feature at build time.

Looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

> 
> Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/build/Makefile.feature            | 1 +
>  tools/build/feature/Makefile            | 4 ++++
>  tools/build/feature/test-dwarf_getcfi.c | 9 +++++++++
>  3 files changed, 14 insertions(+)
>  create mode 100644 tools/build/feature/test-dwarf_getcfi.c
> 
> diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
> index 934e2777a2db..64df118376df 100644
> --- a/tools/build/Makefile.feature
> +++ b/tools/build/Makefile.feature
> @@ -32,6 +32,7 @@ FEATURE_TESTS_BASIC :=                  \
>          backtrace                       \
>          dwarf                           \
>          dwarf_getlocations              \
> +        dwarf_getcfi                    \
>          eventfd                         \
>          fortify-source                  \
>          get_current_dir_name            \
> diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
> index dad79ede4e0a..37722e509eb9 100644
> --- a/tools/build/feature/Makefile
> +++ b/tools/build/feature/Makefile
> @@ -7,6 +7,7 @@ FILES=                                          \
>           test-bionic.bin                        \
>           test-dwarf.bin                         \
>           test-dwarf_getlocations.bin            \
> +         test-dwarf_getcfi.bin                  \
>           test-eventfd.bin                       \
>           test-fortify-source.bin                \
>           test-get_current_dir_name.bin          \
> @@ -154,6 +155,9 @@ endif
>  $(OUTPUT)test-dwarf_getlocations.bin:
>  	$(BUILD) $(DWARFLIBS)
>  
> +$(OUTPUT)test-dwarf_getcfi.bin:
> +	$(BUILD) $(DWARFLIBS)
> +
>  $(OUTPUT)test-libelf-getphdrnum.bin:
>  	$(BUILD) -lelf
>  
> diff --git a/tools/build/feature/test-dwarf_getcfi.c b/tools/build/feature/test-dwarf_getcfi.c
> new file mode 100644
> index 000000000000..50e7d7cb7bdf
> --- /dev/null
> +++ b/tools/build/feature/test-dwarf_getcfi.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <elfutils/libdw.h>
> +
> +int main(void)
> +{
> +	Dwarf *dwarf = NULL;
> +	return dwarf_getcfi(dwarf) == NULL;
> +}
> -- 
> 2.42.0.869.gea05f2083d-goog
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
