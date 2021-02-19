Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CD6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 17:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EA864EB1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 17:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBSRwJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 12:52:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:54706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhBSRwI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 12:52:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613757079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mHKwUcrwGIpXKLJ79kurXSyOA1sGj0zazFE6JzS1cXc=;
        b=W7Snc6ltY5JswIMT9SC2oMkerz58Oc9MAraK5wW5QaPawcnT0sUVXXlLOpfetxAFmqDtQ1
        sItcVrL7yX3lK16vACFtJVrp30nDVKv5HX5EqHeUEud2rIBPBcf0qRzif+ZvxwoUoZnPDa
        SuT49NdYOEw9JOlTiATjJ5AQahmJVw0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A488ACD9;
        Fri, 19 Feb 2021 17:51:19 +0000 (UTC)
Message-ID: <774d8baf12b72e2092001a0ec3da05efbe6e5861.camel@suse.com>
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 19 Feb 2021 18:51:17 +0100
In-Reply-To: <20210218225314.76166422@oasis.local.home>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
         <20201203060226.476475-6-tz.stoyanov@gmail.com>
         <20210218210352.61470b93@oasis.local.home>
         <20210218225314.76166422@oasis.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/CKwBy4pQP7frWJZVI3c"
User-Agent: Evolution 3.38.4 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-/CKwBy4pQP7frWJZVI3c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey guys,

On Thu, 2021-02-18 at 22:53 -0500, Steven Rostedt wrote:
> On Thu, 18 Feb 2021 21:03:52 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> > Hence, we can use x86-tsc as the clock for both the host and guest,
> > and
> > then using perf find out how to convert that to what the 'local'
> > clock
> > would produce. At least the multiplier and the shfit.
>=20
> I just tried this out:
>=20
> =C2=A0http://rostedt.org/private/perf-trace.c
>=20
> Where I did:
>=20
> =C2=A0# trace-cmd record -M 1 -C local -e irq -e sched taskset -c 0
> ./perf-trace
> time_shift=3D31
> time_mult=3D633046315
> time_offset=3D-125757047487632
>
Let me ask something really really stupid: where was this run?

Host? Gust? Both?

This seems very interesting... But I definitely need to stare more at
your code (while scratching my head, at least for now :-P).

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-/CKwBy4pQP7frWJZVI3c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAv+pUACgkQFkJ4iaW4
c+4DGxAAhhjdmc2/0Y1GRCOnC1GBIubXIqP5Y430jZCpG4XOhKSoVqJF9AEpE0Ol
Ih6wXlr9msh+iWMMslki0bJyD3WSwQdecNpqRayZtW5P5+nDPLPh54rb06MdPOM1
KvvavK3/9UPY9xq1rQP7j3h5n7bjFT5r3t+WxWZx15va49x/yPQI6SjNjv1nflMs
L4R0kvIEO8u7xtj5nOBozrUbIogyhl17qi0UDZPkR5jN4NgZ3qYZAbYH9fBYgY9f
JQ0cYDGSxxXkrg4+oVqN79UGr3IlI+di0C3T1yx9qFszDLNXjXqJIFcigdlsbnmW
VrVuwY83so02bXihQiy2r+UM/CzXvevZtFWs75Ckuzq+ofWm7Ulh4/tH0ekqYrgk
kq1mDkwjkgAInf05pgt3eKJ9O8AhsIAYDeYLi3KWCgU6usCl5Gg/Uzm/kKKbwgcY
5lJSTHsvOaCn8RpngCZ6GG6pOaAjMrQWbty46qQjX5zNpzbAZoSX1fKc7P1kM5fu
ZlOBcpcA9Mw41Wppn2yDj4NRdzDojjpCSC3+DzbM4sSZBBvKqLc5UvgTLvIieUzY
qyfpzZfNca0d/Quz4c/eFNyimZqVRbhqQ8uY5RFJjHKNfj4PBZ1hN70k5zy+DbN6
jpZZQ//9y85iF+IRx2TchTZ52u2ytw177YeoKEF/6W0v8FOnRIQ=
=UwEv
-----END PGP SIGNATURE-----

--=-/CKwBy4pQP7frWJZVI3c--

