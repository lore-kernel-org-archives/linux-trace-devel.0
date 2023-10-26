Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C40849C;
	Thu, 26 Oct 2023 05:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A68DC;
	Wed, 25 Oct 2023 22:26:44 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6b1e46ca282so479782b3a.2;
        Wed, 25 Oct 2023 22:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698298004; x=1698902804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkwhE1tq13CFNHMxPtXkTbeVkmQsKLfvU2fVKCp1d+4=;
        b=fVEDwguWRAnqmUEQ6Xwre3jWXLKxOFX+bk021PmOQR7FzQ0VlBy+o+GhKfD7LY6h61
         5eGX0DtYLHRFjaL2VPJE+IG+H2QMevs97VzI42XLg8/ovYH5MhY7lH3eRqQts9KD34j6
         NZ4W/AfMlmlpxzkDIV7yydgmDpl0y4HsXyocZS6UYymsETWh6gq2FaReyTsqhqzxNZeY
         W6DKRcNqKGAq8qYsezbVBcbWYv2D2dx4RbBHHUi6gZMct4/Bf9KManhdhvOIC/ILAWRI
         8gbXqrRHaWdgjW5H3lVgSM/+aV50wI3rbmHJb+sVQhwcwTjwLkxP4w6GpNn81Pfr7yTb
         wbvA==
X-Gm-Message-State: AOJu0YydMjA2pFLIKbTaoGnB1b0oJetDckpioWQfcA00uhYTt0qgd92R
	sCt4gNrVKO1rUjrdNaI9tNqQC+MercCNFlqOGS/YKnFp
X-Google-Smtp-Source: AGHT+IF9EIq1vb+jjYGoqaOOW1kHY58DrZb9p6mV96BDR21MhsmYXqAyVHHfIpytaB8LYx9GC8fEvLh5sj6lCmcjMxU=
X-Received: by 2002:a05:6a21:1a3:b0:17b:7505:8ab7 with SMTP id
 le35-20020a056a2101a300b0017b75058ab7mr10362811pzb.46.1698298003837; Wed, 25
 Oct 2023 22:26:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012035111.676789-14-namhyung@kernel.org>
 <ZTahaOOOgFkclARB@kernel.org> <CAM9d7cg65AYsPg+0eKg8Cj1Vb42vwCdjJAP3_1G_r7-Dwu7z8A@mail.gmail.com>
In-Reply-To: <CAM9d7cg65AYsPg+0eKg8Cj1Vb42vwCdjJAP3_1G_r7-Dwu7z8A@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 25 Oct 2023 22:26:32 -0700
Message-ID: <CAM9d7ciZ0axC1A=q2mT-5fCmNUZF=QtmfcQmfs8aR-tgYftYmA@mail.gmail.com>
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

On Tue, Oct 24, 2023 at 12:10=E2=80=AFPM Namhyung Kim <namhyung@kernel.org>=
 wrote:
>
> Hi Arnaldo,
>
> On Mon, Oct 23, 2023 at 9:38=E2=80=AFAM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Wed, Oct 11, 2023 at 08:50:36PM -0700, Namhyung Kim escreveu:
> > > The annotate_get_insn_location() is to get the detailed information o=
f
> > > instruction locations like registers and offset.  It has source and
> > > target operands locations in an array.  Each operand can have a
> > > register and an offset.  The offset is meaningful when mem_ref flag i=
s
> > > set.
> >
> > This needs to be enclosed in HAVE_DWARF_SUPPORT, as the build is failin=
g
> > in systems where this isn't available, see patch below.
>
> Thanks for the test and the patch, will add it to v2.

Hmm.. I think this function can work without DWARF.
If the only problem is get_dwarf_regnum() probably
I can add a dummy function when libdw is not found.
Maybe I need to use arch reg number here and
convert to DWARF later.

Thanks,
Namhyung


> >
> >   CC      /tmp/build/perf/arch/x86/util/pmu.o
> > util/annotate.c: In function 'extract_reg_offset':
> > util/annotate.c:3537:24: error: implicit declaration of function 'get_d=
warf_regnum' [-Werror=3Dimplicit-function-declaration]
> >  3537 |         op_loc->reg1 =3D get_dwarf_regnum(regname, 0);
> >       |                        ^~~~~~~~~~~~~~~~
> >   CC      /tmp/build/perf/tests/vmlinux-kallsyms.o
> >
> > I tested it with 'make NO_DWARF=3D1'
> >
> > - Arnaldo
> >
> > diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> > index 9d653a1e84ce4889..b998c81c89be04fc 100644
> > --- a/tools/perf/util/annotate.c
> > +++ b/tools/perf/util/annotate.c
> > @@ -3486,6 +3486,7 @@ int annotate_check_args(struct annotation_options=
 *args)
> >         return 0;
> >  }
> >
> > +#ifdef HAVE_DWARF_SUPPORT
> >  /*
> >   * Get register number and access offset from the given instruction.
> >   * It assumes AT&T x86 asm format like OFFSET(REG).  Maybe it needs
> > @@ -3591,3 +3592,4 @@ int annotate_get_insn_location(struct arch *arch,=
 struct disasm_line *dl,
> >
> >         return 0;
> >  }
> > +#endif // HAVE_DWARF_SUPPORT
> > diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> > index 4adda492233d2742..484be346a279c481 100644
> > --- a/tools/perf/util/annotate.h
> > +++ b/tools/perf/util/annotate.h
> > @@ -437,6 +437,7 @@ int annotate_parse_percent_type(const struct option=
 *opt, const char *_str,
> >
> >  int annotate_check_args(struct annotation_options *args);
> >
> > +#ifdef HAVE_DWARF_SUPPORT
> >  /**
> >   * struct annotated_op_loc - Location info of instruction operand
> >   * @reg: Register in the operand
> > @@ -473,4 +474,5 @@ struct annotated_insn_loc {
> >  int annotate_get_insn_location(struct arch *arch, struct disasm_line *=
dl,
> >                                struct annotated_insn_loc *loc);
> >
> > +#endif /* HAVE_DWARF_SUPPORT */
> >  #endif /* __PERF_ANNOTATE_H */
