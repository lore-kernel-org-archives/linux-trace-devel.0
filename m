Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C08AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 16:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51A864E66
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 16:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhBJQQJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:16:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:42416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232146AbhBJQQH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 11:16:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612973715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/d2F3/2dd9SylsI1U3LEGJh+uW41J07oUg7wWm+UEuQ=;
        b=bfjibKyhjhY5Y9DBzOilHBiGWWTjI8rB/eXteYYKRKMkDu9XSHX2qhw5eX2FRhkc81yv+d
        PWFWanLIqhoE+j0qj//lDJUIL0Rx4XGAF6b6n9yL2KjsBwLxzy9z/IiyJtjwv0xu3Qw7bQ
        7JWezbGsu7w5z9tSTn7Sffb0BlXZrHA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7E3F6B125;
        Wed, 10 Feb 2021 16:15:15 +0000 (UTC)
Message-ID: <d8e65d2c5c9f225a7cb811535449656e00aa0f1a.camel@suse.com>
Subject: Re: Kernelshark v2 all-black plots area
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 10 Feb 2021 17:15:14 +0100
In-Reply-To: <60fd40d8-23ab-6518-4e8b-6d66bbd53f5a@gmail.com>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
         <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
         <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
         <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
         <c047a5892fccdd5cd9550cba81fd16c71950fd8e.camel@suse.com>
         <60fd40d8-23ab-6518-4e8b-6d66bbd53f5a@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rx90ae/J6W6qMFPt2SS/"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-rx90ae/J6W6qMFPt2SS/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 17:47 +0200, Yordan Karadzhov (VMware) wrote:
> On 10.02.21 =D0=B3. 16:51 =D1=87., Dario Faggioli wrote:
> > Then, I append the trace-(null).dat file (the guest trace). I do
> > see
> > this on the terminal:
>=20
> I see what you mean. In this case the host and the guest are not=20
> synchronized at all. I guess something went wrong during the
> recording.=20
> Also the fact that the name of the guest VM is "(null)" looks very=20
> suspicious. I guess this is not the real name of the VM you are
> using?
>=20
Well, it is weird, but I think Tzvetomir figured it out. Or at least,
it's probably an issue while parsing the qemu command line for trying
to figure out the name of the guest.

It's indeed strange and annoying, but I don't think it necessarily
means the trace is not valid.

Also, it sure can be something like that. But if I just open the guest
trace alone (or I check the records with `trace-cmd report`), it seems
fine and the timestamps are not crazy.

The screenshot of me doing that is this one:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-guest.png

> Steven, do you have any idea what can cause such problem?
>=20
The trace is here:

http://xenbits.xen.org/people/dariof/ks2-debug/trace-(null).dat

With `trace-cmd dump --options`, I see this:

 sudo trace-cmd dump --options trace-\(null\).dat=20
		[Option TRACECLOCK, 0 bytes]
		[Option UNAME, 47 bytes]
Linux tumbleweed-jeos 5.10.12-1-default x86_64
		[Option VERSION, 47 bytes]
2.9.1 1b6bba6c0682975377477d5eabfd541c060aea03
		[Option TRACEID, 8 bytes]
0xD663C16F20E1B52E
		[Option TimeShift, 68 bytes]
0xD8F36FC634D63137 [peer's trace id]
0x0 [peer's protocol flags]
0x1 [peer's CPU count]
2 [samples count for CPU 0]
	71075647069541 281474976710656 8311226241638 [offset * scaling @ time]
	71075647069541 281474976710656 8315062444376 [offset * scaling @ time]

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-rx90ae/J6W6qMFPt2SS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAkBpIACgkQFkJ4iaW4
c+65LA//e5xOkYjsNmBea42tREgGO54RZyVoO5yvv4IlnggTvm8WcJosRO2fopHk
fZqP+C3vvPRBd/jolv13REChE80W7pXU0ZzX6qPmESmSH5Zg5pgoYZSANRMpnp3x
OFQQuOVEd0UyGBvc2mLDsj5oRuje2m71XkdIaulagVrGs1TFC9r+nw1okd46bj7j
iEVEymKUDaCdQMmGDDq7j3XP0R7NHVeerqjeIsZ9rEkAjHYceaGe8gnBLa/CmXCt
abjO8Wgw5a8OmsGubKhQdUuByIc4trfkIs4AODjQd/gqRnl00XPtwnhdSONIILz8
JOQi8jl9lc7W45VqYxIls0rxuqqBOpvCiX6vOwRIzjDXrR36+182WIv+tBOj/jU0
kFmtfyh15muMMZIsfcp4RrDkkTV/8h+J3SnRBYZsNkAyGQpXTxt3Z/EWXvcV183u
EGBu1oJhMOr+9vR+da/7qMspqqAfAoTIu69injYQek6q44om/4UeSGz2/XqfCjqH
ono7xn8XToMqLHK8qpqAQ+Hr63Vj1zaeObKtubyUxpWoJ0JSYqh5FZ3eVv8EUZ43
gfBE1D+kAIcPQ2rLbCCo2kyOOzwueilNcedt/NHjIibh6TzNGDz4ole4dhe192+6
8bWBD52Y6p5K2Qb/J3FVYsIoARGGtKCmOHULaBkPtxRE0V1wF+4=
=s1vi
-----END PGP SIGNATURE-----

--=-rx90ae/J6W6qMFPt2SS/--

