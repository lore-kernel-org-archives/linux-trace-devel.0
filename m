Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E57C43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9689820737
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 12:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="skXwzy9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDCM1C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:27:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41398 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgDCM1B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 08:27:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id b1so3433734pgm.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 05:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bQtTYPF8vIz4fT0UapQI7HEDeb+sSR6v0qeQLSE2zvk=;
        b=skXwzy9QDdXUClMFkKAhWIllCY5R3G9QsxlgLu5MzMJSfFlUR9qJKYdJ0DKOvLKxNe
         +yBa7fXGMhkrLVsevki1wIdpKsFcfLAQXUL60YWSN64Ti7YJHSDGRE+c+DJngGKn6sYe
         iayT7YNWnD07PQKjtzvyNINsHrif5kynIrOy0qvjYYLZS7AdaW9vcCwuqYZW/MNiYTDQ
         GV9J08LrWQVdKVqEVhyOW2sKAaEUwt8/8NbUgTISJ1lKG94LfEHKTEFErnNhTrHLo/Dv
         vtKE/QlIyYvhOoRUowwyvlqNTLYWs8URoog1lWnsw/YQEqO4KH5r/Vt+CFG4bOs+XRiv
         7hZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bQtTYPF8vIz4fT0UapQI7HEDeb+sSR6v0qeQLSE2zvk=;
        b=A4Llmsepn8kis0QmminaqShaYHT+JumRY5SnsZbhxUA/KiYlKAGMnfgFF3VEy/GUQh
         /K4Lt8bJfK/rBg+PQIYkFRfSGEoMVpmlsoEY0PSv7BvpLo+0hke9lhr0fdpVcqrQxC2a
         GUJpyJC4mNSe8w8cLx+xdbZF+b1RhDDLvkecOei9Vq4n2ssKd8hq2ssy0YjErh5MfDm6
         8Orm/ylVzT83WPTaFbp7Yc0uAn4awjs8iEgR2fMZI/Sbdj/TVo7H8vJsGS1hSbaNH6Yf
         Mfx7nNlHBf7h+1vETfSB18Yv8ze493H2cHEeI46KBg5z/zkH0iEcBcwVIsU1j23sV0Oe
         5OPA==
X-Gm-Message-State: AGi0PuYjBSM4A6gWJiX5+kSDusdRm9ubuV/r9DylOknakanBVMyjnPZg
        UglLBtJjulzgMDKaMesVVmPGvsGcb10m+b4nJ1c=
X-Google-Smtp-Source: APiQypKFhQyoAxdKa57B0vgjTX/uFN8u30++doobXzCVL2MlMmC9OyGLhMPLY6apjrxaGrPWwcFb4GhW+eEBj6mTsRo=
X-Received: by 2002:a63:8c13:: with SMTP id m19mr7641490pgd.44.1585916820798;
 Fri, 03 Apr 2020 05:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200401164509.191494-1-tz.stoyanov@gmail.com> <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
In-Reply-To: <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 3 Apr 2020 15:26:49 +0300
Message-ID: <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest
 tracing file
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 3, 2020 at 2:39 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
>
>
> On 1.04.20 =D0=B3. 19:45 =D1=87., Tzvetomir Stoyanov (VMware) wrote:
> > From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> >
> > The new tracecmd API tracecmd_open_merge() is used to open guest
> > tracing file and synchronize it to the host file.
> > This change is for testing purposes only, to test the new per CPU
> > timestamps synchronization logic.
> > It assumes that the stream with id 0 is the host one, and all others ar=
e
> > guest streams.
> > This change depends on commit:
> >   "trace-cmd: Add new API to merge two trace files"
> > where the new tracecmd API is introduced.
> >
> > Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> > ---
> >   src/libkshark-tepdata.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> > index 8678e12..b80b945 100644
> > --- a/src/libkshark-tepdata.c
> > +++ b/src/libkshark-tepdata.c
> > @@ -1008,8 +1008,17 @@ int kshark_tep_init_input(struct kshark_data_str=
eam *stream,
> >       tep_handle =3D calloc(1, sizeof(*tep_handle));
> >       if (!tep_handle)
> >               return -EFAULT;
> > -
> > -     tep_handle->input =3D tracecmd_open(file);
>
> Hi Ceco,
>
> Is it possible to avoid the hard-coded ID number of the primary stream
> (zero in this case)?

Yes, the first version of the patch is more a POC, to test the new
tracecmd_open_merge() API.

>
> Maybe we can add data field to "struct tepdata_handle" that can be used
> to indicate if the stream is "primary" or not. Note that "struct
> tepdata_handle" is defined only for "libkshark-tepdata.c".

I think a new "unsigned int flags" member should be added to
struct kshark_data_stream;
and flags should indicate if the stream is primary or not, depending
on the way the file is loaded:
 using "-i" option, or "File -> Open" from the menu - primary
 using "-a" option, or "File -> Append" from the menu - secondary

>
> Also do we consider a case when we will need to load more than one
> "primary" stream?

In the host - guest tracing, there is no use case with more than one
primary stream,
but may be there could be other use cases where more than one primary
stream will
be needed ?

Is it possible to append more than one secondary files, using the
current KernelShark 2 ?
I tried appending two files, specifying "-a" option twice, but only
the first "-a" file was appended.

>
> Thanks!
> Yordan
>
>
> > +     if (stream->stream_id > 0) {
> > +             struct kshark_data_stream *primary;
> > +
> > +             primary =3D kshark_get_data_stream(kshark_ctx, 0);
> > +             if (primary && primary->file)
> > +                     tep_handle->input =3D tracecmd_open_merge(file,
> > +                                                             primary->=
file);
> > +             else
> > +                     tep_handle->input =3D tracecmd_open(file);
> > +     } else
> > +             tep_handle->input =3D tracecmd_open(file);
> >       if (!tep_handle->input) {
> >               free(tep_handle);
> >               stream->interface.handle =3D NULL;
> >



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
