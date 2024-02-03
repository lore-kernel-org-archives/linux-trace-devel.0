Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FD10976
	for <linux-trace-devel@vger.kernel.org>; Sat,  3 Feb 2024 03:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706930483; cv=none; b=k9IUpi5SW7wb3/77UDyWWaasFpcSOnkrZfqUFMwC3AACHwrJy3K0qC4oMvhqdCIC9dC4RjdwNIK+ydH1KGBTa0qDLwa/nBRuqo62Tvr/pakMZF7IBKDbr69cxLKc5LxorUil7rE05kElxeHdVHVvNcDcDF7dsUdh+Meg1om+SF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706930483; c=relaxed/simple;
	bh=9bbV8v/XesQnkV5S5/dZRkkgLTcqBfC/AF/L1stS04Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n3Sj2rA1itzQBAIMk/IaRKTvWfAAKky6jDMX2fihoF+dEJZKzML1mcpHCi82GT1BqPqJxhA5GnbMiIaZDVGCuuEHyMk19nl2iS71N7bfhIuzN4b2h9Iw1AeBuOT6pNIfSwvEtdtGp8vcnobCH8qu4OQFekftgYi/qigGyXdRuzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JsctIJA7; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JsctIJA7"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d94691de1eso36415ad.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Feb 2024 19:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706930481; x=1707535281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2u//wf4yb5ku/Yg3213XLgXCGYC5NdB6fyXKhm401o=;
        b=JsctIJA770hEhoTn+tX2kZW+85/L94kyXKR4J6PAd/9781p5dWpSBt43GBs7yekwEp
         LXmcWXAnfgCyz02BhupzfLwOX31QthGnahmeOK98iijEjamYg3R9Q3TbyswCI07z8Qi6
         iUiUZPtz/R8/J3TqVWz5TmZl9y8xBDqSCl+Ff9Dize0qFvv7PMwYZRNNeXxePNSL0k5o
         9Z+cKWK8lF7ASPIjgZUS9UpUah8ajs0GcN2yZSShSnh6gCfu+kCbleyZPQwRl+2/g09d
         KQ6M0yuAz3WUrTuu3YCmcr1bbrb4GACxlLNxsT9AMbMyUX85DkmkVwBO8vZeCFcb8RSO
         fdEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706930481; x=1707535281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m2u//wf4yb5ku/Yg3213XLgXCGYC5NdB6fyXKhm401o=;
        b=aXGn0n+HtKplPN+CQgETKwBSkX83tfGuKywvzIPRe97/qfLmRw2ZumjuGlrnS+7Scp
         ur3+u6aSEr0murPeSuKfa/O2cQy01xD2tBGvdIwgSYt+dNqvnCKaQadP4/4o4LKdxUj0
         lxSJPm3Kcv0giz0gq3kpf3gbyBNyHmETXpyirA9BJvxrvy6fYlVHbdx7Koke28S7vCcw
         Zns3Hwgepb0P3kQ7OuWHxIbjR7jEvl4BfyPnZPYiv7Hx0uV6a1/GLyJDxhaEGuYui5LI
         HwLde+/0iHD2HGCaDf/gMxAEisdFAcj4ORKXj/oFAPX2C5lqZuRorOQn4Mly8isRMeJc
         mutQ==
X-Gm-Message-State: AOJu0YyyltODoJnPOYKTYyWLoHLI0X6kgGJuXf1Vx6W/JUjuomQ1hSge
	82o10sE6mpLrNaU168DgeC7vbsV/i8ZN4lPAQZ+vdPIBCJvJC4TdG9rg+aFHoKUdo5YL2jvxeKV
	PY13Xx8t2+U7UpFFwMYYUWm0jct0oHT5ZRrgI
X-Google-Smtp-Source: AGHT+IGAk0k1DBjlKTa3qXwHjikNO3DQIpo8PmfE1+IuKKtWK6lfiPhAVz0TF2wE8HETTzA62P0HIaMI9gbDNxccIdI=
X-Received: by 2002:a17:903:608:b0:1d8:dd63:674f with SMTP id
 kg8-20020a170903060800b001d8dd63674fmr70951plb.5.1706930480522; Fri, 02 Feb
 2024 19:21:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240202220459.527138-1-namhyung@kernel.org> <20240202220459.527138-15-namhyung@kernel.org>
In-Reply-To: <20240202220459.527138-15-namhyung@kernel.org>
From: Ian Rogers <irogers@google.com>
Date: Fri, 2 Feb 2024 19:21:09 -0800
Message-ID: <CAP-5=fUWaKW7d6_YkET0o26=fjBwX6PPJ1gXQ9wndQM_Oi2O3A@mail.gmail.com>
Subject: Re: [PATCH 14/14] perf annotate-data: Add stack canary type
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 2, 2024 at 2:05=E2=80=AFPM Namhyung Kim <namhyung@kernel.org> w=
rote:
>
> When the stack protector is enabled, compiler would generate code to
> check stack overflow with a special value called 'stack carary' at
> runtime.  On x86_64, GCC hard-codes the stack canary as %gs:40.
>
> While there's a definition of fixed_percpu_data in asm/processor.h,
> it seems that the header is not included everywhere and many places
> it cannot find the type info.  As it's in the well-known location (at
> %gs:40), let's add a pseudo stack canary type to handle it specially.

I wonder if cases like this can be handled by debug info rather than
special cases in the tool. Special cases are fine too, but are
potentially less portable.

Thanks,
Ian

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/annotate-data.h |  1 +
>  tools/perf/util/annotate.c      | 24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
>
> diff --git a/tools/perf/util/annotate-data.h b/tools/perf/util/annotate-d=
ata.h
> index 0bfef29fa52c..e293980eb11b 100644
> --- a/tools/perf/util/annotate-data.h
> +++ b/tools/perf/util/annotate-data.h
> @@ -77,6 +77,7 @@ struct annotated_data_type {
>
>  extern struct annotated_data_type unknown_type;
>  extern struct annotated_data_type stackop_type;
> +extern struct annotated_data_type canary_type;
>
>  /**
>   * struct data_loc_info - Data location information
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 5f3136f57c62..f2683dadf3cf 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -116,6 +116,13 @@ struct annotated_data_type stackop_type =3D {
>         },
>  };
>
> +struct annotated_data_type canary_type =3D {
> +       .self =3D {
> +               .type_name =3D (char *)"(stack canary)",
> +               .children =3D LIST_HEAD_INIT(canary_type.self.children),
> +       },
> +};
> +
>  static int arch__grow_instructions(struct arch *arch)
>  {
>         struct ins *new_instructions;
> @@ -3764,6 +3771,17 @@ static bool is_stack_operation(struct arch *arch, =
struct disasm_line *dl)
>         return false;
>  }
>
> +static bool is_stack_canary(struct arch *arch, struct annotated_op_loc *=
loc)
> +{
> +       /* On x86_64, %gs:40 is used for stack canary */
> +       if (arch__is(arch, "x86")) {
> +               if (loc->segment =3D=3D INSN_SEG_X86_GS && loc->offset =
=3D=3D 40)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  u64 annotate_calc_pcrel(struct map_symbol *ms, u64 ip, int offset,
>                         struct disasm_line *dl)
>  {
> @@ -3938,6 +3956,12 @@ struct annotated_data_type *hist_entry__get_data_t=
ype(struct hist_entry *he)
>                 }
>
>                 mem_type =3D find_data_type(&dloc);
> +
> +               if (mem_type =3D=3D NULL && is_stack_canary(arch, op_loc)=
) {
> +                       mem_type =3D &canary_type;
> +                       dloc.type_offset =3D 0;
> +               }
> +
>                 if (mem_type)
>                         istat->good++;
>                 else
> --
> 2.43.0.594.gd9cf4e227d-goog
>
