Return-Path: <SRS0=/1KP=AS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CC0C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB43C20786
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jul 2020 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594134239;
	bh=U1v8FiFfaAG1xHKJRh9l1If5Ky4VNWSIX5wh2EvBYAs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=D654qKUnkTn8TAtBaRz9p1fgbpue9Kx+GGC/RX4Mm8JM/9ZvH9aT7vg0k+sFbDWqv
	 a13IyWN5u0B4iqCEnDirMjhs6t8u83jSqOTx/P7iNlWGSIQ7luxZx/MZev5/i/h8+k
	 CjY1u2mPRy5lzcX01AKHeW5Noj6MGO8tvS1zJ8E4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgGGPD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jul 2020 11:03:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36563 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgGGPD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jul 2020 11:03:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id 17so46826731wmo.1;
        Tue, 07 Jul 2020 08:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+ePnKsXdtJIiVGFTS040+botc48WuZMYi76zUxj+BQ=;
        b=j5SQf9VyayB7zEyCiSkpmZmDWwliY1CjUwuIyQvD+CKEpvrRzDNEL3sMOQsxjQDfGA
         ImTXwOrjMstdNLx5jxPuFTDjX6qsq6xB8yYNuFB9Xu5nAoqenTNnqPTgLdFNxIFH77pp
         Q/UtlRyELwgPDTc1bYmYJrXfmhVtOrdHYupgBscXmD6bUWVsbL33rgQasT7nMWBfw2Ya
         91sUh4y2hMklKOh7fyla2m5cJ1+UbpnNpSp1hLjDH5HffL4XAtErAtPp9rwGRyMTZBIh
         SF/u66dGeu3d2vWr3l327ZwtVAq71jEFdsDFPYjEQQz1tWTLkv0Q/WJgTm1Chtw0Rm9O
         MQ4g==
X-Gm-Message-State: AOAM5312VJrHNLmPX4OVjurl+wZZ5gV1dA7U97f6GiTKq8zRTACYfMa+
        E8hQO3Uq8zBmdMiaObpDURYF8ytTtiC5Mk3ZdNI=
X-Google-Smtp-Source: ABdhPJy8uOUcKRruQ530QKIET0Jzm7cGz/LfY0TABYgWSxmly7wFDc7TpzO3xgTuGXOmawqc+0/1cVIsmSCgbe5MJ58=
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr4919018wmc.154.1594134235720;
 Tue, 07 Jul 2020 08:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185344.913492689@goodmis.org> <20200702185704.092654084@goodmis.org>
In-Reply-To: <20200702185704.092654084@goodmis.org>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 8 Jul 2020 00:03:44 +0900
Message-ID: <CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] tools lib traceevent: Add interface for options
 to plugins
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
> Add tep_plugin_add_option() and tep_plugin_print_options() to lib traceevent
> library that allows plugins to have their own options. For example, the
> function plugin by default does not print the parent, as it uses the parent
> to do the indenting. The "parent" option is created by the function plugin
> that will print the parent of the function like it does in the trace file.
>
> The tep_plugin_print_options() will print out the list of options that a
> plugin has defined.
>
> Link: http://lore.kernel.org/linux-trace-devel/20190802110101.14759-3-tz.stoyanov@gmail.com
> Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-5-tz.stoyanov@gmail.com
>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse.h  |   2 +
>  tools/lib/traceevent/event-plugin.c | 172 ++++++++++++++++++++++++++++
>  2 files changed, 174 insertions(+)
>
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 776c7c24ee79..02c0438527de 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -406,7 +406,9 @@ char **tep_plugin_list_options(void);
>  void tep_plugin_free_options_list(char **list);
>  int tep_plugin_add_options(const char *name,
>                            struct tep_plugin_option *options);
> +int tep_plugin_add_option(const char *name, const char *val);
>  void tep_plugin_remove_options(struct tep_plugin_option *options);
> +void tep_plugin_print_options(struct trace_seq *s);
>  void tep_print_plugins(struct trace_seq *s,
>                         const char *prefix, const char *suffix,
>                         const struct tep_plugin_list *list);
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> index b53d9a53bcf9..e8f4329ba8e0 100644
> --- a/tools/lib/traceevent/event-plugin.c
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -13,6 +13,7 @@
>  #include <sys/stat.h>
>  #include <unistd.h>
>  #include <dirent.h>
> +#include <errno.h>
>  #include "event-parse.h"
>  #include "event-parse-local.h"
>  #include "event-utils.h"
> @@ -247,6 +248,166 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
>         }
>  }
>
> +static void parse_option_name(char **option, char **plugin)
> +{
> +       char *p;
> +
> +       *plugin = NULL;
> +
> +       if ((p = strstr(*option, ":"))) {
> +               *plugin = *option;
> +               *p = '\0';
> +               *option = strdup(p + 1);
> +               if (!*option)
> +                       return;

It needs to pass the error somehow..


> +       }
> +}
> +
> +static struct tep_plugin_option *
> +find_registered_option(const char *plugin, const char *option)
> +{
> +       struct registered_plugin_options *reg;
> +       struct tep_plugin_option *op;
> +       const char *op_plugin;
> +
> +       for (reg = registered_options; reg; reg = reg->next) {
> +               for (op = reg->options; op->name; op++) {
> +                       if (op->plugin_alias)
> +                               op_plugin = op->plugin_alias;
> +                       else
> +                               op_plugin = op->file;
> +
> +                       if (plugin && strcmp(plugin, op_plugin) != 0)
> +                               continue;
> +                       if (strcmp(option, op->name) != 0)
> +                               continue;
> +
> +                       return op;
> +               }
> +       }
> +
> +       return NULL;
> +}
> +
> +static int process_option(const char *plugin, const char *option, const char *val)
> +{
> +       struct tep_plugin_option *op;
> +
> +       op = find_registered_option(plugin, option);
> +       if (!op)
> +               return 0;
> +
> +       return update_option_value(op, val);
> +}
> +
> +/**
> + * tep_plugin_add_option - add an option/val pair to set plugin options
> + * @name: The name of the option (format: <plugin>:<option> or just <option>)
> + * @val: (optiona) the value for the option

Typo.

> + *
> + * Modify a plugin option. If @val is given than the value of the option
> + * is set (note, some options just take a boolean, so @val must be either
> + * "1" or "0" or "true" or "false").
> + */
> +int tep_plugin_add_option(const char *name, const char *val)
> +{
> +       struct trace_plugin_options *op;
> +       char *option_str;
> +       char *plugin;
> +
> +       option_str = strdup(name);
> +       if (!option_str)
> +               return -ENOMEM;
> +
> +       parse_option_name(&option_str, &plugin);
> +
> +       /* If the option exists, update the val */
> +       for (op = trace_plugin_options; op; op = op->next) {
> +               /* Both must be NULL or not NULL */
> +               if ((!plugin || !op->plugin) && plugin != op->plugin)
> +                       continue;
> +               if (plugin && strcmp(plugin, op->plugin) != 0)
> +                       continue;
> +               if (strcmp(op->option, option_str) != 0)
> +                       continue;
> +
> +               /* update option */
> +               free(op->value);
> +               if (val) {
> +                       op->value = strdup(val);
> +                       if (!op->value)
> +                               goto out_free;
> +               } else
> +                       op->value = NULL;
> +
> +               /* plugin and option_str don't get freed at the end */
> +               free(plugin);
> +               free(option_str);
> +
> +               plugin = op->plugin;
> +               option_str = op->option;
> +               break;
> +       }
> +
> +       /* If not found, create */
> +       if (!op) {
> +               op = malloc(sizeof(*op));
> +               if (!op)
> +                       return -ENOMEM;

goto out_free ?

> +               memset(op, 0, sizeof(*op));
> +               op->next = trace_plugin_options;
> +               trace_plugin_options = op;

I think it's better doing this after setting the value below..

> +
> +               op->plugin = plugin;
> +               op->option = option_str;
> +
> +               if (val) {
> +                       op->value = strdup(val);
> +                       if (!op->value)
> +                               goto out_free;

The option_str will be freed and op will have a dangling pointer..

> +               }
> +       }
> +
> +       return process_option(plugin, option_str, val);
> + out_free:
> +       free(option_str);

Why not free plugin too?

Thanks
Namhyung


> +       return -ENOMEM;
> +}
> +
> +static void print_op_data(struct trace_seq *s, const char *name,
> +                         const char *op)
> +{
> +       if (op)
> +               trace_seq_printf(s, "%8s:\t%s\n", name, op);
> +}
> +
> +/**
> + * tep_plugin_print_options - print out the registered plugin options
> + * @s: The trace_seq descriptor to write the plugin options into
> + *
> + * Writes a list of options into trace_seq @s.
> + */
> +void tep_plugin_print_options(struct trace_seq *s)
> +{
> +       struct registered_plugin_options *reg;
> +       struct tep_plugin_option *op;
> +
> +       for (reg = registered_options; reg; reg = reg->next) {
> +               if (reg != registered_options)
> +                       trace_seq_printf(s, "============\n");
> +               for (op = reg->options; op->name; op++) {
> +                       if (op != reg->options)
> +                               trace_seq_printf(s, "------------\n");
> +                       print_op_data(s, "file", op->file);
> +                       print_op_data(s, "plugin", op->plugin_alias);
> +                       print_op_data(s, "option", op->name);
> +                       print_op_data(s, "desc", op->description);
> +                       print_op_data(s, "value", op->value);
> +                       trace_seq_printf(s, "%8s:\t%d\n", "set", op->set);
> +               }
> +       }
> +}
> +
>  /**
>   * tep_print_plugins - print out the list of plugins loaded
>   * @s: the trace_seq descripter to write to
> @@ -273,6 +434,7 @@ load_plugin(struct tep_handle *tep, const char *path,
>             const char *file, void *data)
>  {
>         struct tep_plugin_list **plugin_list = data;
> +       struct tep_plugin_option *options;
>         tep_plugin_load_func func;
>         struct tep_plugin_list *list;
>         const char *alias;
> @@ -297,6 +459,16 @@ load_plugin(struct tep_handle *tep, const char *path,
>         if (!alias)
>                 alias = file;
>
> +       options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
> +       if (options) {
> +               while (options->name) {
> +                       ret = update_option(alias, options);
> +                       if (ret < 0)
> +                               goto out_free;
> +                       options++;
> +               }
> +       }
> +
>         func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
>         if (!func) {
>                 warning("could not find func '%s' in plugin '%s'\n%s\n",
> --
> 2.26.2
>
>
