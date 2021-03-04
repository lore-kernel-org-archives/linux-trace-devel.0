Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1729DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0E064F52
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbhCDWHY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 17:07:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:37524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241291AbhCDWHN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 17:07:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614895587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EqxGIK7xS/P1I4dhc8ltDme2o+DhL4ZCqvfWxedQyVY=;
        b=sZmMwbC1ZXo735484PFDBhU/i7bdTB2nwKmrgq+2GCmmf6wtv620SSnu/msvO+fbDa/913
        5gN3hMxEPVYv55ympBcAMupkvvHv5oSZtzM3Nlz3c14nEBa5xZi3RgwO97VN6LKQGeqCvS
        GN4yLVpfd33M3t187EzkXUpZWCf8h9w=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4BFE2ACCF;
        Thu,  4 Mar 2021 22:06:27 +0000 (UTC)
Message-ID: <1686fb51dbdee78d102796c68826a4837536db97.camel@suse.com>
Subject: Re: trace-cmd and host-guest tracing
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Date:   Thu, 04 Mar 2021 23:06:26 +0100
In-Reply-To: <CAPpZLN4mySHF=z03gqGv1ZEa_a5Q4su6aP1F_MsG22e=GATyHQ@mail.gmail.com>
References: <CAPpZLN4mySHF=z03gqGv1ZEa_a5Q4su6aP1F_MsG22e=GATyHQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PGs9fSd4BBt8mI3TX6XU"
User-Agent: Evolution 3.38.4 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-PGs9fSd4BBt8mI3TX6XU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-04 at 17:52 +0200, Tzvetomir Stoyanov wrote:
> Hi Dario,
>
Hi!

> We decided to simplify opening trace files with host and guest trace
> data and changed a little bit the logic and the APIs. Now the
> timestamps in the guest file are recalculated by default, when the
> file is opened.=C2=A0
>
Yep, I saw the patch series earlier today... Seems nice. :-)

> Even if the file is opened standalone. This makes the logic,
> described in Bugzilla issue obsolete:
> =C2=A0=C2=A0=C2=A0 https://bugzilla.kernel.org/show_bug.cgi?id=3D211657
> and the issue is not relevant any more. Moreover, the APIs described
> there are removed, as not needed any more.
>
Right. As said, I noticed this already, when seeing the patches fly by.
But thanks a lot for the heads-up!

> I hope that no one started working on that yet.=20
>=20
Well, as a matter of fact Stefano (Cc-ed) was just almost ready
releasing his first RFC, based right on those APIs, which is kind of
funny! :-D :-P

Of course, this is perfectly fine... We knew that the API may change
and things like this one happens all the time in Open Source
development, so better get use to deal with them.

If you don't mind, though, we'd still like to submit the patches he was
working on, as RFC. Surely, the part of the code using the removed API
would have to be ignored... But there's a couple of other things in
those patches too, which we'd like, if possible, to have your feedback
about. Let us know if this could be a problem...

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-PGs9fSd4BBt8mI3TX6XU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmBBWeIACgkQFkJ4iaW4
c+4FhhAA6uJLl64Teiy38Twq/sdxvGxdGMeBYpZ7bCGZZGUd7Z3sgQ6EwPzDoZ8i
O6LA8bQsXcJdNtcHVEysQ/oEutBp6HoW5Ct6VLQHk4UoVbyDDfNotMUerwreaP3I
D+D08+ClRuREYYkShceNBj9H3XBvFo13vt01vWauY3hqWhq8/ZSlpfThVlOxy1Bw
V/CNXJoGCPvbp59CoW8saHM3VveEtZ4KoBBCfIFdz74RYCI+z5WgcnJ6ydAFR7np
p6z/XIoZEyd8gJ4vNisxW77XsQkFRrd9YLPuVfDDJNMow3VHMEYNxDCz6HdGmzlX
iXYbjkNUcJ8W7rvz+cbs1aGtTJ/SCL0FRmO8bugzZbpaphGytZ3JF36W9U/b59+3
h9CwEFTNP4tdqrRbt8y8JiCbN+BXEBzKQDLlMHzqFjgg7663XsTe35BYmbGZjh4H
tv73aq7MqpZppBWGa7wxUvt8/3pkSObunRnC0ohOsnGroOu03qVbwOvJN5dKQB5T
HKtgQMcwzcMk6OJjn/9yClUnul5NL0JJKKKNLwrYHUI2DcUdX/QbgdX1rMEJJ0bG
bmZywdFIrz/0+IYxzcFx2GLvxaHh0j+nV37BKsUhzojtLPTIQWynjUobeuPb+tvM
0kv43DSTvCpGlzoEI0ylEFemjtrCEiy7QjQuequw6mTPvYxKhLw=
=gs01
-----END PGP SIGNATURE-----

--=-PGs9fSd4BBt8mI3TX6XU--

