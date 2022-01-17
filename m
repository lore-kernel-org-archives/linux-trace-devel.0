Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9945BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 16:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbiAQQL4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 11:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbiAQQLz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 11:11:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17CAC06161C
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 08:11:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso30524476pjm.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 08:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/1Cxw1ivX/utQz13y7mqCXOeaUvR7Wdgh98fZIqDWsM=;
        b=g65qWuGXFa9u6V9pH9B384y/qR3Y9TpPS36JTKb/GZgDF/ZQ0rlZN54izgth6d55EP
         ReQcvOvDuOxSxfCgyS8sKcntUTdxMCUvgrXiU/vHb7r6gilk2xuXXA1DCoX+yqyo2mWr
         Wlk/ayfNay1xDnvaMqNpOPv0mIiX+RtRFxJ5Uq07rdtP+g6cYOUxd79hiEkjBj74F1RY
         SAy3KOvvGbIEHDnmD9y2XZ1obldINwzW7lX9DJ01nhF030UiW+wB66aF4y1vLz3jZaLA
         k0rT+7Zte1Hm1phz6kKy0l44g8cFOq2h7YEWH3RjUE0it5BqKsFelggpUWu6xBe1NQOV
         k/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/1Cxw1ivX/utQz13y7mqCXOeaUvR7Wdgh98fZIqDWsM=;
        b=6Efz9auloTmBFsZMCUq8isk4nyVyNNPSAdjl0AMFBUFu6A983Bhl+1+gMAXZoitrS0
         RZ6xS+IZWOPlnWt8X51oLkZKNtms14C4SzoLeOllK6lKB6Mx4bKspZDTK+tstc9XmX3e
         2btwokcIr9PO6P5XRzW7iyNEfVg6VNbgep/dl3R6LvOkHLA1YHl4NDfGHdIxUfz38b9I
         BGrRT7f4o6MtMOWIwMzCaVpQqeeEm8CH/udYsNBCIdWSrqOqnaZ5kNn6KCQSocsiT52u
         9SmEV88hodmM3IM/b1n/iYG3vEOdQcXbuHTEc+a9bNEP55Zj2zapr2IYDqlpknOlXgZw
         uZdw==
X-Gm-Message-State: AOAM533s5MqtbrFOA8s7cPrlEY2oAmM77G9KvOfuFi8u5vEdm5JbofON
        GowQSmWgxsE5dfKzzPHJ7LfigR319WyCUEu9ZtYgwJx4jY0=
X-Google-Smtp-Source: ABdhPJzJ/hqFnH5VhprBjiWr1zSuML8PlZtSXqcogvnQkPhVnsGD5edz6/7lT9TW+GrxlrP5MFUI3/2G6LKwPRyUdk8=
X-Received: by 2002:a17:902:d50d:b0:14a:4ed2:2a18 with SMTP id
 b13-20020a170902d50d00b0014a4ed22a18mr23258868plg.44.1642435915108; Mon, 17
 Jan 2022 08:11:55 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-18-tz.stoyanov@gmail.com>
 <20220115110445.6ea63c4a@gandalf.local.home>
In-Reply-To: <20220115110445.6ea63c4a@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 18:11:38 +0200
Message-ID: <CAPpZLN58EfUYk7uik0YWERcpvFXA=D_EpXdjjn-RTsQuYRNpnQ@mail.gmail.com>
Subject: Re: [PATCH v7 17/25] trace-cmd library: Read strings sections on file load
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 6:04 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:40 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Internal strings database is added to trace input handle, containing all
> > metadata strings from trace file. When a trace file is opened, all
> > strings sections are located and the internal strings database is
> > initialised.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/include/trace-cmd-local.h |  1 +
> >  lib/trace-cmd/trace-input.c             | 64 +++++++++++++++++++++++++
> >  lib/trace-cmd/trace-output.c            |  1 +
> >  3 files changed, 66 insertions(+)
> >
> > diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> > index 4a0a691c..ac7e7f17 100644
> > --- a/lib/trace-cmd/include/trace-cmd-local.h
> > +++ b/lib/trace-cmd/include/trace-cmd-local.h
> > @@ -53,5 +53,6 @@ struct cpu_data_source {
> >  int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
> >                      struct cpu_data_source *data, const char *buff_name);
> >  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
> > +unsigned int get_meta_strings_size(struct tracecmd_input *handle);
> >
> >  #endif /* _TRACE_CMD_LOCAL_H */
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 9027729e..6cc8ee90 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -147,6 +147,9 @@ struct tracecmd_input {
> >       long long               ts_offset;
> >       struct tsc2nsec         tsc_calc;
> >
> > +     unsigned int            strings_size;   /* size of the metadata strings */
> > +     char                    *strings;       /* metadata strings */
> > +
> >       struct host_trace_info  host;
> >       double                  ts2secs;
> >       char *                  cpustats;
> > @@ -984,6 +987,14 @@ static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_sta
> >
> >  static int handle_options(struct tracecmd_input *handle);
> >
> > +static const char *get_metadata_string(struct tracecmd_input *handle, int offset)
> > +{
> > +     if (!handle || !handle->strings || offset < 0 || handle->strings_size >= offset)
> > +             return NULL;
> > +
> > +     return handle->strings + offset;
> > +}
> > +
> >  static int read_section_header(struct tracecmd_input *handle, unsigned short *id,
> >                              unsigned short *flags, unsigned long long *size, const char **description)
> >  {
> > @@ -1007,6 +1018,8 @@ static int read_section_header(struct tracecmd_input *handle, unsigned short *id
> >               *flags = fl;
> >       if (size)
> >               *size = sz;
> > +     if (description)
> > +             *description = get_metadata_string(handle, desc);
> >
> >       return 0;
> >  }
> > @@ -2839,6 +2852,11 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
> >       return lib;
> >  }
> >
> > +__hidden unsigned int get_meta_strings_size(struct tracecmd_input *handle)
> > +{
> > +     return handle->strings_size;
> > +}
> > +
> >  static int handle_options(struct tracecmd_input *handle)
> >  {
> >       long long offset;
> > @@ -3472,6 +3490,50 @@ struct hook_list *tracecmd_hooks(struct tracecmd_input *handle)
> >       return handle->hooks;
> >  }
> >
> > +static int init_metadata_strings(struct tracecmd_input *handle, int size)
> > +{
> > +     char *tmp;
> > +
> > +     tmp = realloc(handle->strings, handle->strings_size + size);
>
> Hmm, I don't remember in our conversations. Did we say we would have more
> than one string section? Or allow it to be broken up? How do offsets work
> in such cases?
>
> I was thinking that we could simply mmap the string section, but that won't
> work if there's more than one.
>

The first implementation was with a single string section at the end
of the file. But when I tested that design with the trace-cmd
guest-host tracing, I realized it is impossible to work without major
changes in the host-guest protocol. The problem is that in the current
host-guest tracing logic, part of the guest metadata file is written
in the guest context, part in the host context. Each of these parts
can put strings in the string section. That will change the way guest
metadata is written. That's why decided to use multiple string
sections in the file. On file read the strings from all sections are
stored into one memory block, and string offset is the offset in that
block. As these sections are compressed usually, simple mmap will not
work even in case of single section.

> -- Steve
>
>
[...]


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
