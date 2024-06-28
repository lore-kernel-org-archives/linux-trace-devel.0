Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7D21DFFB
	for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2024 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588898; cv=none; b=IS+4wQvxyqP23z9oJHefHjOuHk1bUMPoiyywmI0/VArnP7VZaDfXjAM0nZzKZy84w4Ajj3Fi9w7alB7+GFAdI9aWO+tv3dQXkf3SjiU3hBqC2Jji7G9I2tq40AibQWJoMTkbGWzCGup5jJJFYvD5RRXuf+tRV6sTewRaRvTehQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588898; c=relaxed/simple;
	bh=vhPZ1SwllqoOYXgoJHYy4C8Gjfzzm7y/ZMVeBogGeyI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXpPrPpW1/XeaXyb4lulbbpm57vaoXgM0s8z3lEZ0xQTbGWCbUHFX/B3rtvYvKTFQfVy3Xfg0JcSdXADG8hxgPLjQ3HR7xB3badkBiKLgDNFMZmt/scqKnD38ywJRk7Tcc6fbcuJPNFH4Lv+yT/baTSJgqQwgy/CKEkq5Bz3mj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1239FC116B1;
	Fri, 28 Jun 2024 15:34:57 +0000 (UTC)
Date: Fri, 28 Jun 2024 11:34:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Totoro W <tw19881113@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] fix double free issue in event_read_print_args
Message-ID: <20240628113456.730030af@rorschach.local.home>
In-Reply-To: <CAFrM9zvV9oHvCpVmt3un-wMFJFoyXq7SOWTOENpDGrn_HQQDDQ@mail.gmail.com>
References: <CAFrM9zvV9oHvCpVmt3un-wMFJFoyXq7SOWTOENpDGrn_HQQDDQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Jun 2024 09:51:10 +0800
Totoro W <tw19881113@gmail.com> wrote:

> Oops, missing the patch part, here it is:

Could you send a v2 with all the contents.

Thanks,

-- Steve

> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 9f0522c..1f51ee9 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2375,8 +2375,6 @@ process_op(struct tep_event *event, struct
> tep_print_arg *arg, char **tok)
> 
>                 /* it will set arg->op.right */
>                 type = process_cond(event, arg, tok);
> -               if (type == TEP_EVENT_ERROR)
> -                       free(token);
> 
>         } else if (strcmp(token, ">>") == 0 ||
>                    strcmp(token, "<<") == 0 ||
> @@ -3787,7 +3785,7 @@ static int event_read_print_args(struct
> tep_event *event, struct tep_print_arg *
>  {
>         enum tep_event_type type = TEP_EVENT_ERROR;
>         struct tep_print_arg *arg;
> -       char *token;
> +       char *token = NULL;
>         int args = 0;
> 
>         do {
> @@ -3817,6 +3815,7 @@ static int event_read_print_args(struct
> tep_event *event, struct tep_print_arg *
>                 if (type == TEP_EVENT_OP) {
>                         type = process_op(event, arg, &token);
>                         free_token(token);
> +                       token = NULL;
> 
>                         if (consolidate_op_arg(arg) < 0)
>                                 type = TEP_EVENT_ERROR;

