Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA44BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8772564F5E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 11:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbhBDLFA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhBDLE7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 06:04:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546DBC0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Feb 2021 03:04:19 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g15so1581970pjd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Feb 2021 03:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjsTH/Hl9ca3wIK7RwCXO4y0hdn5AjvceX3ysTArI5g=;
        b=X4nFbFmZ7El/7xxXQbm0HjndErU0CNycxKVPKrfOtqG6NjUMxD4zJiwuaNzxLQy0pq
         kZfT05rpi9COH4mo6+hGpYbosHpPyXiZGxsfYsRS8VyEJjc9D2gVDTVKO/hmZJzIBPCF
         8eP3vQyznsMRcrf9eqWRmz8sW2czBZUo+woA7hiE+B2CagqaRwe+rYds7097R7kV5tUU
         XglvyfuPM7CrxC3Khn/QdVFm94BIJRZX/F3QEj7qE/yA9upq596aMQOABm+kdTxE+BHs
         jTbhB8yXXHgoaAmFCGANF+T3wlHiB9f5ZrKz8eZFR44vJJ38MzfIOO/ieuTACDQt9gmF
         SSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjsTH/Hl9ca3wIK7RwCXO4y0hdn5AjvceX3ysTArI5g=;
        b=rFoIerSaXDXIVRFCmmh2NLb1YQ1yvG4ofPmdzEPfbh2WbociWEYuxCk29UG8/Pi5CI
         IESTdRkTmiPkM+YSmJ8EtSll5ddQ5Pm1WdGaHnYDL/a1KRdXUgWAJ7PbImnHjPFkSX3k
         zv+LwXmDbX3FkS6V4SnhWoYaV+3kjiSF9piorHYww3SfK5qdypViYj6W1oHKjVpllf5j
         GvzvgsGiTwvgrCTpkkLR/HI/L0DE6PAUv+JvuSin6/V2RG6vt0LMk2bhWzqRU8FeziUq
         AfOAD7hzsy9YYUZ3PIAkI54FrVwV3kcLEJayNxswZY0Gh+E323+z1DUOUqka7OwOJN9a
         rO8g==
X-Gm-Message-State: AOAM530tiNAQy6VeDK7I15fCJtCEYuskICR5DWeYVM0CuyTgyjn6z06J
        iYHOqEC42ZMt+4TFYl7/ZrgeIkU3IPxUURpgayM=
X-Google-Smtp-Source: ABdhPJwCz9nyB1KhPOdItRMvY0s6MtHPRPSxayT7tCAIGqs49nVWxEKsQ9OG0vyVA6u8m3n5e7I+lPPCOiJ1uCxb1B8=
X-Received: by 2002:a17:902:ee04:b029:e1:7256:fa18 with SMTP id
 z4-20020a170902ee04b02900e17256fa18mr7457879plb.58.1612436658798; Thu, 04 Feb
 2021 03:04:18 -0800 (PST)
MIME-Version: 1.0
References: <20210119095939.6f307c4d@gandalf.local.home>
In-Reply-To: <20210119095939.6f307c4d@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 4 Feb 2021 13:04:01 +0200
Message-ID: <CAPpZLN4D4zDfErUVpXfdaY3iciV0k+nW+uJsBeu79XtaVjxatw@mail.gmail.com>
Subject: Re: Move "load_plugins" out of the opening code
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 19, 2021 at 7:57 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Tzvetomir,
>
> From bugzilla:
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=211255
>
> It was reported that:
>
> $ trace-cmd report -N -r funcgraph_exit trace.dat 2>/dev/null | grep funcgraph_exit | wc -l
> 11645
>
> $ trace-cmd report -N -F funcgraph_exit -r funcgraph_exit trace.dat 2>/dev/null | grep funcgraph_exit | wc -l
> 24826
>
> Where the first should have been as big as the second. The problem with the
> above is really that "-N" does not stop the ftrace function event plugins
> from being loaded.
>
> Looking at this further, I think it's a mistake to have the plugins loaded
> at opening time.
>
> We should have a new function for the library:
>
> int tracecmd_load_plugins(struct tracecmd_handle *handle, int flags);
>
> And this should be called after read_trace_header() in trace-read.c.
>
> We can still have tracecmd_open_head() call this, as the "open_head" is
> basically a "do everything" function.
>
> This will allow us to remove the global "tracecmd_disable_plugins" and
> "tracecmd_disable_sys_plugins" variables and use the flags input instead.
> With the '-N' option, we should probably just skip calling it regardless.
>
> The below patch was just a POC, to see if there was any side-effects for
> this. But it didn't have a return value or flags, which should be added for
> the final version.
>

Hi Steven,
I sent a patch with a different implementation of this fix. I decided to
reimplement it because of two reasons:
 - There is already a function tracecmd_load_plugins(), which is supposed
   to load trace-cmd specific plugins. As there are no such plugins for now,
   this function is a dead code and is not called. However, it is
still part of the
   libtracecmd.
 - Moving that logic out of tracecmd_alloc_fd() will break these APIs:
    tracecmd_open()
    tracecmd_open_fd()
    tracecmd_open_head()
 KernelShark relies on them for reading trace.dat files.  We can think of
 moving plugins loading in a separate API, which must be called at the
 library initialisation phase, but this will require changes in the current
library users (KernelShark?).

> -- Steve
>
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 3e67dd61..11bf8e5d 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -3247,11 +3247,6 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
>         if (!handle->pevent)
>                 goto failed_read;
>
> -       /* register default ftrace functions first */
> -       tracecmd_ftrace_overrides(handle, &handle->finfo);
> -
> -       handle->plugin_list = trace_load_plugins(handle->pevent);
> -
>         tep_set_file_bigendian(handle->pevent, buf[0]);
>         tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
>
> @@ -3344,6 +3339,13 @@ struct tracecmd_input *tracecmd_open(const char *file)
>         return tracecmd_open_fd(fd);
>  }
>
> +void tracecmd_load_plugins(struct tracecmd_input *handle)
> +{
> +       /* register default ftrace functions first */
> +       tracecmd_ftrace_overrides(handle, &handle->finfo);
> +       handle->plugin_list = trace_load_plugins(handle->pevent);
> +}
> +
>  /**
>   * tracecmd_open_head - create a tracecmd_handle from a given file, read
>   *                     and parse only the trace headers from the file
> diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> index d07f4efe..a79bf0aa 100644
> --- a/tracecmd/trace-read.c
> +++ b/tracecmd/trace-read.c
> @@ -1768,10 +1768,14 @@ void trace_report (int argc, char **argv)
>                 die("Wakeup tracing can only be done on a single input file");
>
>         list_for_each_entry(inputs, &input_files, list) {
> +               void tracecmd_load_plugins(struct tracecmd_input *handle);
>                 handle = read_trace_header(inputs->file);
>                 if (!handle)
>                         die("error reading header for %s", inputs->file);
>
> +               if (!tracecmd_disable_plugins)
> +                       tracecmd_load_plugins(handle);
> +
>                 /* If used with instances, top instance will have no tag */
>                 add_handle(handle, multi_inputs ? inputs->file : NULL);
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
