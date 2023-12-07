Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92DC3D0D9
	for <linux-trace-devel@vger.kernel.org>; Thu,  7 Dec 2023 13:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAA9C433C7;
	Thu,  7 Dec 2023 13:20:15 +0000 (UTC)
Date: Thu, 7 Dec 2023 08:20:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ze Gao <zegao2021@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [PATCH v6 1/2] libtraceevent: sync state char array with the
 kernel
Message-ID: <20231207082044.353ba52f@gandalf.local.home>
In-Reply-To: <CAD8CoPAVJYS0YFmEYhXSn-MZ59QUgC5T6y35-R0GpjATOqHbYg@mail.gmail.com>
References: <20230803030955.380537-1-zegao@tencent.com>
	<20231206175506.14f6081d@gandalf.local.home>
	<CAD8CoPAVJYS0YFmEYhXSn-MZ59QUgC5T6y35-R0GpjATOqHbYg@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Dec 2023 10:52:35 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> On Thu, Dec 7, 2023 at 6:54=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
> >
> > On Wed,  2 Aug 2023 23:09:54 -0400
> > Ze Gao <zegao2021@gmail.com> wrote:
> > =20
> > As your update never made it into the kernel I never pulled these patch=
es
> > in. But we do have an issue with the state getting out of sync with what
> > the kernel actually uses.
> >
> > I did this "hack" but it seems to work. What I do is to look at the
> > sched_switch event print parsing arguments, find the __print_flags
> > arguments for the "prev_state" field. And then parse them, creating a n=
ew
> > output and I use that for the write_state() function. =20
>=20
> Thanks for your updates, I remembered to reply with my "hacks"  which
> fix both libtraceevent and "perf sched timehist --state".
> FYI,  for libtraceevent in this thread:
> https://lore.kernel.org/all/CAD8CoPDqZrd2HOUCVkrOq9JgJEQwQnqBn9zD1A3M4aKL=
Z4mLvg@mail.gmail.com

And somehow I missed this reply :-/

Sorry about that.

> and here for perf:
> https://lore.kernel.org/all/CAD8CoPDqZrd2HOUCVkrOq9JgJEQwQnqBn9zD1A3M4aKL=
Z4mLvg@mail.gmail.com/
>=20
> My only concern at that time was the very hacky way to pinpoint the
> TEP_PRINT_FLAGS due to the lack of knowledge of libtraceevent design.
> So I was not actively seeking to push my fixes to the upstream.
>=20
> > I guess this should work for you too? =20
>=20
> I'll give it a try definitely.
>=20
> > I still need to pull in this patch and use that as the default. I'll do
> > that before applying this one, and have your above update be the defaul=
t.
> >
> > Thanks! =20
>=20
>=20
> > -- Steve
> >
> > diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switc=
h.c
> > index 8752caea5c38..760d224f5507 100644
> > --- a/plugins/plugin_sched_switch.c
> > +++ b/plugins/plugin_sched_switch.c
> > @@ -9,13 +9,132 @@
> >  #include "event-parse.h"
> >  #include "trace-seq.h"
> >
> > -static void write_state(struct trace_seq *s, int val)
> > +static const char *convert_sym(struct tep_print_flag_sym *sym)
> >  {
> > -       const char states[] =3D "SDTtZXxW";
> > +       static char save_states[33]; =20
>=20
> how about a gobal counter instead of fixed sized constant here,
> and we can warn if it outbounds, u know, just in case.

I picked 33 to be 1 greater than 32 as that's the max size of prev_state on
32 bit systems. I should change that to be a macro though.

>=20
> > +       memset(save_states, 0, sizeof(save_states));
> > +
> > +       /* This is the flags for the prev_state_field, now make them in=
to a string */
> > +       for (; sym; sym =3D sym->next) {
> > +               long bitmask =3D strtoul(sym->value, NULL, 0);
> > +               int i;
> > +
> > +               for (i =3D 0; !(bitmask & 1); i++)
> > +                       bitmask >>=3D 1;
> > +
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
> > +       if (field !=3D prev_state_field) {
> > +               states =3D get_states(field); =20
>=20
> I think we only need to build the task_state_char_array once,
> and there are no other possibilities here. Correct me if I'm stupid :)

libtracecmd can be used for multiple trace.dat files, that in theory can
have more than one version of sched_switch. And yes this can be called with
two different versions of prev_state.

  trace-cmd report -i trace1.dat -i trace2.dat

This is commonly done to see host and guest trace data interleaved, where
the host and guest could have different versions of sched_switch.

> So here we can check if the char array is built, if so, we can
> directly look it up in the mapping, right?
>=20
> > +               if (!states)
> > +                       states =3D "SDTtZXxW"; =20
>=20
> I think I've done experiments on the very old kernel in which the TP_print
> is brought in the sched_switch tracepoint. The "hack" works for it too,
> so this should not happen. Anyway, I'll give it a try and keep this

I agree that "this should not happen" but I prefer to be safe than sorry,
and always try to write robust code. If in never happens we just waste a
branch, if it does happen, it can give some weird result. I don't know what
is in the future.

> thread updated
> if anything goes wrong.

Thanks,

-- Steve
