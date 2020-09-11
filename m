Return-Path: <SRS0=hB+T=CU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CD3C433E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Sep 2020 02:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A502021941
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Sep 2020 02:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgIKCIY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:08:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50128 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725298AbgIKCIY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Sep 2020 22:08:24 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1kGYUA-00006I-U9; Fri, 11 Sep 2020 03:08:23 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1kGYU9-000SOJ-HN; Fri, 11 Sep 2020 03:08:21 +0100
Message-ID: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk>
Subject: tep_free_plugin_paths() function in libtraceevent
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 11 Sep 2020 03:08:16 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-zhVWXYKVDbdWc0cu7h6P"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-zhVWXYKVDbdWc0cu7h6P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed that the new function tep_free_plugin_paths() is exported
from libtraceevent, but is only declared in a private header file.

If it's meant to be part of the API, it should be declared in a public
header file.  If not, I think it should be hidden from library users.

(I think there are other only functions with this issue; this just came
to my attention because the Debian packaging tools prompted me to
update the symbol-to-minimum-version mapping.)

Ben.

--=20
Ben Hutchings
Never put off till tomorrow what you can avoid all together.


--=-zhVWXYKVDbdWc0cu7h6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl9a3BAACgkQ57/I7JWG
EQnQZQ/5AThSewg1FDqHC+/K2M00sDPl5SkdpUU32w6e3M8LG6ZfSVG0yqd8I5E/
DihpxTUKx6/rPM1tSNS4cA3PEUznsTYbwNb2HWEBx4VtHpCsUSFpKW/F4W1Qe0g9
PZq4Zf6w8MYhfI//IeasYPvkJUdHOiWLK6xvkIbZwxKMSJScuVuhUzK7bb83G3KD
okqShjBBH4A+8UwnFTwNVm/9fU4JovDCmpIX0Vxg2NHW1DUu12JXSIkD5ripeH8B
/qoEHhXKXFwG7FJpqja0ewqpms/g8JInV2RLvlbc0vFjRlI7hkUtRJ/YqBXnJpXS
NFRqUxb3TPvoObIId6W701MldXh6ErMsqTMbEsWaRvxb/alVHhVPecLM6fgsAtyI
nWf0yH69S//N6K83OAYNTRno89LCNRnD15Qe4bWsh+5eubr0IY4Vxw+U3jqaNoc/
AC8l0tRnZF6pyAJc+as9JgwZcEF//D5qU5Wpi57KWwDPfmxO6mSBlQiSGFaUO+57
ZpMQ7MGh+3DCiQTeyymwdgk8KHrZLXnQ3BGxJasNiDK191wmamRQTizkzeNSKzbL
RtjICY6PtlBA8lfKf3D52INyGEB44PEjrnmocpsrh/PieAjyJB+Dfg+VTaKWPGPI
0zsSpLqX7S1AZ6txtHb3ToNtz+wUgT8Egc+j7F5rZeq4VhRIM+I=
=ctia
-----END PGP SIGNATURE-----

--=-zhVWXYKVDbdWc0cu7h6P--
