Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BB88F70
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jul 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721664358; cv=none; b=cvjmoG2bSjnQU2O/ZDofWLu4w3y0nPyATgiEsZfCY0ogpzHUPaWrGIz+10emHLsQsBxZJ1slcm4VbVilYyABoS5TuR59KjDtre3449pxgWdnouySJUeZfVfscTCC30Vs3hZaHP0N3p3GDQ5E+j0hKtiI2WCjV6fUaFAOxA/OSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721664358; c=relaxed/simple;
	bh=UAnd6vGlq9/SiJwqmpluSmuSp68l98P48itfPLcwZ3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAEpdwaGauc3TQBtz+T9bgNQidpfaCe1mn5671LwXU9vZSkMsyUEiXoBK+7G3WozkrMbUXnaBh45vFMxu/Ib8U1WyCIBBu7rVr76hLkYaQuHqh0rmzPXLA4Ga4FBZ6vp9/Hl8vm0CbTqbpjgfTmIXDBMQ0UzYGA59jGrrE+BW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cb566d528aso2794003a91.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jul 2024 09:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721664356; x=1722269156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/E25nOgcIMMR4aTYe8UsfQEo7tetNHJqKzNHi90Evk=;
        b=mJmUsvFhz8iCP3G66qI7MOMLzE9ItVcNyVyAg6/XXAZL7f8T6xSYWRoXN0dfSL4L6T
         hBNqRldznGTY9sU9l+BczTJ4A2Ig8bhfvXN3+NbEXCGf2kcKc1+4T2Zr823zhScZSyLu
         88pL7KYanAjbPNiHq83jg2PukrZqbkKHji65h7gVZJZCSKdSkJ48bElv87UHLwtaleiN
         QWX2PE4QBoh52zv29jrgbsEJXKjBlk5zw3MKroTCXqZ4lKJqqjjoYzxkOy6BIeS4pDx2
         w08uWT6tqdW3hsXmo0lBeqHauNE2axHMRozwUrm0J/obXXk9MOFKJIyTR9dc5czTysp6
         cWZw==
X-Gm-Message-State: AOJu0Yz/cXmfiYD2vtj3V/FKB/KUiAHXSYxsED+vPAl+e+cKKTB1N22P
	gEZWQQVGaxOyJk1LMCzAb9lyou4r9i+IwQLqIW4c9weDNdIwXuMdtyjeMFaCLlGtH9X/zXUkWnH
	3YiigHQiHjlXawGrfS6PqOa/yVxQ=
X-Google-Smtp-Source: AGHT+IHCKmycogB9M0fukmh9EwVDjjF/rbN10RuTuw5cXDRHY2jExIJCDr2iXN9s894PdHDNEOrMKS5N5z5hT+FX7Ao=
X-Received: by 2002:a17:90a:7e16:b0:2cb:4f14:2a70 with SMTP id
 98e67ed59e1d1-2cd274ac104mr5893171a91.30.1721664355681; Mon, 22 Jul 2024
 09:05:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240626033949.1017381-1-namhyung@google.com> <20240719163242.690f4c0e@gandalf.local.home>
 <20240719163913.3684eaaa@gandalf.local.home>
In-Reply-To: <20240719163913.3684eaaa@gandalf.local.home>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 22 Jul 2024 09:05:43 -0700
Message-ID: <CAM9d7ciN8a6KRyu4QUKOZgmBNiSxTKvq2iZs8vfv--Yt=Mwd1g@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Fix a double free in process_op()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Fri, Jul 19, 2024 at 1:39=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Fri, 19 Jul 2024 16:32:41 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Perhaps the real fix was:
>
> Or better yet, something a bit cleaner, as I found another location that
> needs an update.

Looks good, I'll send v2 with this.

Thanks,
Namhyung

>
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 9f0522c8d9e4..d44da8baf087 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2197,21 +2197,24 @@ static int set_op_prio(struct tep_print_arg *arg)
>         return arg->op.prio;
>  }
>
> -static int consolidate_op_arg(struct tep_print_arg *arg)
> +static int consolidate_op_arg( enum tep_event_type type, struct tep_prin=
t_arg *arg)
>  {
>         unsigned long long val, left, right;
>         int ret =3D 0;
>
> +       if (type =3D=3D TEP_EVENT_ERROR)
> +               return -1;
> +
>         if (arg->type !=3D TEP_PRINT_OP)
>                 return 0;
>
>         if (arg->op.left)
> -               ret =3D consolidate_op_arg(arg->op.left);
> +               ret =3D consolidate_op_arg(type, arg->op.left);
>         if (ret < 0)
>                 return ret;
>
>         if (arg->op.right)
> -               ret =3D consolidate_op_arg(arg->op.right);
> +               ret =3D consolidate_op_arg(type, arg->op.right);
>         if (ret < 0)
>                 return ret;
>
> @@ -2375,8 +2378,6 @@ process_op(struct tep_event *event, struct tep_prin=
t_arg *arg, char **tok)
>
>                 /* it will set arg->op.right */
>                 type =3D process_cond(event, arg, tok);
> -               if (type =3D=3D TEP_EVENT_ERROR)
> -                       free(token);
>
>         } else if (strcmp(token, ">>") =3D=3D 0 ||
>                    strcmp(token, "<<") =3D=3D 0 ||
> @@ -2587,7 +2588,7 @@ static int alloc_and_process_delim(struct tep_event=
 *event, char *next_token,
>         if (type =3D=3D TEP_EVENT_OP) {
>                 type =3D process_op(event, field, &token);
>
> -               if (consolidate_op_arg(field) < 0)
> +               if (consolidate_op_arg(type, field) < 0)
>                         type =3D TEP_EVENT_ERROR;
>
>                 if (type =3D=3D TEP_EVENT_ERROR)
> @@ -3818,7 +3819,7 @@ static int event_read_print_args(struct tep_event *=
event, struct tep_print_arg *
>                         type =3D process_op(event, arg, &token);
>                         free_token(token);
>
> -                       if (consolidate_op_arg(arg) < 0)
> +                       if (consolidate_op_arg(type, arg) < 0)
>                                 type =3D TEP_EVENT_ERROR;
>
>                         if (type =3D=3D TEP_EVENT_ERROR) {
>
>
> -- Steve
