Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96B8C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 12:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF4360F4B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 12:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344670AbhIBMrl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 08:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344561AbhIBMrk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 08:47:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4C4C061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Sep 2021 05:46:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w8so1804006pgf.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Sep 2021 05:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iieEQblvk9LYFlzIbuFZp4/qrdi2iLFxbbIEwgs3ozE=;
        b=WMQa5q6e8GGLdCp/yGfZ2GbvDqn0y0YRgUVxzncB1hwcYsTfuVeDtRDmQrHORvpfen
         q2cz3fvEhygVnQTXgD6EIOqxNmIbPanrB108VaYSdnNnSqVhSLxGolPRr7SSn9fuySeD
         SLlhehqPLlts1oiaykVQZXrnmR9EPXMGl4tBWE3HJHAduAtr9vvlnH037VfttCZDcsPZ
         sDF13uOiC5XzTsCSkCUstPBnZneRF5g27inzeCWLTQw3WLWN3pNKQOhi2+COY6OJtR6Z
         yWj7HIZ+uxE8GkXoqGbcYPVm9nJGORB6ApMAsz5oZ1tUsnpFFGyaZUawjz5ljQIJul4x
         PxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iieEQblvk9LYFlzIbuFZp4/qrdi2iLFxbbIEwgs3ozE=;
        b=K+kqV4inIbJOtnRHnVfd0zt7Dbd6cqSa1sruB0r7tL9nqzqLLcf2jsN4jhcHkAfwGc
         aogYKJyPzcCrqIta46xjANhTXPT5+WkIsqA8lWR+vuLiJwPnMutXvPE0rzd/mbAv5Kbd
         aqyvBoC3u8sp4hoELZHjPBSc0uW+r4UOlPFYMjUZ8E++IxaLahl0AQDc4V9D+tkgUvnM
         qqFTApfWJ3DoFvZTw3YrD5LZ4yzujqCl2NZ1yqAV+ujxO9ZEdG1pu8iyoVRS7jCBmMiS
         bCsFofkk6UE75jlQWW7YOXn4pJotoWmEhFg43sM9aQ36IZH8A92BYI1pOCduwbS0axZM
         wk/g==
X-Gm-Message-State: AOAM533hN+gZJEngy6cPGQgqcBSeu1PZC+dLD2SJogGhiEcNzhotflFZ
        1wlzKAB3CgnEtm6A8HhmPgNiWXlUaAp742VVz1aGqG0vppwqlQ==
X-Google-Smtp-Source: ABdhPJzFrayWJeO0ag87LqEuPK4Lm7dTNgdmJwxu5GJ70sbbcQPOFPePukJ96j3QTmmSJib0GxjIASA6nx1DFN6pbco=
X-Received: by 2002:a62:38c9:0:b0:3f2:6ab2:1828 with SMTP id
 f192-20020a6238c9000000b003f26ab21828mr3301979pfa.37.1630586801618; Thu, 02
 Sep 2021 05:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210729050959.12263-1-tz.stoyanov@gmail.com> <20210729050959.12263-52-tz.stoyanov@gmail.com>
 <20210819151807.36cc5868@oasis.local.home>
In-Reply-To: <20210819151807.36cc5868@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 2 Sep 2021 15:46:25 +0300
Message-ID: <CAPpZLN5CGPAa-BiUxdnvGGedFecVenSdgY-793kV8Li=wfw3UA@mail.gmail.com>
Subject: Re: [PATCH v2 51/87] trace-cmd library: Extend the input handler with
 trace data decompression context
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 19, 2021 at 10:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 29 Jul 2021 08:09:23 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > The CPU tarce data is compressed in chunks, as chunk's size is multiple
>
> typos.
>
> > trace pages. The input handler is extended with the necessary
> > structures, to control the data decompression. There are two approaches
> > for data decompression, both are supported and can be used in different
> > use cases:
> >  - in-memory decompression, page by page.
> >  - using a temporary file
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/trace-input.c | 66 ++++++++++++++++++++++++++++++-------
> >  1 file changed, 54 insertions(+), 12 deletions(-)
> >
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 520d611f..6fb63c0f 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -29,6 +29,9 @@
> >
> >  #define COMMIT_MASK ((1 << 27) - 1)
> >
> > +/* force uncompressing in memory */
> > +#define INMEMORY_DECOMPRESS
>
> I wonder if we should just make this a variable in the handle, and
> default it to in memory. Then it will be easy to change it from the
> command line if we want to.

There is "read_zpage", introduced in this patch. It controls whether
to use in memory decompression. The define is used to set the default
value of  read_zpage, when the handler is allocated.

>
> -- Steve
>
> > +
> >  /* for debugging read instead of mmap */
> >  static int force_read = 0;
> >
> > @@ -54,6 +57,24 @@ struct page {
> >  #endif
> >  };
> >
> > +struct zchunk_cache {
> > +     struct list_head                list;
> > +     struct tracecmd_compress_chunk *chunk;
> > +     void                            *map;
> > +     int                             ref;
> > +};
> > +
> > +struct cpu_zdata {
> > +     /* uncompressed cpu data */
> > +     int                     fd;
> > +     char                    file[26]; /*
> > strlen(COMPR_TEMP_FILE) */
> > +     unsigned int            count;
> > +     unsigned int            last_chunk;
> > +     struct list_head        cache;
> > +     struct tracecmd_compress_chunk  *chunks;
> > +};
> > +
> > +#define COMPR_TEMP_FILE "/tmp/trace_cpu_dataXXXXXX"
> >  struct cpu_data {
> >       /* the first two never change */
> >       unsigned long long      file_offset;
> > @@ -72,6 +93,7 @@ struct cpu_data {
> >       int                     page_cnt;
> >       int                     cpu;
> >       int                     pipe_fd;
> > +     struct cpu_zdata        compress;
> >  };
> >
> >  struct cpu_file_data {
> > @@ -150,6 +172,8 @@ struct tracecmd_input {
> >       bool                    use_trace_clock;
> >       bool                    read_page;
> >       bool                    use_pipe;
> > +     bool                    read_zpage; /* uncompress pages
> > in memory, do not use tmp files */
> > +     bool                    cpu_compressed;
> >       int                     file_version;
> >       struct cpu_data         *cpu_data;
> >       long long               ts_offset;
> > @@ -3284,7 +3308,7 @@ static int read_cpu_data(struct tracecmd_input
> > *handle) unsigned long long offset;
> >
> >               handle->cpu_data[cpu].cpu = cpu;
> > -
> > +             handle->cpu_data[cpu].compress.fd = -1;
> >               handle->cpu_data[cpu].kbuf =
> > kbuffer_alloc(long_size, endian); if (!handle->cpu_data[cpu].kbuf)
> >                       goto out_free;
> > @@ -3701,6 +3725,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int
> > fd, int flags) /* By default, use usecs, unless told otherwise */
> >       handle->flags |= TRACECMD_FL_IN_USECS;
> >
> > +#ifdef INMEMORY_DECOMPRESS
> > +     handle->read_zpage = 1;
> > +#endif
> >       if (do_read_check(handle, buf, 3))
> >               goto failed_read;
> >
> > @@ -3915,6 +3942,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
> >   */
> >  void tracecmd_close(struct tracecmd_input *handle)
> >  {
> > +     struct zchunk_cache *cache;
> >       struct file_section *del_sec;
> >       int i;
> >
> > @@ -3933,17 +3961,31 @@ void tracecmd_close(struct tracecmd_input
> > *handle) /* The tracecmd_peek_data may have cached a record */
> >               free_next(handle, i);
> >               free_page(handle, i);
> > -             if (handle->cpu_data && handle->cpu_data[i].kbuf) {
> > -                     kbuffer_free(handle->cpu_data[i].kbuf);
> > -                     if (handle->cpu_data[i].page_map)
> > -
> > free_page_map(handle->cpu_data[i].page_map); -
> > -                     if (handle->cpu_data[i].page_cnt)
> > -                             tracecmd_warning("%d pages still
> > allocated on cpu %d%s",
> > -
> > handle->cpu_data[i].page_cnt, i,
> > -
> > show_records(handle->cpu_data[i].pages,
> > -
> > handle->cpu_data[i].nr_pages));
> > -                     free(handle->cpu_data[i].pages);
> > +             if (handle->cpu_data) {
> > +                     if (handle->cpu_data[i].kbuf) {
> > +
> > kbuffer_free(handle->cpu_data[i].kbuf);
> > +                             if (handle->cpu_data[i].page_map)
> > +
> > free_page_map(handle->cpu_data[i].page_map); +
> > +                             if (handle->cpu_data[i].page_cnt)
> > +                                     tracecmd_warning("%d pages
> > still allocated on cpu %d%s",
> > +
> > handle->cpu_data[i].page_cnt, i,
> > +
> > show_records(handle->cpu_data[i].pages,
> > +
> >  handle->cpu_data[i].nr_pages));
> > +                             free(handle->cpu_data[i].pages);
> > +                     }
> > +                     if (handle->cpu_data[i].compress.fd >= 0) {
> > +
> > close(handle->cpu_data[i].compress.fd);
> > +
> > unlink(handle->cpu_data[i].compress.file);
> > +                     }
> > +                     while
> > (!list_empty(&handle->cpu_data[i].compress.cache)) {
> > +                             cache =
> > container_of(handle->cpu_data[i].compress.cache.next,
> > +                                                  struct
> > zchunk_cache, list);
> > +                             list_del(&cache->list);
> > +                             free(cache->map);
> > +                             free(cache);
> > +                     }
> > +                     free(handle->cpu_data[i].compress.chunks);
> >               }
> >       }
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
