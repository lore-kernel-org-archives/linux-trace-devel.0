Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0125BC432C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCB92176D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJajoTOa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfK1Opk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 09:45:40 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:35412 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfK1Opk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 09:45:40 -0500
Received: by mail-il1-f194.google.com with SMTP id g12so14978557ild.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 06:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GLTK92kF0HgWdHvc2vLhBKyOYAd8NGuT+ogMYTGCL5E=;
        b=AJajoTOavp4f4fnJ7ofHGAxfRySV11yXkg+sTo8H8UolgQmhaMY7tZ0B5yaH0J6bzr
         uerue3iqXzJeyDE5aZFziHDzBELJ8CmnLBKgb4wZM3BIq3A0oYQJHxKl6rg1x5tF5UxN
         FC8YWKOC+je8KedzAnpCmy92OsmEEN5u9Pgeb7nNz4JUSsEckmL9a8ukZ2rGcs4MrDr2
         B/3+MIFuEvd+kvMGfZUE6EIFkXJGtfeIT+HkN2RhQx8U2UTuw/WWPKM0EFRvZtu26r5U
         nHL07rgEcZe1oh2q0K9M7KP3KMGxLsM2MutcqqB4JMrVrAqbTQUlBzRfeBn1Bzqu8p43
         bJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GLTK92kF0HgWdHvc2vLhBKyOYAd8NGuT+ogMYTGCL5E=;
        b=HhfpzOrKe0HbdaIl+RtByCEXUBizckXO9TMKnxVlH4EFWwa89DmgN5QVhomj4BISJY
         6RGip15PV7HT0TCK98TwuJQ/UjbB0oCqy3CbvblonYFF5qpbgXN7wCuWPpWdbL6jpFV5
         1as8fFXQ+rRBX39X6vhp8PCJFPNgfCw7vUrAdhb9kixYcJzklJ9yqSPpMLC+bRFIjN8G
         7nv9HEoATDXqvt1ZXZz8gG6PtepYj2xFsAE1HI9kuz+RSXvKBhU2VFOMNZ7l3FSCe6Zj
         RY9PYZ3JpxlVzO681EOohLeDhzvLqIQGrLfP3PhZzHm8BijJgIjIty2IgEokIYDjSeRq
         wmuw==
X-Gm-Message-State: APjAAAVO/3rRDfizjEUmIPzxZg+29KpiHx0ZQFwGgvtbAawooHsYqc6U
        j8ghN+w6UdboSF+avxf+W5jB/GNkrTEIEKob5Q==
X-Google-Smtp-Source: APXvYqxXiuzqUMMqud7otDBNP63pQWJejOy788DHM1lRKYN0T1DTnd+pIFFWFoU+biKzPXHNPsEN25qjtRKe2ViZMJI=
X-Received: by 2002:a92:bf08:: with SMTP id z8mr18036318ilh.11.1574952339376;
 Thu, 28 Nov 2019 06:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com> <20191128085409.289684-15-tz.stoyanov@gmail.com>
In-Reply-To: <20191128085409.289684-15-tz.stoyanov@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Nov 2019 16:45:28 +0200
Message-ID: <CAE0o1NvU+112Y-HkurJZHKj0ARW3mJvEquF6aB39KLkcnNkrQA@mail.gmail.com>
Subject: Re: [PATCH v15 14/18] trace-cmd: Add host trace clock as guest trace argument
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 11:01 AM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> When tracing host and guest machines, both should use the same
> tracing clock for event timestamps. If a clock is specified
> as host tracing argument, with option "-C clock_name", the same
> is injected as guest tracing argument. If the user wants to use
> different tracing clocks, it can specify it using "-C clock_name"
> as guest tracing argument. In that case, the one specified by
> the user has higher priority.
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 49730d6..e7fb1bd 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
>         char *sav;
>         int name_counter = 0;
>         int neg_event = 0;
> +       struct buffer_instance *instance;
> +       bool guest_config = false;

guest_config is a bit vague of a name for what it's used here. Maybe
has_clock_arg?

>
>         init_common_record_context(ctx, curr_cmd);
>
> @@ -5562,6 +5564,7 @@ static void parse_record_options(int argc,
>                         break;
>                 case 'C':
>                         ctx->instance->ftrace->clock = optarg;
> +                       guest_config = true;
>                         break;
>                 case 'v':
>                         neg_event = 1;
> @@ -5779,14 +5782,26 @@ static void parse_record_options(int argc,
>
>         /* If --date is specified, prepend it to all guest VM flags */
>         if (ctx->date) {
> -               struct buffer_instance *instance;
> -
>                 for_all_instances(instance) {
>                         if (is_guest(instance))
>                                 add_argv(instance, "--date", true);
>                 }
>         }
>
> +       if (guest_config) {
> +               /* If -C is specified, prepend clock to all guest VM flags */
> +               for_all_instances(instance) {
> +                       if (top_instance.ftrace->clock) {
> +                               if (is_guest(instance)) {
> +                                       add_argv(instance,
> +                                                (char *)top_instance.ftrace->clock,
> +                                                true);
> +                                       add_argv(instance, "-C", true);

Shouldn't those two add_arvgv() calls be swapped?

> +                               }
> +                       }
> +               }
> +       }
> +
>         if (!ctx->filtered && ctx->instance->filter_mod)
>                 add_func(&ctx->instance->filter_funcs,
>                          ctx->instance->filter_mod, "*");
> --
> 2.23.0
>

Cheers,

-- Slavi
