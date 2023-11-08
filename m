Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23687CA4C;
	Wed,  8 Nov 2023 05:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1350D1A4;
	Tue,  7 Nov 2023 21:34:57 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-28014fed9efso5201343a91.0;
        Tue, 07 Nov 2023 21:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699421696; x=1700026496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aj8+KDGZnfeN+8vQSl4+O0eA16A22y/CzIXhddtooPI=;
        b=chiOmGcCvmay3WnHKRgdSBIs/runRq8AxloMCPfSWWfvM43YI/CWvQQ0zUuGfdVAFp
         P15/mmZKH/RWCclnNWmKE2BspVQ3tyirYkq8lPUs5VEX9sp06IBs7rieyLtvCLceX0wT
         9wsMfXwhCqArT/XvW9Z04PzlxS9MshS/DvTSnEGQkXRzSyPwqLV3Jie7djKS+4/3khhh
         6ocICQgE0r/1/oDmvPJTYHT6OOJnRi+cH2bXIfqJrgKuMQ+c7FeESNNM2u+IQqLV21z3
         drFt5l75CbwZDMKuQ8Cg1CVE0i8FFvbxQyvMKchsglpSFwylqL7UZ4uRaQzPN+brG6EM
         X7nA==
X-Gm-Message-State: AOJu0Yyy4eLcnT5dHKtQLzsqqd/B3OohFE6H6/M+eRaAasWsMePk5mzf
	a44RX3w6NdRiFwICGvueNmfc+YiSWo5EN8IRCdonL2cP
X-Google-Smtp-Source: AGHT+IHm0pTIf2r+NoqJKkrRqkdT1E+A2wxNwpGxOCzkgbJykuseWPI4yruowkm/BHxXXY7fUJTQBmLSTBPTGAXUV0k=
X-Received: by 2002:a17:90b:1b0e:b0:27c:ef18:d270 with SMTP id
 nu14-20020a17090b1b0e00b0027cef18d270mr755936pjb.20.1699421696369; Tue, 07
 Nov 2023 21:34:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231012035111.676789-1-namhyung@kernel.org> <20231012035111.676789-34-namhyung@kernel.org>
 <20231107183207.2e3aded5985f699fdb3bcd16@kernel.org>
In-Reply-To: <20231107183207.2e3aded5985f699fdb3bcd16@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 7 Nov 2023 21:34:45 -0800
Message-ID: <CAM9d7chtQ7EUracK9f87NN-Er=u+rvKWShbqpvy=De7jyjauEQ@mail.gmail.com>
Subject: Re: [PATCH 33/48] perf dwarf-aux: Check allowed DWARF Ops
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	linux-toolchains@vger.kernel.org, linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 1:32=E2=80=AFAM Masami Hiramatsu <mhiramat@kernel.or=
g> wrote:
>
> On Wed, 11 Oct 2023 20:50:56 -0700
> Namhyung Kim <namhyung@kernel.org> wrote:
>
> > The DWARF location expression can be fairly complex and it'd be hard
> > to match it with the condition correctly.  So let's be conservative
> > and only allow simple expressions.  For now it just checks the first
> > operation in the list.  The following operations looks ok:
> >
> >  * DW_OP_stack_value
> >  * DW_OP_deref_size
> >  * DW_OP_deref
> >  * DW_OP_piece
> >
> > To refuse complex (and unsupported) location expressions, add
> > check_allowed_ops() to compare the rest of the list.  It seems earlier
> > result contained those unsupported expressions.  For example, I found
> > some local struct variable is placed like below.
> >
> >  <2><43d1517>: Abbrev Number: 62 (DW_TAG_variable)
> >     <43d1518>   DW_AT_location    : 15 byte block: 91 50 93 8 91 78 93 =
4 93 84 8 91 68 93 4
> >         (DW_OP_fbreg: -48; DW_OP_piece: 8;
> >          DW_OP_fbreg: -8; DW_OP_piece: 4;
> >          DW_OP_piece: 1028;
> >          DW_OP_fbreg: -24; DW_OP_piece: 4)
> >
> > Another example is something like this.
> >
> >     0057c8be ffffffffffffffff ffffffff812109f0 (base address)
> >     0057c8ce ffffffff812112b5 ffffffff812112c8 (DW_OP_breg3 (rbx): 0;
> >                                                 DW_OP_constu: 184467440=
73709551612;
> >                                                 DW_OP_and;
> >                                                 DW_OP_stack_value)
> >
> > It should refuse them.  After the change, the stat shows:
> >
> >   Annotate data type stats:
> >   total 294, ok 158 (53.7%), bad 136 (46.3%)
> >   -----------------------------------------------------------
> >           30 : no_sym
> >           32 : no_mem_ops
> >           53 : no_var
> >           14 : no_typeinfo
> >            7 : bad_offset
> >
>
> The code itself looks good to me.
>
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

>
> If this fixes the previous patch in the same series (this seems a fix for=
 the
> main usecase), please make it to a single patch.

Well.. I think it's a fix and also a quality issue.  And I'd like to
have this separately to document and confirm which operations
are safe or acceptable.  I listed 4 operations here based on my
local tests but I may miss something.

Thanks,
Namhyung


> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/dwarf-aux.c | 44 +++++++++++++++++++++++++++++++++----
> >  1 file changed, 40 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> > index 7f3822d08ab7..093d7e82b333 100644
> > --- a/tools/perf/util/dwarf-aux.c
> > +++ b/tools/perf/util/dwarf-aux.c
> > @@ -1305,6 +1305,34 @@ static bool match_var_offset(Dwarf_Die *die_mem,=
 struct find_var_data *data,
> >       return true;
> >  }
> >
> > +static bool check_allowed_ops(Dwarf_Op *ops, size_t nops)
> > +{
> > +     /* The first op is checked separately */
> > +     ops++;
> > +     nops--;
> > +
> > +     /*
> > +      * It needs to make sure if the location expression matches to th=
e given
> > +      * register and offset exactly.  Thus it rejects any complex expr=
essions
> > +      * and only allows a few of selected operators that doesn't chang=
e the
> > +      * location.
> > +      */
> > +     while (nops) {
> > +             switch (ops->atom) {
> > +             case DW_OP_stack_value:
> > +             case DW_OP_deref_size:
> > +             case DW_OP_deref:
> > +             case DW_OP_piece:
> > +                     break;
> > +             default:
> > +                     return false;
> > +             }
> > +             ops++;
> > +             nops--;
> > +     }
> > +     return true;
> > +}
> > +
> >  /* Only checks direct child DIEs in the given scope. */
> >  static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
> >  {
> > @@ -1332,25 +1360,31 @@ static int __die_find_var_reg_cb(Dwarf_Die *die=
_mem, void *arg)
> >               /* Local variables accessed using frame base register */
> >               if (data->is_fbreg && ops->atom =3D=3D DW_OP_fbreg &&
> >                   data->offset >=3D (int)ops->number &&
> > +                 check_allowed_ops(ops, nops) &&
> >                   match_var_offset(die_mem, data, data->offset, ops->nu=
mber))
> >                       return DIE_FIND_CB_END;
> >
> >               /* Only match with a simple case */
> >               if (data->reg < DWARF_OP_DIRECT_REGS) {
> > -                     if (ops->atom =3D=3D (DW_OP_reg0 + data->reg) && =
nops =3D=3D 1)
> > +                     /* pointer variables saved in a register 0 to 31 =
*/
> > +                     if (ops->atom =3D=3D (DW_OP_reg0 + data->reg) &&
> > +                         check_allowed_ops(ops, nops))
> >                               return DIE_FIND_CB_END;
> >
> >                       /* Local variables accessed by a register + offse=
t */
> >                       if (ops->atom =3D=3D (DW_OP_breg0 + data->reg) &&
> > +                         check_allowed_ops(ops, nops) &&
> >                           match_var_offset(die_mem, data, data->offset,=
 ops->number))
> >                               return DIE_FIND_CB_END;
> >               } else {
> > +                     /* pointer variables saved in a register 32 or ab=
ove */
> >                       if (ops->atom =3D=3D DW_OP_regx && ops->number =
=3D=3D data->reg &&
> > -                         nops =3D=3D 1)
> > +                         check_allowed_ops(ops, nops))
> >                               return DIE_FIND_CB_END;
> >
> >                       /* Local variables accessed by a register + offse=
t */
> >                       if (ops->atom =3D=3D DW_OP_bregx && data->reg =3D=
=3D ops->number &&
> > +                         check_allowed_ops(ops, nops) &&
> >                           match_var_offset(die_mem, data, data->offset,=
 ops->number2))
> >                               return DIE_FIND_CB_END;
> >               }
> > @@ -1412,7 +1446,8 @@ static int __die_find_var_addr_cb(Dwarf_Die *die_=
mem, void *arg)
> >               if (data->addr < ops->number)
> >                       continue;
> >
> > -             if (match_var_offset(die_mem, data, data->addr, ops->numb=
er))
> > +             if (check_allowed_ops(ops, nops) &&
> > +                 match_var_offset(die_mem, data, data->addr, ops->numb=
er))
> >                       return DIE_FIND_CB_END;
> >       }
> >       return DIE_FIND_CB_SIBLING;
> > @@ -1501,7 +1536,8 @@ int die_get_cfa(Dwarf *dwarf, u64 pc, int *preg, =
int *poffset)
> >               return -1;
> >
> >       if (!dwarf_cfi_addrframe(cfi, pc, &frame) &&
> > -         !dwarf_frame_cfa(frame, &ops, &nops) && nops =3D=3D 1) {
> > +         !dwarf_frame_cfa(frame, &ops, &nops) &&
> > +         check_allowed_ops(ops, nops)) {
> >               *preg =3D reg_from_dwarf_op(ops);
> >               *poffset =3D offset_from_dwarf_op(ops);
> >               return 0;
> > --
> > 2.42.0.655.g421f12c284-goog
> >
>
>
> --
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
