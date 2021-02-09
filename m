Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F67CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 10:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DD1364DAE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 10:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhBIKuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 05:50:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:52140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232077AbhBIKsu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 05:48:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612867683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=NIq7yoKtFzWd7VQzawdH2FFxERfkZ0jcnjX+8NoXvYU=;
        b=R+Ur/N8KsESci5VkR1F3sMJzdElwfO/MWN3o1PynxGgx9mXH43jplctGOyTAuTj6ONzGwD
        PuBWMdPnDCBGayKU/rsKgns+nsWXbiGNDZckZrYLGGR9BwCpJGYSPHsiGB1hvwMjLNOkZB
        at2SIhIUCK/Ibe5n4EpQZLohHHLAqSE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 99A60AF26;
        Tue,  9 Feb 2021 10:48:03 +0000 (UTC)
Message-ID: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
Subject: Kernelshark v2 all-black plots area
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Date:   Tue, 09 Feb 2021 11:48:02 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fGBSAxNK3DXlz4Se+geN"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-fGBSAxNK3DXlz4Se+geN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Heya, me again! :-)

So, I'm not playing with trace-cmd only, I'm also giving a try to
kernelshark-v2.

I can build it fine, and it even starts, but the plots area looks
almost all black. The events and the tasks occurring on the "last CPU"
(i.e., on CPU7 if I have 8 CPUs) are more or less fine, it seems
(although still hard to work with, given the background).

Actually, it's the last plot that "works". In fact, if I add a task
plot, I do see what that one is supposed to show, but the events of
CPU7 disappear.

Others are there, because the marker moves if I click on the entries in
the trace area... but they're kind of behind the black cover.

A screenshot can be found here:
http://xenbits.xen.org/people/dariof/kernelshark-v2-black.png

Am I the only one? Can it be related to my configuration or build
environment?

I'm happy to help with more info or try some debugging, if you think it
could be useful.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-fGBSAxNK3DXlz4Se+geN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAiaGIACgkQFkJ4iaW4
c+4pUA//V1HYE+ps4qe6PZuWV/FAcydXDzCLvMvlpOjam5o6OXPzECCoGyTEWrEf
r4TnHxHyOjpUDb0ie9RtdlxqW1SML8JK51JA/IL0A7CzBZ7cnkguuc6mgmMX2o/I
l92l5sMX4kzbuuW2bt4cRz/XWuT5MKAWDcaSi83jsGrL9QtmOHSNMBSn+ZelWr1A
dNHorCPT05B8q4N8QgkATvDHQXmpbSQC1GzCP/59sBVlRsbylfB2RF0XTgbH6ogP
8rFBKgPLQyz0J1MLY/smsIHuvHfr0hiPVidFAy7icWZoUgolX2bUQNe1cSnId1vO
d/96wxzaYlXaOzTAdJgivuug83Nbek7uJDU8abvo0Zazi4Yj+RfdA8HmOCEyBltR
zrIfkx3ZuhgBzokTYyGirlpiyXwpvfBnp18MYx+i6zzAcAOkchAw2hbkddPN9VvT
rgLexzGhYZIIoxqXWuO5gHU8LXtm92kComYPXnd/3+x79+URqniB0HI8+gTm3skk
5DszciAo1UG1aicRNtWOSUDN+ZrPbhW+wxmH3l0xtgaWC+aAMADEBwpu0rNcuSk2
bSpV5splAsqO7kqJoEccoedduKwlXWEuM0PiqRkwrzSuB037zc9WK0DyQQsZwTPX
Hq8YbLKG6w6m/IDrE6LPMWrD5Vc6fPjJFUNu47xWIdOWhNH7ryk=
=P9CW
-----END PGP SIGNATURE-----

--=-fGBSAxNK3DXlz4Se+geN--

