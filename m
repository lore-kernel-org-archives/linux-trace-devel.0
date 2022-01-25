Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C17BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 15:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581524AbiAYPKs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 10:10:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60152 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581512AbiAYPIL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 10:08:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68AC161673
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 15:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFFC340E0;
        Tue, 25 Jan 2022 15:08:10 +0000 (UTC)
Date:   Tue, 25 Jan 2022 10:08:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression
 algorithms
Message-ID: <20220125100809.528667ef@gandalf.local.home>
In-Reply-To: <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
        <20220119082715.245846-2-tz.stoyanov@gmail.com>
        <20220123174851.52f0e2bb@rorschach.local.home>
        <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com>
        <20220124150335.2516da99@gandalf.local.home>
        <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 25 Jan 2022 09:48:43 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > > >  
> > > > > +     free(bytes);
> > > > > +     handle->pointer = 0;
> > > > > +     handle->capacity = s_uncompressed;  
> > > >
> > > > If size is the greater of the two (compressed could be larger) and
> > > > capacity is the allocated buffer, shouldn't we make it equal to size
> > > > and not uncompressed?  
> > >
> > > The name "capacity" in reading logic is a bit confusing, as it
> > > actually is used to track the size of uncompressed data. The buffer
> > > may be larger, but if the uncompressed is smaller - the rest is
> > > garbage and must not be read.  
> >
> > Then the extend function is broken:  
> 
> For this particular use case, the logic is not correct - the realloc()
> could be redundant, if the real buffer size is bigger than the
> capacity. But as usually a compression handle is used for reading or
> for writing only, this is unlikely to happen. At least I cannot
> imagine a use case where the same compression handle will be used for
> reading a compress block and for writing compressed data. But even if
> we hit that case - there is no data corruption or memory leak, just a
> redundant realloc(). To solve that, reading and writing capacities
> could be introduced ?
>     struct tracecmd_compression {
>        ...
>        unsigned int            capacity_read;
>        unsigned int            capacity_write;
>        ...
>    }

A redundant realloc is not an issue, in fact, they are pretty fast (it
detects that the requested size still fits what is allocated and just
returns).

> 
> But that change will be for a very rare case - when the compressed
> data size is bigger than the uncompressed (usually happens only with a
> very small data) + the same compression handle is used for compression
> and decompression (not used in that way in trace-cmd).
> 
> >
> > static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
> > {
> >         int extend;
> >         char *buf;
> >
> >         if (size <= handle->capacity)
> >                 return 0;
> >
> >         extend = ((size - handle->capacity) / BUFSIZ + 1) * BUFSIZ;
> >         buf = realloc(handle->buffer, handle->capacity + extend);
> >         if (!buf)
> >                 return -1;
> >         handle->buffer = buf;
> >         handle->capacity += extend;
> >
> >         return 0;
> > }
> >
> > As it sets the capacity to the allocated size, not what is stored.
> >
> > Perhaps you meant:
> >
> >         handle->capacity += size;

The above should still work, instead of doing the += extend.

The point I was making is that capacity should either be the requested size
allocated, or what is actually allocated. The above function sets it to
what is allocated, and the other code sets it to what was requested. We
should pick it to be one or the other.

-- Steve


> >
> > ?
> >  
> > >  
> > > >
> > > >  
> > > > > +     return 0;
> > > > > +error:
> > > > > +     tracecmd_compress_reset(handle);
> > > > > +     free(bytes);
> > > > > +     return -1;
> > > > > +}
> > > > > +
