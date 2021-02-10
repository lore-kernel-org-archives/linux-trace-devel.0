Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589D7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 23:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1DD6024A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 23:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhBJXgr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 18:36:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:41828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhBJXgr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 18:36:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613000160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZnkFnvM+0tGegX6LWOfrxw5ZpRThxuexP0SRDWibjlQ=;
        b=JZfkl08ogbW5uKdUaj7z/eajxjqsVFyM0WrGIhcx7NJAlVK0oFExTDI53vcyqqHxqHKXxy
        WQyZpzrwazxo0h/JmsqNQohbBphbH0Up8sUapoF65A5+qzK8ciirkrfeDt2a0BPcaNT12O
        mSBb0wFFV0zlUpH66qONypmYnE+5ntw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 457FDB05E;
        Wed, 10 Feb 2021 23:36:00 +0000 (UTC)
Message-ID: <56c9cda6840914b01b92c6013d689af5e109d4f0.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Thu, 11 Feb 2021 00:35:59 +0100
In-Reply-To: <20210210170246.727e5773@gandalf.local.home>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
         <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
         <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
         <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
         <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
         <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
         <56a35d33639ef7668678fd7f87dab995b2d6a3a7.camel@suse.com>
         <CAPpZLN5wdN1V5JTbpdPZQmYx2avnxUJCcZaExGb6-yP1Ly-Ktw@mail.gmail.com>
         <20210210170246.727e5773@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JNg74sClZtbaqE2lHokg"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-JNg74sClZtbaqE2lHokg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 17:02 -0500, Steven Rostedt wrote:
> On Tue, 9 Feb 2021 19:01:04 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >=20
> > None is working on that yet, any help is highly appreciated :) I
> > just
> > created an issue in Bugzilla=C2=A0 for that:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D211657
>=20
> I had the below patch locally for some time now. It's a somewhat a
> hack, but
> should work. But this should be done properly. The hack below works
> if you
> include only two files, the host first followed by the guest:
>=20
> =C2=A0trace-cmd report -i trace-host.dat -i trace-guest.dat
>=20
Ah, very useful indeed, if only as a starting point!

Thanks for sharing this. Much appreciated. :-)

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-JNg74sClZtbaqE2lHokg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAkbd8ACgkQFkJ4iaW4
c+6XeRAAsm5YSxb3apfCpmrQvh+Ray7wh/MQH96CC3aasThOuPKuzXLt26kHE/Uh
u31Y2kaIh8/fwq1rJSLd0Sxiy0841acBmqd3tpcep8DoRI6Jw4c6qXKPk8jtkuTP
juLoFiJ2hxt+OnUCppvd4dAHVvMFQjrRSqp/vykz6Q98dAv/OZWJ8VfQRMY3P7Me
FvtfbTKEcGX2alx++t0CFI1MjoVI0rx6N4EqZd9U3lr/jIY8qM+fkxoGiag4D5hw
RIeKUcS2WJwC1D9N8feFnecBfMSvm4MsH/xIM9cP2NUBf+oolax7vmYwCgGE8f4c
7hsjcwra79bw13z71p9+wDXkPrtZs6+JY7GSAIIK1KG//P+M/llaG11S573tXcPi
edokMBS7YbnHjiRUQ9F2I9oJ6BSjwczR1FZsShJ6nEksAbky8zWKgsCGNNlzFS5q
1GNWt7cTIQvLxewp81Kp5xzfQiREzeP47SkDaifJcqbsPVl1IP63LXmtCZueyafs
tks43Na0eBaa6dSedH8dRkZFI8EZHRz3oZbVlS5+9wuKn8SMfwS6cg0LTL4unXq/
v070JsRJh81QPE0NRDnoZs5MyoGLx0rFJLaatRKPi9TlRMUbAHmJbKTP58wi4EUj
8W2/J8WJfG8t57cqzZeGji3xrkX1iJlXxI+0vzmWj4BUrvy5lZg=
=oVV3
-----END PGP SIGNATURE-----

--=-JNg74sClZtbaqE2lHokg--

