Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AFFF0;
	Mon,  4 Dec 2023 16:10:35 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so2916208a12.1;
        Mon, 04 Dec 2023 16:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701735035; x=1702339835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNrtMZXRyIGyhkjT4JI1KSJerGhWTgoNl7m2Gv0tWQ8=;
        b=d95sEYLXlzwo5ZENkQxq/8Q5V6ecULN8XUf8zbv9VBWwIgpSg0rH77Q2SM9eCAA6Ws
         fAUorDaYeJeMWDrpcbEDra928bX8YDQhODcNE+A0o3s06FQzZhtfQIvoidnqGN6Fszkk
         XDEVErqNWw95pIlnEfq/3W3C3m32po/hV/jV9gB1D3sKAZKaOfFsWDt/6jBOW33bUbeI
         molWnZT29nOLv4i/EYz7WQ+5yAfBGgZQzFkCwq3YbizXEaYeywKwLczB925bnAxPfG98
         hJ+uzguBNBIE54Ddi57yXxQQrMF3lK37K/37TSEveNHPycDx8u8pG8igR1GkMzq4gwwm
         GmIQ==
X-Gm-Message-State: AOJu0YweMnoMJ0IQHu1inSJU6OxbS+Ea3PmYbpSrqHqU0CVWA6M9XWI8
	fRWBxcD2iksmZX/KllDD+yVhn6IRM+2Gt3TQBFVyP2QKqNs=
X-Google-Smtp-Source: AGHT+IHpJOO1gjA+QD4Y2Vv8sBMHvrZDvCNXRG2CGvSQAxz+GqJV4mQxzYN3cA8/d3COk14Ub3zwaYtqJBJGsTAuVqQ=
X-Received: by 2002:a17:90a:8005:b0:286:6cc1:3f1f with SMTP id
 b5-20020a17090a800500b002866cc13f1fmr476637pjn.86.1701735035239; Mon, 04 Dec
 2023 16:10:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012035111.676789-37-namhyung@kernel.org>
 <852644CC-CF12-475A-A7D2-84EFDCE9D248@linux.vnet.ibm.com>
In-Reply-To: <852644CC-CF12-475A-A7D2-84EFDCE9D248@linux.vnet.ibm.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 4 Dec 2023 16:10:24 -0800
Message-ID: <CAM9d7cgdUfdMnhmMpqnkpJyV5hJE9dgGuwPetSNM0KfDuYfs6A@mail.gmail.com>
Subject: Re: [PATCH 36/48] perf annotate-data: Introduce struct data_loc_info
To: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users <linux-perf-users@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Sun, Dec 3, 2023 at 8:22=E2=80=AFAM Athira Rajeev
<atrajeev@linux.vnet.ibm.com> wrote:
> Hi Namhyung,
>
> I have a thought there. For the type and typeoff sort keys to work, we de=
pend on Dwarf support in perf, right ?
> If the perf is built without dwarf support ( either due to older elfutils=
 or missing libdw.h ) , find_data_type will return NULL and we will get =E2=
=80=9Cunknown=E2=80=9D for Data Type and Data Type Offset in the result.

Yes, right.

>
> Can we add a pr_debug line in find_data_type (which is in else part for H=
AVE_DWARF_SUPPORT) so that user can understand if =E2=80=9Cunknown=E2=80=9D=
 is due to missing devel during the build ? Or may be restrict -s type,type=
off if dwarf support is missing ?

I think it's better to add a warning if DWARF is not supported.
Thanks for your review!

Namhyung
