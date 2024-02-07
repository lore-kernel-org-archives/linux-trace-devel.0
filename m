Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E886AE2
	for <linux-trace-devel@vger.kernel.org>; Wed,  7 Feb 2024 19:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707335788; cv=none; b=kH/n/pIHRIPlg2fzRRCQeSPqU2Ms+6CSE7R605jeAG0AshszoCuE9EK9xcGlIkrk2sKq7ep083Vy/EzCSDTbdK0NWURJ82RoQnHN1opwy7qLjDcuWKgAMHr4VKDGz2kAcvoisr+QFEZMYLgf2EWlVF9xVNWK83AndIs/qifwd7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707335788; c=relaxed/simple;
	bh=dzgYn4bp7nr3cKM50l3TAoVq8LCXbeNtvvcBhmI+5F4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q24mqTOqaen1pg662oTzroCXaxPMRmjC4k7shyOQPPR9Mov0wKx7z/Z6Df3pZ+L5MLKhMpqzntdKk9hp6df6uohR1Eb6v4vYQCqaZzp8PVyQqu0dP0x8mt782s2rNjp6oz1xCOUUXWwQPP8y1qJ+10OLiPntzeR+MzioSFbvb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X/LDMUNl; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X/LDMUNl"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d9daf74f41so17615ad.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Feb 2024 11:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707335785; x=1707940585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOFmIdHcVZFpvdlv+SwpSo0Y7EY1nbkZlWlLRqBJt6I=;
        b=X/LDMUNl7q9r6qduvQQvW4Ck0iiopQjs1f8lsQz4dzB3rd0araf0qa5JvuZ/kNfDFU
         gviYn784uyuu80WBVvON8JAQm09zLX1op41GCtzyCeOus5dS8dURR/lrLE6eolBcmSYB
         49DNlVVXW/ILEwmXVA6z4KHP2ZaisphbBxUJiMLoDCXa5tCfv/G2v46gu6pf8gHaRfKB
         GIvmH3CzJroIAFEKJchqEUNYfrcaMfL/Yh7OPgZb4Kkc1RrMo7V4DDVzN/L+A46l5BuJ
         Ed4n6OljKwUvXGR8pW4XTBYxq6fZjLT9Ys6H0QfSxcE4jyHZZJjQIgRj16MD+WLtPHiy
         /iEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707335785; x=1707940585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOFmIdHcVZFpvdlv+SwpSo0Y7EY1nbkZlWlLRqBJt6I=;
        b=UG3XymI4wU69407B2/aGamBI13CS7lnHnnp6oNvl939rDbibGhOcX2r+XRp8GdV/R/
         apRVYw+YrfQMj/YR3pNrqdQ6VXY4EEn+QoVbqG1nbu0RCdnaesOD0c5LfsQF/ibN3m+0
         rPjVpmo1qWKvC/eGE4Wd3VB77ZqvQ1Razky/SYoZ1QqB0sBF1E4H7+P95qQQOVM7lA3h
         DTwb6W3m40nwv+c5eyG7iObONFN1pjIT2rYcKKhxGFu0xwIlqzcG7q0yocY3p049DbRs
         TZ/oFGzVz1Th2pnZdGJLnODZ4KCzWORb6L6ETmza0BWBcJe+hQeOTwTQvpAPrPmV6dpn
         7NBQ==
X-Gm-Message-State: AOJu0YyGnmZ9iTBuPU9Umlxk4npHMLJdNWC06USz0k4jf9ILFkCLCYPK
	Cp6/60bosVdiglYNTlGGCvmHqpuGF0PtAldGeS0coyjmTZz8A2Ved1UX/6YkhsNJDNKIw4vkM+e
	JIKP4XElC58ZQ5fjsfpzMrrkOz/dyXfFGQX+c
X-Google-Smtp-Source: AGHT+IFyDmN8vpC/DtDFuDdylPr5fqRKmrKple2kR7uMrqfpHKpOh5ImkTJJ2shCLtNsUJhOZnmu0pONfefEfmA+h98=
X-Received: by 2002:a17:903:484:b0:1d8:da36:d0ae with SMTP id
 jj4-20020a170903048400b001d8da36d0aemr215750plb.3.1707335785036; Wed, 07 Feb
 2024 11:56:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240202220459.527138-1-namhyung@kernel.org> <20240202220459.527138-5-namhyung@kernel.org>
 <CAP-5=fU=P-ib+n+OfqJAbm8gS2RY-W-KcBskoSHkC+aCmXYcXQ@mail.gmail.com>
 <CAM9d7chvEw6r8_7agxOpWxufTo+dLaNForSFFShCFGd9KDBtoA@mail.gmail.com>
 <CAP-5=fWx9Uub9uRgQJq_ekQScm4fJXMdr9_cr19vcckCPjPt9w@mail.gmail.com> <CAM9d7ciGna7tm5gxoVAQexj_to9sRSL-emmCTSkMbGZgY8mthw@mail.gmail.com>
In-Reply-To: <CAM9d7ciGna7tm5gxoVAQexj_to9sRSL-emmCTSkMbGZgY8mthw@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 7 Feb 2024 11:56:13 -0800
Message-ID: <CAP-5=fXWew4c-0zAAny-1R+6mZpfATUc8pEi0G6G79BebiaPuA@mail.gmail.com>
Subject: Re: [PATCH 04/14] perf map: Add map__objdump_2rip()
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

On Wed, Feb 7, 2024 at 11:04=E2=80=AFAM Namhyung Kim <namhyung@kernel.org> =
wrote:
>
> On Tue, Feb 6, 2024 at 3:34=E2=80=AFPM Ian Rogers <irogers@google.com> wr=
ote:
> >
> > On Tue, Feb 6, 2024 at 3:04=E2=80=AFPM Namhyung Kim <namhyung@kernel.or=
g> wrote:
> > >
> > > Hi Ian,
> > >
> > > On Fri, Feb 2, 2024 at 5:42=E2=80=AFPM Ian Rogers <irogers@google.com=
> wrote:
> > > >
> > > > On Fri, Feb 2, 2024 at 2:05=E2=80=AFPM Namhyung Kim <namhyung@kerne=
l.org> wrote:
> > > > >
> > > > > Sometimes we want to convert an address in objdump output to
> > > > > map-relative address to match with a sample data.  Let's add
> > > > > map__objdump_2rip() for that.
> > > >
> > > > Hi Namhyung,
> > > >
> > > > I think the naming can be better here. Aren't the objdump addresses
> > > > DSO relative offsets? Is the relative IP relative to the map or the
> > > > DSO?
> > >
> > > AFAIK the objdump addresses are DSO-relative and rip is to map.
> > > They are mostly the same but sometimes different due to kASLR
> > > for the kernel.
> >
> > Perhaps we need to use names like map_rip for mapping relative and
> > dso_rip to clean this up, or to add a different mapping_type to the
> > enum. For non-kernel maps addresses for map are either the whole
> > virtual address space (identity) or relative to a dso:
> > https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.gi=
t/tree/tools/perf/util/map.h?h=3Dperf-tools-next#n115
> > https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.gi=
t/tree/tools/perf/util/map.h?h=3Dperf-tools-next#n20
> > The dso addresses should work for objdump so perhaps the kernel
> > addresses need map__pgoff fixing?
>
> I'm not sure about the vDSO case.
>
> By the way, I need to take a look if we can make this objdump-rip
> thing simpler as you mentioned.  My feeling is that it can be done
> but I'd like to do it in a separate work and to move this forward.

Makes sense. Could we add a comment to the header file definition to
capture some of this? Perhaps a "to be removed" to avoid later patches
adding dependencies to the function.

Thanks,
Ian

> Thanks,
> Namhyung
