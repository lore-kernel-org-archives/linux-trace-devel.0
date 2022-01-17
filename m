Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A2EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 13:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiAQNnl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiAQNnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 08:43:40 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02CBC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 05:43:40 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c3so21300019pls.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 05:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YaS2sSF8Aqa4uoUeV5LkDFi+g9h7WlgA73H8Htc7nwM=;
        b=C46YC5DULcijC2RSXxpwGkkRoIcdLxjETEJwCaB0w0A/9FG5tZXIDxEyK/Q/vWr1ZB
         lIqJqJLo+XWpocVT1B60GBpMps13QcuKSrer2ZYU8yZG3sdqdiSj2gKDuA1QXXX+D4Ul
         xBNKI/aI/qSZuNu4nOhfBNFz4hVGrHtU8pBlJ3KheHYirAyLY+zcV0aJyOlD/6vexYuw
         qK+LqCw4UVaH4KJPfl7AoTkXVILrUTfVYbygzdI1AONYN9tHzALqn6W+4R/YPXEGf4ET
         O+3VqKgUfLHFjvDXGmCdGwIoOaikJXkimbw4f8CaBcAeaGmq7O8+F/Nt35e1sFEb1MXI
         lqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YaS2sSF8Aqa4uoUeV5LkDFi+g9h7WlgA73H8Htc7nwM=;
        b=4IHSettZbhhovgoNJ7E+xVoNLIgz81exJdO2LB22x6MR/9kh+Gg07Jeqlm4OGzFBKB
         5xNevfDWykxOYptEb3PMIoCZl8UUgUjJTNP+Yeo24sRyl1jq9Mt3BU+h7BKPPaD1kx98
         CKuvlf6423x8HcxbANxU1/qP5jCUxS+iWVV0mPmOLa7VRpIP/RxWBJ66pRp+CoFM5+GF
         efAupD283rJIfBhn26QpY6fr0hgtf/H7UeRxwx5HCHJAnbAHL5tdtqyBkbCmzTSQeAeQ
         Tr4ShAopW7er9jP6M08PCMQpEf56R4qLlf/Xy3kPV0wPF2U7lpGXFgystsc40YwacSse
         qaDw==
X-Gm-Message-State: AOAM5338OcspqBDQxnXzphp+nTbKONNMv+Qzh7hfS30FWVjzr7+zi1Fz
        FF4uLWD5LKQWhoLh8Ahs/yL1kGgnO505OgbXtYfYiaTe2+g=
X-Google-Smtp-Source: ABdhPJzE2BNY+0HohCXlFACDSo4SEbzk4ariMhUh8uRA+zz0tUMStbFPgwbRNJhsA6BXkQhhpjJ1Z0nTGCvu6/x5Ab0=
X-Received: by 2002:a17:902:ab53:b0:149:7902:bc8f with SMTP id
 ij19-20020a170902ab5300b001497902bc8fmr21996513plb.85.1642427020176; Mon, 17
 Jan 2022 05:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-10-tz.stoyanov@gmail.com>
 <20220115101248.09eca50f@rorschach.local.home>
In-Reply-To: <20220115101248.09eca50f@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 15:43:23 +0200
Message-ID: <CAPpZLN7pEM0HiKoF-=YyCPPBMphfWTNXD6KeVe92unejGZuwmg@mail.gmail.com>
Subject: Re: [PATCH v7 09/25] trace-cmd library: Move CPU flyrecord trace
 metadata into the buffer option, for trace file version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 5:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:32 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> I'm going to keep mentioning spacing ;-)
>
> > Extended the BUFFER trace option in trace file version 7 with CPU
> > flyrecord trace metadata. In the version 6 of the trace file, this metadata
> > is located at several places in the file. Part of the metadata is only for
> > the top trace instance, thus limiting per-instance configuration. Moving
> > all CPU trace related metadata in the BUFFER option simplifies the parsing
> > and makes per-instance configuration more flexible. In the new file
> > structure, the top instance is treated as any other instances.
>
> space
>
> > The format of the extended BUFFER option is:
> >  - offset of the buffer in the trace file
> >  - name of the buffer
> >  - trace clock, used in this buffer for events timestamps
> >  - count of CPUs with trace data
> >  - array, describing each CPU with trace data:
> >    - CPU id
> >    - offset of CPU trace data in the trace file
> >    - size of the recorded CPU trace data
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/trace-output.c | 191 +++++++++++++++++++++++++----------
> >  1 file changed, 137 insertions(+), 54 deletions(-)
> >
> > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > index 59093be2..6e40c929 100644
> > --- a/lib/trace-cmd/trace-output.c
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -1675,7 +1675,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
> >  }
> >
> >  static struct tracecmd_option *
> > -add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
> > +add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
> >  {
> >       struct tracecmd_option *option;
> >       char *buf;
> > @@ -1725,8 +1725,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
> >       struct tracecmd_option *option;
> >       struct tracecmd_buffer *buf;
> >
> > +     if (HAS_SECTIONS(handle))
> > +             return 0;
> > +
> >       list_for_each_entry(buf, &handle->buffers, list) {
> > -             option = add_buffer_option(handle, buf->name, buf->cpus);
> > +             option = add_buffer_option_v6(handle, buf->name, buf->cpus);
> >               if (!option)
> >                       return -1;
> >               buf->option = option;
> > @@ -1777,6 +1780,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
> >       return 0;
> >  }
> >
> > +static char *get_clock(struct tracecmd_output *handle)
> > +{
> > +     struct tracefs_instance *inst;
> > +
> > +     if (handle->trace_clock)
> > +             return handle->trace_clock;
> > +
> > +     /*
> > +      * If no clock is set on this handle, get the trace clock of
> > +      * the top instance in the handle's tracing dir
> > +      */
> > +     inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
> > +     if (!inst)
> > +             return NULL;
> > +     handle->trace_clock = tracefs_get_clock(inst);
>
> Why allocate an instance, doesn't:
>
>         tracefs_get_clock(NULL);
>
> do the same? (at least the man page says it does).
>
> Or are you worried that this has to do something with the tracing_dir?
> But do we care?

Yes, because of tracing_dir. I'll add a check:

if (!handle->tracing_dir) {
      handle->trace_clock = tracefs_get_clock(NULL);
      return handle->trace_clock;
}

which is the most common case. If there is tracing_dir associated with
the handle, the old logic should be used - just to be on the safe
side.

>
> > +     tracefs_instance_free(inst);
> > +     return handle->trace_clock;
> > +}
> > +
> > +__hidden struct tracecmd_option *
> > +out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
>
> Again, I think it's safe to remove all the references to v7, and just
> have that be the default.
>
> > +                      unsigned short id, unsigned long long data_offset,
> > +                      int cpus, struct data_file_write *cpu_data)
> > +{
> > +     struct tracecmd_option *option;
> > +     int i, j = 0, k = 0;
> > +     int *cpu_ids = NULL;
> > +     struct iovec *vect;
> > +     char *clock;
> > +
> > +     if (!HAS_SECTIONS(handle))
> > +             return NULL;
> > +
> > +     clock = get_clock(handle);
> > +
> > +     /* Buffer flyrecord option, v7:
>
> Including here (no need to say "v7")
>
> > +      *  - trace data offset in the file
> > +      *  - buffer name
> > +      *  - buffer clock
> > +      *  - CPU count
> > +      *  - for each CPU:
> > +      *    - CPU id
> > +      *    - CPU trace data offset in the file
> > +      *    - CPU trace data size
> > +      */
> > +
> > +     /* Buffer latency option, v7:
>
> and here.
>
> > +      *  - trace data offset in the file
> > +      *  - buffer name
> > +      *  - buffer clock
> > +      */
> > +
> > +     vect = calloc(5 + (cpus * 3), sizeof(struct iovec));
>
> What's with the magical 5 and 3 numbers above?
>
> As from the comments above, I only count 4 and 3.
>
>  4 : offset, name, clock, count
>  3 : cpu offset, name, clock
>
> Could include the above in a comment too.
>
> -- Steve
>
> > +     if (!vect)
> > +             return NULL;
> > +     if (cpus) {
> > +             cpu_ids = calloc(cpus, sizeof(int));
> > +             if (!cpu_ids) {
> > +                     free(vect);
> > +                     return NULL;
> > +             }
> > +     }
> > +     vect[j].iov_base = (void *) &data_offset;
> > +     vect[j++].iov_len = 8;
> > +     vect[j].iov_base = (void *) name;
> > +     vect[j++].iov_len = strlen(name) + 1;
> > +     vect[j].iov_base = (void *) clock;
> > +     vect[j++].iov_len = strlen(clock) + 1;
> > +     if (id == TRACECMD_OPTION_BUFFER) {
> > +             vect[j].iov_base = (void *) &k;
> > +             vect[j++].iov_len = 4;
> > +             for (i = 0; i < cpus; i++) {
> > +                     if (!cpu_data[i].file_size)
> > +                             continue;
> > +                     cpu_ids[i] = i;
> > +                     vect[j].iov_base = &cpu_ids[i];
> > +                     vect[j++].iov_len = 4;
> > +                     vect[j].iov_base = &cpu_data[i].data_offset;
> > +                     vect[j++].iov_len = 8;
> > +                     vect[j].iov_base = &cpu_data[i].write_size;
> > +                     vect[j++].iov_len = 8;
> > +                     k++;
> > +             }
> > +     }
> > +
> > +     option = tracecmd_add_option_v(handle, id, vect, j);
> > +     free(vect);
> > +     free(cpu_ids);
> > +
> > +     return option;
> > +}
> > +
> >  struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
> >  {
> >       struct tracecmd_output *handle;
> > @@ -1847,8 +1942,8 @@ out:
> >       return ret;
> >  }



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
