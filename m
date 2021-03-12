Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0873C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 11:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C96564EE8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 11:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCLLrV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Mar 2021 06:47:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:57888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhCLLrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 06:47:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615549623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MuE9uf11Yjb6ECIuNyD7mlcDFBKL6AVEuyBnzNFtYXc=;
        b=ui/YCQLQnAuMSELQVe3QCEhY+n9esIDsja82hT3WNbZkz69JlQar1i57giFkFsiwlW8ZMt
        aLbCowDlJAfnoIfmgapV5wj8dyiB0cdNbXoSCZieYBGfMrQc95k1dreg13w8xsNBw1Scf6
        25X/FItgQ2OjcWDVDH1AkKB0sPDtAVo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A0C04AFE6;
        Fri, 12 Mar 2021 11:47:03 +0000 (UTC)
Message-ID: <58b5888bfe22ee3825362492fab34fe3d0d493d9.camel@suse.com>
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Michal Sojka <michal.sojka@cvut.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 12 Mar 2021 12:47:02 +0100
In-Reply-To: <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
References: <87mtv97nlj.fsf@steelpick.2x.cz>
         <20210311145059.27147-1-michal.sojka@cvut.cz>
         <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
         <87k0qd7evn.fsf@steelpick.2x.cz>
         <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Azv+qqGk1//8oe2qKYGj"
User-Agent: Evolution 3.38.4 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-Azv+qqGk1//8oe2qKYGj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-03-12 at 08:46 +0200, Yordan Karadzhov (VMware) wrote:
> Hi Michal,
>=20
Hey Michal! Nice to see you here too... well, it's a small world, I
guess? :-P

> On 11.03.21 =D0=B3. 19:57, Michal Sojka wrote:
> > You're right. I looked at polkit sources and it really seems that
> > only
> > one location is supported. It is determined at configuration time
> > so on
> > some systems it may be different from /usr/share/... I'm talking
> > specifically about NixOS, but it already has the patch I sent.
> >=20
> > So I leave it up to you whether to apply the patch or not. I think
> > that
> > supporting seamless installation into $HOME is useful if one wants
> > to
> > quickly use a newer version not available in their distribution.
>=20
> Building, installing as root and testing the latest version shouldn't
> cause any problems/conflicts on your system. Note that there is a
> script=20
> in kernel-shark/build called "cmake_uninstall.sh". It is guaranteed
> that=20
> this script removes every single file that has been installed.
>=20
Not completely sure, but since NixOS is being mentioned, I think at
least part of the point here is  making sure that a development/testing
version of KS can be installed in those "special" systems that have
read-only filesystems (or similar configurations).

In such a system, even if you are root, if the makefile tries to put
stuff in a part of the fs which is not writable, it's pretty much
game-over.

In fact, I don't know much about NixOS, but I'm on one of those
"immutable" systems myself (openSUSE MicroOS, FTR) so I can relate. :-)

So, although it's definitely a niche use-case (for now!! :-P), I think
that either this patch, or at least not making the above issue fatal
(as you're saying yourself) would make the life of some users easier.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Azv+qqGk1//8oe2qKYGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmBLVLYACgkQFkJ4iaW4
c+5+4A//YKRLxXj+TiQot4kZSn3Fz+MDoZeJsfm5ZJwxn5eDYSYJPWtAhngO3Sd9
FlOcKyjbKkbrsawnQwf3O1KGc48yhTzg6mWJcS023XsFCPaXIC70JjIriQDSKuvF
NibTQypoxs2fair9PXt69URC+sWkbet5beG5mtkQ4kAfLt+ZKzQQL6dZDL3TLEU9
Zvh/v0PxvlSbr7MfGkc+p/0S6y2NjkieFN8VksPw5ofmM/3KbGcj2CM2jCMXYuzW
NKhnS2V9qyqNoBj37yJbTyL+FeQQs2z/7iWCdimFjerOGHI8lTvbqwEnglKx1MrV
rx+X8dMWnIUcfmrsD22hOJMjZ91hPfsYNPg3J8rDB5omX9dfWfH98YT0LQDcaL/8
E6ez2F1YwQwBNxdiCKjoz6407TJ1Ue+NQYLGDa8gbRUB/MDadFAMiFlvoklpvdPC
5+uYcJSB5YHnY0epOPca8B4fuHugaAljTgrTRK3iTpSZZClj4Dskgs+AwwY4Kghi
WcX7E4v5kDEO0HUoyZynetvuhVXeN19iNIGepqbul59fwMHhOmg4pg/B97kZBJ54
pyQTZwJj5IpMz2kXuNAGG0P1faaetUrUj8dOagGETsUGu194OBuwYGCYZjmRqzU+
00H49pEfNR+TaK9QxYT15H6HymQ4bAKjwGJZlSGjk/+xlc+OKeo=
=0p2d
-----END PGP SIGNATURE-----

--=-Azv+qqGk1//8oe2qKYGj--

