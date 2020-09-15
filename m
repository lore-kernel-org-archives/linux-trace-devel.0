Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45366C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 00:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A3E2068D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 00:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIPAft (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:35:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45572 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726639AbgION1S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Sep 2020 09:27:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1kIAz2-0001xA-Md; Tue, 15 Sep 2020 14:26:56 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1kIAz2-000HMB-9V; Tue, 15 Sep 2020 14:26:56 +0100
Message-ID: <466701766794299d1c238f450c89fac07e43744b.camel@decadent.org.uk>
Subject: Re: tep_free_plugin_paths() function in libtraceevent
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 15 Sep 2020 14:26:48 +0100
In-Reply-To: <CAPpZLN5Wt3dFxxLh1aCN43kJWAadsPXga7wXGUxDDPzHW3Ot=Q@mail.gmail.com>
References: <e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk>
         <20200914212945.GC166601@kernel.org>
         <CAPpZLN5Wt3dFxxLh1aCN43kJWAadsPXga7wXGUxDDPzHW3Ot=Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-pJ5u2yREWXCAAPw8KtVM"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-pJ5u2yREWXCAAPw8KtVM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-09-15 at 16:12 +0300, Tzvetomir Stoyanov wrote:
> On Tue, Sep 15, 2020 at 12:29 AM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> > Em Fri, Sep 11, 2020 at 03:08:16AM +0100, Ben Hutchings escreveu:
> > > I noticed that the new function tep_free_plugin_paths() is exported
> > > from libtraceevent, but is only declared in a private header file.
>=20
> Hi Ben,
> The tep_free_plugin_paths() function is supposed to be an internal
> function, not an API - that's why it is in a private header. What do you
> mean by "exported": the "tep_" prefix, or the fact that it is not static?

It is exported from the shared library, i.e. it's included in the
library's dynamic symbols.  That means that it could be called by a
program using the library, and would conflict with a function defined
by the program.

> I can remove the prefix, if that is what bothers you.

No, exporting symbols without that prefix would make conflicts more
likely.

> The function is
> defined in event-plugin.c and is used in event-parse.c, that's why it
> cannot be made static without a library redesign.

Yes, I realise that.  However you can define it as "hidden":
<https://gcc.gnu.org/onlinedocs/gcc-10.2.0/gcc/Common-Function-Attributes.h=
tml#index-visibility-function-attribute>.

Ben.

> > > If it's meant to be part of the API, it should be declared in a publi=
c
> > > header file.  If not, I think it should be hidden from library users.
> > >=20
> > > (I think there are other only functions with this issue; this just ca=
me
> > > to my attention because the Debian packaging tools prompted me to
> > > update the symbol-to-minimum-version mapping.)
> >=20
> > Tzvetomir, can you please take a look?
> >=20
> > - Arnaldo
>=20
>=20
--=20
Ben Hutchings
I'm not a reverse psychological virus.
Please don't copy me into your signature.


--=-pJ5u2yREWXCAAPw8KtVM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl9gwRgACgkQ57/I7JWG
EQljZBAAzeF3KsqWp3YXp/6TMge9JcyJ7zmM8zy3jYMJOjntzrF1uC4QjE5txpkx
JH+3KpytWtVKgstTYNMf5YXMDi+GU0jd8vUd0b0zXFF1I3a4vrTQgl2Ku4ZgkIFK
/9TuUEWT8FFrCE0+g9HmSX6QByD6W+JfGgBBRd2YkX0gIMsIyFGymeVV0WZAkZtR
VNwPJZw2QooDKZdmDFInX/6H52LYdQKoN0s/so2xPXlOvAbTZHBxcUWNlCMa4Rsx
pE1H4NeVNa5O5NSz1KmYQ5lvKiUbckDtVQeU2Rq9GL2ezehaMIV+aTmCJYtDmZ15
GSFaphY25zfZZAtjEg39PiYvJhLDAHcgIAgHsXd4/oBJ7otprm9Xu2rBfymq5jY5
dhcPnXekUmbpWqmZJYjljREWPvO/LA4EDus4ocA+bS/aljhG0hclIsHcN625JQG6
wriB2f0rFNAjFYC65nFEBFSFTu4ug0NwAfuJ1WaxNWVyTzTPwBjJmn/8cMiqIK/6
9Np+kpI51jaG4WYX/vNItbHns6r04Z1YRgJ26v0GM0nxVSNRrPJpCGdjIwDVGie4
/W0RWFKSTZSNHTPTO7EhdZR/lS7KABuUn/SbRQV86+9NvRYDMeb5dRrRk/hOBuJK
w6Xg9P4wXZ3c+2lA25sAtJTa9CtOV24718AXv77fLwcqmt4Unso=
=+ClB
-----END PGP SIGNATURE-----

--=-pJ5u2yREWXCAAPw8KtVM--
