Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF8CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B798D64DE0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhBQQes (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 11:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhBQQec (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 11:34:32 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5717C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 08:33:49 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id m2so8815765pgq.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 08:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v1FCYrsMrHNC388C0ReQp99JtZ4dK229j6bm5YG9F3w=;
        b=VnGF5urjEWJv1iH+I/AFOMWP6UT3XjWJCBlwOKG9lueH2MJuVg4y7IQPNqPsPMyuLQ
         4+QdEkC2SFaJZDlTKX8407UUI88jsZqgFxwYTHSpYC4tvqQT3LJnIy8GUI034l8DRvAD
         wvmnyBMrC+QkcRjDlMov6xbHGG85IX1pOJ7FXOKOpEcryO4elNZwwBTXL0lPhaMphhzX
         4N59P73/isnavvh3kmIpt2Jy7ZHu2rZ1pVTj+nAR7+MRq0Z1r3RgjcFVCDjzKMHoLphK
         CKKsG2CpDLUX+Vre7BkNgExK6v/fJM6HpEdmtMCyN2Sh5plc6/elI7q4dZpQwoMxEvvx
         z8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v1FCYrsMrHNC388C0ReQp99JtZ4dK229j6bm5YG9F3w=;
        b=fHD0GCylvj/MW55lBV715xvbZvT5rCj0tTjEJHrjFDE5eq3EE5v2dEGGB7fvC+1dTm
         /fXLijDlbrtw5eeCVsvKaYscpaR17f5IrJP/In4UNTX0ztgAU/yX3/VD8wLJQbRk6FC6
         ZMTt3jKPK6KD2GxhPF1pNn7lQ4D7I/nekUTlJ1N4AaioffoeSl8b19OPG2m/Tp+0lOSQ
         W/ClTpejiqent6qMlIwmzHOfRbdFkmA4xuelJoltYQqHah+/BpBbnx89IpWys0oHup4T
         atFpPQiCWfQ6z8AQcdffn3hXZ0FnP6DGvGWekkrqVdR5xMEMm5ZQOTd4U0iLBDY7psC5
         ezNg==
X-Gm-Message-State: AOAM532mNmOfoXu/wyhs0PfPJ1viICYT6ky6ObGWQz5FaDnUie44X+Ob
        /KYFngu7XInQ7cI/w9suQmDDWTgps1VXfAJEKKLSZUmg9rFL7w==
X-Google-Smtp-Source: ABdhPJypfX6oVGxKIPkyniNpVLCSB4+b1chX0zR9J5cV2xUCRb93XJsb2cu72wrlw3v16NkouAmHMQiCxt4oBVaYMVc=
X-Received: by 2002:a62:6346:0:b029:1db:a562:be79 with SMTP id
 x67-20020a6263460000b02901dba562be79mr68689pfb.81.1613579629417; Wed, 17 Feb
 2021 08:33:49 -0800 (PST)
MIME-Version: 1.0
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
 <20210217042341.1675546-2-tz.stoyanov@gmail.com> <20210217110045.71771e87@gandalf.local.home>
In-Reply-To: <20210217110045.71771e87@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 17 Feb 2021 18:33:32 +0200
Message-ID: <CAPpZLN4EoCES6CHo8uoyOoFr9nopOkQZKVF5voFPCYM4pnzyhg@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 17, 2021 at 6:00 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> >  /* --- Opening and Reading the trace.dat file --- */
> >
> > +enum  {
> > +     TRACECMD_FILE_INIT              = (1 << 0),
> > +     TRACECMD_FILE_HEADERS           = (1 << 1),
> > +     TRACECMD_FILE_FTRACE_EVENTS     = (1 << 2),
> > +     TRACECMD_FILE_ALL_EVENTS        = (1 << 3),
> > +     TRACECMD_FILE_KALLSYMS          = (1 << 4),
> > +     TRACECMD_FILE_PRINTK            = (1 << 5),
> > +     TRACECMD_FILE_CMD_LINES         = (1 << 6),
> > +     TRACECMD_FILE_CPU_COUNT         = (1 << 7),
> > +     TRACECMD_FILE_OPTIONS           = (1 << 8),
> > +     TRACECMD_FILE_CPU_LATENCY       = (1 << 9),
> > +     TRACECMD_FILE_CPU_FLYRECORD     = (1 << 10),
>
> Why did you use bits, and not just a number?
>
> It's not that this is quantum physics and we are in multiple states at once
> ;-)

I use these flags to track what is in the file, not just a state. The
state is the most significant bit which is set,
but that way there is information for all passed states. I use the
same logic when reading the file, to verify if
all required information is in the file.

>
> Order matters, so we want to make sure that when we enter one state, we are
> coming in from another state.

Yes, I added checks before entering any of these states to verify its
dependencies.

>
>
> > +};
> > +#define TRACECMD_FILE_TRACE_DATA (TRACECMD_FILE_CPU_LATENCY | TRACECMD_FILE_CPU_FLYRECORD)
> > +
> >  enum {
> >       TRACECMD_OPTION_DONE,
> >       TRACECMD_OPTION_DATE,
> > @@ -115,9 +130,7 @@ enum {
> >  enum {
> >       TRACECMD_FL_IGNORE_DATE         = (1 << 0),
> >       TRACECMD_FL_BUFFER_INSTANCE     = (1 << 1),
> > -     TRACECMD_FL_LATENCY             = (1 << 2),
> > -     TRACECMD_FL_IN_USECS            = (1 << 3),
> > -     TRACECMD_FL_FLYRECORD           = (1 << 4),
> > +     TRACECMD_FL_IN_USECS            = (1 << 2),
> >  };
> >
> >  struct tracecmd_ftrace {
> > @@ -150,6 +163,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
> >  void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
> >  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
> >  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
> > +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
> >  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
> >  int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
> >
> > @@ -273,6 +287,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
> >                                                  const char *name, int cpus);
> >
> >  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
> > +int tracecmd_write_cmdlines(struct tracecmd_output *handle);
> >  int tracecmd_write_options(struct tracecmd_output *handle);
> >  int tracecmd_append_options(struct tracecmd_output *handle);
> >  int tracecmd_update_option(struct tracecmd_output *handle,
> > @@ -500,7 +515,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
> >  void *tracecmd_record_offset(struct tracecmd_input *handle,
> >                            struct tep_record *record);
> >
> > -int save_tracing_file_data(struct tracecmd_output *handle,
> > -                        const char *filename);
> > -
> >  #endif /* _TRACE_CMD_PRIVATE_H */
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 76bcb215..c171e93c 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -102,6 +102,7 @@ struct host_trace_info {
> >
> >  struct tracecmd_input {
> >       struct tep_handle       *pevent;
> > +     unsigned long           file_state;
> >       struct tep_plugin_list  *plugin_list;
> >       struct tracecmd_input   *parent;
> >       unsigned long           flags;
> > @@ -161,6 +162,11 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle)
> >       return handle->flags;
> >  }
> >
> > +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle)
> > +{
> > +     return handle->file_state;
> > +}
> > +
> >  #if DEBUG_RECORD
> >  static void remove_record(struct page *page, struct tep_record *record)
> >  {
> > @@ -782,34 +788,40 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
> >       ret = read_header_files(handle);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_HEADERS;
> > +     tep_set_long_size(handle->pevent, handle->long_size);
> >
> >       ret = read_ftrace_files(handle, NULL);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_FTRACE_EVENTS;
> >
> >       ret = read_event_files(handle, NULL);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_ALL_EVENTS;
> >
> >       ret = read_proc_kallsyms(handle);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_KALLSYMS;
> >
> >       ret = read_ftrace_printk(handle);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_PRINTK;
> >
> >       if (read_and_parse_cmdlines(handle) < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_CMD_LINES;
> >
> >       if (read_cpus(handle) < 0)
> >               return -1;
> > +     handle->file_state |= TRACECMD_FILE_CPU_COUNT;
> >
> >       if (read_options_type(handle) < 0)
> >               return -1;
> >
> > -     tep_set_long_size(handle->pevent, handle->long_size);
> > -
> >       return 0;
> >  }
> >
> > @@ -2657,6 +2669,7 @@ static int read_options_type(struct tracecmd_input *handle)
> >       if (strncmp(buf, "options", 7) == 0) {
> >               if (handle_options(handle) < 0)
> >                       return -1;
> > +             handle->file_state |= TRACECMD_FILE_OPTIONS;
> >               if (do_read_check(handle, buf, 10))
> >                       return -1;
> >       }
> > @@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
> >        * Check if this is a latency report or flyrecord.
> >        */
> >       if (strncmp(buf, "latency", 7) == 0)
> > -             handle->flags |= TRACECMD_FL_LATENCY;
> > +             handle->file_state |= TRACECMD_FILE_CPU_LATENCY;
> >       else if (strncmp(buf, "flyrecord", 9) == 0)
> > -             handle->flags |= TRACECMD_FL_FLYRECORD;
> > +             handle->file_state |= TRACECMD_FILE_CPU_FLYRECORD;
>
> I think we should keep the LATENCY and FLYRECORD flags, as they have
> different meanings and define the type of handle, not just the state they
> are in. We can have the logic flow through different states depending on if
> it is a latency or flyrecord file.

As I use the new flags to track what is written / read from the file,
it overlaps with the
old TRACECMD_FL_FLYRECORD and TRACECMD_FL_LATENCY flags.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
