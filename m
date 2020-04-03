Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331D5C2BA16
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 17:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AE0D207FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 17:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JhFx1DdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390962AbgDCRNK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 13:13:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44934 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgDCRNJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 13:13:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so2934284plr.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 10:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5bQHeNNoozaVTsA4LXvA7npny+3BYNOVgJ86mcikYtg=;
        b=JhFx1DdG6utzAHMHi7tBCNHc67XTClWvGrckIZl767Qa0aMZsaneLblqAhN1KEVpAw
         AqTVeHvR1HGfnwQgdpvVJORqU8pOAy7e79y45v12GAETP05mdTzbRLaZXzplRbv4OzIf
         MYWV0Uj/DrdeeYDxBiLfmync/UOmNBBWOftqN1ebTur6f+mW7ZGZfbCXPYvJHrEoLMNF
         6U+FC5fJ5nqAkdECJe5AdHMIFQmezyYJWlRGjKlbWyeiM2JEuGl7O75Pmne4jTL/P4/N
         /MuApWGV4/GeESTeO4CZyYF3C8eMD9fHSwspDS/vIDHAGMxGPV32XYlGNCnYSF4bRC19
         Hd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5bQHeNNoozaVTsA4LXvA7npny+3BYNOVgJ86mcikYtg=;
        b=lX+FNAmZihXRAfwUhTJFk2U6lAcy2dhgJbokR9XmbUPAc8k7ft8GG7vvwhrzfHVQG1
         hgpP7QZrhc/6RKjlnwpC7Vo2NMAe5ggFmAeoXmwjChHEXIS8hrfJPx3icnW0s4KMTX4L
         /L+4jq5HVFt3Nyxc4a2ObqRUUJWuV9q4pyF62BW6eIlue/mC0s6cngpcgEduStiHNvjk
         yWU+FNPKnChceU1Ilyd7NcG0pgezahqCXKcMAfXuvFHzq1z9Kq4Cx1I0lahUu+Xyzh43
         WGgfdCgG0eFo/ligmXFlx1GJFWJ2uposr4PKqjGHK4G25H3QGedeR7WMfu3ThPbwtASp
         AcPA==
X-Gm-Message-State: AGi0PubtGd8nuqCk7XddjVORZ4IkZFtnp3ouQtAKdSsfugJUC4TbCDkp
        gn+9xB65xU5+3Hkgs76DRnJ+xbKH6OsN061gC8w=
X-Google-Smtp-Source: APiQypKCJxZ0mGoFrh7aJl9AkJba3iVedUiRCBMmnE8iCrdvjRQU6F1oCXPJ98kiE+UbDLskOTNMdgbWN4LO2HQDwzQ=
X-Received: by 2002:a17:90a:228c:: with SMTP id s12mr11067095pjc.68.1585933987596;
 Fri, 03 Apr 2020 10:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
 <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com> <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
 <5b55ebc5-d682-f934-a643-c0fe65fba003@gmail.com>
In-Reply-To: <5b55ebc5-d682-f934-a643-c0fe65fba003@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 3 Apr 2020 20:12:56 +0300
Message-ID: <CAPpZLN61s-7SY_Ey8Qu7n+=v0FE6VVgxoTp-qrGgit0=Rj_0SQ@mail.gmail.com>
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

On Fri, Apr 3, 2020 at 6:09 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
>
>
> On 3.04.20 =D0=B3. 15:26 =D1=87., Tzvetomir Stoyanov wrote:
> > On Fri, Apr 3, 2020 at 2:39 PM Yordan Karadzhov (VMware)
> > <y.karadz@gmail.com> wrote:
> >>
> >>
> >>
> >> On 1.04.20 =D0=B3. 19:45 =D1=87., Tzvetomir Stoyanov (VMware) wrote:
> >>> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> >>>
> >>> The new tracecmd API tracecmd_open_merge() is used to open guest
> >>> tracing file and synchronize it to the host file.
> >>> This change is for testing purposes only, to test the new per CPU
> >>> timestamps synchronization logic.
> >>> It assumes that the stream with id 0 is the host one, and all others =
are
> >>> guest streams.
> >>> This change depends on commit:
> >>>    "trace-cmd: Add new API to merge two trace files"
> >>> where the new tracecmd API is introduced.
> >>>
> >>> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> >>> ---
> >>>    src/libkshark-tepdata.c | 13 +++++++++++--
> >>>    1 file changed, 11 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> >>> index 8678e12..b80b945 100644
> >>> --- a/src/libkshark-tepdata.c
> >>> +++ b/src/libkshark-tepdata.c
> >>> @@ -1008,8 +1008,17 @@ int kshark_tep_init_input(struct kshark_data_s=
tream *stream,
> >>>        tep_handle =3D calloc(1, sizeof(*tep_handle));
> >>>        if (!tep_handle)
> >>>                return -EFAULT;
> >>> -
> >>> -     tep_handle->input =3D tracecmd_open(file);
> >>
> >> Hi Ceco,
> >>
> >> Is it possible to avoid the hard-coded ID number of the primary stream
> >> (zero in this case)?
> >
> > Yes, the first version of the patch is more a POC, to test the new
> > tracecmd_open_merge() API.
> >
> >>
> >> Maybe we can add data field to "struct tepdata_handle" that can be use=
d
> >> to indicate if the stream is "primary" or not. Note that "struct
> >> tepdata_handle" is defined only for "libkshark-tepdata.c".
> >
> > I think a new "unsigned int flags" member should be added to
> > struct kshark_data_stream;
> > and flags should indicate if the stream is primary or not, depending
> > on the way the file is loaded:
> >   using "-i" option, or "File -> Open" from the menu - primary
> >   using "-a" option, or "File -> Append" from the menu - secondary
> >
>
> Maybe it has to be a bit more sophisticated. Does the "primary" stream
> know how to recognize its "secondary" streams?
>
Yes, there are tracing IDs in both host and guest files. When these IDs mat=
ch,
files are from a same tracing session.
I can add "parent_stream_id" member in "struct kshark_data_stream" and
initialize it
when reading the files, according to the trace IDs. This can be useful
in KVMCombo
plugin also, for proper PID to VCPU mapping.

>
> >>
> >> Also do we consider a case when we will need to load more than one
> >> "primary" stream?
> >
> > In the host - guest tracing, there is no use case with more than one
> > primary stream,
> > but may be there could be other use cases where more than one primary
> > stream will
> > be needed ?
> >
> > Is it possible to append more than one secondary files, using the
> > current KernelShark 2 ?
> > I tried appending two files, specifying "-a" option twice, but only
> > the first "-a" file was appended.
> Yes, this can be done from the menus, but you are right that something
> goes wrong when trying to do this from the command line. I will
> investigate and will try to get it fixed.
>
> Thanks!
> Yordan
>
> >
> >>
> >> Thanks!
> >> Yordan
> >>
> >>
> >>> +     if (stream->stream_id > 0) {
> >>> +             struct kshark_data_stream *primary;
> >>> +
> >>> +             primary =3D kshark_get_data_stream(kshark_ctx, 0);
> >>> +             if (primary && primary->file)
> >>> +                     tep_handle->input =3D tracecmd_open_merge(file,
> >>> +                                                             primary=
->file);
> >>> +             else
> >>> +                     tep_handle->input =3D tracecmd_open(file);
> >>> +     } else
> >>> +             tep_handle->input =3D tracecmd_open(file);
> >>>        if (!tep_handle->input) {
> >>>                free(tep_handle);
> >>>                stream->interface.handle =3D NULL;
> >>>
> >
> >
> >



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
