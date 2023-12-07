Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhhxjVwL"
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83134D4B
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 Dec 2023 18:52:48 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-54c1cd8d239so580256a12.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Dec 2023 18:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701917567; x=1702522367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWiCvdRwc02IhR9dFfTY9yUx4Qpw44Q0yhp+aDyhY4Q=;
        b=fhhxjVwLMTPFaCaIiVYDjdBEWQSSldMjZe45E06hUBWhVAzJzbxd31Que+LrPQilnK
         UXErBdthGo5x441+J12uvnsOEwzFzJBUDi8Qoq8swj36ZcOUVdFl1r26F4GQcKhQDgnT
         uj5q1COZdbAUN3YLydqKN39fBgWfDo+e+LGdCL3szgfGyoWdGD5jnlZhi9NneEYQk4jr
         0jgKEjRj1L3qwlIKHFbCQLAsSFy81/DGO+T4QSBoF1N/WuxYgy4efTsW/6DbXVsdoJur
         cYa1yI6XOdzFitGQQo2YPAK0/Jf25CMVpoUahm15cPv7fPT8g6Bt3+/EwMXwv0fq2al2
         lYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701917567; x=1702522367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWiCvdRwc02IhR9dFfTY9yUx4Qpw44Q0yhp+aDyhY4Q=;
        b=mpROGcZSI/tvFkSHMJefRxqQnzpj0K6NLAiB1TdQrFqxx1TEz8glF/LrbxXn6NSDQv
         v22AtqoIAfQ1POBLk/RcNMjbhO128CeweACnfGGrea6VUka3XjEgeY2fdOqcXrfO6RMQ
         Q2hlNp0qPFMfNqxPuMyaYu3o7xUbuGXTnGSi5+e4Qn6l18HEQEV5AAfnqOBKF5WHsQT/
         8VA3F1wcvRtzsvlhU4h0QmyyMXaro5DzFE9QqcJnBW55FGQT7gCjXMdgAa+ADIqtHouv
         A9rYkkGeSbEJUFuXzMv5KpVrEU5sOdhfagGpgZC798L2Zey1crETWPfpO7wZQZKtRxiH
         KHzQ==
X-Gm-Message-State: AOJu0YxJItJDiTW9vykDG3zZpjPLPScIZ7MzcVs3deCvAdQjubnBRDUJ
	zwEpJMZq2NUMyUBfvygoktDOrtYywOOUvzA62EE=
X-Google-Smtp-Source: AGHT+IH7u4Q/b/H5lQjA9ZPZ+flgrUCTK1UpdvFlcOe7gqjR7GUpfG7Zzwpagyaax+81xtGfgbudWJTNDK/zrxT16aA=
X-Received: by 2002:a50:d553:0:b0:54d:1879:b4df with SMTP id
 f19-20020a50d553000000b0054d1879b4dfmr699106edj.0.1701917566662; Wed, 06 Dec
 2023 18:52:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230803030955.380537-1-zegao@tencent.com> <20231206175506.14f6081d@gandalf.local.home>
In-Reply-To: <20231206175506.14f6081d@gandalf.local.home>
From: Ze Gao <zegao2021@gmail.com>
Date: Thu, 7 Dec 2023 10:52:35 +0800
Message-ID: <CAD8CoPAVJYS0YFmEYhXSn-MZ59QUgC5T6y35-R0GpjATOqHbYg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] libtraceevent: sync state char array with the kernel
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 6:54=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> On Wed,  2 Aug 2023 23:09:54 -0400
> Ze Gao <zegao2021@gmail.com> wrote:
>
> > Update state char array to match the latest kernel
> > definitions.
> >
> > Signed-off-by: Ze Gao <zegao@tencent.com>
> > ---
> >  plugins/plugin_sched_switch.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switc=
h.c
> > index 8752cae..e0986ac 100644
> > --- a/plugins/plugin_sched_switch.c
> > +++ b/plugins/plugin_sched_switch.c
> > @@ -11,7 +11,7 @@
> >
> >  static void write_state(struct trace_seq *s, int val)
> >  {
> > -     const char states[] =3D "SDTtZXxW";
> > +     const char states[] =3D "SDTtXZPI";
> >       int found =3D 0;
> >       int i;
> >
>
> Hi Ze,
>
> As your update never made it into the kernel I never pulled these patches
> in. But we do have an issue with the state getting out of sync with what
> the kernel actually uses.
>
> I did this "hack" but it seems to work. What I do is to look at the
> sched_switch event print parsing arguments, find the __print_flags
> arguments for the "prev_state" field. And then parse them, creating a new
> output and I use that for the write_state() function.

Thanks for your updates, I remembered to reply with my "hacks"  which
fix both libtraceevent and "perf sched timehist --state".
FYI,  for libtraceevent in this thread:
https://lore.kernel.org/all/CAD8CoPDqZrd2HOUCVkrOq9JgJEQwQnqBn9zD1A3M4aKLZ4=
mLvg@mail.gmail.com
and here for perf:
https://lore.kernel.org/all/CAD8CoPDqZrd2HOUCVkrOq9JgJEQwQnqBn9zD1A3M4aKLZ4=
mLvg@mail.gmail.com/

My only concern at that time was the very hacky way to pinpoint the
TEP_PRINT_FLAGS due to the lack of knowledge of libtraceevent design.
So I was not actively seeking to push my fixes to the upstream.

> I guess this should work for you too?

I'll give it a try definitely.

> I still need to pull in this patch and use that as the default. I'll do
> that before applying this one, and have your above update be the default.
>
> Thanks!


> -- Steve
>
> diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.=
c
> index 8752caea5c38..760d224f5507 100644
> --- a/plugins/plugin_sched_switch.c
> +++ b/plugins/plugin_sched_switch.c
> @@ -9,13 +9,132 @@
>  #include "event-parse.h"
>  #include "trace-seq.h"
>
> -static void write_state(struct trace_seq *s, int val)
> +static const char *convert_sym(struct tep_print_flag_sym *sym)
>  {
> -       const char states[] =3D "SDTtZXxW";
> +       static char save_states[33];

how about a gobal counter instead of fixed sized constant here,
and we can warn if it outbounds, u know, just in case.

> +       memset(save_states, 0, sizeof(save_states));
> +
> +       /* This is the flags for the prev_state_field, now make them into=
 a string */
> +       for (; sym; sym =3D sym->next) {
> +               long bitmask =3D strtoul(sym->value, NULL, 0);
> +               int i;
> +
> +               for (i =3D 0; !(bitmask & 1); i++)
> +                       bitmask >>=3D 1;
> +
> +               if (i > 32)
> +                       continue; // warn?
> +
> +               save_states[i] =3D sym->str[0];
> +       }
> +
> +       return save_states;
> +}
> +
> +static struct tep_print_arg_field *
> +find_arg_field(struct tep_format_field *prev_state_field, struct tep_pri=
nt_arg *arg)
> +{
> +       struct tep_print_arg_field *field;
> +
> +       if (!arg)
> +               return NULL;
> +
> +       if (arg->type =3D=3D TEP_PRINT_FIELD)
> +               return &arg->field;
> +
> +       if (arg->type =3D=3D TEP_PRINT_OP) {
> +               field =3D find_arg_field(prev_state_field, arg->op.left);
> +               if (field && field->field =3D=3D prev_state_field)
> +                       return field;
> +               field =3D find_arg_field(prev_state_field, arg->op.right)=
;
> +               if (field && field->field =3D=3D prev_state_field)
> +                       return field;
> +       }
> +       return NULL;
> +}
> +
> +static struct tep_print_flag_sym *
> +test_flags(struct tep_format_field *prev_state_field, struct tep_print_a=
rg *arg)
> +{
> +       struct tep_print_arg_field *field;
> +
> +       field =3D find_arg_field(prev_state_field, arg->flags.field);
> +       if (!field)
> +               return NULL;
> +
> +       return arg->flags.flags;
> +}
> +
> +static struct tep_print_flag_sym *
> +search_op(struct tep_format_field *prev_state_field, struct tep_print_ar=
g *arg)
> +{
> +       struct tep_print_flag_sym *sym =3D NULL;
> +
> +       if (!arg)
> +               return NULL;
> +
> +       if (arg->type =3D=3D TEP_PRINT_OP) {
> +               sym =3D search_op(prev_state_field, arg->op.left);
> +               if (sym)
> +                       return sym;
> +
> +               sym =3D search_op(prev_state_field, arg->op.right);
> +               if (sym)
> +                       return sym;
> +       } else if (arg->type =3D=3D TEP_PRINT_FLAGS) {
> +               sym =3D test_flags(prev_state_field, arg);
> +       }
> +
> +       return sym;
> +}
> +
> +static const char *get_states(struct tep_format_field *prev_state_field)
> +{
> +       struct tep_print_flag_sym *sym;
> +       struct tep_print_arg *arg;
> +       struct tep_event *event;
> +
> +       event =3D prev_state_field->event;
> +
> +       /*
> +        * Look at the event format fields, and search for where
> +        * the prev_state is parsed via the format flags.
> +        */
> +       for (arg =3D event->print_fmt.args; arg; arg =3D arg->next) {
> +               /*
> +                * Currently, the __print_flags() for the prev_state
> +                * is embedded in operations, so they too must be
> +                * searched.
> +                */
> +               sym =3D search_op(prev_state_field, arg);
> +               if (sym)
> +                       return convert_sym(sym);
> +       }
> +       return NULL;
> +}
> +
> +static void write_state(struct trace_seq *s, struct tep_format_field *fi=
eld,
> +                       struct tep_record *record)
> +{
> +       static struct tep_format_field *prev_state_field;
> +       static const char *states;
> +       unsigned long long val;
>         int found =3D 0;
> +       int len;
>         int i;
>
> -       for (i =3D 0; i < (sizeof(states) - 1); i++) {
> +       if (field !=3D prev_state_field) {
> +               states =3D get_states(field);

I think we only need to build the task_state_char_array once,
and there are no other possibilities here. Correct me if I'm stupid :)
So here we can check if the char array is built, if so, we can
directly look it up in the mapping, right?

> +               if (!states)
> +                       states =3D "SDTtZXxW";

I think I've done experiments on the very old kernel in which the TP_print
is brought in the sched_switch tracepoint. The "hack" works for it too,
so this should not happen. Anyway, I'll give it a try and keep this
thread updated
if anything goes wrong.


Regards,
Ze Gao

> +               prev_state_field =3D field;
> +       }
> +
> +       tep_read_number_field(field, record->data, &val);
> +
> +       len =3D strlen(states);
> +       for (i =3D 0; i < len; i++) {
>                 if (!(val & (1 << i)))
>                         continue;
>
> @@ -99,8 +218,8 @@ static int sched_switch_handler(struct trace_seq *s,
>         if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) =3D=
=3D 0)
>                 trace_seq_printf(s, "[%d] ", (int) val);
>
> -       if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) =
=3D=3D 0)
> -               write_state(s, val);
> +       field =3D tep_find_any_field(event, "prev_state");
> +       write_state(s, field, record);
>
>         trace_seq_puts(s, " =3D=3D> ");
>
