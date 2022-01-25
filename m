Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC37C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 17:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiAYRdL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 12:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356212AbiAYRau (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 12:30:50 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63560C06173D
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 09:30:50 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h12so20619902pjq.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 09:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rBOb4QQ2dgfUbW0o2qYxxGZdO04lKSmCMP6Q6RDtDWk=;
        b=mCuAOtizJLCO794+MrIV08kgcuEMVRcu3vr1FSrYHY7EWrePvCa0jmcrbZ5Ih6dYME
         FisswEov8dC1UKs17j9+SLEjmA1j/z4XMOn8cvZ1XmPrgg7Ft7j1ySF0fseJftw1Qepn
         KIjt0SJtwUhtF+4vDgwjqBOW23Mmahcu7cAqVscBYTlBWgkDYhRU5X1aadkFAnqu3e2E
         XGA/MhlMuueCZWgY8sXA1sQRS+t/u1dG1TTABUVoDcfdTTXeuVNax9xFmQ8s+blpCrp+
         t7iH0MLlfcZjuzfFIUX7ftAWTj3a0ytNOx4fbUP+Kc2ajoLT9yki0X+8qbNjRVFCi0vc
         k2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBOb4QQ2dgfUbW0o2qYxxGZdO04lKSmCMP6Q6RDtDWk=;
        b=s/umRTWMvhQydX1TcXojz7JS6tgXSpff24DmLkGOjLaznRal1RxIMfy3ET8bGjvEjk
         ul4yMnhpFgqPTfJkpwGNcFkouQTmEljUqYJPQGIYV6nUMkRkfGOyPWIVE5zpfRZKsfy2
         jUtrNaHeN1Z64orksVpDhwFMIoIz53x0t/fpl0ekG/GCml2T+g5OKamIvlLbCtJrSgFw
         7DjWxHIs01LmZHdfIFio8sPPQBe3nrSqchJhg2A8gK0KNEfvt+8ssoQ/LkcB+qOs8Eb4
         Qv6kt90mO6QjfcpuM7KtkfaULkw3hGCa8ybwRP9ZQ/Gqoa36NvNqVcg3NHlF6qostrm8
         0NFQ==
X-Gm-Message-State: AOAM533k/x0+xX/he9pb8FAnbnM4lpnlvJmTInPbnjgTrvDL0kPzZfgG
        ubmM721oYXKb8bnAu6zQI5jE3BxEkKVUwpkzGErSVo3CwH0=
X-Google-Smtp-Source: ABdhPJyUq3wEeYjLywsYJ+S0EsqgKy3R29Il+yKt2FSg8ZghA4V5AEM47T6LAKJwwrRBAtbHn+80YrkIAKb5jQ7onmg=
X-Received: by 2002:a17:902:7fc8:b0:14a:e403:2f18 with SMTP id
 t8-20020a1709027fc800b0014ae4032f18mr19713397plb.45.1643131849838; Tue, 25
 Jan 2022 09:30:49 -0800 (PST)
MIME-Version: 1.0
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
 <20220119082715.245846-2-tz.stoyanov@gmail.com> <20220123174851.52f0e2bb@rorschach.local.home>
 <CAPpZLN6BpbaThK66MJaykk7gSPDq2qQHkbmunQeT0NyMNMGnAw@mail.gmail.com>
 <20220124150335.2516da99@gandalf.local.home> <CAPpZLN6_VNmH3O1GML6cPfXJwp2K-SJseVd4fe=bbLZR8pm8PA@mail.gmail.com>
 <20220125100809.528667ef@gandalf.local.home>
In-Reply-To: <20220125100809.528667ef@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 25 Jan 2022 19:30:33 +0200
Message-ID: <CAPpZLN4ET-wF2BcQzEb99F8LFADVDYZR6_kdo4530XC=1eJG3Q@mail.gmail.com>
Subject: Re: [PATCH v7 01/20] trace-cmd library: Add support for compression algorithms
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 5:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 25 Jan 2022 09:48:43 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > > >
> > > > > > +     free(bytes);
> > > > > > +     handle->pointer = 0;
> > > > > > +     handle->capacity = s_uncompressed;
> > > > >
> > > > > If size is the greater of the two (compressed could be larger) and
> > > > > capacity is the allocated buffer, shouldn't we make it equal to size
> > > > > and not uncompressed?
> > > >
> > > > The name "capacity" in reading logic is a bit confusing, as it
> > > > actually is used to track the size of uncompressed data. The buffer
> > > > may be larger, but if the uncompressed is smaller - the rest is
> > > > garbage and must not be read.
> > >
> > > Then the extend function is broken:
> >
> > For this particular use case, the logic is not correct - the realloc()
> > could be redundant, if the real buffer size is bigger than the
> > capacity. But as usually a compression handle is used for reading or
> > for writing only, this is unlikely to happen. At least I cannot
> > imagine a use case where the same compression handle will be used for
> > reading a compress block and for writing compressed data. But even if
> > we hit that case - there is no data corruption or memory leak, just a
> > redundant realloc(). To solve that, reading and writing capacities
> > could be introduced ?
> >     struct tracecmd_compression {
> >        ...
> >        unsigned int            capacity_read;
> >        unsigned int            capacity_write;
> >        ...
> >    }
>
> A redundant realloc is not an issue, in fact, they are pretty fast (it
> detects that the requested size still fits what is allocated and just
> returns).
>
> >
> > But that change will be for a very rare case - when the compressed
> > data size is bigger than the uncompressed (usually happens only with a
> > very small data) + the same compression handle is used for compression
> > and decompression (not used in that way in trace-cmd).
> >
> > >
> > > static inline int buffer_extend(struct tracecmd_compression *handle, unsigned int size)
> > > {
> > >         int extend;
> > >         char *buf;
> > >
> > >         if (size <= handle->capacity)
> > >                 return 0;
> > >
> > >         extend = ((size - handle->capacity) / BUFSIZ + 1) * BUFSIZ;
> > >         buf = realloc(handle->buffer, handle->capacity + extend);
> > >         if (!buf)
> > >                 return -1;
> > >         handle->buffer = buf;
> > >         handle->capacity += extend;
> > >
> > >         return 0;
> > > }
> > >
> > > As it sets the capacity to the allocated size, not what is stored.
> > >
> > > Perhaps you meant:
> > >
> > >         handle->capacity += size;
>
> The above should still work, instead of doing the += extend.
>
> The point I was making is that capacity should either be the requested size
> allocated, or what is actually allocated. The above function sets it to
> what is allocated, and the other code sets it to what was requested. We
> should pick it to be one or the other.

I didn't know about that realloc optimization (check if requested size
fits into already allocated memory). In that case, we can use the
requested size in both places. But still allocate a page aligned
buffer in buffer_extend(), to avoid frequent reallocs (although
realloc will be called almost every time).

>
> -- Steve
>
>
> > >
> > > ?
> > >
> > > >
> > > > >
> > > > >
> > > > > > +     return 0;
> > > > > > +error:
> > > > > > +     tracecmd_compress_reset(handle);
> > > > > > +     free(bytes);
> > > > > > +     return -1;
> > > > > > +}
> > > > > > +



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
