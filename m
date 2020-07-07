Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB128C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 14:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81DA320773
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594133748;
	bh=aHocRiSUxiusQJVW3h6x7684Mvq5u9pKr23eOxvna4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=H+MC6Ph41c+DJlQ9aXS3SAdiU/MGGX8k2soOBENziqu7F28/+PpprGwcXo+bYhbBA
	 3l4g3gEE2x26D5XP90D0Mwljxbrrs+UE2b6H+m3IF1bA5JxU7TNG8jj9eYmHs5m5eG
	 Oi2lcGspMby2HCrxJbHThLEmV79t6H0QpLda0EPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgGGOzs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:55:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40442 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgGGOzr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 10:55:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id f139so46871843wmf.5;
        Tue, 07 Jul 2020 07:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVk7panNQ6v9maJMNYGJyJFPDhFb8C1XdWOE6GaZmDo=;
        b=Mf/cwMRbVC7yMED1r/gGW4jSswFN/qv5pIM2pRUWwrxl2+pNJbui/Gx/evfyX7+UWp
         NcXkx/+5X72qejB3zD4pg2fWEqam15DwAoojumfoE7l2bJonJN6JD10pnJU0W975qouT
         XnWTSG5wKY5gLMb4/2sPofqus70F77T9npsl9AJINAvQJyQxGv27OZijCV2FmS36zvPt
         3+eECdmWHnx3hwYKgpQnjm5qHHixa+vV7ekFTqr/C5l4dHYOV+ICnSkL7fOhjLK3Cnsc
         TohAo/4UqHftRIZmET94UAlZM6LDOmzbnWVF2IuzGEdkH01lWbmM7Bla18f+6jTeiyDJ
         NAwA==
X-Gm-Message-State: AOAM532cWQfDD/Su+I505EpHM3H2suzm4DMI676fz5XPR41vvDmRXK4k
        0zeLjsDN3dnApmA5MJYH1c1wc2WSytGhks/evU8=
X-Google-Smtp-Source: ABdhPJwI4SEGicEFTStrXGPXnf0reXhLqLPKVodm4fV0CGLtP7Cm22Kn4tTG4alEoR8IeihwACfrTt5uH9ookEHpGqY=
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr4872746wmc.154.1594133745559;
 Tue, 07 Jul 2020 07:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org> <20200702185703.946652691@goodmis.org>
In-Reply-To: <20200702185703.946652691@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 7 Jul 2020 23:55:34 +0900
Message-ID: <CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/15] tools lib traceevent: Add tep_load_plugins_hook()
 API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve and Tzvetomir,

On Fri, Jul 3, 2020 at 3:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
>
> Add the API function tep_load_plugins_hook() to the traceevent API to allow
> tools a common method to load in the plugins that are part of the lib
> traceevent library.
>
> Link: http://lore.kernel.org/linux-trace-devel/20190802110101.14759-4-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-4-tz.stoyanov@gmail.com
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse.h  |  6 ++++++
>  tools/lib/traceevent/event-plugin.c | 19 +++++++++----------
>  2 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index b77837f75a0d..776c7c24ee79 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -396,6 +396,12 @@ struct tep_plugin_list;
>  struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
>  void tep_unload_plugins(struct tep_plugin_list *plugin_list,
>                         struct tep_handle *tep);
> +void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
> +                          void (*load_plugin)(struct tep_handle *tep,
> +                                              const char *path,
> +                                              const char *name,
> +                                              void *data),
> +                          void *data);
>  char **tep_plugin_list_options(void);
>  void tep_plugin_free_options_list(char **list);
>  int tep_plugin_add_options(const char *name,
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> index e1f7ddd5a6cf..b53d9a53bcf9 100644
> --- a/tools/lib/traceevent/event-plugin.c
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -365,20 +365,19 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
>         closedir(dir);
>  }
>
> -static void
> -load_plugins(struct tep_handle *tep, const char *suffix,
> -            void (*load_plugin)(struct tep_handle *tep,
> -                                const char *path,
> -                                const char *name,
> -                                void *data),
> -            void *data)
> +void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
> +                          void (*load_plugin)(struct tep_handle *tep,
> +                                              const char *path,
> +                                              const char *name,
> +                                              void *data),
> +                          void *data)

Can we have a comment (or a doc) for this API?  I'm not sure how it's used..


>  {
>         char *home;
>         char *path;
>         char *envdir;
>         int ret;
>
> -       if (tep->flags & TEP_DISABLE_PLUGINS)
> +       if (tep && tep->flags & TEP_DISABLE_PLUGINS)
>                 return;

Is it ok to call with a NULL tep handle?

Thanks
Namhyung


>
>         /*
> @@ -386,7 +385,7 @@ load_plugins(struct tep_handle *tep, const char *suffix,
>          * check that first.
>          */
>  #ifdef PLUGIN_DIR
> -       if (!(tep->flags & TEP_DISABLE_SYS_PLUGINS))
> +       if (!tep || !(tep->flags & TEP_DISABLE_SYS_PLUGINS))
>                 load_plugins_dir(tep, suffix, PLUGIN_DIR,
>                                  load_plugin, data);
>  #endif
> @@ -423,7 +422,7 @@ tep_load_plugins(struct tep_handle *tep)
>  {
>         struct tep_plugin_list *list = NULL;
>
> -       load_plugins(tep, ".so", load_plugin, &list);
> +       tep_load_plugins_hook(tep, ".so", load_plugin, &list);
>         return list;
>  }
>
> --
> 2.26.2
>
>
