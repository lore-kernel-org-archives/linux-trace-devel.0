Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E8EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 17:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242820AbiAQRTC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 12:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243492AbiAQRSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 12:18:23 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA82DC061A7D
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 09:12:32 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id q25so4998559pfl.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 09:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/FdWOnFCGfBqfl8Lq0Drx+7BnWUpZLxYLVWOGWFBK8M=;
        b=KC1iOJDPmPcOhTLq6lrH1BoaWkq8uTQBC0suGJb22TJDI4jFJs2SM7ciyZml6q3fRv
         d/3wAhof9laHtm0kByeb52fwZJEsvUOt3vCUB0nZ+nXYScguAy2tyjjjPUZL2MqAiiWr
         ctKfIEQ44V4GLlcr9bdyv4zZRY3w6vdRBCikacaxvsd85DwkSX1qsayzkOvMAoVQG78G
         ls1fM6M7ifD8PmTCw6myRjEFHp8+UEgOUQ3cEap5rQqP0LUwB/o/srhU98DB2pbA/J9P
         d1vj8Aa5Wv+FOFeMU/hZOlUF+mebzcr48I7cQWqSuFyFFAME9meRyeFXcZ4IC6QB6ith
         rJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/FdWOnFCGfBqfl8Lq0Drx+7BnWUpZLxYLVWOGWFBK8M=;
        b=JK1PrqahirCT8rhF7MYov2kHY0II2Kwk+67COjTEIl/aEJmp86sWcIu/GN1PwEsdvp
         iO40iqk27frfEBosXhpJB/ovvJEf14SJ4RmhzWwXFnFNFJgJabaz483hXhwimAcq+zKP
         VB2i0QJrQ8PBmP5ONTeQeko9ARJXcgL0NFUGc33R6l2FC95rwRwE+Jtt07O+E84CP78d
         fIkZwlezp/S9HvPS+3LdYj7/E6HXVWGBmclessnr0b1pTfZ8aBZi6wzJmTgnnYJfhYzk
         +teTModp43y7fx5cW+iKrCCkZeKYjOj3XiO0xNuNnHNiEuxn61B6XberoPAH6ADh8DVJ
         H3Tw==
X-Gm-Message-State: AOAM530tPLGMsiUSzn+R54Zheam6tFkE6gsLWjkFOfRSmJXGoOT4OX8z
        04m5AetmGxjsfDj/pj/nb9nzXWfhr+zvNzZisP0=
X-Google-Smtp-Source: ABdhPJxSbHzSqDp4LS8hsTjziFhnUjJ+l5PM4ImAyAZedUh5jTVnHCDQQMGXjvx8/5jOJ41cpFZL58tIryQs2Ogq4dA=
X-Received: by 2002:a63:1910:: with SMTP id z16mr15399355pgl.323.1642439552097;
 Mon, 17 Jan 2022 09:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20211210105448.97850-1-tz.stoyanov@gmail.com> <20211210105448.97850-8-tz.stoyanov@gmail.com>
 <20220115095705.05c80eb9@rorschach.local.home>
In-Reply-To: <20220115095705.05c80eb9@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jan 2022 19:12:15 +0200
Message-ID: <CAPpZLN4FkKfqbFVj2dxmn7ScFnoiugq0BN9nkaJhmL0Ld1hD=g@mail.gmail.com>
Subject: Re: [PATCH v7 07/25] trace-cmd library: Add multiple options sections
 in trace file version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Jan 15, 2022 at 4:57 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 10 Dec 2021 12:54:30 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> Nit, paragraphs should really be separated by spaces ;-)
>
> > Introduced chain of options sections in trace file version 7. Extended
> > the "DONE" option to hold the offset into the file to the next options
> > section.
>
> > Format of trace file version 7 is extended with a new mandatory field
> > after the compression algorithm header:
>
> >  <8 bytes>, unsigned long long integer - offset into the trace file
> > where the first options section is located. This allows to place this
> > section anywhere in the file. As all other sections have corresponding
> > options, describing their offsets into the trace file, this change makes
> > the structure of trace file version 7 flexible.
>
> Makes it easier to read. Especially when you get older and your eyes
> don't work as well.
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/trace-output.c | 103 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 96 insertions(+), 7 deletions(-)
> >
> > diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> > index aa55aad7..6e07fece 100644
> > --- a/lib/trace-cmd/trace-output.c
> > +++ b/lib/trace-cmd/trace-output.c
> > @@ -64,7 +64,7 @@ struct tracecmd_output {
> >       unsigned long           file_version;
> >       unsigned long           strings_p;
> >       unsigned long           strings_offs;
> > -     size_t                  options_start;
> > +     tsize_t                 options_start;
>
> I have to ask. Why use tsize_t? (I see it used elsewhere as well, but
> just really noticed it now)
>
> The only reference to tsize_t I see in the wild is for libtiff.

That is the comment where tsize_t is defined, at the top of this file:
    /* We can't depend on the host size for size_t, all must be 64 bit */

As I understand, on 32 bit arch, size_t is 32 bit. "options_start" is
offset in the file, it should be always 64 bit. I can just use
"unsigned long long" instead.


>
> >       bool                    big_endian;
> >
> >       struct list_head        options;
> > @@ -89,6 +89,7 @@ struct list_event_system {
> >
> >  #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
> >
> > +static int write_options_v7(struct tracecmd_output *handle);
>
> I'm thinking that since v7 will be the main method, we could just
> remove all the references to "v7", as we don't know if v8 will use this
> as well. That is, the old versions should be labeled as such ("v6"),
> but the new versions shouldn't have to be.
>
> >  static int save_string_section(struct tracecmd_output *handle);
> >
> >  static stsize_t
> > @@ -218,6 +219,9 @@ void tracecmd_output_close(struct tracecmd_output *handle)
> >               return;
> >
> >       if (handle->file_version >= FILE_VERSION_SECTIONS) {
> > +             /* write any unsaved options at the end of trace files with sections */
> > +             write_options_v7(handle);
> > +
> >               /* write strings section */
> >               save_string_section(handle);
> >       }
> > @@ -1295,6 +1299,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
> >   */
> >  static int output_write_init(struct tracecmd_output *handle)
> >  {
> > +     unsigned long long offset;
> >       char buf[BUFSIZ];
> >       int endian4;
> >
> > @@ -1328,6 +1333,14 @@ static int output_write_init(struct tracecmd_output *handle)
> >       endian4 = convert_endian_4(handle, handle->page_size);
> >       if (do_write_check(handle, &endian4, 4))
> >               return -1;
> > +     if (HAS_SECTIONS(handle)) {
> > +             /* Write 0 as options offset and save its location */
> > +             offset = 0;
> > +             handle->options_start = do_lseek(handle, 0, SEEK_CUR);
> > +             if (do_write_check(handle, &offset, 8))
> > +                     return -1;
> > +     }
> > +
> >       handle->file_state = TRACECMD_FILE_INIT;
> >       return 0;
> >  }
> > @@ -1396,7 +1409,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
> >        * We can only add options before tracing data were written.
> >        * This may change in the future.
> >        */
> > -     if (handle->file_state > TRACECMD_FILE_OPTIONS)
> > +     if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
> >               return NULL;
> >
> >       for (i = 0; i < count; i++)
> > @@ -1409,8 +1422,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
> >                       return NULL;
> >               }
> >       }
> > -
> > -     option = malloc(sizeof(*option));
> > +     option = calloc(1, sizeof(*option));
> >       if (!option) {
> >               tracecmd_warning("Could not allocate space for option");
> >               free(data);
> > @@ -1473,7 +1485,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
> >       return 0;
> >  }
> >
> > -int tracecmd_write_options(struct tracecmd_output *handle)
> > +static int write_options_v6(struct tracecmd_output *handle)
> >  {
> >       struct tracecmd_option *options;
> >       unsigned short option;
> > @@ -1491,7 +1503,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
> >
> >       if (do_write_check(handle, "options  ", 10))
> >               return -1;
> > -
> > +     handle->options_start = do_lseek(handle, 0, SEEK_CUR);
> >       list_for_each_entry(options, &handle->options, list) {
> >               endian2 = convert_endian_2(handle, options->id);
> >               if (do_write_check(handle, &endian2, 2))
> > @@ -1515,6 +1527,70 @@ int tracecmd_write_options(struct tracecmd_output *handle)
> >               return -1;
> >
> >       handle->file_state = TRACECMD_FILE_OPTIONS;
> > +     return 0;
> > +}
> > +
> > +static int write_options_v7(struct tracecmd_output *handle)
> > +{
> > +     struct tracecmd_option *options;
> > +     unsigned long long endian8;
> > +     unsigned short endian2;
> > +     unsigned int endian4;
> > +     bool new = false;
> > +     tsize_t offset;
> > +
> > +     /* Check if there are unsaved options */
> > +     list_for_each_entry(options, &handle->options, list) {
> > +             if (!options->offset) {
> > +                     new = true;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (!new)
> > +             return 0;
> > +     offset = do_lseek(handle, 0, SEEK_CUR);
>
> The spacing is backwards above. You can remove the space before the
>  "if (!new)" and add one after the if condition.
>
> The if check is the result of the previous loop, and should be
> associated with it, just like one would do in any language.
>
> Code spacing is important. It should be used to show how lines of code
> are associated with each other, just like paragraphs in text.
>
> > +     /* Append to the previous options section, if any */
> > +     if (handle->options_start) {
> > +             if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
> > +                     return -1;
> > +             endian8 = convert_endian_8(handle, offset);
> > +             if (do_write_check(handle, &endian8, 8))
> > +                     return -1;
> > +             if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
> > +                     return -1;
> > +     }
>
> space
>
> > +     offset = out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
> > +     if (offset == (off_t)-1)
> > +             return -1;
>
> space.
>
> > +     list_for_each_entry(options, &handle->options, list) {
> > +             /* Option is already saved, skip it */
> > +             if (options->offset)
> > +                     continue;
> > +             endian2 = convert_endian_2(handle, options->id);
> > +             if (do_write_check(handle, &endian2, 2))
> > +                     return -1;
> > +             endian4 = convert_endian_4(handle, options->size);
> > +             if (do_write_check(handle, &endian4, 4))
> > +                     return -1;
> > +             /* Save the data location */
> > +             options->offset = do_lseek(handle, 0, SEEK_CUR);
> > +             if (do_write_check(handle, options->data, options->size))
> > +                     return -1;
> > +     }
> > +
> > +     endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
> > +     if (do_write_check(handle, &endian2, 2))
> > +             return -1;
> > +     endian4 = convert_endian_4(handle, 8);
> > +     if (do_write_check(handle, &endian4, 4))
> > +             return -1;
> > +     endian8 = 0;
> > +     handle->options_start = do_lseek(handle, 0, SEEK_CUR);
> > +     if (do_write_check(handle, &endian8, 8))
> > +             return -1;
> > +     if (out_update_section_header(handle, offset))
> > +             return -1;
> >
> >       return 0;
> >  }
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
