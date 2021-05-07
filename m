Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21D9C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 12:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD6F6143F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 12:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhEGMte (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 08:49:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:57888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237054AbhEGMt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 08:49:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620391706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k15wI6xZ0+QDa903HLbGMsZLezOxZ0p8RMNa2kA5SrI=;
        b=jzWJ768DnveQGBkeVzbHtgeCmK/8HrrUQ2WkKCn3pX/1CmTgv/3X0ZfgYqER8xY60QOKam
        f1wgg7rJO3dtktxEpBdC+3ADtZixuQzE4dNymwquv0ksMEfTuj64Fu8mPprdlZBFqaLizf
        HBer2tWdJtVa0FbYJgpSiP6t+o175Vk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C1F5CAD4D;
        Fri,  7 May 2021 12:48:26 +0000 (UTC)
Message-ID: <098a7c9a4af4c0e6364a29eeacbd74a7505f61c0.camel@suse.com>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Fri, 07 May 2021 14:48:25 +0200
In-Reply-To: <20210507075834.43497e77@gandalf.local.home>
References: <20210506171400.7c00b731@gandalf.local.home>
         <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
         <20210506214012.741cbbd7@oasis.local.home>
         <CAPpZLN48irG2cuPZi4+RAORbkxpnHudNf1wdXBdjYDmr4e8bhw@mail.gmail.com>
         <20210507075834.43497e77@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Nv8UpCqP1mdhDPLX5iiZ"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-Nv8UpCqP1mdhDPLX5iiZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-05-07 at 07:58 -0400, Steven Rostedt wrote:
> On Fri, 7 May 2021 07:20:15 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >=20
>=20
> > Doesn't a VMExit always happen in the thread that runs the vCPU
> > anyway?
>=20
> The problem is that we do not know what Tgid we are looking for. If
> you
> have 10 guests, you have 10 different Tgid's that are running those
> guests.
> How do you know which guest is attached to the cid you are looking
> for?
> There's currently no way to find that mapping.=C2=A0
>
Yes, it is true that this part is missing. I have, like, a thought in
the back of my head that this may be doable in some way, but I can't
actually come up with a working solution!

What prompted my question was the fact that I was not understanding the
focus on this side of the issue, when we had no link to the CID anyway.
And that because...

> In fact, that's why I posted
> this patch:
>      =20
> https://lore.kernel.org/kvm/20210505163855.32dad8e7@gandalf.local.home/
>=20
... I had missed this patch. :-)

> So you trace the kvm exit, and all 10 guests were active at that
> time, and
> you have 100 threads that called kvm exit. Now how do you find the
> pid of
> the task that owns the cid you are looking for, especially if each
> guest
> has their own cid?
>=20
Yeah, as said, I see it now.

> Oh, and the guest is run by a fork of qemu that has some other name!
> So you
> can not rely on looking at the thread's cmdline.
>=20
Yeah, that probably depends where you look. Plus, we know don't want to
rely on QEMU doing things in a specific way.

> Again, how else can you map the cid to the guest thread? That's the
> missing
> link that following the wake ups give you.
>=20
Yep, understood. And despite that weird feeling that there may be
other/simpler ways, I can't name any, so we should go ahead with this
approach I guess. :-)

Thanks for taking the time to explain it, and sorry for the noise. :-D

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Nv8UpCqP1mdhDPLX5iiZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCVNxkACgkQFkJ4iaW4
c+6x6g/9FHYzARPTiq9UtqPbpX1lYjHqETWXcq4WhQhbW/yrtGQ3FPQmBa/VLaSr
MV9YvNw34VmKH1U5lMje77i4ow+2XYzjlhZ+KRrjeA+YW+hRt6G+GNwGcLHTVXjV
FUOOYWW2+TJDhpE8TklXxSvSsAEcwBNBG++oDxIVQrBVvKJQRecbzdbLajeXS4wK
+GNxcxvpLC7sxvoIIe94Cv19FegoiU8QEQABG7SAxIjOT29NTqS+Fff0gQrh4miz
J0N3FiXdJHr7SnhzS4bj4oLVV85GCA/B4PM1me/2bofLzS8rhLXIHlrCIP7QAmZq
eV/ltmTKOmPSD2FytgVR8p0B2I7almMPhAE1sUEMaS/xWI6TaaCTa2LOh5MDPeFg
EF4u+0P4Dzc4tYzoKX7lOmURouycSwZ+jdT8SJKrnv9R0sjp9o26V694U7Qt4sHI
lPYupI2G6NR1y7AIfmpW4KE59Y3BauzRzjYgE2CX8MKJTDBtNaUKRmH3CyToClm4
pgX8GOOz2eeJtX2La8fuEExsVGX2Y4Kc/ngQuI/KsytssslQDzJPxD+Rgo4PdeiZ
V/prDg8m6fXvlsR2wu2+9UHFYCbs3xJmZUg0LFeB7VZYmcW/yiEFmqUuBmRWAhky
t5GPA2uTIbyp4tSbeNvyAtQApLD0Mtvduf0IfSn6kILExnUldvA=
=4H1R
-----END PGP SIGNATURE-----

--=-Nv8UpCqP1mdhDPLX5iiZ--

