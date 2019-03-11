Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BA0C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D2B206BA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:44:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHfGHTcN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfCKNos (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:44:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38157 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfCKNos (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 09:44:48 -0400
Received: by mail-io1-f68.google.com with SMTP id p18so4036092ioh.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 06:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T4wD7GyXFEOCvHw2/iUsKWNik1kckun3slyW076xw50=;
        b=MHfGHTcNqVpGWhLRQGz/CJzMkpnrXTisHuXK9j1ZbSYSg/EBBAmNM78YPEko+DHzCT
         DHFdIJHdtdg7n4VS90aIluQ2Vi7e/i4LRoGWve/7rDQr9WNKvlH9dR9mKBpvYlbGn7oc
         pC1v/KPBdz6Ok4t+3B7mRyMwhd4byQAupefeMKO926G1HfgXZPoOnpWfVtGLz4OH0FOZ
         tWsQPrXZ03PARs6tinOsSr3PAS08aqDJeREpONFPMllZ9/z1OMuxB+XmUi05dzlw72n7
         taqLqDksKE6QYUkOV3QOiDXkBHnIZ6IDPC25HZ69iZF46ia8g8eYZWHLZ7Qm9tbHJ7nN
         ggBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T4wD7GyXFEOCvHw2/iUsKWNik1kckun3slyW076xw50=;
        b=lwpbrhWdVl1133Mp8tY57wls5QhPy/N/855DRQoLDJADhH21kfVGJdsJFBlobyOQVu
         l9yNE7OctYXj5W6GNCxiMuLdza3yrQ5V/8dENvMSFpU5RY3+WwOk69HxO5SNSiUBihsi
         6TlxNGocjPrqf7EqiUxQRjzR8UIjPqtSG5fzm3SCchbNGVuo/mS2yfOvmjFt6Gqm0Axf
         4WYqxoJpQ6u5UR4+DKvaLvYosjRTJspDHlVfXJRwNxYfBelijDE/5Dxu980psaOTe+oQ
         8z4eT7tqV3yl2I2D9/vHvUmmTyQQA52NssHs0ln3Wl1DNy9kGqAyTuKE409PAWdynYcu
         /JdA==
X-Gm-Message-State: APjAAAUbwYujkCMe8TiIe8pRqyUhYobP0qnP79ni6y65N0BIj2BvKkYR
        r6W24ysdmIRU0bXQmj1ijyNiW2ylW66MZDSe270dA/3hzg==
X-Google-Smtp-Source: APXvYqwn9eaLFmr4McIhGDQga7ysUUkvHif2+dUpPb7dmfqBEDYbklBDs16YoB0+/LUiUUS2eb0+vnKfuqRYI1h1Kv4=
X-Received: by 2002:a6b:5908:: with SMTP id n8mr16056124iob.206.1552311887623;
 Mon, 11 Mar 2019 06:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190307154316.19194-1-ykaradzhov@vmware.com> <20190307154316.19194-5-ykaradzhov@vmware.com>
 <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com> <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
In-Reply-To: <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 11 Mar 2019 15:44:36 +0200
Message-ID: <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 3:20 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
>
>
> On 11.03.19 =D0=B3. 14:09 =D1=87., Slavomir Kaslev wrote:
> > On Thu, Mar 7, 2019 at 5:44 PM Yordan Karadzhov <ykaradzhov@vmware.com>=
 wrote:
> >>
> >> const char *lib =3D plugin.toStdString().c_str();
> >>
> >> This line is a bad idea because the returned array may (will) be
> >> invalidated when the destructor of std::string is called.
> >>
> >> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> >> ---
> >>   kernel-shark/src/KsUtils.cpp | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.c=
pp
> >> index 34b2e2d..d7b1753 100644
> >> --- a/kernel-shark/src/KsUtils.cpp
> >> +++ b/kernel-shark/src/KsUtils.cpp
> >> @@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_cont=
ext *kshark_ctx)
> >>
> >>          auto lamRegUser =3D [&kshark_ctx](const QString &plugin)
> >>          {
> >> -               const char *lib =3D plugin.toStdString().c_str();
> >> +               const char *lib =3D plugin.toLocal8Bit().data();
> >>                  kshark_register_plugin(kshark_ctx, lib);
> >>          };
> >>
> >> @@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_co=
ntext *kshark_ctx)
> >>
> >>          auto lamUregUser =3D [&kshark_ctx](const QString &plugin)
> >>          {
> >> -               const char *lib =3D plugin.toStdString().c_str();
> >> +               const char *lib =3D plugin.toLocal8Bit().data();
> >>                  kshark_unregister_plugin(kshark_ctx, lib);
> >>          };
> >
> > Doesn't the new version have the same problem with the temporary QByteA=
rray?
> >
> > How about saving the data in a local std::string/QByteArray variable?
> >
> >                 std::string lib =3D plugin.toStdString();
> >                 kshark_register_plugin(kshark_ctx, lib.c_str());
> >
>
> Hi Slavi,
>
> As far I can understand toStdString() will create a fresh std::string
> and this string will has its own copy of the characters. However, this
> copy gets out-of-scope as soon as we hit the semicolon of the line.
>
> My understanding was that toLocal8Bit().data() makes no copy so the
> array will go out-of-scope only when the QString is destroyed.

I did some digging into QString's implementation. From my reading of
the code, toLocal8Bit() calls into qt_convert_to_latin1()[1] which
does allocation, copying/transform-to-latin1 and returns the
QByteArray. So it seems that toLocal8Bit() is still making a copy.

[1] https://github.com/qt/qtbase/blob/5.12/src/corelib/tools/qstring.cpp#L5=
275

Cheers,

-- Slavi

>
> But anyway, your solution looks cleaner and safer.
> I will send another version of the patch.
> Thanks a lot!
> Y.
>
>
> > Thanks!
> >
> >
> > --
> > Slavomir Kaslev
> >



--=20
Slavomir Kaslev
