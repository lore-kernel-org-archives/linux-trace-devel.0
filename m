Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFC2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 16 Jul 2022 14:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGPOKT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 16 Jul 2022 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPOKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 16 Jul 2022 10:10:19 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEE4210
        for <linux-trace-devel@vger.kernel.org>; Sat, 16 Jul 2022 07:10:18 -0700 (PDT)
Received: from [91.187.115.177] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oCi8T-0002xw-0S; Sat, 16 Jul 2022 15:47:09 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oCi8S-006czU-16;
        Sat, 16 Jul 2022 15:47:08 +0200
Date:   Sat, 16 Jul 2022 15:47:08 +0200
From:   Ben Hutchings <benh@debian.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools/rtla: Fix command symlinks
Message-ID: <YtLBXMI6Ui4HLIF1@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VNmDCqjgJAatXKt+"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.187.115.177
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--VNmDCqjgJAatXKt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

"ln -s" stores the next argument directly as the symlink target, so
it needs to be a relative path.  In this case, just "rtla".

Fixes: 0605bf009f18 ("rtla: Add osnoise tool")
Fixes: a828cd18bc4a ("rtla: Add timerlat tool and timelart top mode")
Signed-off-by: Ben Hutchings <benh@debian.org>
---
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -108,9 +108,9 @@ install: doc_install
 	$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
 	$(STRIP) $(DESTDIR)$(BINDIR)/rtla
 	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || rm $(DESTDIR)$(BINDIR)/osnoise
-	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/osnoise
+	ln -s rtla $(DESTDIR)$(BINDIR)/osnoise
 	@test ! -f $(DESTDIR)$(BINDIR)/timerlat || rm $(DESTDIR)$(BINDIR)/timerlat
-	ln -s $(DESTDIR)$(BINDIR)/rtla $(DESTDIR)$(BINDIR)/timerlat
+	ln -s rtla $(DESTDIR)$(BINDIR)/timerlat
=20
 .PHONY: clean tarball
 clean: doc_clean

--VNmDCqjgJAatXKt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmLSwVMACgkQ57/I7JWG
EQkvARAAs8j2aSZ28FvK+yyteGunsWn2TDDgVgIffKbZclqtrQAYWKdajby30YAC
2ec5g4ceMvym6scIYI6cDRsIuvshg2KNZffbj+e92aQGegrzeQLyZV1shcp65IQ5
i+S/wMaad8qnElmkCn3trCHO87BmLOh+qs6RcFskEgbGJKYNmBLB8DTAYXXWwidR
FNr0/+Argby3J3HS8N61yHezHN7doT8m90mbCWmM3iiaiPP1wEIywRfzO61+LY3R
4UBH8RUHBe5rJJ02USJnM63gCcemMGHz3KdjYZwU0S93ItGeQks2TPhP4Kn0tcsc
rAVjZqcPi3gw+9XCH9kDqPFEXY7xWoHZhChqvOB8OBytK3X0Wl78rkoyh6O7A85u
upwubfLqiB+S1l/ceIYco8PjU35m0qKEmp0WxOi0eXr33kw8wI64ksEQWrDNWESd
SKy46dRqzyOxH0xyl6DuaInyeW5IZlBiCfTRb6W3OOjWBdvhp277BfIGnv7GVVjz
eZAzgb9OExxcwhwiDtUA39QX3IL5POyTaMMRh0J05B/wNrMkEMaoWJZ2ykOD/lJk
mF5+g+9Pm5i/iI29RLG79D22P6dX47Jh8efZfKYNgUuLDlZAbn3Kkdt0okO5hoQu
PEU5jhq0bQeOGd3Bpt3hUeXcE9sErb9CKSD4Hk4yN6ZBJYlcxYc=
=XRRZ
-----END PGP SIGNATURE-----

--VNmDCqjgJAatXKt+--
