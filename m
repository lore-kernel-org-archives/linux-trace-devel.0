Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BC6C433E1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEB920674
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594134412;
	bh=TdInpyO2y91vBfjn8fUfcz2avXldE2h0eIj7gzUW3xw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=QaS1Hcx7vSGLOGWmlyds/XYMepzt6tEiFFDz9ORNfdCsFuIRRnBtefmcJDJMlEQJL
	 QMPqAqtqU0ZyW+9RVBL/nOWGZUhkwouzD4n6A+p+L4emr/ozTmT1xMXaBQ9VnOPJNQ
	 zpF8dwkq7QWaPo98FqA0v8eFEoPrdvk+p67Iffus=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGGPGw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:06:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34856 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGPGw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 11:06:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id z2so23256340wrp.2;
        Tue, 07 Jul 2020 08:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AANqO2KtTrnNg7izF8K9Ef7gmZmgqgOqPmaDChXpHcA=;
        b=sa/OBK9MEHGvNJlL2di1/oCZ28+SKjjIB/G8YC/GycaBmQzuYCg3mi+ynIA5ZEf8UB
         oCH9QHfRYBIsdEpD1v6whqm4IDVqs7Pzjes4YI8Ei0/Iv9x1w1F78hqmno4iRcPQLZiw
         EWUSNg5GUmFr8f/KKv9XuCLOMXINLYmcdJq1a9ZQ1u+gQKp9Lmnuluu1o45sj4Y63LEc
         avkh0RlOJZXyozwQDHf7i/lxUMBFnjtceeXQwRV0qweW5QToEyZVyufI7LWDSw4hUKad
         VcX0pfMknL1fqN8c3w20oqvP5EsPhuzr8RcFWYwYQ+2U4Sh2VLaw0/MLZweqUIR7G+ao
         x2FA==
X-Gm-Message-State: AOAM530seMoxmaFv4nV9tcj70mu//7PDOOCXxqaQIfSWhyweaGYNIGpj
        QDYjIDNLMn16HJK4sYcUjLl2+SHa9awiiq19uv8=
X-Google-Smtp-Source: ABdhPJzyOCCMUppkRFM+6veT10dqNSeZaEZ3AoXFmVHIX15uwoNBN1baVhmhI8/OiKLtGkpnYvH44nuGkln9GIW1Lsc=
X-Received: by 2002:adf:e901:: with SMTP id f1mr54438313wrm.80.1594134409172;
 Tue, 07 Jul 2020 08:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org> <20200702185704.248123446@goodmis.org>
In-Reply-To: <20200702185704.248123446@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 8 Jul 2020 00:06:38 +0900
Message-ID: <CAM9d7chfvJwodpVrHGc5E2J80peRojmYV_fD8x3cpn9HFRUw2g@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] tools lib traceevent: Introduced new traceevent
 API, for adding new plugins directories.
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

On Fri, Jul 3, 2020 at 3:57 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
>
> Implement new traceevent plugin API, which can be used to add new plugins
> directories:
> enum tep_plugin_load_priority {
>         TEP_PLUGIN_FIRST,
>         TEP_PLUGIN_LAST,
> };
> int tep_add_plugin_path(struct tep_handle *tep, char *path,
>                         enum tep_plugin_load_priority prio);
>
> It adds the "path" as new plugin directory, in the context of
> the handler "tep". The tep_load_plugins() API searches for plugins
> in this new location. Depending of the priority "prio", the plugins
> from this directory are loaded before (TEP_PLUGIN_FIRST) or after
> (TEP_PLUGIN_LAST) the ordinary libtraceevent plugin locations.
>
> Link: http://lore.kernel.org/linux-trace-devel/20191007114947.17104-2-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-6-tz.stoyanov@gmail.com
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse-local.h |  5 +-
>  tools/lib/traceevent/event-parse.c       |  1 +
>  tools/lib/traceevent/event-parse.h       |  7 +++
>  tools/lib/traceevent/event-plugin.c      | 70 ++++++++++++++++++++++++
>  4 files changed, 82 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index cee469803a34..96a0b0ca0675 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -13,6 +13,7 @@ struct func_map;
>  struct func_list;
>  struct event_handler;
>  struct func_resolver;
> +struct tep_plugins_dir;
>
>  struct tep_handle {
>         int ref_count;
> @@ -47,7 +48,6 @@ struct tep_handle {
>         struct printk_list *printklist;
>         unsigned int printk_count;
>
> -
>         struct tep_event **events;
>         int nr_events;
>         struct tep_event **sort_events;
> @@ -81,10 +81,13 @@ struct tep_handle {
>
>         /* cache */
>         struct tep_event *last_event;
> +
> +       struct tep_plugins_dir *plugins_dir;
>  };
>
>  void tep_free_event(struct tep_event *event);
>  void tep_free_format_field(struct tep_format_field *field);
> +void tep_free_plugin_paths(struct tep_handle *tep);
>
>  unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
>  unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index e1bd2a93c6db..064c100d2d5a 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -7065,6 +7065,7 @@ void tep_free(struct tep_handle *tep)
>         free(tep->events);
>         free(tep->sort_events);
>         free(tep->func_resolver);
> +       tep_free_plugin_paths(tep);
>
>         free(tep);
>  }
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 02c0438527de..91f462f5a606 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -393,6 +393,13 @@ struct tep_plugin_list;
>
>  #define INVALID_PLUGIN_LIST_OPTION     ((char **)((unsigned long)-1))
>
> +enum tep_plugin_load_priority {
> +       TEP_PLUGIN_FIRST,
> +       TEP_PLUGIN_LAST,
> +};
> +
> +int tep_add_plugin_path(struct tep_handle *tep, char *path,
> +                       enum tep_plugin_load_priority prio);
>  struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
>  void tep_unload_plugins(struct tep_plugin_list *plugin_list,
>                         struct tep_handle *tep);
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> index e8f4329ba8e0..1d4f1809cf17 100644
> --- a/tools/lib/traceevent/event-plugin.c
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -39,6 +39,12 @@ struct tep_plugin_list {
>         void                    *handle;
>  };
>
> +struct tep_plugins_dir {
> +       struct tep_plugins_dir          *next;
> +       char                            *path;
> +       enum tep_plugin_load_priority   prio;
> +};
> +
>  static void lower_case(char *str)
>  {
>         if (!str)
> @@ -544,6 +550,7 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
>                                                void *data),
>                            void *data)
>  {
> +       struct tep_plugins_dir *dir = NULL;
>         char *home;
>         char *path;
>         char *envdir;
> @@ -552,6 +559,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
>         if (tep && tep->flags & TEP_DISABLE_PLUGINS)
>                 return;
>
> +       if (tep)
> +               dir = tep->plugins_dir;
> +       while (dir) {
> +               if (dir->prio == TEP_PLUGIN_FIRST)
> +                       load_plugins_dir(tep, suffix, dir->path,
> +                                        load_plugin, data);
> +               dir = dir->next;
> +       }
> +
>         /*
>          * If a system plugin directory was defined,
>          * check that first.
> @@ -586,6 +602,15 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
>
>         load_plugins_dir(tep, suffix, path, load_plugin, data);
>
> +       if (tep)
> +               dir = tep->plugins_dir;
> +       while (dir) {
> +               if (dir->prio == TEP_PLUGIN_LAST)
> +                       load_plugins_dir(tep, suffix, dir->path,
> +                                        load_plugin, data);
> +               dir = dir->next;
> +       }
> +
>         free(path);
>  }
>
> @@ -598,6 +623,51 @@ tep_load_plugins(struct tep_handle *tep)
>         return list;
>  }
>
> +/**
> + * tep_add_plugin_path - Add a new plugin directory.
> + * @tep: Trace event handler.
> + * @path: Path to a directory. All files with extension .so in that

Is the extension (".so") fixed?  I think a new API has the suffix argument
which may change it... ?


> + *       directory will be loaded as plugins.
> + *@prio: Load priority of the plugins in that directory.
> + *
> + * Returns -1 in case of an error, 0 otherwise.
> + */
> +int tep_add_plugin_path(struct tep_handle *tep, char *path,
> +                       enum tep_plugin_load_priority prio)
> +{
> +       struct tep_plugins_dir *dir;
> +
> +       if (!tep || !path)
> +               return -1;
> +
> +       dir = calloc(1, sizeof(*dir));
> +       if (!dir)
> +               return -1;
> +
> +       dir->path = strdup(path);

It needs to check the return value..

Thanks
Namhyung


> +       dir->prio = prio;
> +       dir->next = tep->plugins_dir;
> +       tep->plugins_dir = dir;
> +
> +       return 0;
> +}
> +
> +void tep_free_plugin_paths(struct tep_handle *tep)
> +{
> +       struct tep_plugins_dir *dir;
> +
> +       if (!tep)
> +               return;
> +
> +       dir = tep->plugins_dir;
> +       while (dir) {
> +               tep->plugins_dir = tep->plugins_dir->next;
> +               free(dir->path);
> +               free(dir);
> +               dir = tep->plugins_dir;
> +       }
> +}
> +
>  void
>  tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
>  {
> --
> 2.26.2
>
>
