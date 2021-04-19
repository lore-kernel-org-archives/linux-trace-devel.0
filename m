Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FCBC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 04:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E908561090
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 04:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhDSEwA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 00:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhDSEvz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 00:51:55 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46610C06174A
        for <linux-trace-devel@vger.kernel.org>; Sun, 18 Apr 2021 21:50:19 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m12so2675766pgr.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 18 Apr 2021 21:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qCGDfzHwy+nRl9Wk93v23EqCpfkXlP9D8rkUTOrNCUs=;
        b=X04u21NAAhgTm0ip4zJ/8y1PS9HaxiaKYx0KOkqx38g1g6opPuYlZIcNKJp3yaaf8K
         KmF6gtI4UDfWYT+bvKDoS9P46xdZjn9QDfw6Re4osesLpJa4IwIeKBdDAj3LOmzI+Fhp
         1dfWT6Ne0g+s5t9Uf8MjgZB+Mc0oA+vkwQYvQAhe6JWNfVpHca7lgPGNadWD9mr2p6w3
         90prWEe/sxJphphD95TFkiMmLJc6Kz/22tw39m4N40G0MxOWIvPsVahkpH1p8GuC+l2+
         4XSOCFSioib57o+vS8kPWk6/VHwc2unBlgHYLyl0l0Zs0DY5w5uhz34ihbenocfD6aZk
         FRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCGDfzHwy+nRl9Wk93v23EqCpfkXlP9D8rkUTOrNCUs=;
        b=nFcTtBxZUYTj+5yPJaMF/tl1yPyByUjl6pbIEfPSh/c18ijEZT+fLYbdR05Tfz4UfU
         bVBe9QsOZgPap91olPzVBDuBdwSuS64rt1c3at/Mu88tY/bBJ5BNp8lqXfwP5NHhVJGo
         bjVmDdbYLOChpujzM7yIk3o4e1fgNZUwio+YeZmdbDwim+Bu5Od31rfqfz4PohgbunFn
         DTPBqfB2zQCcSEMjp2U4Nx8XrLqh6YiAX0qSfFOvTIkS/VTKUw6JnZ+FC56AE1KSu6gH
         O2LzwzlBsTtX08/H/2iWUkWhtmYb1sGdgJiREVGRnntAGZn5yR075HoAEYzebCoCuPHF
         Q9fw==
X-Gm-Message-State: AOAM531fiUxG5xcrWe344AFcQ9NNEsQac0UddjAtJF3dsb3Tusjif/Pf
        QDaetNM6EVdO5DTjSY3BWBBsi4zt7hNFE9lW3290cbDNxp8=
X-Google-Smtp-Source: ABdhPJybaQ4ry+YkWnWpGDy2pqrqJVhAq9AXXWSlMEBy7wOOf0Zmh+D4KrNGM3317lEWe10sQVryY3BPZH2v7Tfvn9M=
X-Received: by 2002:a65:418a:: with SMTP id a10mr9893477pgq.307.1618807818812;
 Sun, 18 Apr 2021 21:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210416172331.3870833-1-rostedt@goodmis.org> <20210416172331.3870833-2-rostedt@goodmis.org>
In-Reply-To: <20210416172331.3870833-2-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 19 Apr 2021 07:50:02 +0300
Message-ID: <CAPpZLN7MJUQS0xbDJSK2F+T6LdsLn3q_f4+jRTgiV+ODa+1uAg@mail.gmail.com>
Subject: Re: [PATCH 1/3] trace-cmd list: Have -o read the options directory
 instead of file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 16, 2021 at 9:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> The trace_options file only shows the options that are available when a
> tracer is set. This is annoying as one needs to enable the tracer in order
> to see all the options that are available.
>
> Starting with Linux v4.4, all tracers options are displayed in the options
> directory. Walk through the options directory instead of simply reading
> the trace_options file.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tracecmd/trace-list.c | 48 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
>
> diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
> index 63216b43..0ba49853 100644
> --- a/tracecmd/trace-list.c
> +++ b/tracecmd/trace-list.c
> @@ -255,13 +255,57 @@ static void show_tracers(void)
>         show_file("available_tracers");
>  }
>
> -
>  static void show_options(void)
>  {
> +       struct dirent *dent;
> +       struct stat st;
> +       char *path;
> +       DIR *dir;
> +
> +       path = tracefs_get_tracing_file("options");
> +       if (!path)
> +               goto show_file;
> +       if (stat(path, &st) < 0)
> +               goto show_file;
> +
> +       if ((st.st_mode & S_IFMT) != S_IFDIR)
> +               goto show_file;
> +
> +       dir = opendir(path);
> +       if (!dir)
> +               die("Can not read instance directory");
> +
> +       while ((dent = readdir(dir))) {
> +               const char *name = dent->d_name;
> +               long long val;
> +               char *file;
> +               int ret;
> +
> +               if (strcmp(name, ".") == 0 ||
> +                   strcmp(name, "..") == 0)
> +                       continue;
> +
> +               ret = asprintf(&file, "options/%s", name);
> +               if (ret < 0)
> +                       die("Failed to allocate file name");
> +               ret = tracefs_instance_file_read_number(NULL, file, &val);
> +               if (!ret) {
> +                       if (val)
> +                               printf("%s\n", name);
> +                       else
> +                               printf("no%s\n", name);
> +               }
> +               free(file);
> +       }
> +       closedir(dir);
> +       tracefs_put_tracing_file(path);
> +       return;
> +
> + show_file:
> +       tracefs_put_tracing_file(path);
>         show_file("trace_options");
>  }

The libtracefs options APIs can be used, instead of walking through
the directory:

struct tracefs_options_mask *all = tracefs_options_get_supported(NULL);
struct tracefs_options_mask *enabled = tracefs_options_get_enabled(NULL);
char *name;

for (int i = 1; i < TRACEFS_OPTION_MAX; i++) {
        if (!tracefs_option_mask_is_set(all, i))
                continue;
        name = tracefs_option_name(i);
        if (!tracefs_option_mask_is_set(enabled, i))
                printf("%s\n", name);
        else
                printf("no%s\n", name);
}

>
> -
>  static void show_clocks(void)
>  {
>         char *clocks;
> --
> 2.29.2
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
