Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7BDC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1AA764EE3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBZEDQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBZEDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 23:03:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E383C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:02:35 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ba1so4619350plb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbETCwAChM1Cn5LcQ1SrTxdPMyKy/kX+PWWVDmWzB3o=;
        b=M1+n+BiNsSdD6NQ3GZvlCZ2Z07zbT4NuNI1D8kXAAkmbQ782SI+qt9w5JwASGpjgrV
         i3lk7VdMBmxd7Ha6cACLQEsjiQNeRCLymGgBNwXqlW7cGkQR58LuVgtNp0b/34ABJuZZ
         I9U8gqg1+Oo+hQ1z4kA+856gYu1xt9V0QEk14x5fA5V45KX0NBJVLxe3bBQ1Mou8wh5F
         2acy5Qq603vR9YhQMTG2uz7ZdTTlTiiOl+mNbEVsXyW6JJOWQA+rDmqbq3+GTmcUyd1j
         lkotAGyFd6QOQmYiUYqTCWuIf1EzJN9sJtPQMnE974pUsQj9+WaGqgbR/W5JUCj3ltCC
         L53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbETCwAChM1Cn5LcQ1SrTxdPMyKy/kX+PWWVDmWzB3o=;
        b=DYV5uCe+MDT1EsJ+M6W8GrgtGo2d8eqzUxa8iWp/UTMqli9EhqKb3NlBcgpwFTzOTC
         yIfB6z0hYBftPkEWP/aqx2ZVXuUcAn8UKGLrXy8u3BkE61yGRUnVGA8KSGAfKKJQi0oB
         8Qa0B1t2CZZkrGc9kaKVNEurLpSv7k9uE9FCCbDvBz+nmoOIKMKl6cDN7rXG60nuE0+8
         8rUBcmzmzUkZmT1V0F3ct9wbgUo+9PMjIR4fUv8Sdb3seGnYXcnWORZWJFFDLleY78+H
         vNUcgJSwY8SwTWgfxb2v3tKv86ATuULUMMAME+Q9le+90+qXlyL7jHAWbS+9G12Ri3am
         AT+A==
X-Gm-Message-State: AOAM533ugQDZfyEGKEDe88bXshkNDEPhrSycQnPRE2Wv0/0vQLQnAWE2
        i49Wc2rQkpNRTVO9aTXjPvi/vKz5PjSU9xADCzGIKJwyrtY=
X-Google-Smtp-Source: ABdhPJxaWc4/NJAtPdyVpJwaJuONk0lcdYZIi/kh0S5ITkabRguO+nqHk/OPZsDasjuZwHqGDhLa8477edyQZ1iscAc=
X-Received: by 2002:a17:902:d898:b029:e4:3021:ac92 with SMTP id
 b24-20020a170902d898b02900e43021ac92mr1156420plz.26.1614312154078; Thu, 25
 Feb 2021 20:02:34 -0800 (PST)
MIME-Version: 1.0
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
 <20210219053156.2235035-2-tz.stoyanov@gmail.com> <20210224181814.3de4e4ca@gandalf.local.home>
In-Reply-To: <20210224181814.3de4e4ca@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 26 Feb 2021 06:02:17 +0200
Message-ID: <CAPpZLN4y_zvPJ0qDzAVqBhNo9aOPLzubN6BXtxKdSNgZys8Uxw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Thu, Feb 25, 2021 at 1:18 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 19 Feb 2021 07:31:55 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> > index eddfd9eb..fc968cc9 100644
> > --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> > +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> > @@ -95,6 +95,20 @@ static inline int tracecmd_host_bigendian(void)
> >
> >  /* --- Opening and Reading the trace.dat file --- */
> >
> > +enum  {
> > +     TRACECMD_FILE_INIT,
> > +     TRACECMD_FILE_HEADERS,
> > +     TRACECMD_FILE_FTRACE_EVENTS,
> > +     TRACECMD_FILE_ALL_EVENTS,
> > +     TRACECMD_FILE_KALLSYMS,
> > +     TRACECMD_FILE_PRINTK,
> > +     TRACECMD_FILE_CMD_LINES,
> > +     TRACECMD_FILE_CPU_COUNT,
> > +     TRACECMD_FILE_OPTIONS,
> > +     TRACECMD_FILE_CPU_LATENCY,
> > +     TRACECMD_FILE_CPU_FLYRECORD,
> > +};
> > +
> >  enum {
> >       TRACECMD_OPTION_DONE,
> >       TRACECMD_OPTION_DATE,
> > @@ -115,9 +129,7 @@ enum {
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
> > @@ -150,6 +162,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
> >  void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
> >  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
> >  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
> > +unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
> >  unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
> >  int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
> >
> > @@ -273,6 +286,7 @@ struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handl
> >                                                  const char *name, int cpus);
> >
> >  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
> > +int tracecmd_write_cmdlines(struct tracecmd_output *handle);
> >  int tracecmd_write_options(struct tracecmd_output *handle);
> >  int tracecmd_append_options(struct tracecmd_output *handle);
> >  int tracecmd_update_option(struct tracecmd_output *handle,
> > @@ -500,7 +514,4 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
> >  void *tracecmd_record_offset(struct tracecmd_input *handle,
> >                            struct tep_record *record);
> >
> > -int save_tracing_file_data(struct tracecmd_output *handle,
> > -                        const char *filename);
>
> This turning into a static function looks unrelated to this patch, and
> should be a separate clean up patch.

I think it is logically from this patch. The only usage of this function
outside of its file is for fixing the forgotten "saved_cmdlines" in
the trace-cmd agent. This patches introduces a new API for that,
tracecmd_write_cmdlines(), that should be used for saving the
cmdlines as it has additional validations. I replaced the old way
of saving the cmdlines with the new API in the whole code, which
makes no sense to have save_tracing_file_data() non static.

>
> > -
> >  #endif /* _TRACE_CMD_PRIVATE_H */
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 76bcb215..9ef7b9f1 100644
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
> > +     handle->file_state = TRACECMD_FILE_HEADERS;
> > +     tep_set_long_size(handle->pevent, handle->long_size);
>
> The moving of setting long size also looks to be unrelated to (or perhaps
> it's just a dependency of) this patch. That change should also be in a
> separate patch.

It is related. This patch changes the behaviour of reading and
parsing the trace.dat file headers in case of partially written file,
the use case of listener and agent.  As the long size information
is already available at that moment, when the
TRACECMD_FILE_HEADERS state is reached, it should be applied.
Otherwise it could be lost, in case some of the headers after that are
still not present in the file - which may be a valid and expected situation.
When the tracecmd_get_output_handle_fd() is used to read a partially
written file, there is one important change - tracecmd_read_headers()
is called, to get the state of that partial file. Without the above
"set long size"
change, the tep hanlder used in tracecmd_get_output_handle_fd() could be
with invalid long size, even though the long size is in the file.

>
> >
> >       ret = read_ftrace_files(handle, NULL);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
> >
> >       ret = read_event_files(handle, NULL);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_ALL_EVENTS;
> >
> >       ret = read_proc_kallsyms(handle);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_KALLSYMS;
> >
> >       ret = read_ftrace_printk(handle);
> >       if (ret < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_PRINTK;
> >
> >       if (read_and_parse_cmdlines(handle) < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_CMD_LINES;
> >
> >       if (read_cpus(handle) < 0)
> >               return -1;
> > +     handle->file_state = TRACECMD_FILE_CPU_COUNT;
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
> > +             handle->file_state = TRACECMD_FILE_OPTIONS;
> >               if (do_read_check(handle, buf, 10))
> >                       return -1;
> >       }
> > @@ -2665,9 +2678,9 @@ static int read_options_type(struct tracecmd_input *handle)
> >        * Check if this is a latency report or flyrecord.
> >        */
> >       if (strncmp(buf, "latency", 7) == 0)
> > -             handle->flags |= TRACECMD_FL_LATENCY;
> > +             handle->file_state = TRACECMD_FILE_CPU_LATENCY;
> >       else if (strncmp(buf, "flyrecord", 9) == 0)
> > -             handle->flags |= TRACECMD_FL_FLYRECORD;
> > +             handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
> >       else
> >               return -1;
> >
> > @@ -2688,11 +2701,11 @@ static int read_cpu_data(struct tracecmd_input *handle)
> >       /*
> >        * Check if this is a latency report or not.
> >        */
> > -     if (handle->flags & TRACECMD_FL_LATENCY)
> > +     if (handle->file_state == TRACECMD_FILE_CPU_LATENCY)
> >               return 1;
> >
> >       /* We expect this to be flyrecord */
> > -     if (!(handle->flags & TRACECMD_FL_FLYRECORD))
> > +     if (handle->file_state != TRACECMD_FILE_CPU_FLYRECORD)
> >               return -1;
> >
> >       cpus = handle->cpus;
> > @@ -3153,6 +3166,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
> >       handle->header_files_start =
> >               lseek64(handle->fd, handle->header_files_start, SEEK_SET);
> >
> > +     handle->file_state = TRACECMD_FILE_INIT;
> > +
> >       return handle;
> >
> >   failed_read:
> > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > index 588f79a5..732e3b44 100644
> > --- a/lib/trace-cmd/trace-output.c
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -54,10 +54,10 @@ struct tracecmd_output {
> >       int                     cpus;
> >       struct tep_handle       *pevent;
> >       char                    *tracing_dir;
> > -     int                     options_written;
> >       int                     nr_options;
> >       bool                    quiet;
> > -     struct list_head        options;
> > +     unsigned long           file_state;
> > +     struct list_head        options;
> >       struct tracecmd_msg_handle *msg_handle;
> >  };
> >
> > @@ -797,8 +797,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
> >       return -1;
> >  }
> >
> > -int save_tracing_file_data(struct tracecmd_output *handle,
> > -                        const char *filename)
> > +static int save_tracing_file_data(struct tracecmd_output *handle,
> > +                               const char *filename)
> >  {
> >       unsigned long long endian8;
> >       char *file = NULL;
> > @@ -836,6 +836,33 @@ out_free:
> >       return ret;
> >  }
> >
> > +static int check_out_state(struct tracecmd_output *handle, int new_state)
> > +{
> > +     if (!handle)
> > +             return -1;
> > +
> > +     switch (new_state) {
> > +     case TRACECMD_FILE_HEADERS:
> > +     case TRACECMD_FILE_FTRACE_EVENTS:
> > +     case TRACECMD_FILE_ALL_EVENTS:
> > +     case TRACECMD_FILE_KALLSYMS:
> > +     case TRACECMD_FILE_PRINTK:
> > +     case TRACECMD_FILE_CMD_LINES:
> > +     case TRACECMD_FILE_CPU_COUNT:
> > +     case TRACECMD_FILE_OPTIONS:
> > +             if (handle->file_state == (new_state - 1))
> > +                     return 0;
> > +             break;
> > +     case TRACECMD_FILE_CPU_LATENCY:
> > +     case TRACECMD_FILE_CPU_FLYRECORD:
> > +             if (handle->file_state == TRACECMD_FILE_OPTIONS)
> > +                     return 0;
> > +             break;
> > +     }
> > +
> > +     return -1;
> > +}
> > +
> >  static struct tracecmd_output *
> >  create_file_fd(int fd, struct tracecmd_input *ihandle,
> >              const char *tracing_dir,
> > @@ -905,20 +932,30 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
> >       endian4 = convert_endian_4(handle, handle->page_size);
> >       if (do_write_check(handle, &endian4, 4))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_INIT;
> >
> >       if (ihandle)
> >               return handle;
> >
> >       if (read_header_files(handle))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_HEADERS;
> > +
> >       if (read_ftrace_files(handle))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
> > +
> >       if (read_event_files(handle, list))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_ALL_EVENTS;
> > +
> >       if (read_proc_kallsyms(handle, kallsyms))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_KALLSYMS;
> > +
> >       if (read_ftrace_printk(handle))
> >               goto out_free;
> > +     handle->file_state = TRACECMD_FILE_PRINTK;
> >
> >       return handle;
> >
> > @@ -973,10 +1010,10 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
> >       int i, size = 0;
> >
> >       /*
> > -      * We can only add options before they were written.
> > +      * We can only add options before tracing data were written.
> >        * This may change in the future.
> >        */
> > -     if (handle->options_written)
> > +     if (handle->file_state > TRACECMD_FILE_OPTIONS)
> >               return NULL;
> >
> >       for (i = 0; i < count; i++)
> > @@ -1038,8 +1075,20 @@ tracecmd_add_option(struct tracecmd_output *handle,
> >
> >  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
> >  {
> > +     int ret;
> > +
> > +     ret = check_out_state(handle, TRACECMD_FILE_CPU_COUNT);
> > +     if (ret < 0) {
> > +             warning("Cannot write CPU count into the file, unexpected state 0x%X",
> > +                     handle->file_state);
> > +             return ret;
> > +     }
> >       cpus = convert_endian_4(handle, cpus);
> > -     return do_write_check(handle, &cpus, 4);
> > +     ret = do_write_check(handle, &cpus, 4);
> > +     if (ret < 0)
> > +             return ret;
> > +     handle->file_state = TRACECMD_FILE_CPU_COUNT;
> > +     return 0;
> >  }
> >
> >  int tracecmd_write_options(struct tracecmd_output *handle)
> > @@ -1048,10 +1097,17 @@ int tracecmd_write_options(struct tracecmd_output *handle)
> >       unsigned short option;
> >       unsigned short endian2;
> >       unsigned int endian4;
> > +     int ret;
> >
> >       /* If already written, ignore */
> > -     if (handle->options_written)
> > +     if (handle->file_state == TRACECMD_FILE_OPTIONS)
> >               return 0;
> > +     ret = check_out_state(handle, TRACECMD_FILE_OPTIONS);
> > +     if (ret < 0) {
>
> I wonder if we should keep the old logic, which using states is the
> equivalent of:
>
>         if (handle->file_state >= TRACECMD_FILE_OPTIONS)
>                 return 0;
>
> And not even bother with the check, as the old logic would not error nor
> warn if this was called in a later state after options.

We should not use the old logic here. This patch changes the way partially
written trace.dat files are processed. Handlers to such files are created by
tracecmd_get_output_handle_fd(), which now tracks the state of the partial
file - what headers are already written. In the old logic, options_written is
always false for partial files, even though the options could already be in
the file. That just worked because tracecmd_write_options() is never called
in such cases, where options are already in the file. But with the new logic,
the state of the partial file reflects its content, this should be
taken into account.

>
> > +             warning("Cannot write options into the file, unexpected state 0x%X",
> > +                     handle->file_state);
> > +             return ret;
> > +     }
> >
> >       if (do_write_check(handle, "options  ", 10))
> >               return -1;
> > @@ -1078,7 +1134,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
> >       if (do_write_check(handle, &option, 2))
> >               return -1;
> >
> > -     handle->options_written = 1;
> > +     handle->file_state = TRACECMD_FILE_OPTIONS;
> >
> >       return 0;
> >  }
> > @@ -1092,9 +1148,11 @@ int tracecmd_append_options(struct tracecmd_output *handle)
> >       off_t offset;
> >       int r;
> >
> > -     /* If already written, ignore */
> > -     if (handle->options_written)
> > -             return 0;
> > +     /* We can append only if options are already written and tracing data
> > +      * is not yet written
> > +      */
>
> Nit. The above is "Linux networking" comment style, which is not normal
> Linux style that we follow. It should be:
>
>         /*
>          * We can append only if options are already written and tracing data
>          * is not yet written
>          */
>
> > +     if (handle->file_state != TRACECMD_FILE_OPTIONS)
> > +             return -1;
> >
> >       if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
> >               return -1;
> > @@ -1128,8 +1186,6 @@ int tracecmd_append_options(struct tracecmd_output *handle)
> >       if (do_write_check(handle, &option, 2))
> >               return -1;
> >
> > -     handle->options_written = 1;
> > -
> >       return 0;
> >  }
> >
> > @@ -1145,7 +1201,7 @@ int tracecmd_update_option(struct tracecmd_output *handle,
> >               return -1;
> >       }
> >
> > -     if (!handle->options_written) {
> > +     if (handle->file_state < TRACECMD_FILE_OPTIONS) {
> >               /* Hasn't been written yet. Just update current pointer */
> >               option->size = size;
> >               memcpy(option->data, data, size);
> > @@ -1203,10 +1259,28 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
> >       return option;
> >  }
> >
> > +int tracecmd_write_cmdlines(struct tracecmd_output *handle)
> > +{
> > +     int ret;
> > +
> > +     ret = check_out_state(handle, TRACECMD_FILE_CMD_LINES);
> > +     if (ret < 0) {
> > +             warning("Cannot write command lines into the file, unexpected state 0x%X",
> > +                     handle->file_state);
> > +             return ret;
> > +     }
> > +     ret = save_tracing_file_data(handle, "saved_cmdlines");
> > +     if (ret < 0)
> > +             return ret;
> > +     handle->file_state = TRACECMD_FILE_CMD_LINES;
> > +     return 0;
> > +}
> > +
> >  struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
> >  {
> >       struct tracecmd_output *handle;
> >       char *path;
> > +     int ret;
> >
> >       handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
> >       if (!handle)
> > @@ -1215,7 +1289,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
> >       /*
> >        * Save the command lines;
> >        */
> > -     if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
> > +     if (tracecmd_write_cmdlines(handle) < 0)
> >               goto out_free;
> >
> >       if (tracecmd_write_cpus(handle, cpus) < 0)
> > @@ -1224,6 +1298,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
> >       if (tracecmd_write_options(handle) < 0)
> >               goto out_free;
> >
> > +     ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
> > +     if (ret < 0) {
> > +             warning("Cannot write latency data into the file, unexpected state 0x%X",
> > +                     handle->file_state);
> > +             goto out_free;
> > +     }
> > +
> >       if (do_write_check(handle, "latency  ", 10))
> >               goto out_free;
> >
> > @@ -1235,6 +1316,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
> >
> >       put_tracing_file(path);
> >
> > +     handle->file_state = TRACECMD_FILE_CPU_LATENCY;
> > +
> >       return handle;
> >
> >  out_free:
> > @@ -1255,6 +1338,13 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
> >       int ret;
> >       int i;
> >
> > +     ret = check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
> > +     if (ret < 0) {
> > +             warning("Cannot write trace data into the file, unexpected state 0x%X",
> > +                     handle->file_state);
> > +             goto out_free;
> > +     }
> > +
> >       if (do_write_check(handle, "flyrecord", 10))
> >               goto out_free;
> >
> > @@ -1340,6 +1430,8 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
> >       free(offsets);
> >       free(sizes);
> >
> > +     handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
> > +
> >       return 0;
> >
> >   out_free:
> > @@ -1356,7 +1448,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
> >       /*
> >        * Save the command lines;
> >        */
> > -     ret = save_tracing_file_data(handle, "saved_cmdlines");
> > +     ret = tracecmd_write_cmdlines(handle);
> >       if (ret)
> >               return ret;
> >
> > @@ -1404,7 +1496,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
> >  {
> >       struct tracecmd_output *handle = NULL;
> >       struct tracecmd_input *ihandle;
> > -     struct tep_handle *pevent;
> >       int fd2;
> >
> >       /* Move the file descriptor to the beginning */
> > @@ -1417,9 +1508,10 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
> >               return NULL;
> >
> >       /* get a input handle from this */
> > -     ihandle = tracecmd_alloc_fd(fd2, 0);
> > +     ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
>
> This change looks like it belongs in a separate patch.

Yes, I'll put it into its own patch, It is just an optimization. When
these flags were introduced recently, I did not check what should
the default state in all use cases.

>
> >       if (!ihandle)
> >               return NULL;
> > +     tracecmd_read_headers(ihandle);
> >
> >       /* move the file descriptor to the end */
> >       if (lseek(fd, 0, SEEK_END) == (off_t)-1)
> > @@ -1432,11 +1524,11 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
> >
> >       handle->fd = fd;
> >
> > -     /* get endian and page size */
> > -     pevent = tracecmd_get_tep(ihandle);
> > -     /* Use the pevent of the ihandle for later writes */
> > +     /* get tep, state, endian and page size */
> > +     handle->file_state = tracecmd_get_file_state(ihandle);
> > +     /* Use the tep of the ihandle for later writes */
> >       handle->pevent = tracecmd_get_tep(ihandle);
> > -     tep_ref(pevent);
> > +     tep_ref(handle->pevent);
> >       handle->page_size = tracecmd_page_size(ihandle);
> >       list_head_init(&handle->options);
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index efd96d27..9396042d 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -3770,7 +3770,7 @@ static void setup_agent(struct buffer_instance *instance,
> >       network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
> >                                                    listed_events);
> >       add_options(network_handle, ctx);
> > -     save_tracing_file_data(network_handle, "saved_cmdlines");
> > +     tracecmd_write_cmdlines(network_handle);
>
> Yeah, I think the above change should be a separate patch.

I think it should be part of this patch, as using the new
tracecmd_write_cmdlines() API is an important part of
the file validation.

Thanks!

>
> Thanks!
>
> -- Steve
>
> >       tracecmd_write_cpus(network_handle, instance->cpu_count);
> >       tracecmd_write_options(network_handle);
> >       tracecmd_msg_finish_sending_data(instance->msg_handle);
> > diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> > index c707a5d5..8366d128 100644
> > --- a/tracecmd/trace-split.c
> > +++ b/tracecmd/trace-split.c
> > @@ -510,7 +510,7 @@ void trace_split (int argc, char **argv)
> >       if (!handle)
> >               die("error reading %s", input_file);
> >
> > -     if (tracecmd_get_flags(handle) & TRACECMD_FL_LATENCY)
> > +     if (tracecmd_get_file_state(handle) == TRACECMD_FILE_CPU_LATENCY)
> >               die("trace-cmd split does not work with latency traces\n");
> >
> >       page_size = tracecmd_page_size(handle);
>

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
