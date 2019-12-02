Return-Path: <SRS0=ia4w=ZY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A6BC432C0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 07:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2292146E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 07:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="er9g8Emq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLBHyW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:54:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44957 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfLBHyW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 02:54:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id d199so13417079pfd.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 01 Dec 2019 23:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hyoxRBARKYPdwDfvliPiv0Aph54ccarBCI8C6PUL0g8=;
        b=er9g8Emq4Ma9dWKbswyhvjnx0zdRQnRcQg4t6T/P8AOyFxYdx1QouSZXnd/N2GW0kR
         d+LIdhFHQ7IJHLdUfBNwfX8n8Af4wObEz8KdbT7Vx/ukQdgDryuZWMEnlnP5PszNp4pQ
         w6IcAnkC2fF2uiknwLDajvaNVOcRJIPzMKt+WSLCW58+lUiHgQXa2z5NECYO4ji5KnEo
         5UtUgRHwZpA78kxeURi+NbjncPd/wY9w6YZpJ597SstQrlP0ubEO5OUvAw1ZaFAjvXXh
         fKbp5RaojVNZieAUpiIka50KL+ju+KnIsOVrFPp8b9TL6Wuad5StZwYa6QQpAt0E82LA
         nNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyoxRBARKYPdwDfvliPiv0Aph54ccarBCI8C6PUL0g8=;
        b=jDfNEifkTdZupfA3Zx+wo6nsxqdrTd0oVq6j6aro0Ue1VTk47KjE8MrMDxMLFR6JkN
         CwW70cijbG+JkEioQFgDVsC1VrGyUvjAas++3fon5nYwVrUjnlcQGCd+e+qAAx/HXScz
         y8H77CJGzX+kdoAaeHLpFa6KIxUsLvldRASXh0va1eqMMz1tlxs1WeBcApbexWrusPTN
         69yDeXUojpC9quACv+7OFkzazt44QulTWcTLyIoyZcTvfQMVr0vWhlgDALpPO3cnfg44
         +MDT2MsPUFg9qOYoHZtfgPAGGV8oOx/+5qoPWGFapuBfH/DtsY0wz2OHC80YpUyYJld2
         4czQ==
X-Gm-Message-State: APjAAAWaCPWQOOar9ytjpit6EYrKFMrkqTXXAXFm/qlE2qC3ySdVK+7g
        PsLR1CzbWeHhkttwq1wQMz0AU19Pyq2f1+4Rb5j1HV4zG/8=
X-Google-Smtp-Source: APXvYqxhAr2xiMA/FZ7utHzp1XzQb5B4G9QFEo1dD1WkudtUOVTWMNpImhuzbITL30+FOgP3OTEigeKCsX6V/HWHJcM=
X-Received: by 2002:a62:7883:: with SMTP id t125mr17148604pfc.141.1575273261173;
 Sun, 01 Dec 2019 23:54:21 -0800 (PST)
MIME-Version: 1.0
References: <20191007114947.17104-1-tz.stoyanov@gmail.com> <20191007114947.17104-3-tz.stoyanov@gmail.com>
In-Reply-To: <20191007114947.17104-3-tz.stoyanov@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 2 Dec 2019 09:54:09 +0200
Message-ID: <CAPpZLN4hxVZEJyY5f4FZin+B34HMk5V4=K49ixkpFki5sJB7TA@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ping.

I think this will be useful in avoiding problems like
https://bugzilla.kernel.org/show_bug.cgi?id=205643

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center



On Mon, Oct 7, 2019 at 2:49 PM Tzvetomir Stoyanov (VMware)
<tz.stoyanov@gmail.com> wrote:
>
> When a development version of trace-cmd is built and run on the machine,
> by default it loads only installed plugins, from system directories.
> Thus, the development plugins will not be loaded. To simplify the development
> process, a new logic is added:
>   At plugins load time, check the location of trace-cmd application and look
>   for "plugins" directory around it. If found, load plugins from it. Those
>   plugins will be loaded last, so in case of duplication the "development"
>   plugins win.
> A two new APIs are introduced to libtraceevent, in order to accomplish this
> logic:
>  tep_load_plugins_dir() - loads tep plugins from a specific directory.
>  tep_plugins_append() - Append two plugin lists.
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h |  2 ++
>  lib/trace-cmd/trace-input.c   |  7 +-----
>  lib/trace-cmd/trace-util.c    | 42 +++++++++++++++++++++++++++++++++++
>  tracecmd/trace-check-events.c |  7 +-----
>  tracecmd/trace-list.c         | 14 ++----------
>  5 files changed, 48 insertions(+), 24 deletions(-)
>
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 4090eba..d1aaef8 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -24,6 +24,8 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
>  extern int tracecmd_disable_sys_plugins;
>  extern int tracecmd_disable_plugins;
>
> +struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep);
> +
>  char **tracecmd_event_systems(const char *tracing_dir);
>  char **tracecmd_system_events(const char *tracing_dir, const char *system);
>  struct tep_handle *tracecmd_local_events(const char *tracing_dir);
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 6102eb3..28da455 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2886,15 +2886,10 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
>         if (!handle->pevent)
>                 goto failed_read;
>
> -       if (tracecmd_disable_plugins)
> -               tep_set_flag(handle->pevent, TEP_DISABLE_PLUGINS);
> -       if (tracecmd_disable_sys_plugins)
> -               tep_set_flag(handle->pevent, TEP_DISABLE_SYS_PLUGINS);
> -
>         /* register default ftrace functions first */
>         tracecmd_ftrace_overrides(handle, &handle->finfo);
>
> -       handle->plugin_list = tep_load_plugins(handle->pevent);
> +       handle->plugin_list = trace_load_plugins(handle->pevent);
>
>         tep_set_file_bigendian(handle->pevent, buf[0]);
>         tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 8aa3b6c..690a135 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -860,6 +860,48 @@ void trace_util_free_plugin_files(char **files)
>         free(files);
>  }
>
> +static char *get_source_plugins_dir(void)
> +{
> +       char *p, path[PATH_MAX+1];
> +       int ret;
> +
> +       ret = readlink("/proc/self/exe", path, PATH_MAX);
> +       if (ret > PATH_MAX || ret < 0)
> +               return NULL;
> +
> +       dirname(path);
> +       p = strrchr(path, '/');
> +       if (!p)
> +               return NULL;
> +       /* Check if we are in the the source tree */
> +       if (strcmp(p, "/tracecmd") != 0)
> +               return NULL;
> +
> +       strcpy(p, "/lib/traceevent/plugins");
> +       return strdup(path);
> +}
> +
> +struct tep_plugin_list*
> +trace_load_plugins(struct tep_handle *tep)
> +{
> +       struct tep_plugin_list *list;
> +       char *path;
> +
> +       if (tracecmd_disable_plugins)
> +               tep_set_flag(tep, TEP_DISABLE_PLUGINS);
> +       if (tracecmd_disable_sys_plugins)
> +               tep_set_flag(tep, TEP_DISABLE_SYS_PLUGINS);
> +
> +       path = get_source_plugins_dir();
> +       if (path)
> +               tep_add_plugin_path(tep, path, TEP_PLUGIN_LAST);
> +       free(path);
> +
> +       list = tep_load_plugins(tep);
> +
> +       return list;
> +}
> +
>  char *tracecmd_get_tracing_file(const char *name)
>  {
>         static const char *tracing;
> diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
> index b09fcd0..ffaae27 100644
> --- a/tracecmd/trace-check-events.c
> +++ b/tracecmd/trace-check-events.c
> @@ -43,12 +43,7 @@ void trace_check_events(int argc, char **argv)
>         if (!pevent)
>                 exit(EINVAL);
>
> -       if (tracecmd_disable_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
> -       if (tracecmd_disable_sys_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
> -
> -       list = tep_load_plugins(pevent);
> +       list = trace_load_plugins(pevent);
>         ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
>         if (ret || parsing_failures)
>                 ret = EINVAL;
> diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
> index 65099a5..6b59117 100644
> --- a/tracecmd/trace-list.c
> +++ b/tracecmd/trace-list.c
> @@ -317,14 +317,9 @@ static void show_plugin_options(void)
>         if (!pevent)
>                 die("Can not allocate pevent\n");
>
> -       if (tracecmd_disable_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
> -       if (tracecmd_disable_sys_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
> -
>         trace_seq_init(&s);
>
> -       list = tep_load_plugins(pevent);
> +       list = trace_load_plugins(pevent);
>         tep_plugin_print_options(&s);
>         trace_seq_do_printf(&s);
>         tep_unload_plugins(list, pevent);
> @@ -348,14 +343,9 @@ static void show_plugins(void)
>         if (!pevent)
>                 die("Can not allocate pevent\n");
>
> -       if (tracecmd_disable_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
> -       if (tracecmd_disable_sys_plugins)
> -               tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
> -
>         trace_seq_init(&s);
>
> -       list = tep_load_plugins(pevent);
> +       list = trace_load_plugins(pevent);
>         tep_print_plugins(&s, "  ", "\n", list);
>
>         trace_seq_do_printf(&s);
> --
> 2.21.0
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
