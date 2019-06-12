Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACBFC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67AC215EA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 15:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vaVbtxuH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408715AbfFLPbp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:31:45 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41779 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405706AbfFLPbp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 11:31:45 -0400
Received: by mail-oi1-f196.google.com with SMTP id g7so8805299oia.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jun 2019 08:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l7mZvKKYjoVoh+JKEXOiBNkw+CrpW3QACVrNJxfe9A4=;
        b=vaVbtxuHuvXE5N+OOXCfjAXZaZmoKZ6TwiObGuyST9BTNkxC7OFFTjmmIQVkqvq8mu
         fX8JcCDqas7VXNc6FerTLo5/v6BiNL8Fjxa5S6jMlEiV5pEJ0aXRBDo1dTp0F/EK7/3O
         tiji7Y+btv+kBqY4GbfKiPVihl5Wp+q1OITLE2xbsCfXU76tb2hluEcWG7CMwWDg/6+e
         h9KKZfQflr4qMT75APPVDrojc2mFXsFW7/Nnwl1QUoq8hnGMSBWrrnvFRBE2zOjOmBv7
         3dRDD4ivXUIwbPTRYJmpEFnVmfeYmCN7crT3RFQWwSGG/9qgTnGcjI6d6ryNCH9WGkMH
         mHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l7mZvKKYjoVoh+JKEXOiBNkw+CrpW3QACVrNJxfe9A4=;
        b=StjnNBdwTRuu3yWMT4YAbUMpsotwh/KM8EcMi460XdYub4P6fi/URmQGD1vsspN2Wd
         M6wUrbUyd2bzkkb+mbjjANnov/JE1nJoOJ+OyxeOB/Q6BDF5Ysvbt6eeZv0bU5P41Mzr
         HicfjJR7cLkFPj1qD0rqLyIf0cA1Um9MrRDtI4yB7DQVe3YIoIjWhk8ruuScEL1AW7YO
         Iy2y3MAovR5/gZED+dkw5tiFpHHrKbcj3Es1DdATg3eUHNMp0RFHk7xen/l4fBybzn08
         mbutAowN8K+BM3/z9rt6+HgkFZLIxOIDAKmjy+NyCbqWK3c2gtcbCT0il672xFJAavEH
         GfDw==
X-Gm-Message-State: APjAAAUzVbFUhiS9oZ5xqezrFavSq6Mtg0vCsqiWCH9C6oB7zlshklLP
        SSkjSqQkW06CSps+kiqDXxSMGy7wAGIafEt9lEEFygAa
X-Google-Smtp-Source: APXvYqyXdhkPGncYisbpNVXK569DP7mELldLpKz8y9hcwF/4PpJ6qfVzQKa0yCsoKitnJGxlhN4t+wXokD6SoS+tUtg=
X-Received: by 2002:aca:2416:: with SMTP id n22mr18494590oic.116.1560353504375;
 Wed, 12 Jun 2019 08:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
 <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com> <20190612081252.6fd3d118@gandalf.local.home>
In-Reply-To: <20190612081252.6fd3d118@gandalf.local.home>
From:   Alan Mikhak <alanmikhak@gmail.com>
Date:   Wed, 12 Jun 2019 08:31:30 -0700
Message-ID: <CAOY98Nfv24YknzV36PZFnVLsPK6UcCxZiKfTJ-mv4dUsDUzaMA@mail.gmail.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 5:12 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 12 Jun 2019 07:34:35 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> > On 12.06.19 =D0=B3. 6:59 =D1=87., Alan Mikhak wrote:
> > > Fix compiler error at KsSession.cpp:457:30 on Raspberry Pi 3
> > >
> > > Fix by changing the type of local variable 'pos' from uint64_t to
> > > size_t in KsSession::loadDualMarker().
> > >
> > > KsSession.cpp:457:30: error: no matching function for call to
> > > =E2=80=98KsSession::_getMarker(const char [6], uint64_t*)=E2=80=99
> > >    if (_getMarker("markA", &pos)) {
> > >                                ^
> > > In file included from KsSession.cpp:14:0:
> > > KsSession.hpp:97:7: note: candidate:
> > >   bool KsSession::_getMarker(const char*, size_t*)
> > >    bool _getMarker(const char* name, size_t *pos);
> > >         ^~~~~~~~~~
> > > KsSession.hpp:97:7: note:   no known conversion for
> > > argument 2 from =E2=80=98uint64_t* {aka long long unsigned int*}=E2=
=80=99
> > > to =E2=80=98size_t* {aka unsigned int*}=E2=80=99
> > >
> > > Signed-off-by: Alan Mikhak <amikhak@wirelessfabric.com>
> > > ---
> > >   kernel-shark/src/KsSession.cpp | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSess=
ion.cpp
> > > index 9d86776..a581bbf 100644
> > > --- a/kernel-shark/src/KsSession.cpp
> > > +++ b/kernel-shark/src/KsSession.cpp
> > > @@ -450,7 +450,7 @@ void KsSession::saveDualMarker(KsDualMarkerSM *dm=
)
> > >    */
> > >   void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *gr=
aphs)
> > >   {
> > > -   uint64_t pos;
> > > +   size_t pos;
> > >
> > >     dm->reset();
> > >     dm->setState(DualMarkerState::A);
> > >
> >
> >
> > Hi Alan,
> > Thanks a lot for this fix!
> >
> > Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> >
>
> Thanks Alan and Yordan.
>
> I queued this patch for my next push to the repo (currently working on
> some other things before I do that push).
>
> -- Steve

Hi Steve and Yordan,

FYI, I ran the kernel get_maintainers.pl script when preparing this
patch but the script didn't suggest linux-trace-devel@vger.kernel.org
or either of you as maintainers.

Regards,
Alan
