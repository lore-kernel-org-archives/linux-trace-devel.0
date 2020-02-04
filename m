Return-Path: <SRS0=5emk=3Y=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D8BC2D0B1
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E29E320730
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0BPASd6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgBDLM1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 06:12:27 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35468 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgBDLMU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 06:12:20 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so7150295plt.2;
        Tue, 04 Feb 2020 03:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aUTbPK5hqdnfd6ET5RB1/UVTtKvhLEvaensAdf9wtlo=;
        b=c0BPASd6egTIHFc0ehictqlGn7fhqzelxxJ0T1vA+XJrKjDeB+KiAmlPkbp/npDJAa
         VGZawmRW1GnoO6tuqulxfGl2nO63w1NFKE0H9KcQRNYTZjO5fGuAVfVLnXP1juO3UdeK
         Ob74xY5LCwGVUMp+/KZiYFzY1meSoXh8fIB1nFDscdnI2zttSTCnnzZcZbAbCPdY3t0I
         8A9W3CGPdoBwbZk+0Fb+VdBHm23KAwSb3CiRU+Ad1e3UCsycj2bCosEVAbNMsIxpIEos
         ZMw6nhk6s6vmPi91rGS185RmSPnQ3CHJh/QP4B3fqyNibCLDkXwt/HUyZa/yIsMp3PX5
         trxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aUTbPK5hqdnfd6ET5RB1/UVTtKvhLEvaensAdf9wtlo=;
        b=ClgNOBpNR0Z1gYh1lTwfTqdHIvADXsozFfgnkt1a6IRFM7kE97bA9+1UIhDXpe9Ua2
         RS0IoSZIFXWPnxP1av71WpVwYPCTURcCCSsPyieZHP/r7Uu8dD6NClXaEDRLGCstcDSv
         LRo7rbhLO4qqGK+bFQ8eoKw3gEvw2JavVY/hVj+hIr7kyWJw5DlNVT49n2AHw+RPWG0r
         cm26W2lNu7j+1DWDtOR8PGhiYVaEMmgn5K0AekQdGcD5tXRGpOWxwLvjebzA+SYjzCkG
         FydXLEMxA5OBPwh/1VYJzntKgExAzedrzuDnrF2AVMez+3a4TQT5QlAdP+lM+0JyYPOO
         YZMA==
X-Gm-Message-State: APjAAAW0VEIbN/2VYETA8/6rDTyPRctHNsYUiAimorVyJeiwGYtTOAkp
        g3fz7UR6Eb+VvfoikLdDhfuSZ7343LWPXP1Qt+c=
X-Google-Smtp-Source: APXvYqwkf/ea/Wg90UbHxH7UJFNU4h1aMvWa3nd+PSwmThksvVrGDx/IvVcE1u2+bh1CqFFDH983rmxQ9B+A77nPTXs=
X-Received: by 2002:a17:902:d20c:: with SMTP id t12mr29769700ply.18.1580814740109;
 Tue, 04 Feb 2020 03:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20200201161931.29665-1-lukas.bulwahn@gmail.com>
 <CAHp75VezYub1YzGSMrwQ7ntAV6EftgLxFiQu9wVnekPHPe4d_g@mail.gmail.com> <alpine.DEB.2.21.2002040533360.3062@felia>
In-Reply-To: <alpine.DEB.2.21.2002040533360.3062@felia>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 4 Feb 2020 13:12:12 +0200
Message-ID: <CAHp75VeXBTt07W0Xvke4P_4MEo92Ee7wUbxCg1_LgkXcsVgvVg@mail.gmail.com>
Subject: Re: [PATCH RFC] MAINTAINERS: add TRACE EVENT LIBRARY section
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 4, 2020 at 6:42 AM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
>
>
> On Mon, 3 Feb 2020, Andy Shevchenko wrote:
>
> > On Sat, Feb 1, 2020 at 6:21 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> > >
> > > The git history shows that the files under ./tools/lib/traceevent/ are
> > > being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
> > > and are discussed on the linux-trace-devel list.
> > >
> > > Add a suitable section in MAINTAINERS for patches to reach them.
> > >
> > > This was identified with a small script that finds all files only
> > > belonging to "THE REST" according to the current MAINTAINERS file, and I
> > > acted upon its output.
> >
> > > +TRACE EVENT LIBRARY
> > > +M:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> > > +M:     Steven Rostedt <rostedt@goodmis.org>
> > > +L:     linux-trace-devel@vger.kernel.org
> > > +S:     Maintained
> > > +F:     tools/lib/traceevent/
> >
> > Don't forget to run early mentioned scripts (in some other threads).
> >
>
> Andy, I did run on next-20200203:

Awesome, thanks!

> $ ./scripts/checkpatch.pl -f MAINTAINERS
>
> WARNING: MAINTAINERS entries use one tab after TYPE:
> #14607: FILE: MAINTAINERS:14607:
> +M:     Micah Morton <mortonm@chromium.org>
>
> WARNING: MAINTAINERS entries use one tab after TYPE:
> #14608: FILE: MAINTAINERS:14608:
> +S:     Supported
>
> WARNING: MAINTAINERS entries use one tab after TYPE:
> #14609: FILE: MAINTAINERS:14609:
> +F:     security/safesetid/
>
> WARNING: MAINTAINERS entries use one tab after TYPE:
> #14610: FILE: MAINTAINERS:14610:
> +F:     Documentation/admin-guide/LSM/SafeSetID.rst
>
> total: 0 errors, 4 warnings, 18577 lines checked
>
>
> That issue in MAINTAINERS has a pending patch since 2019-12-07, with three
> attempts of asking to be picked up by now:
>
> - https://lore.kernel.org/lkml/20191207182751.14249-1-lukas.bulwahn@gmail.com/
> - https://lore.kernel.org/lkml/20200116185844.11201-1-lukas.bulwahn@gmail.com/
> - https://lore.kernel.org/lkml/20200204040434.7173-1-lukas.bulwahn@gmail.com/
>
> It is not related to this patch in MAINTAINERS here.
>
>
> I also ran $ perl ./scripts/parse-maintainers.pl and checked the generated
> diff for this entry, but there was no reordering required; a one-element
> list of F: entries is difficult to get unsorted ;)
>
> I am not adding any mess (ordering issues) to MAINTAINERS with this patch,
> other than what is already there, but cleaning that up is completely other
> story.

-- 
With Best Regards,
Andy Shevchenko
