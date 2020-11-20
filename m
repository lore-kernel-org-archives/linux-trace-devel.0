Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146DCC56202
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A089122255
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BmAQfwDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgKTMHA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 07:07:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:46808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgKTMHA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 07:07:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605874018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sWBPnVOn3JUbfPUv0gEfbjGJMslCqmcfTHQYPMoUQZo=;
        b=BmAQfwDG2LnHuOgU3OJHwClJDzdB3Hoo4Z7MMAQwLzVcxqLCnQSs4bhsavSiC+Z/+K3Bz1
        ycdwsBNtSW/FBhZm8PstpoJXBbjhXIEQCr1bXAlvHXAmbUWr0WjXj/nSCnake0d1Nkv5U6
        ZDQhCydUwSi2bHaQgBJ/Sxn0WagGGpg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95285AD5C;
        Fri, 20 Nov 2020 12:06:58 +0000 (UTC)
Message-ID: <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
Subject: Re: [PATCH] Fix `make -jN trace-cmd gui`
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 20 Nov 2020 13:06:57 +0100
In-Reply-To: <20201119220910.1a8ec625@oasis.local.home>
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
         <20201119220910.1a8ec625@oasis.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hKixEvwFi25SEy7cumkf"
User-Agent: Evolution 3.38.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-hKixEvwFi25SEy7cumkf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-11-19 at 22:09 -0500, Steven Rostedt wrote:
> On Tue, 17 Nov 2020 21:16:45 +0000
> Dario Faggioli <dfaggioli@suse.com> wrote:
> >=20
> > Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
>=20
> Thanks Dario,
>=20
Hi!

> I applied it.=C2=A0
>
Great! Thanks... This will help me, because I want to do:

  %build
  make %{?_smp_mflags} prefix=3D%{_prefix} trace-cmd gui

in the openSUSE package for KernelShark (see the spec file here:
https://build.opensuse.org/package/show/openSUSE:Factory/kernelshark )
which is now packaging version 1.2

> But note, we will be releasing kernelshark soon in its
> own repository (a new and improved version!)
>=20
Yep, sure! I did followed the talks you've been giving about it at
events, and I even played a little with what you have here:

https://github.com/yordan-karadzhov/kernel-shark-2.alpha

The host-guest tracing part, as I think you can guess.

> Stay tuned!
>=20
Looking forward to it!

Thanks again and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-hKixEvwFi25SEy7cumkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl+3sWEACgkQFkJ4iaW4
c+5tUhAAguaEisUAI9N0QQvosW2ZOofsNFIyAahNJV47K8LYB4b6DhE8n28ETDyx
LnG393D0cwAfN6xKmdjFR2rMp9ezsfUGv6qEyucHwAKkXINkrJKg+E4OiMWekBef
iwkamlcXPTJtX7ZWd2uSUKRmX5ZLQ2T0OFiFz7pLRuIlao0r0yqTPtDgeXk0SXQX
gQoG396xAzUQFWhiBEJgF1i8/j1GwnsYBHv7rTMs8Lws+KGCWgJp+0Uq0zWa/EOq
cpL4uvDcgH+hDpvVz9hMaTqFrVybJylmdvQHOjUT2PmpOhvz2Ee2r9Z0oMlPYh5j
qALLox8oki8H5IUFmNc1LcmCiLbJmT4qzTWv0GPoC1ybFc90LCch9qSVBhhSb9nX
xqrFMILBJ3GjTIPngW6wbSNuYIHdbmNrLjX2KXAdZRyHXnJjO5UfF2KC1PAc6ZJ8
pJ287Xj1qkYEicftCt84tlDkfCrQ9Nfzi1uiPgznYldE9pQ0wF2NLCODAf5He7fP
vu5YFczZZdpYXs4z5H3+yApKKdfXK0xsaz2Ri72CzwSxSzyDDiOsUiVcIvFjIVRw
F0XviHHlN68IJ5NeZDCGVlqOdpSx5fUaS69MFRaVuWMOBDpEe6UXyDRiLaHvY+ah
u+bSj2N3I+WlxFp7TqzoQVF0iIbk3jywXWcoBn7tCQpKCAYpFhY=
=TTJR
-----END PGP SIGNATURE-----

--=-hKixEvwFi25SEy7cumkf--

