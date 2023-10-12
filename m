Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05172262BB;
	Thu, 12 Oct 2023 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AF5BE;
	Thu, 12 Oct 2023 09:53:01 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-27d113508bfso947727a91.3;
        Thu, 12 Oct 2023 09:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697129581; x=1697734381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbYdyYCLJzWKhagPtB2fZh6NdUcQYAFm57gjL1qGF48=;
        b=NDEQvwkQkWubFS0l0atPAWvMdLyJD3omUIvoWkhTmVunGbuJPp980w/XuvrUN2A2pe
         +ejDIvuti8upy6nF3b5l1YtyWvVFsi2C0Nl55ENLl4k6YOSa0eYMLhyV71IkzLBOSBXB
         b2SWtiGToYJNvF8G5Xp8YYo4XoiiF+3S2hEbx7zRJjZ6vyCtBc0kB07kcX9ZpglFFsDP
         1/pyandn6YbTBVy9UkgzcGyBKQA9lovThvkOSUaV3d36VAiop8O+DFQeankxCKn4p7SB
         jrNU32lp/1Jt0LkUCzW1Ujx34E6zXUTFHBSJnI3JcpzOYhWh4Yk83vmG7SEBfj6zHqB/
         kaYg==
X-Gm-Message-State: AOJu0Yw4OAEqA02wq8Xnn8b1AERlmknRdLATmPQsbG+KDE94WMhwVM5Y
	6SUINky50eTn9ufpvx3Xcq4hjbFH7Vdfpsl4z5M=
X-Google-Smtp-Source: AGHT+IG9jsSRf7EIm7g+9z1WGXCY0hL8ay7WE0VOiI32HNTtUx5gxJO32EGx3ySvVI7spQ9vBSU3cZfJIJgMJk13zMw=
X-Received: by 2002:a17:90a:2a8f:b0:27d:6b8:93be with SMTP id
 j15-20020a17090a2a8f00b0027d06b893bemr4680096pjd.42.1697129580644; Thu, 12
 Oct 2023 09:53:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012091537.GM6307@noisy.programming.kicks-ass.net>
In-Reply-To: <20231012091537.GM6307@noisy.programming.kicks-ass.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 12 Oct 2023 09:52:49 -0700
Message-ID: <CAM9d7cgiagnJ3zZ0KvyvYtVVp3ycb3BNwL6x2-eUYJhHbPSohw@mail.gmail.com>
Subject: Re: [RFC 00/48] perf tools: Introduce data type profiling (v1)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Oct 12, 2023 at 2:17=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Oct 11, 2023 at 08:50:23PM -0700, Namhyung Kim wrote:
>
> > Actually there's a performance issue about getting disassembly from the
> > objdump for kernel.  On my system, GNU objdump was really slower than t=
he
> > one from LLVM for some reason so I had to pass the following option for
> > each perf report and perf annotate.
> >
> >     $ sudo perf report --objdump=3Dllvm-objdump ...
> >
> >     # To save it in the config file and drop the command line option
> >     $ sudo perf config annotate.objdump=3Dllvm-objdump
> >
> > Even with this change, still the most processing time was spent on the
> > objdump to get the disassembly.  It'd be nice if we can get the result
> > without using objdump at all.
>
> So the kernel has an instruction decoder, all we need is something that
> can pretty print the result. IIRC Masami had an early version of that
> somewhere.
>
> With those bits, and some basic ELF parsing (find in objtool for
> instance) you can implement most of objdump yourself.

That would be nice, but I'm a bit afraid of dealing with details
of instruction decoding especially for unusual ones considering
extensibility to user space and other architectures.

Thanks,
Namhyung
