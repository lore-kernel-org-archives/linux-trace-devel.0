Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA1BC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60AE0207FD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 14:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ki03YYpR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgAFOd7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 09:33:59 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46589 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgAFOd6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 09:33:58 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so26950582pgb.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 06:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BatzYnC4FswhR3C1Q5mhXYj5UWHTlHYMvJHbWAt9+ao=;
        b=Ki03YYpRnKoNdaSSebUzbUyDIM9aS3ld+rxOlN08pvKPurSvWLJCzsGkXpbSgNe+wN
         7KVWfEw+/Q+I7FCPBDzOiQ37dhZkuw3XRzENYyE8NrIV+nkXx3ukQTYBCCfYnLfgi9d+
         STdQhT44EsaFxoLiOIlkI92j3/DeyETVmGyzp1/VToY1EiAyTMKIHGUdOz36tAm9hOo8
         AGtXxEo5KCDHFauavdA6n6nXi9eUwXt57Kp2U0/qtDnu+cyyYIqXs0miO5LfQuePLW8e
         XZ4qrpCcepm+D8mzqA4wa77gAQz1UJGxWdjk1L2Z4+o7l7oWefGW6sGahBFePAyJPRn0
         o+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BatzYnC4FswhR3C1Q5mhXYj5UWHTlHYMvJHbWAt9+ao=;
        b=dFQh8QnVTVfxOed4J1/IPHUzozfaPRTQtDhsdPf+QNi/qFqR8g+c2f4UoIhtkdnVy/
         aPJ92UlGSaTH0oRULSPvD6nzhZBPXqe4q3NIQUT2Tma2sgsu2JjP/ppaQbXkumVU9a5k
         c/C9NhQam6lnpZEaYdmON3jdSxriAjX90pHmWA7r2kTaU5kMGn5tO2J1SoFhgXZrLspj
         ilmdjFCDKyugtiU30iFBTHp0qFdM++tw9q9jCFeY+lQJWBff7i96uwK8jyOsPW4Itr7C
         cTr3dz6NIllGg0dan7Q4C2bdHhSeE3TTTZSY98EJoelJglrdbcjmtX9+PiZcPuQag81V
         cdng==
X-Gm-Message-State: APjAAAV0V+OuppdxiuMzd+g0ckrsU3az+p6AleS4s0C8+FqlR9NWp18F
        uhdpQaPuc9tHXbSC+fXMUrpYiwmZL8pn/9M6zfU=
X-Google-Smtp-Source: APXvYqwVtIP0D37jnPdw5/R0h4kqwEJsgBftRb8opQhfXxN9ZrxOFePLPAES5TlArTMpKT3fM6TAR8GiNUtH33KwnCg=
X-Received: by 2002:a62:7883:: with SMTP id t125mr112594929pfc.141.1578321238167;
 Mon, 06 Jan 2020 06:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
 <20191213153029.133570-11-tz.stoyanov@gmail.com> <20191220150413.5d1c52e5@gandalf.local.home>
In-Reply-To: <20191220150413.5d1c52e5@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Jan 2020 16:33:47 +0200
Message-ID: <CAPpZLN57bceVGMdpsTrx6FBQz42f35-BKrdWRKSOYob2BO7wHw@mail.gmail.com>
Subject: Re: [PATCH v18 10/18] trace-cmd: Store the session tracing ID in the
 trace.dat file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 10:04 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 13 Dec 2019 17:30:21 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The ID of the current tracing session is stored in the trace.dat file.
> > A new file option is introduced:
> >       TRACECMD_OPTION_TRACEID
> > The data is stored in the file as NULL terminated string:
> >       "\nTraceID: %llu\n"
>
> If the trace ID is just a 64 bit number, why is it stored in the file
> as a string?
>

The only reason for this is to avoid endian long long conversions,
and to simplify reading of trace.dat file, for debug purposes.

> -- Steve
>
>
> > A new libtracecmd API is introduced, to get the ID when the trace.dat file is read:
> >       unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/trace-cmd/trace-cmd.h |  2 ++
> >  lib/trace-cmd/trace-input.c   | 25 +++++++++++++++++++++++++
> >  tracecmd/trace-record.c       | 15 +++++++++++++++
> >  3 files changed, 42 insertions(+)
> >
> > diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> > index ad69313..6cc2913 100644
> > --- a/include/trace-cmd/trace-cmd.h
> > +++ b/include/trace-cmd/trace-cmd.h
> > @@ -86,6 +86,7 @@ enum {
> >       TRACECMD_OPTION_CPUCOUNT,
> >       TRACECMD_OPTION_VERSION,
> >       TRACECMD_OPTION_PROCMAPS,
> > +     TRACECMD_OPTION_TRACEID,
> >  };
> >
> >  enum {
> > @@ -128,6 +129,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
> >  void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
> >  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
> >  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
> > +unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
> >
> >  void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
> >
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 91362f3..40d9825 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -79,6 +79,7 @@ struct tracecmd_input {
> >       struct tep_plugin_list  *plugin_list;
> >       struct tracecmd_input   *parent;
> >       unsigned long           flags;
> > +     unsigned long long      trace_id;
> >       int                     fd;
> >       int                     long_size;
> >       int                     page_size;
> > @@ -2169,6 +2170,15 @@ static void procmap_free(struct pid_addr_maps *maps)
> >       free(maps);
> >  }
> >
> > +static int trace_traceid_load(struct tracecmd_input *handle, char *buf)
> > +{
> > +
> > +     if (sscanf(buf, "%*s %llu", &handle->trace_id) == 1)
> > +             return 0;
> > +
> > +     return -1;
> > +}
> > +
> >  #define STR_PROCMAP_LINE_MAX (PATH_MAX+22)
> >  static int trace_pid_map_load(struct tracecmd_input *handle, char *buf)
> >  {
> > @@ -2406,6 +2416,10 @@ static int handle_options(struct tracecmd_input *handle)
> >                       if (buf[size-1] == '\0')
> >                               trace_pid_map_load(handle, buf);
> >                       break;
> > +             case TRACECMD_OPTION_TRACEID:
> > +                     if (buf[size-1] == '\0')
> > +                             trace_traceid_load(handle, buf);
> > +                     break;
> >               default:
> >                       warning("unknown option %d", option);
> >                       break;
> > @@ -3507,3 +3521,14 @@ void tracecmd_set_show_data_func(struct tracecmd_input *handle,
> >  {
> >       handle->show_data_func = func;
> >  }
> > +
> > +/**
> > + * tracecmd_get_traceid - get the trace id of the session
> > + * @handle: input handle for the trace.dat file
> > + *
> > + * Returns the trace id, written in the trace file
> > + */
> > +unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
> > +{
> > +     return handle->trace_id;
> > +}
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 7089f7b..b65aeb2 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -3714,6 +3714,19 @@ add_pid_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
> >       trace_seq_destroy(&s);
> >  }
> >
> > +static void
> > +add_trace_id(struct tracecmd_output *handle, struct buffer_instance *instance)
> > +{
> > +     char *str = NULL;
> > +     int len;
> > +
> > +     len = asprintf(&str, "\nTraceID: %llu\n", instance->trace_id);
> > +     if (len < 1)
> > +             return;
> > +     tracecmd_add_option(handle, TRACECMD_OPTION_TRACEID, len + 1, str);
> > +     free(str);
> > +}
> > +
> >  static void
> >  add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
> >  {
> > @@ -3817,6 +3830,8 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
> >       add_option_hooks(handle);
> >       add_uname(handle);
> >       add_version(handle);
> > +     if (!no_top_instance())
> > +             add_trace_id(handle, &top_instance);
> >  }
> >
> >  static void write_guest_file(struct buffer_instance *instance)
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
