Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AE2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 14:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiAQOLd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiAQOLd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 09:11:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CD1C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 06:11:32 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n8so8178776plc.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 06:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGbDxvvGlRzzu1OPH+Any3Ox3QX0yXzjhB3ehW0ichY=;
        b=WlWj4PVvJx/3Hiy2VpNJmDuss9WRMKNc0kBFCPD3gsu2EuyvSic9fHK7tM08mF1/G0
         XKtmwLpVd0RGrD7x6Vx8jAHMA5hdyYUi4AwpoGQ4snoAuA6aqZhdV/V4lwP1EAq4aALM
         GZjLBWtuSQFLBAHk0ew9g6Ed5nHzWqXcsWDDBr4zXDOmZeSbo6K/9Yt2118h+ZnAD25G
         0iuowiDljsNo3VEtjNZmZ2Qw7xGaPIbhW0+dgN/OvqSIXJPvIIOiktqg3P5kiD47ZqLV
         4xO7Shg4BKh2kTecYccwY+jxIpiEHVrwuFtoMQld8YT3Ci0jIesLAZqLQ8AndlGqem+s
         qjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGbDxvvGlRzzu1OPH+Any3Ox3QX0yXzjhB3ehW0ichY=;
        b=fJ+fMNLacGlsL/SjauXUzh+l4mNT8U/4SXw3XVNdpb9qlCFhnJuZWo4XSOMgnZaouv
         lDWaV8PNjFdzaP3QFf58dhkzcM8tgSHCsw8jZTaAB5TRDliwooO8xxej6n65x4xi8gXX
         okJsf2ajw6b6HP7NCqeqENGGVWoOHmHhkiF6DLrpUBr+PtpoU+VMrTEspxuDBEmuX+1R
         LBk+XA8dfBV9OPKmUcFxIilfvmLUW1EtMJlPR9HsZ48K6WY4Jue5pbjnqaU6GKMxiBrV
         kmBN4zsIR2OA+8AXm8RXe0hC3SU/sWbNKO2pcgrU2nweAcfEOatv9XAnpGNXSV8soAZk
         FYzw==
X-Gm-Message-State: AOAM530ynXcobZ+/4e7iVtQxVCdQcYYqaqPWvZSX9s38MLvxdbvqcHtD
        MaGUg8gD4f1b4Bo5IV2V+HrAN06qW1SYRXD5WUV+38ML
X-Google-Smtp-Source: ABdhPJwd+E5SeTmB7J972M8VI2yqIlz8lfuGIEhS4z36xjJDKHz78YRAQr7sKsDVfBBQ/FZbLTz3su1ZlVKvY8nrFcs=
X-Received: by 2002:a17:902:d50d:b0:14a:4ed2:2a18 with SMTP id
 b13-20020a170902d50d00b0014a4ed22a18mr22743916plg.44.1642428692207; Mon, 17
 Jan 2022 06:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-12-tz.stoyanov@gmail.com>
 <20220115102050.627f5e89@rorschach.local.home>
In-Reply-To: <20220115102050.627f5e89@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 16:11:16 +0200
Message-ID: <CAPpZLN6MW5N6obt5AzY9_SyFOnxJHbPff70GcSgUAswdoEu8yg@mail.gmail.com>
Subject: Re: [PATCH v7 11/25] trace-cmd library: Fit CPU latency trace data in
 the new trace file version 7 format
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:34 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> More nitpicking about spacing ;-)
>
> > Trace file version 7 format is based on sections. To fit the latency
> > trace data in this structure, a new section and option for it is
> > defined:
> >   BUFFER_TEXT
>
> space
>
> > It is similar to the BUFFER section which holds the flyrecord binary
> > data, but has a latency specific design for text data. The BUFFER_TEXT
> > section has:
> >  - section header, as all other sections
> >  - compression of the trace data, optional
> >  - corresponding trace option, pointing to the section
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  .../include/private/trace-cmd-private.h       |  1 +
> >  lib/trace-cmd/trace-output.c                  | 24 ++++++++++++++++---
> >  2 files changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> > index 047fc26f..d8ee9b74 100644
> > --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> > +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> > @@ -145,6 +145,7 @@ enum {
> >       TRACECMD_OPTION_KALLSYMS,
> >       TRACECMD_OPTION_PRINTK,
> >       TRACECMD_OPTION_CMDLINES,
> > +     TRACECMD_OPTION_BUFFER_TEXT,
> >       TRACECMD_OPTION_MAX,
> >  };
> >
> > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > index 44050dc8..47227728 100644
> > --- a/lib/trace-cmd/trace-output.c
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -1874,7 +1874,9 @@ out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
> >
> >  struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
> >  {
> > +     enum tracecmd_section_flags flags = 0;
> >       struct tracecmd_output *handle;
> > +     tsize_t offset;
> >       char *path;
> >
> >       handle = tracecmd_output_create(output_file);
> > @@ -1891,7 +1893,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
> >
> >       if (tracecmd_write_cpus(handle, cpus) < 0)
> >               goto out_free;
> > -
> > +     if (tracecmd_write_buffer_info(handle) < 0)
> > +             goto out_free;
> >       if (tracecmd_write_options(handle) < 0)
> >               goto out_free;
> >
> > @@ -1901,23 +1904,38 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
> >               goto out_free;
> >       }
> >
> > -     if (do_write_check(handle, "latency  ", 10))
> > +     if (!HAS_SECTIONS(handle) && do_write_check(handle, "latency  ", 10))
> >               goto out_free;
> >
> >       path = get_tracing_file(handle, "trace");
> >       if (!path)
> >               goto out_free;
> >
> > +     offset = do_lseek(handle, 0, SEEK_CUR);
> > +     if (HAS_SECTIONS(handle) &&
> > +         !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
> > +             goto out_free;
> > +
> > +     offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
> > +                                       "buffer latency", flags, false);
> > +
> >       copy_file(handle, path);
> > +     if (out_update_section_header(handle, offset))
> > +             goto out_free;
> >
> >       put_tracing_file(path);
> >
> >       handle->file_state = TRACECMD_FILE_CPU_LATENCY;
> >
> > +     if (HAS_SECTIONS(handle))
> > +             tracecmd_write_options(handle);
> > +
> >       return handle;
>
>
> >
> >  out_free:
> > -     tracecmd_output_close(handle);
> > +     if (handle)
> > +             tracecmd_output_close(handle);
> > +     unlink(output_file);
>
> Hmm, how does the above play a role in this patch?
>
> That is, what about this new BUFFER_TEXT required this change?
> I mean, output_file is being removed now, but I don't see anything in
> the rest of the patch to warrant that?
>

That looks like a leftover from a previous version of this patch.

> -- Steve
>
>
> >       return NULL;
> >  }
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
