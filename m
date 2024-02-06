Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35281CF94
	for <linux-trace-devel@vger.kernel.org>; Tue,  6 Feb 2024 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707262444; cv=none; b=WWGtebp+ni/c896acOFnTGsPYMyEWsaRF4ZqpxzIeeqaIjw/9hdV60OOcMx5vLL2/j6/XmXVxkOH/j4fIp8YekMBL9igOLfT7MXGWF4n7agfGqO6u9fWEPekVT3lucn5Oy/QjHV37wdvn8OeTTZJFbu4AvtvEYSL6tGyTf/1GCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707262444; c=relaxed/simple;
	bh=K0JHVhNm290kYjW/2jbRNVQlHhXuWShGQ3vaF09Rtbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IZc6ozbIw7GNDjpLe5V3xoZy8al2NZJItqzY/pFFO8CFgD6EbI0B5QSxz6ZMmWZ17PjsjYmBTU1bBM7lsXYovIhRSeDFUrFaLWj9tDKvxEyePnEJZJ/qhLHE6GzyaBsPlgXD9v+KGQ0alXxL5j4JsGU8HymOwe47QaEBKcC+ffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EpQj700k; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EpQj700k"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d93b982761so98515ad.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2024 15:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707262437; x=1707867237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZojdQamwHKccRr82ZmQZAgprokxPdXHB3lzbm6t4X8=;
        b=EpQj700ktJeEDnifVPj7Lgs3nuhI/rPAbAmpYzCyaXlqRG6dCRjji2f1aiJ1kjEu0R
         LEyNHoMs3c+xnrDTPIkR6JUenR7ON8c+TJqTXrsr3NF37W/6X7sqoAfwU2FI1NQQ4y6d
         iIBu5WmR7kTaKE1M7fI1iytdKh3YqR743GfNSA7bg0oG5RTq+NgnNVlskeQWimC5d28O
         VO7/6JWh0ef2HiE4IF2rBU1+DYZ3yiJHG/uv1tJiLtsjwmxyDwEXo4QWLuBO4BhprgLp
         OwKY141wMW7uE484j3s19Klxw6bB/eyfM0+Pdv/VsACwrLUQvwPNF6/AHvoawVJ714p0
         h3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707262437; x=1707867237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MZojdQamwHKccRr82ZmQZAgprokxPdXHB3lzbm6t4X8=;
        b=vT/OwGYsT/czrITBh79OJSYNqBr96WaSQhiue/o9/OpniZegnXXLyVH+4af46Sm7bu
         BsVMW2F42RRPKR9e5uVPGqKziPDNBUmX54bmk/AIy6ew+cdmkLekn8zoUoFX59/gwR5o
         PpLwsOQBvyf6etq8o6Cx71ilbOmZgmzCQNE6dt3A1B1YAl8neWAjYl6jL66cdrsDdW8a
         IPxW1ZqhjVhDkWT9mcTbnw25uOVxdM8zlyCGogAxa5nej/IbNxhfw7RIobb9g5cC1ldq
         5WnAicLt5l4UCWhKohmtUud5CZx/faoR31ihKvYnv+aSqtm62VgS9sMjUteNwy+zT7qq
         C80A==
X-Gm-Message-State: AOJu0YwfadjPU/lxSLNlkJctgFc8Fc8NSJ9LF35Ica2AYrXrna2I0JmN
	uX/s5QaXwqxaCcPoKOYKcL3TJB6X6DX82Ola24Q7imMn30MWwnuA9oXjnTtAx9HUHbO6FN1OeI9
	r2B0qol3DGlZngvFmMA1BzJXU2y8OjvhZaPHHtcOt8fDPBkQ21Hqj/S0=
X-Google-Smtp-Source: AGHT+IFkHqjGgP7sJpFT7zMMRof3mHJG2tyE/mCS56leYNTbbj02eyfle5Xij7RGqPgwwO+bwhvwMjYY4IVotQgGJpk=
X-Received: by 2002:a17:902:c94e:b0:1d8:cc74:b11e with SMTP id
 i14-20020a170902c94e00b001d8cc74b11emr1462pla.6.1707262436801; Tue, 06 Feb
 2024 15:33:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240202220459.527138-1-namhyung@kernel.org> <20240202220459.527138-5-namhyung@kernel.org>
 <CAP-5=fU=P-ib+n+OfqJAbm8gS2RY-W-KcBskoSHkC+aCmXYcXQ@mail.gmail.com> <CAM9d7chvEw6r8_7agxOpWxufTo+dLaNForSFFShCFGd9KDBtoA@mail.gmail.com>
In-Reply-To: <CAM9d7chvEw6r8_7agxOpWxufTo+dLaNForSFFShCFGd9KDBtoA@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 6 Feb 2024 15:33:45 -0800
Message-ID: <CAP-5=fWx9Uub9uRgQJq_ekQScm4fJXMdr9_cr19vcckCPjPt9w@mail.gmail.com>
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

On Tue, Feb 6, 2024 at 3:04=E2=80=AFPM Namhyung Kim <namhyung@kernel.org> w=
rote:
>
> Hi Ian,
>
> On Fri, Feb 2, 2024 at 5:42=E2=80=AFPM Ian Rogers <irogers@google.com> wr=
ote:
> >
> > On Fri, Feb 2, 2024 at 2:05=E2=80=AFPM Namhyung Kim <namhyung@kernel.or=
g> wrote:
> > >
> > > Sometimes we want to convert an address in objdump output to
> > > map-relative address to match with a sample data.  Let's add
> > > map__objdump_2rip() for that.
> >
> > Hi Namhyung,
> >
> > I think the naming can be better here. Aren't the objdump addresses
> > DSO relative offsets? Is the relative IP relative to the map or the
> > DSO?
>
> AFAIK the objdump addresses are DSO-relative and rip is to map.
> They are mostly the same but sometimes different due to kASLR
> for the kernel.

Perhaps we need to use names like map_rip for mapping relative and
dso_rip to clean this up, or to add a different mapping_type to the
enum. For non-kernel maps addresses for map are either the whole
virtual address space (identity) or relative to a dso:
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/map.h?h=3Dperf-tools-next#n115
https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git/tr=
ee/tools/perf/util/map.h?h=3Dperf-tools-next#n20
The dso addresses should work for objdump so perhaps the kernel
addresses need map__pgoff fixing?

Thanks,
Ian

> >
> > > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > > ---
> > >  tools/perf/util/map.c | 20 ++++++++++++++++++++
> > >  tools/perf/util/map.h |  3 +++
> > >  2 files changed, 23 insertions(+)
> > >
> > > diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> > > index 54c67cb7ecef..66542864b7b5 100644
> > > --- a/tools/perf/util/map.c
> > > +++ b/tools/perf/util/map.c
> > > @@ -594,6 +594,26 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
> > >         return ip + map__reloc(map);
> > >  }
> > >
> > > +u64 map__objdump_2rip(struct map *map, u64 ip)
> > > +{
> > > +       const struct dso *dso =3D map__dso(map);
> > > +
> > > +       if (!dso->adjust_symbols)
> > > +               return ip;
> > > +
> > > +       if (dso->rel)
> > > +               return ip + map__pgoff(map);
> > > +
> > > +       /*
> > > +        * kernel modules also have DSO_TYPE_USER in dso->kernel,
> > > +        * but all kernel modules are ET_REL, so won't get here.
> > > +        */
>
> Hmm.. This comment is not true anymore.  Will remove
> in other places too.
>
> Thanks,
> Namhyung
>
>
> > > +       if (dso->kernel =3D=3D DSO_SPACE__USER)
> > > +               return ip - dso->text_offset;
> > > +
> > > +       return map__map_ip(map, ip + map__reloc(map));
> > > +}
> > > +
> > >  bool map__contains_symbol(const struct map *map, const struct symbol=
 *sym)
> > >  {
> > >         u64 ip =3D map__unmap_ip(map, sym->start);
> > > diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> > > index 49756716cb13..65e2609fa1b1 100644
> > > --- a/tools/perf/util/map.h
> > > +++ b/tools/perf/util/map.h
> > > @@ -132,6 +132,9 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
> > >  /* objdump address -> memory address */
> > >  u64 map__objdump_2mem(struct map *map, u64 ip);
> > >
> > > +/* objdump address -> rip */
> > > +u64 map__objdump_2rip(struct map *map, u64 ip);
> > > +
> > >  struct symbol;
> > >  struct thread;
> > >
> > > --
> > > 2.43.0.594.gd9cf4e227d-goog
> > >
