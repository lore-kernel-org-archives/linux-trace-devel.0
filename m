Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB64F14ABB;
	Tue, 24 Oct 2023 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE10510C9;
	Tue, 24 Oct 2023 12:10:13 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-27d425a2dd0so4212773a91.2;
        Tue, 24 Oct 2023 12:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698174613; x=1698779413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFLJZBS7agKqAkEvq06+8+duvFvUx+uUvizA/RGK7gk=;
        b=Gd6TRx6/m7r0r47AI+HnypksqBe5Kspgw8VTtOMTnjP23TZdYOVlAv2/1hidb+YBWP
         Y9Doi0zYY+HcrTpk9wY9FTuX5psBoB7XWIRikhv7W6Z25gedH4JBdK4Rde8t53ocAjWA
         YGyhawOzav8/IhVoaPMXW23kXa86vvsouYdTV2v0BAtNMjTWu32eyr//dB2HsQ2x3LtE
         nwUS/ZeeA8g57PCRWOlbd7WDvizr8W5jLQF8RiBNv+ytVLm6TZGvK8zx9EUL7MRcS/xu
         fQDYCcklYrrRtrXELY66soS92pVoPlvYYjWogoZtnhMK1XBX7Pb8qiwvx6b+6E4N2qVE
         65Gg==
X-Gm-Message-State: AOJu0Yy1JGAKjrFeFLSvtjgY7QvxucFj16NlLTFrEK+NgDzqy+jE1rzS
	wqnkdJyIN7v/xTF0LApBo191z9DPFdeQhIQOpYA=
X-Google-Smtp-Source: AGHT+IEsQl/xke1QpF1wrB/mEuwglEi68xhvPN4fzxrQ2MxRHossM2my/b3DKnDGo+wrha+KeeeIJqIyF206c2s2rVw=
X-Received: by 2002:a17:90b:3812:b0:27d:3f08:cc21 with SMTP id
 mq18-20020a17090b381200b0027d3f08cc21mr14009203pjb.5.1698174612976; Tue, 24
 Oct 2023 12:10:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012035111.676789-14-namhyung@kernel.org>
 <ZTahaOOOgFkclARB@kernel.org>
In-Reply-To: <ZTahaOOOgFkclARB@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 24 Oct 2023 12:10:01 -0700
Message-ID: <CAM9d7cg65AYsPg+0eKg8Cj1Vb42vwCdjJAP3_1G_r7-Dwu7z8A@mail.gmail.com>
Subject: Re: [PATCH 13/48] perf annotate: Add annotate_get_insn_location()
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Arnaldo,

On Mon, Oct 23, 2023 at 9:38=E2=80=AFAM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Wed, Oct 11, 2023 at 08:50:36PM -0700, Namhyung Kim escreveu:
> > The annotate_get_insn_location() is to get the detailed information of
> > instruction locations like registers and offset.  It has source and
> > target operands locations in an array.  Each operand can have a
> > register and an offset.  The offset is meaningful when mem_ref flag is
> > set.
>
> This needs to be enclosed in HAVE_DWARF_SUPPORT, as the build is failing
> in systems where this isn't available, see patch below.

Thanks for the test and the patch, will add it to v2.

Namhyung

>
>   CC      /tmp/build/perf/arch/x86/util/pmu.o
> util/annotate.c: In function 'extract_reg_offset':
> util/annotate.c:3537:24: error: implicit declaration of function 'get_dwa=
rf_regnum' [-Werror=3Dimplicit-function-declaration]
>  3537 |         op_loc->reg1 =3D get_dwarf_regnum(regname, 0);
>       |                        ^~~~~~~~~~~~~~~~
>   CC      /tmp/build/perf/tests/vmlinux-kallsyms.o
>
> I tested it with 'make NO_DWARF=3D1'
>
> - Arnaldo
>
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 9d653a1e84ce4889..b998c81c89be04fc 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -3486,6 +3486,7 @@ int annotate_check_args(struct annotation_options *=
args)
>         return 0;
>  }
>
> +#ifdef HAVE_DWARF_SUPPORT
>  /*
>   * Get register number and access offset from the given instruction.
>   * It assumes AT&T x86 asm format like OFFSET(REG).  Maybe it needs
> @@ -3591,3 +3592,4 @@ int annotate_get_insn_location(struct arch *arch, s=
truct disasm_line *dl,
>
>         return 0;
>  }
> +#endif // HAVE_DWARF_SUPPORT
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index 4adda492233d2742..484be346a279c481 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -437,6 +437,7 @@ int annotate_parse_percent_type(const struct option *=
opt, const char *_str,
>
>  int annotate_check_args(struct annotation_options *args);
>
> +#ifdef HAVE_DWARF_SUPPORT
>  /**
>   * struct annotated_op_loc - Location info of instruction operand
>   * @reg: Register in the operand
> @@ -473,4 +474,5 @@ struct annotated_insn_loc {
>  int annotate_get_insn_location(struct arch *arch, struct disasm_line *dl=
,
>                                struct annotated_insn_loc *loc);
>
> +#endif /* HAVE_DWARF_SUPPORT */
>  #endif /* __PERF_ANNOTATE_H */
