Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF57C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 07:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE0464E7A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 07:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBIHTS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:19:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:50858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhBIHTO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 02:19:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612855105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4bx/CaJ9dKByChpDVcit3DB5j3ixPSNTAvEI3tfvdsQ=;
        b=HYrWZmX1+vSS8VJJ7zexjka2iTPDOUmW0n+K+8S5ED+32v5dG5FXN1d42nlfQuVcZhBk/D
        V0b6ngbvsOSAk/plExY1mjBn7+a1+bt+wAoeZPhJ/RCjfhrKEy2G05FxzR+fIP+zZWEcnJ
        LcEAt4RlEt21mvSU6eoPjVVXlQ0sgqg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A82C2AB71;
        Tue,  9 Feb 2021 07:18:25 +0000 (UTC)
Message-ID: <36b92f82fa13ab5f36b50ba6aff852d66a55f9f3.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 09 Feb 2021 08:18:24 +0100
In-Reply-To: <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-n8rW0w4Y7TjLX/hAt4iz"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-n8rW0w4Y7TjLX/hAt4iz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 08:03 +0200, Tzvetomir Stoyanov wrote:
> Hi Dario,
>=20
Hi!

> On Tue, Feb 9, 2021 at 7:32 AM Dario Faggioli <dfaggioli@suse.com>
> wrote:
> >=20
> > If necessary, I can provide more info about my setup, or do more
> > tests.
>=20
> There are a few limitations that we are working to address:
> =C2=A01. Ensure that vhost_vsock module is loaded on the host.
> =C2=A02. You should add a vsock device manually to your VM config, I use
> "virsh edit <vm name>" to add:
> =C2=A0=C2=A0 <vsock model=3D'virtio'>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <cid auto=3D'yes'/>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <address type=3D'pci' domain=3D'0x0000' bu=
s=3D'0x00' slot=3D'0x09'
> function=3D'0x0'/>
> =C2=A0=C2=A0=C2=A0 </vsock>
> somewhere in the <devices> </devices> section.
>=20
Yep, these are both fine. In fact, I tested host<-->guest communication
via vsock independently, and it works, so it does not seem a vsock
issue...

I also try without the series applied (but keeping patch 2) and it
still fails in the same way.

FTR, in the past, I've used trace-cmd from git with an earlier version
of this series applied (the "KVM clock" wasn't there yet) on the same
environment I'm using now, and it worked.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-n8rW0w4Y7TjLX/hAt4iz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAiN0AACgkQFkJ4iaW4
c+7dWRAAheCG8rAVHquak+DfmXqAI+FAaqDxmSf3iu+M5xbhXIQrEEORCt4oSR82
Fzx9mPDDyqNHw16oLnJ2pRxyUCsC7aJz63NKIDPTeuLyuKtQmLIdE0/par904baK
p66skWTyam2dcyl/u40ay4KdmPQuNwZ+0GeoX9aM02tbdKAskxuDNhIAuJ7pKobP
wfZRp2pxdfj4/opHbQ+yDwARc9tQmmK878MucvNUED6D+d5fKECYY300mdR5Ocie
YmBQPrA1jYW4Ynwox6Zf5xik3gR2d/1TdNE5ENdeBZqtyPmtuLR60/sm03W+OR82
UOsBpL8WgmTEhFEhT3zj34xrquff3yi5HLtzqBSnLXhiQBdZOIUWU8TZEH+11qzu
vHDEQ22uBIWh5yKJ6Tg+2/iLRyycu4RxLf5R+6xJS0wjq5FoAqddE6omM0MVKU4k
G3rZyxS8F45TnNb/w89TUXlefVKx+RtVcJg154xvwEZpmTpn8Q/otkUBrNHXwAYk
Sz6LUTTqqHQvHyEkMz6rkbiCeUIyd+LWaRe+5xaxs3o7GyF6drKxGMTjdra03cZB
SlqJAQwHSYxAuGv20gjJPFL5XnQ/q7IkfyKfBMqAKmB+cwsXgp1KqWjOzwfdw/c8
y+HqI7vVgxbXK+pHGxGSZ8+eZkq+sWY3lAdkwePS9ZodiaezCcI=
=XSVY
-----END PGP SIGNATURE-----

--=-n8rW0w4Y7TjLX/hAt4iz--

