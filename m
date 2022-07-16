Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBC5C43334
	for <linux-trace-devel@archiver.kernel.org>; Sat, 16 Jul 2022 13:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiGPNsk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Jul 2022 09:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiGPNsj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Jul 2022 09:48:39 -0400
X-Greylist: delayed 84 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 16 Jul 2022 06:48:38 PDT
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004A51C933
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Jul 2022 06:48:38 -0700 (PDT)
Received: from [91.187.115.177] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oCi9r-0002yq-SB; Sat, 16 Jul 2022 15:48:35 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oCi9q-006d0E-2p;
        Sat, 16 Jul 2022 15:48:34 +0200
Date:   Sat, 16 Jul 2022 15:48:34 +0200
From:   Ben Hutchings <benh@debian.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools/rtla: Build with EXTRA_{C,LD}FLAGS
Message-ID: <YtLBshz0nMQ7530H@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JnWgVlHI76m+bY57"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.187.115.177
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--JnWgVlHI76m+bY57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

To allow for distributions and other builders to apply hardening
policy and other customisation, append EXTRA_CFLAGS and EXTRA_LDFLAGS
to the corresponding variables.

Signed-off-by: Ben Hutchings <benh@debian.org>
---
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -30,8 +30,8 @@ WOPTS	:=3D 	-Wall -Werror=3Dformat-security
=20
 TRACEFS_HEADERS	:=3D $$($(PKG_CONFIG) --cflags libtracefs)
=20
-CFLAGS	:=3D	-O -g -DVERSION=3D\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(=
TRACEFS_HEADERS)
-LDFLAGS	:=3D	-ggdb
+CFLAGS	:=3D	-O -g -DVERSION=3D\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(=
TRACEFS_HEADERS) $(EXTRA_CFLAGS)
+LDFLAGS	:=3D	-ggdb $(EXTRA_LDFLAGS)
 LIBS	:=3D	$$($(PKG_CONFIG) --libs libtracefs)
=20
 SRC	:=3D	$(wildcard src/*.c)

--JnWgVlHI76m+bY57
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmLSwbIACgkQ57/I7JWG
EQmqGQ/8Dep1OVgyrGFUGnIJGO5+cgiUGYI/NOKjSH0lel+SmkHonO3XsUCy80LH
Yh4foO4uE78tLobRh7DF1tiimS1DXqQqc01JAckBjdq1w6giSfksNdAebpLcgXCl
VFtVUhPRWsU03RY8Y7OIE2LmtwBpmOPUb7Re8gp+JjQMmmA4tMzZDclzid6g4xYa
oBi8Q0ZFp7t2X22T/Qn08qaqkahWTyIqXaK8NkuBKzgXuZGoPKVvPN95kRM89LKo
ZN/SaGRmUcpxtRmFpXU/eRTudyuninyjvKB8xYY7e5GE41TvGkRqh9Xm++geAK5O
fAOVQV0HmhcsQFg+Qtkul5a6R5S8PF4NqBCLyUnHAmJq26BlRAjD3j2zf9St4/iv
9TbexfJ/ILLR1DCiNRDj1hksvjDh57VB64gH3nTXd7ucIWe8dtEPtTEAfSC5MoQL
4VAHFlTLkjS6oQYcB5+NoGgHO8ElTK2rl0QHz3L4uVZyaxXdaVOdWo8QP1W4RG0i
H0CLFlJ/0GfZUSuoosGmAD8DILHnQcrLAV2ui+6IHGNcaPrBJ5Hi3ngBgvrfpz9V
DBtKerp3dbSmZSASOWGO769NtEyfPz4JGbRmAu7AiS4/6ig+/iAy2WN7G1cMToR3
hcti19YbWXxu1Ldf8EzoEwQbjpTqhYbdIXE1icLEuR4KnJWax3Y=
=R2q9
-----END PGP SIGNATURE-----

--JnWgVlHI76m+bY57--
