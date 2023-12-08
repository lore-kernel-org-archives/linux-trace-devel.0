Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFq6bF4+"
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2631730
	for <linux-trace-devel@vger.kernel.org>; Thu,  7 Dec 2023 23:41:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-54c9116d05fso2423239a12.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Dec 2023 23:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702021273; x=1702626073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LXJK3LWSsuSaszBxMhiYja2aYBJ1pweOkwS3OjEs0g=;
        b=CFq6bF4+ZUYh4Xmtj924Cd0rMNfX68nDKz6vSX8nVnfnMHCgptZdi968dMH0YG12e6
         kvhOYQFLEj/OIe7k4JDAzq40BQCKfvAhSLLNcZON6Q3BFY8Xt8IqHt7nl49Ns7E/UcBq
         9Aai8S2WUXC4ySkiPMAVyOAJ9nCeVQ34Mu58aNCWI/w8bim4dw62dPseM4ECUDX1WUKI
         m6GHeoVTjexKLdDfd2X9zTEK9/iIiCtpRhMDd/M+dTr5lm7dCQBUoh84zT2vxw+LHP/W
         KKJXzxjUG+cw7GUcJz4DJGEYVt4G/DP/5RC7XwGKoYtXrA2ArIE5mCc7lRN3pK2oYFA4
         KlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702021273; x=1702626073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5LXJK3LWSsuSaszBxMhiYja2aYBJ1pweOkwS3OjEs0g=;
        b=QyQgJsAIrETDiPfATw/fO6tNlVdUaQbrPD8LfUXOZeRI9r7PScqMBEkVZuaEs0SRX+
         ZJjntfAekKipuUwuM0A3qBHj9n9F2LUBNCEcI1TP1oXTGkRzkoZp1d7tKXiP+UBK/kM8
         XzxF1ssqPm27jbKVTXc5I1DfOlQRXk0VUnov+JUXNteqsb28b+at9AVjq9unMkxz+h3u
         p+IzjgxxqoPNkmJlD8bVV7Pk4ay/gIRWpXSEC8iv8SFqG0D8MfoStX3nW6XpSnI6Oaf2
         FPbV03UT++LVPYW1BMzlUe2aldNiESzFScjikpc1kBboAPqa2MWVUQR32udZYSYgs9v5
         R8Kw==
X-Gm-Message-State: AOJu0YyaNEhSMR8vyrLFd/f9EqyG2bnwpUbmqj+oZM5aHUn/L0c0U4gt
	XhGmoyGunYrAu96ofEmEg0xaZ5+Wg+Xesnz1Wt9N9EYjMTexck76
X-Google-Smtp-Source: AGHT+IHNN/Cju4kJC7b2mlla4SO5u4n4JMCwXOrJ9ASU+mMEluALLGBV4TJ2iDHZU928iLAuSKsoSbG57LUwjOPpXG8=
X-Received: by 2002:a50:c353:0:b0:54c:f1dc:a428 with SMTP id
 q19-20020a50c353000000b0054cf1dca428mr1238193edb.95.1702021273085; Thu, 07
 Dec 2023 23:41:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206185759.7792f272@gandalf.local.home>
In-Reply-To: <20231206185759.7792f272@gandalf.local.home>
From: Ze Gao <zegao2021@gmail.com>
Date: Fri, 8 Dec 2023 15:41:01 +0800
Message-ID: <CAD8CoPC5Wi24OMPXtbacQuGdz1Eg771xLNbEd_iD0RgOWEfCnQ@mail.gmail.com>
Subject: Re: [PATCH v2] libtraceevent plugins: Parse sched_switch "prev_state"
 field for state info
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 7:57=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> The write_state() function uses a hard coded string "SDTtXZPI" to index
> the sched_switch prev_state field bitmask. This is fine, except for when
> the kernel changes this string, in which case this will break again.
>
> Worse yet, there can be various saved trace files that have various
> versions of this string, and updating the string may work for one trace
> file, it will likely break another trace file.
>
> Instead, look into the event itself, and how it parsed the "print fmt".
> Using the tep_print_args, the mapping between the bits and the output tha=
t
> the kernel uses is exposed to user space. Walk the print arguments until
> the __print_flags() for the "prev_state" field is found, and use that to
> build the states string for future parsing.
>
> Save the "prev_state_field" pointer, as it should be the same for later
> occurrences, but if more than one trace data (more than one tep handler)
> is being parsed, the string will need to be updated each time a new field
> is passed in, as this is not saved in the tep handle itself.
>
> Link: https://lore.kernel.org/linux-trace-devel/20231206175506.14f6081d@g=
andalf.local.home/
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/linux-trace-devel/2023120618075=
0.68fc8648@gandalf.local.home/
>
> - Added check for field is NULL if the prev_state does not exist.
>
>  plugins/plugin_sched_switch.c | 133 ++++++++++++++++++++++++++++++++--
>  1 file changed, 128 insertions(+), 5 deletions(-)
>
> diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.=
c
> index e0986ac9cc3d..bde68c4b602d 100644
> --- a/plugins/plugin_sched_switch.c
> +++ b/plugins/plugin_sched_switch.c
> @@ -9,13 +9,136 @@
>  #include "event-parse.h"
>  #include "trace-seq.h"
>
> -static void write_state(struct trace_seq *s, int val)
> +static const char *convert_sym(struct tep_print_flag_sym *sym)
>  {
> -       const char states[] =3D "SDTtXZPI";
> +       static char save_states[33];
> +
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

It's no big deal but I think glibc has a faster version of ffs here
we can directly call that one instead.

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
> +       if (!field)
> +               return;
> +
> +       if (!states || field !=3D prev_state_field) {
> +               states =3D get_states(field);
> +               if (!states)
> +                       states =3D "SDTtXZPI";
> +               printf("states =3D '%s'\n", states);

printf here introduces some noises when I use perf script to inspect
the raw events,
and it always shows this "out-of-nowhere" message in the first
sched_switch record.
Still, no big deal, and better without this one.

> +               prev_state_field =3D field;
> +       }
> +
> +       tep_read_number_field(field, record->data, &val);
> +
> +       len =3D strlen(states);
> +       for (i =3D 0; i < len; i++) {
>                 if (!(val & (1 << i)))
>                         continue;

I think here is another case to consider, the preemption state. it's
exposed as well IIRC.
and the kernel denotes this as "R+", maybe we can follow that
convention by adding
checks like:

        if (!found) {
                trace_seq_putc(s, 'R');
                if (val)
                     trace_seq_putc(s,  =E2=80=98+=E2=80=99);
        }

Just in case, if you were not intentional to make it as it is now.

> @@ -99,8 +222,8 @@ static int sched_switch_handler(struct trace_seq *s,
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
> --
> 2.42.0
>

Overall, I did the tests on my settings, and the patch worked. It's much mo=
re
robust in finding and validating TEP_PRINT_FLAG than the one I posted and
This is the first time I know we are capable of doing analyses on multiple =
data
records simultaneously. Learned a lot!

Last but the least,  I had trouble applying the diff to the branch libtrace=
event
initially but had to copy and paste on my own.  Just FYI. Still no big deal=
 :)

Thanks,
Ze
