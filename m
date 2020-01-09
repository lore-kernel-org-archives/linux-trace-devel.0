Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97192C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 14:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 513432067D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 14:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOPfTjvP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgAIOOk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 09:14:40 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37439 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731533AbgAIOOj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 09:14:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so3289284pga.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 06:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9LBTIUpvlgVyKtj3BWCd30m2mj6ibX0v/euXISihp8A=;
        b=UOPfTjvPFamn9uBWhMOFbPZzY+agfU5iPMS8URxql4Y3hknIjSP8xtGw9wGxWt+Y/s
         EoYKfzZOgLjWYLXhQ8uabeOkLvisFj03qGvukrOPEopl+KOm8h4+ej/4A5oKcXPE06qU
         Qs+7goiBqnpIzGZEXGLDT4H0Enn8NRkDE4alOSJJgEfA+CmiaZf391Xh0bxJweHQrck9
         jxzGzg2It5cCUdvO05G5hO4pNtKT4ApccxwGritGpQAkqaxa2Oo7ZMrQcxPzoGGrlnCX
         QzgQRda4Cq9DxvbjwR32tVzzB+6F+NmS2zNuf2ysdaP+UQRAfOOvOYdA58vCKiAxH+iH
         f08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9LBTIUpvlgVyKtj3BWCd30m2mj6ibX0v/euXISihp8A=;
        b=QIqjKkImnrxMAOoAebSZwo4ywVhcLyL2SVijxQn1AamDNAScSAmM2tE/jC0KjxBNrw
         8Y2ZqH1Fna4YI8bbEZpezrAfPIuRetJDp3K2OhnVfDsTAShwLM9GaRwEweJ5lCsKKera
         LyrkI4RtcAP83UwuW4S81Bthym0rR4QWWdUQwL1KaVbZPBxXLjW8ByZJxmkQoUJA446X
         zX4OZ+goHFlKzFiyReZ/gd7J4DpX6asYOt6CKVx/xOllI/XE2BIW6GBP8ZpLm3uMmzY4
         0UeSdvw5L0Qa65V1iGi7o/48Y3W6YYj9uP1bqs8Z+wDd7bJkP286anmK1ZyDtdxXakUH
         lhBA==
X-Gm-Message-State: APjAAAWqacsNArPXyIba1I1bwdEnp1h1WHJlPICfetC6h8qPr5t33Qbt
        J98wymonrXhnYlBxBiFQqDh6qrfVlu2J3YaMng38JrpTsJg=
X-Google-Smtp-Source: APXvYqxSYzXH1haiIs7uRowbCokbcbeKQqlLA5UGOPHeU9AvGK3RmmZty3YfnKoQwnRrKyzpjrlZl5M+07jl6Q08P4k=
X-Received: by 2002:a62:1613:: with SMTP id 19mr11735244pfw.7.1578579278774;
 Thu, 09 Jan 2020 06:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20200106154058.60660-1-tz.stoyanov@gmail.com> <20200106154058.60660-5-tz.stoyanov@gmail.com>
 <20200108160918.32d81c4a@gandalf.local.home>
In-Reply-To: <20200108160918.32d81c4a@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 9 Jan 2020 16:14:27 +0200
Message-ID: <CAPpZLN6btoinjnxL7Gv5bgyc1f1==WRJsshXqD6sqtne2Y=rNw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] trace-cmd,kernel-shark: New libtracefs APIs for
 ftrace events and systems
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 8, 2020 at 11:09 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  6 Jan 2020 17:40:57 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
>
> > --- /dev/null
> > +++ b/lib/tracefs/tracefs-events.c
> > @@ -0,0 +1,476 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +/*
> > + * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * Updates:
> > + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> > + *
> > + */
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <dirent.h>
> > +#include <unistd.h>
> > +#include <errno.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +
> > +#include "kbuffer.h"
> > +#include "tracefs.h"
> > +#include "tracefs-local.h"
> > +
> > +/**
> > + * tracefs_read_page_record - read a record off of a page
> > + * @tep: tep used to parse the page
> > + * @page: the page to read
> > + * @size: the size of the page
> > + * @last_record: last record read from this page
> > + *
> > + * If a ring buffer page is available, and the need to parse it
> > + * without having a handle, then this function can be used
>
> Not having a handle to what? Ah, I wrote this back in 2011. And that
> "handle" meant a tracecmd_input_handle. Hmm, I think we need a
> tracefs_handle of some sort for this, because it will slow down
> tracefs_iterate_raw_events() very much so).
>
I'm not sure how tracefs_handle could speed up the events iteration,
but I can think about it in a context of a different patch. The
current patch set
is just a skeleton of the new library, most of the code is moved from
the application
or libtracecmd with almost no modifications.

>
> > + *
> > + * The @tep needs to be initialized to have the page header information
> > + * already available.
> > + *
> > + * The @last_record is used to know where to read the next record from
> > + * If @last_record is NULL, the first record on the page will be read
> > + *
> > + * Returns:
> > + *  A newly allocated record that must be freed with free_record() if
>
> Hmm, free_record() needs a prefix ("tracefs_") ?
Actually free_record() is not exported as libtracefs API, which is
confusing. There is
free_record() libtracecmd API, which is used in the trace-cmd context. May be it
is better to have tracefs_free_record() , or to use the one from libtracecmd ?

>
> > + *  a record is found. Otherwise NULL is returned if the record is bad
> > + *  or no more records exist
> > + */
> > +struct tep_record *
> > +tracefs_read_page_record(struct tep_handle *tep, void *page, int size,
> > +                       struct tep_record *last_record)
> > +{
> > +     unsigned long long ts;
> > +     struct kbuffer *kbuf;
> > +     struct tep_record *record = NULL;
> > +     enum kbuffer_long_size long_size;
> > +     enum kbuffer_endian endian;
> > +     void *ptr;
> > +
> > +     if (tep_is_file_bigendian(tep))
> > +             endian = KBUFFER_ENDIAN_BIG;
> > +     else
> > +             endian = KBUFFER_ENDIAN_LITTLE;
> > +
> > +     if (tep_get_header_page_size(tep) == 8)
> > +             long_size = KBUFFER_LSIZE_8;
> > +     else
> > +             long_size = KBUFFER_LSIZE_4;
> > +
> > +     kbuf = kbuffer_alloc(long_size, endian);
> > +     if (!kbuf)
> > +             return NULL;
> > +
> > +     kbuffer_load_subbuffer(kbuf, page);
> > +     if (kbuffer_subbuffer_size(kbuf) > size) {
> > +             warning("%s: page_size > size", __func__);
> > +             goto out_free;
> > +     }
> > +
> > +     if (last_record) {
> > +             if (last_record->data < page || last_record->data >= (page + size)) {
> > +                     warning("%s: bad last record (size=%u)",
> > +                             __func__, last_record->size);
> > +                     goto out_free;
> > +             }
> > +
> > +             ptr = kbuffer_read_event(kbuf, &ts);
> > +             while (ptr < last_record->data) {
>
> Here we are doing a linear search of last_record.
>
> I could probably add a quicker solution to this by finding the next
> record by passing in last_record->data and last_record->ts to a kbuffer
> function, at the bottom.
>
>
> > +                     ptr = kbuffer_next_event(kbuf, NULL);
> > +                     if (!ptr)
> > +                             break;
> > +                     if (ptr == last_record->data)
> > +                             break;
> > +             }
> > +             if (ptr != last_record->data) {
> > +                     warning("$s: could not find last_record", __func__);
> > +                     goto out_free;
> > +             }
> > +             ptr = kbuffer_next_event(kbuf, &ts);
> > +     } else
> > +             ptr = kbuffer_read_event(kbuf, &ts);
> > +
> > +     if (!ptr)
> > +             goto out_free;
> > +
> > +     record = malloc(sizeof(*record));
> > +     if (!record)
> > +             return NULL;
> > +     memset(record, 0, sizeof(*record));
> > +
> > +     record->ts = ts;
> > +     record->size = kbuffer_event_size(kbuf);
> > +     record->record_size = kbuffer_curr_size(kbuf);
> > +     record->cpu = 0;
> > +     record->data = ptr;
> > +     record->ref_count = 1;
> > +
> > + out_free:
> > +     kbuffer_free(kbuf);
> > +     return record;
> > +}
> > +
> > +static void free_record(struct tep_record *record)
> > +{
> > +     if (!record)
> > +             return;
> > +
> > +     if (record->ref_count > 0)
> > +             record->ref_count--;
> > +     if (record->ref_count)
> > +             return;
> > +
> > +     free(record);
> > +}
> > +
> > +static int
> > +get_events_in_page(struct tep_handle *tep, void *page,
> > +                int size, int cpu,
> > +                int (*callback)(struct tep_event *,
> > +                                struct tep_record *,
> > +                                int, void *),
> > +                void *callback_context)
> > +{
> > +     struct tep_record *last_record = NULL;
> > +     struct tep_event *event = NULL;
> > +     struct tep_record *record;
> > +     int id, cnt = 0;
> > +
> > +     if (size <= 0)
> > +             return 0;
> > +
> > +     while (true) {
> > +             event = NULL;
> > +             record = tracefs_read_page_record(tep, page, size, last_record);
>
> This is very slow because the above function does a linear search to
> find the next record each time! It would be much better to keep a kbuf
> reference and use that.
>
>
> > +             if (!record)
> > +                     break;
> > +             free_record(last_record);
> > +             id = tep_data_type(tep, record);
> > +             event = tep_find_event(tep, id);
> > +             if (event && callback) {
> > +                     if (callback(event, record, cpu, callback_context))
> > +                             break;
> > +             }
> > +             last_record = record;
> > +     }
> > +     free_record(last_record);
> > +
> > +     return cnt;
> > +}
> > +
>
> Here's a patch (untested ;-) that should help speed up the reading by
> using the last record from before. This may even be able to help speed
> up other parts of the code.
>
> -- Steve
>
> diff --git a/lib/traceevent/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
> index b18dedc4..ecbb64e9 100644
> --- a/lib/traceevent/kbuffer-parse.c
> +++ b/lib/traceevent/kbuffer-parse.c
> @@ -649,6 +649,40 @@ void *kbuffer_read_at_offset(struct kbuffer *kbuf, int offset,
>         return data;
>  }
>
> +/**
> + * kbuffer_set_position - set kbuf to index to a current offset and timestamp
> + * @kbuf:      The kbuffer to read from
> + * @offset:    The offset to set the current postion to
> + * @ts:                The timestamp to set the kbuffer to.
> + *
> + * This routine is used to set the current position saved in @kbuf.
> + * This can be used in conjunction with using kbuffer_curr_offset() to
> + * get the offset of an event retrieved from the @kbuf subbuffer, and
> + * also using the time stamp that was retrived from that same event.
> + * This will set the position of @kbuf back to the state it was when
> + * it returned that event.
> + *
> + * Returns zero on success, -1 otherwise.
> + */
> +int kbuffer_set_position(struct kbuffer *kbuf, int offset,
> +                          unsigned long long *ts)
> +{
> +       int ret;
> +
> +       offset -= kbuf->start;
> +
> +       if (offset < 0 || offset >= kbuf->size || !ts)
> +               return -1;      /* Bad offset */
> +
> +       kbuf->next = offset;
> +       ret = next_event(kbuf);
> +       if (ret < 0)
> +               return -1;
> +
> +       kbuf->timestamp = *ts;
> +       return 0;
> +}
> +
>  /**
>   * kbuffer_subbuffer_size - the size of the loaded subbuffer
>   * @kbuf:      The kbuffer to read from

Thanks Steven! I'll test it and add it in the next version of the patch set.


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
