Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFC0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 09:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456531AbiAYJLu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 04:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453784AbiAYIzr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 03:55:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055AFC06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 23:49:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id d5so16719101pjk.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 23:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbOIKpcN3H+1hXfx5xgLrLpf14Wsp5A6AF6OSs35l6o=;
        b=DWBoDDFH3fYn2x1xbPLnrn07pP5HSxwaxQffE9m7Kv3KbX07iHi69IX+FtZYLV8NW+
         GmiLxyF/H25OUzkYsnFz8AB+sUWwePCuPqd/mXFVkKlVaALfW7hQwNUgaI8uDO7HVqfV
         C2mD/vpnQYraUbDF1J6QXnEmUcQJ7jHkF562GTPrnydB+udP1mT9V7OP8O5EMqTeiyOu
         3+a9ZbGdTazbnRCLi3QifpVcXPaRzO7KGoZmo8S+gQg5FYJt7AaM+VLVtiQtWT5vrjrZ
         HzL3UlywbfDhabxQDtJJMzU2afnxEONOfxiXSaeA7lIFKmqYJiMef7AYECUDd31w+XpS
         4uzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbOIKpcN3H+1hXfx5xgLrLpf14Wsp5A6AF6OSs35l6o=;
        b=qZPwx/bL8GmJqoVG5tYLMnpXPvpWDpjKWoEmdAxlRgKVjHra7QQOTYat8KB37Rk1TF
         wCy5DrQ92uti9W+yqGoVu61eL9arr+O8jM2auam3ITiA8hPj4zOSRHaTwJmrodx2DM2f
         TQkey7+vou8JCcO7v2wNzfLDBtcOIOkIiQxd3JkBqVDGErdHm/oYqPnMmsNo+hLXpbRq
         VnewTfcjCVXMaNn4ZVwwVqGxCKskkGd0XfLI4dbvDPRBzh0iGzRSRVKsqzaE7/cHfwuJ
         jErAx/8hyjNlpAcoHhFDpjM7wSqgPBw35FUWNEGV1RpvaYatmn1YyRAu7D6Q6oOgVhtw
         agbg==
X-Gm-Message-State: AOAM531bOHbkwnEmxEa/GHOokVIiixED4CG1yullbNUs3SoYC2hUc3GQ
        KDDAAhtXObyok2IiSD6xZvmgujLQiKCaB8JGDaciu7TG
X-Google-Smtp-Source: ABdhPJzYPnX33k8vCV1woUdUCzI+xyaKUNxbfr//oF2bH4/Vx3Iy59BGKizCwwPkf91kOLZguAyCfP70Ma5X9Qvju2U=
X-Received: by 2002:a17:90b:4c11:: with SMTP id na17mr2250302pjb.208.1643096939693;
 Mon, 24 Jan 2022 23:48:59 -0800 (PST)
MIME-Version: 1.0
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
 <20220119082715.245846-2-tz.stoyanov@gmail.com> <20220123174851.52f0e2bb@rorschach.local.home>
 <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com> <20220124150335.2516da99@gandalf.local.home>
In-Reply-To: <20220124150335.2516da99@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 25 Jan 2022 09:48:43 +0200
Message-ID: <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression algorithms
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 24, 2022 at 10:03 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 24 Jan 2022 06:54:48 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > Can this handle sections that are more than 4G in size?
> > >
> > > That is definitely something we need to be able to handle. Or if a
> > > trace-cmd data file has a section greater than 4G, it is broken up into
> > > smaller chunks for compression?
> >
> > Yes, large sections are compressed and uncompressed in chunks. That
> > limits the size of one chunk, not the section size. In the proposed
> > implementation, one chunk of compressed trace data is 10 trace pages.
>
> OK.
>
>
> > > > +
> > > > +/**
> > > > + * tracecmd_uncompress_block - uncompress a memory block
> > > > + * @handle: compression handle
> > > > + *
> > > > + * Read compressed memory block from the file and uncompress it into internal buffer.
> > > > + * The tracecmd_compress_read() can be used to read the uncompressed data from the buffer
> > >
> > > BTW, even though we allow 100 character width, it's best to keep
> > > comments under 80, when possible.
> > >
> > > Also, I found the naming of tracecmd_compress_read/write() confusing as
> > > it reads and writes to the buffer and not the file. It may not have
> > > been so bad if we didn't have these functions where we have
> > > compress_block and uncompress_block that reads and writes to the file.
> > >
> > > Prehaps s/tracecmd_compress_read/tracecmd_compress_retrieve/
> > >         s/tracecmd_compress_write/tracecmd_compress_insert/
> > >
> > > ?
> > >
> >
> > I'm OK to rename them, though the current names sound logical to me.
> > In the trace-cmd code, I just replaced read() with
> > tracecmd_compress_read(), that's why decided to choose that name.
>
> The issue I had was that tracecmd_read reads the file, whereas to me
> "tracecmd_compress_read()" sounds like it would read the file that was
> compressed, and not an intermediate buffer.
>
> My issue is that the name does not reflect that it is reading from this
> intermediate.
>
> Another name could be:
>
>  tracecmd_compress_buffer_read()
>  tracecmd_compress_buffer_write()
>

I like the names with "_buffer_read", will rename them in the next version.

> Perhaps that would be better. That lets you know that its reading the
> compressed buffer, as the "buffer" in the name suggests.
>
>
> > >
> > > > +     free(bytes);
> > > > +     handle->pointer = 0;
> > > > +     handle->capacity = s_uncompressed;
> > >
> > > If size is the greater of the two (compressed could be larger) and
> > > capacity is the allocated buffer, shouldn't we make it equal to size
> > > and not uncompressed?
> >
> > The name "capacity" in reading logic is a bit confusing, as it
> > actually is used to track the size of uncompressed data. The buffer
> > may be larger, but if the uncompressed is smaller - the rest is
> > garbage and must not be read.
>
> Then the extend function is broken:

For this particular use case, the logic is not correct - the realloc()
could be redundant, if the real buffer size is bigger than the
capacity. But as usually a compression handle is used for reading or
for writing only, this is unlikely to happen. At least I cannot
imagine a use case where the same compression handle will be used for
reading a compress block and for writing compressed data. But even if
we hit that case - there is no data corruption or memory leak, just a
redundant realloc(). To solve that, reading and writing capacities
could be introduced ?
    struct tracecmd_compression {
       ...
       unsigned int            capacity_read;
       unsigned int            capacity_write;
       ...
   }

But that change will be for a very rare case - when the compressed
data size is bigger than the uncompressed (usually happens only with a
very small data) + the same compression handle is used for compression
and decompression (not used in that way in trace-cmd).

>
> static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
> {
>         int extend;
>         char *buf;
>
>         if (size <= handle->capacity)
>                 return 0;
>
>         extend = ((size - handle->capacity) / BUFSIZ + 1) * BUFSIZ;
>         buf = realloc(handle->buffer, handle->capacity + extend);
>         if (!buf)
>                 return -1;
>         handle->buffer = buf;
>         handle->capacity += extend;
>
>         return 0;
> }
>
> As it sets the capacity to the allocated size, not what is stored.
>
> Perhaps you meant:
>
>         handle->capacity += size;
>
> ?
>
> >
> > >
> > >
> > > > +     return 0;
> > > > +error:
> > > > +     tracecmd_compress_reset(handle);
> > > > +     free(bytes);
> > > > +     return -1;
> > > > +}
> > > > +
> > > > +/**
> > > > + * tracecmd_compress_block - compress a memory block
> > > > + * @handle: compression handle
> > > > + *
> > > > + * Compress the content of the internal memory buffer and write the compressed data in the file
> > > > + * The tracecmd_compress_write() can be used to write data into the internal memory buffer, before
> > > > + * calling this API.
> > > > + *
> > > > + * Returns 0 on success, or -1 in case of an error.
> > > > + */
> > > > +int tracecmd_compress_block(struct tracecmd_compression *handle)
> > > > +{
> > > > +     unsigned int size;
> > > > +     char *buf;
> > > > +     int endian4;
> > > > +     int ret;
> > > > +
> > > > +     if (!handle || !handle->proto ||
> > > > +         !handle->proto->compress_size || !handle->proto->compress_block)
> > > > +             return -1;
> > > > +
> > > > +     size = handle->proto->compress_size(handle->pointer);
> > >
> > > space
> > >
> > > > +     buf = malloc(size);
> > > > +     if (!buf)
> > > > +             return -1;
> > >
> > > space
> > >
> > > > +     ret = handle->proto->compress_block(handle->buffer, handle->pointer, buf, &size);
> > > > +     if (ret < 0)
> > > > +             goto out;
> > >
> > > Do we want to free the compress handle on error?
> >
> > I think returning an error is enough, the caller should decide if to
> > free the compress handle in that case. The handle is not allocated
> > here.
> >
>
> Heh, I actually meant: Do we want to reset the handle here?
>
> That is, I'm not asking to do more, but if we should do less.
>

I see what you mean, it makes sense to keep the data in case of
compression failure. Let the caller decide if to reset the handle.


> > >
> > > space
> > >
> > > > +     /* Write compressed data size */
> > > > +     endian4 = tep_read_number(handle->tep, &size, 4);
> > > > +     ret = do_write(handle, &endian4, 4);
> > > > +     if (ret != 4)
> > > > +             goto out;
> > >
> > > space
> > >
> > > > +     /* Write uncompressed data size */
> > > > +     endian4 = tep_read_number(handle->tep, &handle->pointer, 4);
> > > > +     ret = do_write(handle, &endian4, 4);
> > > > +     if (ret != 4)
> > > > +             goto out;
> > >
> > > space
> > >
> > > > +     /* Write compressed data */
> > > > +     ret = do_write(handle, buf, size);
> > > > +     ret = ((ret == size) ? 0 : -1);
> > > > +out:
> > > > +     tracecmd_compress_reset(handle);
>
> I meant, do we want to do the above for all error cases?
>
> > > > +     free(buf);
> > > > +     return ret;
> > > > +}
>
> ...
>
> > > > +/**
> > > > + * tracecmd_compress_copy_from - Copy and compress data from a file
> > > > + * @handle: compression handle
> > > > + * @fd: file descriptor to uncompressed data to copy from
> > > > + * @chunk_size: size of one compression chunk
> > > > + * @read_size: in - max bytes to read from @fd, 0 to read till the EOF
> > > > + *          out - size of the uncompressed data read from @fd
> > >
> > > Is this an array of two?
> >
> > No, it is a pointer to single long long, used as input and output parameter.
>
> I'm confused by the comment then. What is does the above "in" and "out"
> mean?
>
> >
> > >
> > > > + * @write_size: return, size of the compressed data written into @handle
> > > > + *
> > > > + * This function reads uncompressed data from given @fd, compresses the data using the @handle
> > > > + * compression context and writes the compressed data into the fd associated with the @handle.
> > > > + * The data is compressed on chunks with given @chunk_size size.
> > > > + * The compressed data is written in the format:
> > > > + *  - 4 bytes, chunks count
> > > > + *  - for each chunk:
> > > > + *    - 4 bytes, size of compressed data in this chunk
> > > > + *    - 4 bytes, uncompressed size of the data in this chunk
> > > > + *    - data, bytes of <size of compressed data in this chunk>
> > >
> > > I guess this answers the question from the beginning about the use of
> > > int in the structure.
> > >
> > > > + *
> > > > + * On success 0 is returned, @read_size and @write_size are updated with the size of
> > > > + * read and written data.
> > > > + */
> > > > +int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int chunk_size,
> > > > +                             unsigned long long *read_size, unsigned long long *write_size)
> > > > +{
> > > > +     unsigned int rchunk = 0;
> > > > +     unsigned int chunks = 0;
> > > > +     unsigned int wsize = 0;
> > > > +     unsigned int rsize = 0;
> > > > +     unsigned int rmax = 0;
> > > > +     unsigned int csize;
> > > > +     unsigned int size;
> > > > +     unsigned int all;
> > > > +     unsigned int r;
> > > > +     off64_t offset;
> > > > +     char *buf_from;
> > > > +     char *buf_to;
> > > > +     int endian4;
> > > > +     int ret;
> > > > +
> > > > +     if (!handle || !handle->proto ||
> > > > +         !handle->proto->compress_block || !handle->proto->compress_size)
> > > > +             return 0;
> > >
> > > space
> > >
> > > > +     if (read_size)
> > > > +             rmax = *read_size;
> > >
> > > space
> > >
> > > > +     csize = handle->proto->compress_size(chunk_size);
> > >
> > > space
> > >
> > > > +     buf_from = malloc(chunk_size);
> > > > +     if (!buf_from)
> > > > +             return -1;
> > >
> > > space
> > >
> > > > +     buf_to = malloc(csize);
> > > > +     if (!buf_to)
> > > > +             return -1;
> > >
> > > space
> > >
> > > > +     /* save the initial offset and write 0 chunks */
> > >
> > > Why zero? The above comment is more like " /* set x to zero */ x = 0; "
> >
> > Maybe "write 0 as initial chunk count" is a better comment. The error
> > cases below rely on that "0". Count of 0 should be written in the
> > file, in case of some error, or in case there is no data to compress.
>
> Yeah, please add more to that comment.
>
> Thanks,
>
> -- Steve
>
> >
> > >
> > > > +     offset = lseek64(handle->fd, 0, SEEK_CUR);
> > > > +     write_fd(handle->fd, &chunks, 4);
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
