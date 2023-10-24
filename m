Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ABA208AB;
	Tue, 24 Oct 2023 19:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966FE109;
	Tue, 24 Oct 2023 12:16:45 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-27d0acd0903so3300557a91.1;
        Tue, 24 Oct 2023 12:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698175005; x=1698779805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlrMdORzuIhiCBvkEoOY6AWWIm1ZLrThelr3CoWzGZs=;
        b=G2uQ1r6dV0Sexax7tleAPNzf9PDdohQaUNLyjU71+QWblGZhm34T/sknLmvijR7fCN
         5Ec1aEklFtawW92pLmBRIAej8T2d8VAzEdPYvJ7RgDRzjAR+5aQNroGuDQ4CCGUgju/A
         rPpbqDzJRdGP56P/VSb60x9WH9GhbnNB9c0ycZ9XCqDMxHEjube5Baeu8G10nBE8YKNs
         koBDYaKedhO6zOWX0Lyi2kyfKI+Tce/VjrrsI1dPcT1+euresj7QW+0wTqZB4qfDPp9q
         RP7WN0ifzV96CxkS0hpB6JX7b3fAoEWZhuzZdgwOIipuYaB9xldzUgpOEEqqY//nj7Ha
         mS5A==
X-Gm-Message-State: AOJu0YzX/6F7qhMfzE5uujK0Ts8ifRzVpplBE0lJc7tJeJl4IAE5FDTv
	+MvI4e+nHlCVK1MWUhLuIcTSWROdZ+YgkNANyUU=
X-Google-Smtp-Source: AGHT+IEeRsQ1loc1YYpY1a97APjF3K2XayF3rTQMK7R5xL0iD1J55Zh+XzcrB698bMOcSnEoPrg92TWKjW0OoSHcWxQ=
X-Received: by 2002:a17:90a:199e:b0:27e:3342:5c1f with SMTP id
 30-20020a17090a199e00b0027e33425c1fmr6738107pji.43.1698175004908; Tue, 24 Oct
 2023 12:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <87pm15vw5r.fsf@linux.intel.com>
In-Reply-To: <87pm15vw5r.fsf@linux.intel.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 24 Oct 2023 12:16:32 -0700
Message-ID: <CAM9d7ch504cnFzTL1qPh349uSrbEZop19kB-DbUsnoOKEvtFBQ@mail.gmail.com>
Subject: Re: [RFC 00/48] perf tools: Introduce data type profiling (v1)
To: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org, Ben Woodard <woodard@redhat.com>, 
	Joe Mario <jmario@redhat.com>, Kees Cook <keescook@chromium.org>, 
	David Blaikie <blaikie@google.com>, Xu Liu <xliuprof@google.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Mon, Oct 23, 2023 at 2:58=E2=80=AFPM Andi Kleen <ak@linux.intel.com> wro=
te:
>
> Namhyung Kim <namhyung@kernel.org> writes:
>
> > Hello,
> >
> > I'm happy to share my work on data type profiling.  This is to associat=
e
> > PMU samples to data types they refer using DWARF debug information.  So
> > basically it depends on quality of PMU events and compiler for producin=
g
> > DWARF info.  But it doesn't require any changes in the target program.
> >
> > As it's an early stage, I've targeted the kernel on x86 to reduce the
> > amount of work but IIUC there's no fundamental blocker to apply it to
> > other architectures and applications.
>
> FWIW i posted a similar patchkit a long time ago
>
> https://lore.kernel.org/lkml/20171128002321.2878-13-andi@firstfloor.org/
>
> It was on my list to resurrect that, it's great that you are doing
> something similar.
>
> The latest iteration (not posted) was here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git/log/?h=
=3Dperf/var-resolve-7

Oh, I wasn't aware of this series.  I'll take a look.

>
> The main difference seems to be that mine was more for perf script
> (e.g. i supported PT decoding), while you are more focused on sampling.
> I relied on the kprobes/uprobes engine, which unfortunately was always
> quite slow and had many limitations.

Right, I think dealing with regular samples would be more useful.
But Intel PT support looks interesting.

>
> Perhaps it would be possible merge the useful parts of the two approaches=
?

Sounds good!  Thanks for your comment!
Namhyung
