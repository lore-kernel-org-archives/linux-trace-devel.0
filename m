Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E74EC432C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7196921741
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:34:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9PZOn4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfK1Oen (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 09:34:43 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46687 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfK1Oem (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 09:34:42 -0500
Received: by mail-il1-f195.google.com with SMTP id q1so24372941ile.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 06:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRX+x4pv+wOSBHp2HQbWlFqUYzegsvajJ2Atwyz5fjE=;
        b=k9PZOn4H2xAfjDnksejQHm/6Bs7hnD56CwW4g8xByCSdaIcSx8tPHKf9WfNXEdnIz3
         Fo6GMz6RW5tgkX0+35xKgrquylJUGXlcMM9t6JCiJPAnewFXZBYuHgKRRHli+htRdUbi
         /UCD9mtCkFSjbpIEYOUIWcB9iJmVP1nO34fl34/cS6qkSkNk6Ez51ylHjPkZN4t70jS+
         OkQvcGCGZ49oTCBGsNlHvBRGWIwidbFFXBURDa8+0jiajWUhEZ8VBNjidMLGe5xsCKtG
         kijpz2dlwI/OMQXKEV2TUwJHARFvZSZdf8iAVFy4mQQ+d4FWNXy7mWroXOBBgcPdsOyO
         n0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRX+x4pv+wOSBHp2HQbWlFqUYzegsvajJ2Atwyz5fjE=;
        b=ERIRGqm6H4lcrkGzLzBfhdCc+mroyn+CvdPkgNfEgOAmCjoMSITQftqv8LOHTUDg7v
         nZBhy9X2C3Sh8YNnfN3zZobXUScY88nCB1U/oLrQbVU0TNRIQ4gkHXzFa0GDaHNDLGtN
         9rhTDRiMyM7OHd7hQzOQdERiCTqCGCICWCmhZwWVY7mO3uMoMPNZGFHGDWhLXHj3d7UL
         Ht2Y3KZa2dWWQ84YlZtEejWRqngzxjKOSksUKPReZ8WY7Ud/hSaJkXH3Da6EHLyI9efs
         YHRd+nhny7VXEt2iUTJ4TRrvmcmD+xlGlKVjZfeD0L1W/ERr0FWQlbgRBuRofaXK6dgF
         7yfA==
X-Gm-Message-State: APjAAAXYDsIkRKe/luzhTqNsD2ks1Z+cJLwnos+6rpGbbKF8rTTLD2Dq
        4O1ZGXAa6ykT4OfJnXIWQFkAEXZ7O5qy5pW+e1VAB25Fsg==
X-Google-Smtp-Source: APXvYqzot+Poyx8qteheOZ68+pxNVdVi6vrT0Y98lJInUOXNeSESppQY1KJG0WSCr0+xKQfK2oIfCxOefMZyNPLErEk=
X-Received: by 2002:a05:6e02:6c6:: with SMTP id p6mr50169291ils.303.1574951682080;
 Thu, 28 Nov 2019 06:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com> <20191128085409.289684-12-tz.stoyanov@gmail.com>
In-Reply-To: <20191128085409.289684-12-tz.stoyanov@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Nov 2019 16:34:30 +0200
Message-ID: <CAE0o1Ns2X+T_fyz7zR-npzMJ82+4oL-Qvt6q2YLUwgbjJkeDOQ@mail.gmail.com>
Subject: Re: [PATCH v15 11/18] trace-cmd: Exchange tracing IDs between host
 and guest
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

[...]

> diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
> index 1c6e0a3..cc330b7 100644
> --- a/tracecmd/trace-agent.c
> +++ b/tracecmd/trace-agent.c
> @@ -128,6 +128,7 @@ cleanup:
>  static void agent_handle(int sd, int nr_cpus, int page_size)
>  {
>         struct tracecmd_msg_handle *msg_handle;
> +       unsigned long long trace_id;
>         unsigned int *ports;
>         char **argv = NULL;
>         int argc = 0;
> @@ -144,7 +145,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
>         if (!msg_handle)
>                 die("Failed to allocate message handle");
>
> -       ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv, &use_fifos);
> +       ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
> +                                         &use_fifos, &trace_id);

Why is `tracecmd_msg_recv_trace_req` receiving trace_id if it's
getting generated by the agent below?

>         if (ret < 0)
>                 die("Failed to receive trace request");
>
> @@ -153,13 +155,13 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
>
>         if (!use_fifos)
>                 make_vsocks(nr_cpus, fds, ports);
> -
> +       trace_id = tracecmd_generate_traceid();
>         ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
> -                                          ports, use_fifos);
> +                                          ports, use_fifos, trace_id);
>         if (ret < 0)
>                 die("Failed to send trace response");
> -
> -       trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos);
> +       trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
> +                          use_fifos, trace_id);
>
>         free(argv[0]);
>         free(argv);

Cheers,

-- Slavi
