Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5813FE7
	for <linux-trace-devel@vger.kernel.org>; Fri,  8 Dec 2023 13:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C99C433C8;
	Fri,  8 Dec 2023 13:52:08 +0000 (UTC)
Date: Fri, 8 Dec 2023 08:52:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ze Gao <zegao2021@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Ze Gao
 <zegao@tencent.com>
Subject: Re: [PATCH v2] libtraceevent plugins: Parse sched_switch
 "prev_state" field for state info
Message-ID: <20231208085240.66101533@gandalf.local.home>
In-Reply-To: <CAD8CoPC5Wi24OMPXtbacQuGdz1Eg771xLNbEd_iD0RgOWEfCnQ@mail.gmail.com>
References: <20231206185759.7792f272@gandalf.local.home>
	<CAD8CoPC5Wi24OMPXtbacQuGdz1Eg771xLNbEd_iD0RgOWEfCnQ@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Dec 2023 15:41:01 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> > diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switc=
h.c
> > index e0986ac9cc3d..bde68c4b602d 100644
> > --- a/plugins/plugin_sched_switch.c
> > +++ b/plugins/plugin_sched_switch.c
> > @@ -9,13 +9,136 @@
> >  #include "event-parse.h"
> >  #include "trace-seq.h"
> >
> > -static void write_state(struct trace_seq *s, int val)
> > +static const char *convert_sym(struct tep_print_flag_sym *sym)
> >  {
> > -       const char states[] =3D "SDTtXZPI";
> > +       static char save_states[33];
> > +
> > +       memset(save_states, 0, sizeof(save_states));
> > +
> > +       /* This is the flags for the prev_state_field, now make them in=
to a string */
> > +       for (; sym; sym =3D sym->next) {
> > +               long bitmask =3D strtoul(sym->value, NULL, 0);
> > +               int i;
> > +
> > +               for (i =3D 0; !(bitmask & 1); i++)
> > +                       bitmask >>=3D 1; =20
>=20
> It's no big deal but I think glibc has a faster version of ffs here
> we can directly call that one instead.

I'm use to using ffs in the kernel, but I'm always weary of glibc. No real
reason, just a personal reaction. Anyway, this is far from a fast path if
it's only calculated when hitting a new prev_state field. Although this can
happen often with host/guest tracing.

I figured I'd optimize that in another patch.

>=20
> > +               if (i > 32)
> > +                       continue; // warn?
> > +
> > +               save_states[i] =3D sym->str[0];
> > +       }
> > +
> > +       return save_states;
> > +}
> > +


> > +static void write_state(struct trace_seq *s, struct tep_format_field *=
field,
> > +                       struct tep_record *record)
> > +{
> > +       static struct tep_format_field *prev_state_field;
> > +       static const char *states;
> > +       unsigned long long val;
> >         int found =3D 0;
> > +       int len;
> >         int i;
> >
> > -       for (i =3D 0; i < (sizeof(states) - 1); i++) {
> > +       if (!field)
> > +               return;
> > +
> > +       if (!states || field !=3D prev_state_field) {
> > +               states =3D get_states(field);
> > +               if (!states)
> > +                       states =3D "SDTtXZPI";
> > +               printf("states =3D '%s'\n", states); =20
>=20
> printf here introduces some noises when I use perf script to inspect
> the raw events,
> and it always shows this "out-of-nowhere" message in the first
> sched_switch record.
> Still, no big deal, and better without this one.

Bah, that was for debugging. I forgot to nuke it. That's what I get when I
work on user space tooling while compiling the kernel for updates I'm doing
there. :-p

>=20
> > +               prev_state_field =3D field;
> > +       }
> > +
> > +       tep_read_number_field(field, record->data, &val);
> > +
> > +       len =3D strlen(states);
> > +       for (i =3D 0; i < len; i++) {
> >                 if (!(val & (1 << i)))
> >                         continue; =20
>=20
> I think here is another case to consider, the preemption state. it's
> exposed as well IIRC.
> and the kernel denotes this as "R+", maybe we can follow that
> convention by adding
> checks like:
>=20
>         if (!found) {
>                 trace_seq_putc(s, 'R');
>                 if (val)
>                      trace_seq_putc(s,  =E2=80=98+=E2=80=99);
>         }
>=20
> Just in case, if you were not intentional to make it as it is now.

Sounds good. I'd do that in a separate patch too.

>=20
> > @@ -99,8 +222,8 @@ static int sched_switch_handler(struct trace_seq *s,
> >         if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) =
=3D=3D 0)
> >                 trace_seq_printf(s, "[%d] ", (int) val);
> >
> > -       if (tep_get_field_val(s,  event, "prev_state", record, &val, 1)=
 =3D=3D 0)
> > -               write_state(s, val);
> > +       field =3D tep_find_any_field(event, "prev_state");
> > +       write_state(s, field, record);
> >
> >         trace_seq_puts(s, " =3D=3D> ");
> >
> > --
> > 2.42.0
> > =20
>=20
> Overall, I did the tests on my settings, and the patch worked. It's much =
more
> robust in finding and validating TEP_PRINT_FLAG than the one I posted and
> This is the first time I know we are capable of doing analyses on multipl=
e data
> records simultaneously. Learned a lot!
>=20
> Last but the least,  I had trouble applying the diff to the branch libtra=
ceevent
> initially but had to copy and paste on my own.  Just FYI. Still no big de=
al :)

I have three patches I have yet to push on top of this one. I'm way behind
in my user space work. As mentioned above, I tend to screw up when I try to
focus both on the kernel and user space libraries (unless I'm working on
both because they are related, but that's not currently the case).

Hopefully this will get done before the end of the year.

Thanks!

-- Steve
