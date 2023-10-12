Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E68331A85;
	Thu, 12 Oct 2023 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C293D7;
	Thu, 12 Oct 2023 09:19:18 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-27cfb84432aso847283a91.2;
        Thu, 12 Oct 2023 09:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697127557; x=1697732357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nbiq+SbKVzv0umicsGQIbdhA4gJE73jhezJTqZ1Ip3U=;
        b=K67LX5HRZ2VXLvm3g+RKGJVmR2F0DFJ9Aa1a5XbjFY5JNCvtSOgasy1+ADnB01T9Di
         C1q5C8vZalVM+ImxX/AkVf12iyf3urb04OIwCutkt6hosVNUjnKgtWsynNotG5z0gGz2
         lhiG5vLHxn5pZk4inU5xnGMsB0x5dwAiXE+n9ZQooddwcjMBJRatzsf/tuaxpLjxeVa8
         zBIEV32bFmXJPzcrdk5cDSky+n8DX5tczgxXx6e4AVeSPMJ37l8cSCk147+iP1x/K4BV
         zE+H88JiJo1OMr3cWQJ+3y1CSKdn4sIYn9+liUAjIInw2gAbvBKKF6blfg3H3Z9QgIgv
         GOpA==
X-Gm-Message-State: AOJu0Yy3wI2NpNj/aeu4tm7NQvMTMk2OpbNkaeb51rqb7GRVxk3SEe6I
	bpM7H7SoFH1TUDGJ3rUI9AjYkV8jKewCmOQSzEM=
X-Google-Smtp-Source: AGHT+IHYLrnpzZAD48VSQEnb88UJ0/CEHEDk3PHs3RQe1priuwUSfgGoMET9eceQ/VkvhvhIiKvqKxjoKfTP1qNM6Tw=
X-Received: by 2002:a17:90b:3a8e:b0:274:2906:656a with SMTP id
 om14-20020a17090b3a8e00b002742906656amr22645241pjb.5.1697127557440; Thu, 12
 Oct 2023 09:19:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <ZSeMGPPfxkMvdaP3@gmail.com>
In-Reply-To: <ZSeMGPPfxkMvdaP3@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 12 Oct 2023 09:19:04 -0700
Message-ID: <CAM9d7chzw4UeHHeXaMfPTiRdLbv7PbpK=xkgxMDojAxAc8y7Jg@mail.gmail.com>
Subject: Re: [RFC 00/48] perf tools: Introduce data type profiling (v1)
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users@vger.kernel.org, 
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
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Ingo,

On Wed, Oct 11, 2023 at 11:03=E2=80=AFPM Ingo Molnar <mingo@kernel.org> wro=
te:
>
>
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
> > * How to use it
> >
> > To get precise memory access samples, users can use `perf mem record`
> > command to utilize those events supported by their architecture.  Intel
> > machines would work best as they have dedicated memory access events bu=
t
> > they would have a filter to ignore low latency loads like less than 30
> > cycles (use --ldlat option to change the default value).
> >
> >     # To get memory access samples in kernel for 1 second (on Intel)
> >     $ sudo perf mem record -a -K --ldlat=3D4 -- sleep 1
> >
> >     # Similar for the AMD (but it requires 6.3+ kernel for BPF filters)
> >     $ sudo perf mem record -a --filter 'mem_op =3D=3D load, ip > 0x8000=
000000000000' -- sleep 1
>
> BTW., it would be nice for 'perf mem record' to just do the right thing o=
n
> whatever machine it is running on.
>
> Also, why are BPF filters required - due to the IP filtering of mem-load
> events?

Right, because AMD uses IBS for precise events and it doesn't
have a filtering feature.

>
> Could we perhaps add an IP filter to perf events to get this built-in?
> Perhaps attr->exclude_user would achieve something similar?

Unfortunately IBS doesn't support privilege filters IIUC.  Maybe
we could add a general filtering logic in the NMI handler but I'm
afraid it can complicate the code and maybe slow it down a bit.
Probably it's ok to have only a simple privilege filter by IP range.

>
> > In perf report, it's just a matter of selecting new sort keys: 'type'
> > and 'typeoff'.  The 'type' shows name of the data type as a whole while
> > 'typeoff' shows name of the field in the data type.  I found it useful
> > to use it with --hierarchy option to group relevant entries in the same
> > level.
> >
> >     $ sudo perf report -s type,typeoff --hierarchy --stdio
> >     ...
> >     #
> >     #    Overhead  Data Type / Data Type Offset
> >     # ...........  ............................
> >     #
> >         23.95%     (stack operation)
> >            23.95%     (stack operation) +0 (no field)
> >         23.43%     (unknown)
> >            23.43%     (unknown) +0 (no field)
> >         10.30%     struct pcpu_hot
> >             4.80%     struct pcpu_hot +0 (current_task)
> >             3.53%     struct pcpu_hot +8 (preempt_count)
> >             1.88%     struct pcpu_hot +12 (cpu_number)
> >             0.07%     struct pcpu_hot +24 (top_of_stack)
> >             0.01%     struct pcpu_hot +40 (softirq_pending)
> >          4.25%     struct task_struct
> >             1.48%     struct task_struct +2036 (rcu_read_lock_nesting)
> >             0.53%     struct task_struct +2040 (rcu_read_unlock_special=
.b.blocked)
> >             0.49%     struct task_struct +2936 (cred)
> >             0.35%     struct task_struct +3144 (audit_context)
> >             0.19%     struct task_struct +46 (flags)
> >             0.17%     struct task_struct +972 (policy)
> >             0.15%     struct task_struct +32 (stack)
> >             0.15%     struct task_struct +8 (thread_info.syscall_work)
> >             0.10%     struct task_struct +976 (nr_cpus_allowed)
> >             0.09%     struct task_struct +2272 (mm)
> >         ...
>
> This looks really useful!

:)

Thanks,
Namhyung
