Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F1FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 08:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46A922D58
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 08:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLJI4w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 03:56:52 -0500
Received: from sleepmap.de ([85.10.206.218]:34874 "EHLO mail.sleepmap.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388312AbgLJIz6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 03:55:58 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 03:55:57 EST
Date:   Thu, 10 Dec 2020 09:48:02 +0100
From:   David Runge <dave@sleepmap.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 00/27] Start KernelShark v2 transformation
Message-ID: <X9Hgwhhc5hbhLsFV@hmbx>
References: <20201209134203.428068-1-y.karadz@gmail.com>
 <20201209213822.74c90f15@oasis.local.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vSU1K3JPHG/PleKH"
Content-Disposition: inline
In-Reply-To: <20201209213822.74c90f15@oasis.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--vSU1K3JPHG/PleKH
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Dec 2020 09:48:02 +0100
From: David Runge <dave@sleepmap.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
	linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 00/27] Start KernelShark v2 transformation

On 2020-12-09 21:38:22 (-0500), Steven Rostedt wrote:
> On Wed,  9 Dec 2020 15:41:36 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> I just realized that the current repo doesn't build against the latest
> libtracefs, because the library's location has moved.  I noticed that
> the CMake files have it hard coded with:
>=20
>  find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
>  find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
>=20
> Is there a way to make cmake use pkg-config?
>=20
> 	pkg-config --cflags --libs libtracefs
>=20
> Will give us the correct includes and libraries for building against
> libtracefs if installed.
>=20
> We'll want the same for libtraceevent and libtracecmd as well.

find_package() [1] is usually used for package discovery in cmake-land.
If the NAMES argument is provided it overrides any provided package
name.
In more complex cases (of the package) it is better to have the
package ship with a find_<PACKAGE>.cmake file that will be automatically
used by cmake if it is installed in the system locations.

To use pkg-config/pkgconf directly, it is possible to make use of
the FindPkgConfig [2] module.

Best,
David

P.S.: Out of context: Why is the cmake minimum requirement so low? To
make use of useful features in cmake it needs to be at least 3.4, better
higher even.

[1] https://cmake.org/cmake/help/latest/command/find_package.html#command:f=
ind_package
[2] https://cmake.org/cmake/help/latest/module/FindPkgConfig.html

--=20
https://sleepmap.de

--vSU1K3JPHG/PleKH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEkb2IFf4AQPp/9daHVMKPT/WhqUkFAl/R4MIACgkQVMKPT/Wh
qUlFZQ/+JFzoIfidT3NbAJ/PF84Ix3i5bH5yknB67P4cwOYoesP1MAap5h+jVyn+
sUa3bb+TMrfzjphAsDeeZz/8Cb0WMcDq901CTc+MBIorpqTZIiWCBoBukqOIy+tq
YB94v4o1ajD2PITz4EHjjwvs2ZOjGSWyQpGhmBPLuJpw5nGQHQG255yOLQYFHUlM
D6I3cXkA+9LbncDUL4fk5Bc3K9nCl5tscsOxUsrLWRkH8BgFRncF05jhE3InPH9h
BaCUFhQwPhI5sHieTbVpvnSRTQZEj7hEjnZKf4qFeeSLE5e0SZjSoD+HS2oTznNr
BuFZzc7YZdclvd/a/f22dal+T3ejsEi74Wy+2tbRk14KfY+1CIY0cx7Zit4j5XFr
L4tIr7UOdMJqf3PBROIj67gMqSi/B4M7EzquvwBxq7F0/03Zu6etDzFMIo8+QAy4
YdNa6Z0aIm4o5ZtPdZx+0xPS/Tqbrij+MUFOdD3bqehknmkMvb3Xhm3nm1i5/td1
Jx/8T+3Ez2oIZPPoPVjSFfjfbLRnUA6S2ba2q+VNTVsbpSy9V6xcIzN1qV48otCN
lSo8XE8Sfo4fpJYry62Wvhzr6cayXuDQnayLKDTWmuOnFvhNrBb4AeAHgCC6iNkY
Jjnwiqh7H6z/1g/cswTNeL1/cu2CdSo61xaN52lENzLD24IAfx0=
=rVJi
-----END PGP SIGNATURE-----

--vSU1K3JPHG/PleKH--
