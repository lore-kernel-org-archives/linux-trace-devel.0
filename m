Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D90C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 17:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLORm4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLORmz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 12:42:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6FA11C0E
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 09:42:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D8CDB81C00
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 17:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF40C433D2
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671126172;
        bh=/F4Pbkn/uKrSi/k33wAI6ocYVBlM+8/gLTK7i7/yH/0=;
        h=From:To:Subject:Date:From;
        b=Obg3QTrhUlq+VETluthPbNDE9h8wHBZO2ItiNqBSNiFku5e9r7pBOCv1dBOl+f5su
         vGIzY3UBf+T2KC0yhZ/FzfgA8qy6rh0ppX7M1Cbghfy3e1KvF6IX1bndzq5sNgRmmA
         8kQRyAOyTj48kEY3oY+tFBiv129ww+N2539j+HaHuaX9Wf88xwuB17FMs34EUN5oyZ
         CIGKgaAKAotfS2PYxPfOqKwsMmRkgLqEOsi+AKhNWdWblhnGpltHdeGWx51kQG17x0
         YcNHADTr0mvYmoNOqpEbUk6zKfnx3C20dMOwSU6CMB9FmrMDopM9LFe6w+HQOWkcS5
         YlpEMWsKKmS5Q==
From:   Felipe Balbi <balbi@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Subject: libtraceevent and threads
Date:   Thu, 15 Dec 2022 19:42:32 +0200
Message-ID: <871qp0wol3.fsf@balbi.sh>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

I was playing with binding `libtraceevent' to rust today. Generating the
bindings with rust's `bindgen' is very straight forward. When I moved to
porting the existing tests to rust, I found out that running a single
test always worked, while running all tests caused random allocation
failures and (apparent) corruption of the trace_seq buffer.

Upon further investigating the issue, I noticed that asking `cargo' to
run tests in a single thread (essentially one test at a time), always
gave me good results, but as soon as I let `cargo' run 2 threads (or
more) failures would show.

I appears that this is because `libtraceevent' keeps some global state
and that prevents different threads to keep their own "context" of the
library.

I can't say for sure, but it seems that the culprit here is:

	static const char *input_buf;

in line 31 of src/event-parse.c. Would there be a way to hide that
perhaps as part of `struct tep_handle'?

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEEg3wK/NVnD14JZqsmho6y4DXKpEQFAmObXIgRHGJhbGJpQGtl
cm5lbC5vcmcACgkQho6y4DXKpERvCQ/9EBQwyzv1VFbYVFaNMMtici1RfMjg2dwg
fBBsjQGzu+G2KOmS/Erb4RARKWLnXgLzojB8kMOQ3wsvvE28oGSHd4ekcGxajihb
dfJZHSK8uRvr8TYSAKs/mL6IxhgvLxSG+mDbB0N5FgHepdjaDyPZuOdv7p1j5bqk
CkxMJBMgE9y7u+ThPyvHf9fTFyHs6oULY2wKgPwjHzmZnOTElLPQhvPmXycJmVtL
mFSDwNdp6jgmBhXxdLWwn75LPlL/S10wJ2h6e+RdTyagyOzkVRYc2jlmlcqvxCp/
7pBAclAvmq2st2O/GNDkFfn4l+wv+HKCcxo6QpF23SZRxp3s1Nr4Ho9/dKElCAQu
zsnS3TuEvksIi+um2ifCqjM0hxeBOZHd4YG8ulFDLMxj0+r5QdzmsdyYavVKth/8
ojK8PiFpc9fN25/kq2X/E1A2abLIw+1kSKUqkHYLO5gAVW8RzUmRmPvHnas9P8oY
lmzo5jy23Jh/LAPTZf0YqFmL+j+T4708kuGjRmG1kjV293dXvsS9JsCqlD20/GYw
pOkx2UEJREVCttybaF877osMFOpjfwJUwNV3yIm1H/3zSd7IondqlBDhgsgM4wbw
pNOmZZyu98PMm5B09CSQyOOHUA8pq6o3oZtpX8VuRw4Om+cEhsxuu2tfCNnD0iwZ
fxp9KKKTvLk=
=dzoE
-----END PGP SIGNATURE-----
--=-=-=--
