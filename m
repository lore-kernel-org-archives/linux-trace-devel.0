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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8EFC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 05:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C52961090
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 05:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhDSFLn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 01:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSFLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 01:11:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63478C06174A
        for <linux-trace-devel@vger.kernel.org>; Sun, 18 Apr 2021 22:11:14 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so22391942pfn.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 18 Apr 2021 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FhkA6B0I8pV/PkPBRODmMq9taw77IqP6aW0PhbddiE8=;
        b=NsNGMhZrGiW4RezMcg/chBnu8sYc1xDtL2aCnxs+0vKPpORW3Hmd6wuA3I4bIoroAx
         qNcR6QCQORDgC7hapYu+brloWLxKwiSfa1aavgNXUSCO9gmb0Vn7nD3PVjw1o9bgKuOB
         cnh5ZZgiEwQqHu7PEfkwc51fQ9V8KxzaVlq0rj9cQyh1IbiEQdYU99Qos/w5j84+BfO6
         upMW5gSvJlSQqfcw2BqDcFM3rMHI2i8tM5o37hmReAkfZz/hh+PAIcpCSFXdzJzGOgBa
         +5upZo1JbKG0EoNSUPyeG0RPbbtGkCLpiq7gOovqMlKMN44KJoP4QZv47LbEkMBeWZn8
         md/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FhkA6B0I8pV/PkPBRODmMq9taw77IqP6aW0PhbddiE8=;
        b=LEBc1aQz9uq/b5IYppcmVL+Qv3Vo/1su2wz2xiC6MOUIQZkVdx/ySY3pyKaxoun0Nz
         toPQLw8z2sZ5f1V8+YYqyyxqGEdUUr0INZTh/nToiXY0pHrh91YipuSSaBWTZGuXLYkU
         rJkCCi6cDYfslwD2KtlwQC36krQ/ckhZWcZFcS+XaUSzd++BV0ulob50NjzYyr6nfzjX
         HLM8qVsKKVZo6YFazMrV/jnlaYt3viyRRdH4ThNR6gedRYECV7+ttSlXsonV0XDGtvZJ
         cVpQfBjsOiXO61B3RBNsKiNRApZd2dHsGCuE00IRGPxf+eR9v4wsFEPmQZfx7F/twOap
         MVMA==
X-Gm-Message-State: AOAM530zSfAIheaD+/ksIVMcwMMW4ujcUKtfexioV3JoBIZwf1QhHoze
        hEcWURmrjOYHvetH/ezPL+W5iBdHsdcQMXevPkcr41J7
X-Google-Smtp-Source: ABdhPJxc0F4zTJfgX/zukrJjjA6sk7vFKgbax+hgy92nNbxyqLtjdi55hhaExgeae48M1GO2l5zrZOnnKnz0OB8guEc=
X-Received: by 2002:aa7:9d81:0:b029:248:c39c:3f26 with SMTP id
 f1-20020aa79d810000b0290248c39c3f26mr17640346pfq.55.1618809073884; Sun, 18
 Apr 2021 22:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210416213018.3890036-1-rostedt@goodmis.org> <20210416213018.3890036-2-rostedt@goodmis.org>
In-Reply-To: <20210416213018.3890036-2-rostedt@goodmis.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 19 Apr 2021 08:10:57 +0300
Message-ID: <CAPpZLN6_NjZYmhDMfskxtKOaVrVm+6pa2ic-LrvoKGBN+h=QhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace-cmd list: Use tracefs to help find events for -e
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Apr 17, 2021 at 1:08 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> When the user specifies -e and wants to search for events, use the tracefs
> helper functions tracefs_event_systems() and tracefs_system_events() to
> find the matching events.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  lib/trace-cmd/trace-input.c |   6 +-
>  tracecmd/trace-list.c       | 136 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 135 insertions(+), 7 deletions(-)
>
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 991abd5f..a540ab24 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1234,9 +1234,11 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
>                         ts -= handle->tsc_calc.offset;
>                         ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
>                 } else {
> -                       tracecmd_warning("Timestamp $llu is before the initial offset %llu, set it to 0",
> +                       tracecmd_warning("Timestamp %llu is before the initial offset %llu\n"
> +                                        "\tSetting offset to 0",
>                                          ts, handle->tsc_calc.offset);
> -                       ts = 0;
> +                       handle->tsc_calc.offset = 0;
> +                       ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);

That looks like from a different patch? I'll send v3 from my patch set
with these fixes.

>                 }
>         }
>
> diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
> index 63216b43..84ee573b 100644
> --- a/tracecmd/trace-list.c
> +++ b/tracecmd/trace-list.c
> @@ -105,6 +105,122 @@ static void process_file_re(process_file_func func,
>         regfree(&reg);
>  }
>
> +static void show_event(process_file_func func, const char *system, const char *event)
> +{
> +       char *buf;
> +       int ret;
> +
> +       ret = asprintf(&buf, "%s:%s", system, event);
> +       if (ret < 0)
> +               die("Can not allocate event");
> +       func(buf, strlen(buf));
> +       free(buf);
> +}
> +
> +static void show_system(process_file_func func, const char *system)
> +{
> +       char **events;
> +       int e;
> +
> +       events = tracefs_system_events(NULL, system);
> +       if (!events) /* die? */
> +               return;
> +
> +       for (e = 0; events[e]; e++)
> +               show_event(func, system, events[e]);
> +}
> +
> +static void show_event_systems(process_file_func func, char **systems)
> +{
> +       int s;
> +
> +       for (s = 0; systems[s]; s++)
> +               show_system(func, systems[s]);
> +}
> +
> +
> +static void process_events(process_file_func func, const char *re)
> +{
> +       regex_t system_reg;
> +       regex_t event_reg;
> +       char *str;
> +       size_t l = strlen(re);
> +       bool just_systems = true;
> +       char **systems;
> +       char **events;
> +       char *system;
> +       char *event;
> +       int s, e;
> +
> +       systems = tracefs_event_systems(NULL);
> +       if (!systems)
> +               return process_file_re(func, "available_events", re);
> +
> +       if (!re || l == 0) {
> +               show_event_systems(func, systems);
> +               return;
> +       }
> +
> +       str = strdup(re);
> +       if (!str)
> +               die("Can not allocate momory for regex");
> +
> +       system = strtok(str, ":");
> +       event = strtok(NULL, "");
> +
> +       if (regcomp(&system_reg, system, REG_ICASE|REG_NOSUB))
> +               die("invalid regex '%s'", system);
> +
> +       if (event) {
> +               if (regcomp(&event_reg, event, REG_ICASE|REG_NOSUB))
> +                       die("invalid regex '%s'", event);
> +       } else {
> +               /*
> +                * If the regex ends with ":", then event would be null,
> +                * but we do not want to match events.
> +                */
> +               if (re[l-1] != ':')
> +                       just_systems = false;
> +       }
> +       free(str);
> +
> +       for (s = 0; systems[s]; s++) {
> +
> +               if (regexec(&system_reg, systems[s], 0, NULL, 0) == 0) {
> +                       if (!event) {
> +                               show_system(func, systems[s]);
> +                               continue;
> +                       }
> +                       events = tracefs_system_events(NULL, systems[s]);
> +                       if (!events) /* die? */
> +                               continue;
> +                       for (e = 0; events[e]; e++) {
> +                               if (regexec(&event_reg, events[e], 0, NULL, 0) == 0)
> +                                       show_event(func, systems[s], events[e]);
> +                       }
> +                       tracefs_list_free(events);
> +                       continue;
> +               }
> +               if (just_systems)
> +                       continue;
> +
> +               events = tracefs_system_events(NULL, systems[s]);
> +               if (!events) /* die? */
> +                       continue;
> +
> +               for (e = 0; events[e]; e++) {
> +                       if (regexec(&system_reg, events[e], 0, NULL, 0) == 0)
> +                               show_event(func, systems[s], events[e]);
> +               }
> +               tracefs_list_free(events);
> +       }
> +       tracefs_list_free(systems);
> +
> +       regfree(&system_reg);
> +       if (event)
> +               regfree(&event_reg);
> +}
> +
>  static int show_file_write(char *buf, int len)
>  {
>         return fwrite(buf, 1, len, stdout);
> @@ -210,24 +326,34 @@ static int event_format_write(char *fbuf, int len)
>         return 0;
>  }
>
> +static int event_name(char *buf, int len)
> +{
> +       printf("%s\n", buf);
> +
> +       return 0;
> +}
> +
>
>  static void show_event_filter_re(const char *re)
>  {
> -       process_file_re(event_filter_write, "available_events", re);
> +       process_events(event_filter_write, re);
>  }
>
>
>  static void show_event_trigger_re(const char *re)
>  {
> -       process_file_re(event_trigger_write, "available_events", re);
> +       process_events(event_trigger_write, re);
>  }
>
> -
>  static void show_event_format_re(const char *re)
>  {
> -       process_file_re(event_format_write, "available_events", re);
> +       process_events(event_format_write, re);
>  }
>
> +static void show_event_names_re(const char *re)
> +{
> +       process_events(event_name, re);
> +}
>
>  static void show_events(const char *eventre, int flags)
>  {
> @@ -244,7 +370,7 @@ static void show_events(const char *eventre, int flags)
>                 else if (flags & SHOW_EVENT_TRIGGER)
>                         show_event_trigger_re(eventre);
>                 else
> -                       show_file_re("available_events", eventre);
> +                       show_event_names_re(eventre);
>         } else
>                 show_file("available_events");
>  }
> --
> 2.29.2
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
