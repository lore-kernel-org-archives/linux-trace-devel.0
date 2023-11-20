Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169D2E3;
	Mon, 20 Nov 2023 12:43:12 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2839b418f7fso2076048a91.2;
        Mon, 20 Nov 2023 12:43:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700512991; x=1701117791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uEWKcf0Qu+JBFnsj4DeP5h18wjA4sNIxAJuwdb8sxU=;
        b=hKwgQgnBzTZLF4RlW/aeaGNubHJTv+IgO+8jkMihNlQbqXgOc3Oh+LkyqDspkbCF48
         HirD1OmCLY4bfxnMXmoGdsJxdEINbsTr0byj+I2AzmZ58JLHjA+HZeNKTBVVa4atRFyd
         2kfi/BmS5xjYe+VmQ/RtI5sUF5Ng9ghKJA6SFqeCz37t8EJ6rwpNNICrobxa0qBsUmKq
         26k8yrUb04UHl/xcxwCVHrJ53H5V8Q8Z8NAH3i6LsmhPsGLwcmI6hI5iAed8QEe5B5G+
         qiYqhTzh6opezbQbHDX0vRrpsLrG72xnfix4D4iuZXDqXrPU3HWoW9uViQh4GfuoRi/7
         O9rg==
X-Gm-Message-State: AOJu0YyQ9GApiYr1CPYdwsB31aUifcx80iXOPrwgHvmGJwhX2gJ4Np0n
	fLpqrtR6v2kYTsFM2CgDijkD4tvkjaEhcrYiwcc=
X-Google-Smtp-Source: AGHT+IG/d7JgW8EAdqGPjQumtNuDPJUeNf5SpANhbNyrZWBbVaf/AsuklIdvm5uo7lAZd0Z3QCaEp67JShW5j0p1u5U=
X-Received: by 2002:a17:90a:f018:b0:27f:fc2f:4831 with SMTP id
 bt24-20020a17090af01800b0027ffc2f4831mr7539084pjb.13.1700512991415; Mon, 20
 Nov 2023 12:43:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110000012.3538610-1-namhyung@kernel.org> <20231110000012.3538610-13-namhyung@kernel.org>
 <CA+JHD90fkWNrQWO5DrHeV8mCmFyKKqJ8fV=KwztRi7TSw+8yDg@mail.gmail.com>
In-Reply-To: <CA+JHD90fkWNrQWO5DrHeV8mCmFyKKqJ8fV=KwztRi7TSw+8yDg@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 20 Nov 2023 12:43:00 -0800
Message-ID: <CAM9d7chUNfAnLB-Hwry8M1d1Nb+YH3jf3ySmTZJoC0NYeqDAdA@mail.gmail.com>
Subject: Re: [PATCH 12/52] perf annotate-data: Add find_data_type()
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users <linux-perf-users@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Andi Kleen <ak@linux.intel.com>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Arnaldo,

On Sat, Nov 11, 2023 at 10:55=E2=80=AFAM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> On Thu, Nov 9, 2023, 9:00 PM Namhyung Kim <namhyung@kernel.org> wrote:
>>
>>
>> +static bool find_cu_die(struct debuginfo *di, u64 pc, Dwarf_Die *cu_die=
)
>> +{
>> +       Dwarf_Off off, next_off;
>> +       size_t header_size;
>> +
>> +       if (dwarf_addrdie(di->dbg, pc, cu_die) !=3D NULL)
>> +               return cu_die;
>
> Isn't the return type a bool?
>
> Shouldn't be 'return true;'?
>
> Ends up like that as cu_die isn't NULL, but looks confusing.

Ok, will change.

>
>> +
>> +       /*
>> +        * There are some kernels don't have full aranges and contain on=
ly a few
>> +        * aranges entries.  Fallback to iterate all CU entries in .debu=
g_info
>> +        * in case it's missing.
>> +        */
>> +       off =3D 0;
>> +       while (dwarf_nextcu(di->dbg, off, &next_off, &header_size,
>> +                           NULL, NULL, NULL) =3D=3D 0) {
>> +               if (dwarf_offdie(di->dbg, off + header_size, cu_die) &&
>> +                   dwarf_haspc(cu_die, pc))
>> +                       return true;
>> +
>> +               off =3D next_off;
>> +       }
>> +       return false;
>> +}
>> +
>>
>> +struct annotated_data_type *find_data_type(struct map_symbol *ms, u64 i=
p,
>> +                                          int reg, int offset)
>> +{
>> +       struct annotated_data_type *result =3D NULL;
>> +       struct dso *dso =3D ms->map->dso;
>> +       struct debuginfo *di;
>> +       Dwarf_Die type_die;
>> +       struct strbuf sb;
>> +       u64 pc;
>> +
>> +       di =3D debuginfo__new(dso->long_name);
>> +       if (di =3D=3D NULL) {
>> +               pr_debug("cannot get the debug info\n");
>
>
> Shouldn't inform the dso->long_name and function name to ease debugging?

Sounds good, I'll update it in the v3.

Thanks,
Namhyung
