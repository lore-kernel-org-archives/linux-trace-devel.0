Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BD5C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 00:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EA76117A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 00:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhDOAvS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 20:51:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:37852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhDOAvR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 20:51:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618447854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dlYSapZ/7bzlynnCiHUirDDpulbBa6SiYnz7NV4uVao=;
        b=n630jxTO3aLbC2wjboZ60L7moOGNnolNdHh1blZtvfk4GLUPZFFWYgvlDWGdgEeiz4Z/4e
        OUDGbOipJwDiY/UfU9CQY6SpAc0NHz67prJuSd55aRDSH7oqEvKewwhrl5beOl990r1FLO
        xl7xK//mD0RN7rCf0GxY0/ZavnwiKLs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5757AFE8;
        Thu, 15 Apr 2021 00:50:54 +0000 (UTC)
Message-ID: <281ee74f5ce416feeafbca7cb8370889e0d2067f.camel@suse.com>
Subject: Re: A KernelShark plugin for Xen traces analysis
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Enrico Bini <enrico.bini@unito.it>
Date:   Thu, 15 Apr 2021 02:50:53 +0200
In-Reply-To: <20210414150752.34366b99@gandalf.local.home>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
         <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
         <eefc512b8c1ac26c4eaae81e79ee0243901a3de2.camel@suse.com>
         <7184a7d7-6bca-4106-d70e-8cf9d5b227fb@citrix.com>
         <20210414150752.34366b99@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2AQ1hzKpsCodCCgwu1uf"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-2AQ1hzKpsCodCCgwu1uf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-14 at 15:07 -0400, Steven Rostedt wrote:
> On Wed, 14 Apr 2021 19:11:19 +0100
> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>=20
> > Where the plugin (ought to) live depends heavily on whether we
> > consider
> > the trace format a stable ABI or not.
>=20
> Agreed. Like the VMware plugin to handle ESX traces. It's internal
> and not
> published as the API is not stable.
>=20
Mmm... Does this imply that Linux's tracepoints should be considered a
stable ABI then? :-D :-D :-D

> But if it ever becomes stable, and you would like it to live with
> KernelShark, we are looking to have a place to store third party
> plugins.
>=20
Sure. TBH, either Xen or KernelShark main or plugin repositories would
be fine for me.

Which doesn't mean we should choose randomly, as clearly each solution
has pros and cons that needs to be evaluated.

I'm just saying that we would prefer the plugin to end up in one of
those places, rather than remaining its own project. And of course
we're up for maintaining it, wherever it lands. :-)

> We are working to make sure that the API for KernelShark plugins
> remains
> stable, so your plugins should always work too.
>=20
Great!

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-2AQ1hzKpsCodCCgwu1uf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB3je0ACgkQFkJ4iaW4
c+4g1xAAyNZnLAMDBqCg/xvPLTBFwcx1vx9zIc4zYPKhCWbQwbhVPlVzwumZ+IN7
hNiPbSphYIi+AanJ1cLp0xHclH3Z/5DMFOAfHIh+tqPghWnASi6a/4/ah+4QNMWK
N862BrNCaCMj3Pt4ig35HgQoDNBnu+tp4pcSpSrDPTXEEv5aTqmx8a1kBMqYacba
suoePMzpZ8ksXdaMATQ375dDKxtEihXfwiGP4Si94Rfebvp/fAJZ41yZO2qRv6wp
vG+PSRQrT723U9HEnW3bO2mrGAm1giLrL004zQE8TvdgzYG7eLvOkGFqSOkOpafT
DliJSRNdQC3/jMVprby/A1ypmVTmUm34RGhDq2os5b8BqYwQHx180odgD+KCf7/4
ZqqkwewMDRQelqCM5a8OB3TvhbfM3PRjekDIiiAy+7ExRihtIb6pqtj2I0d/ubB7
VwsViousoUQidt9+uPYUCZxwLOaUCyb/SKsFcJEfs4xJ5C3mFv9YNv0DoWX+nvSR
+m03nc/M+P1BL44qUpcpHhG/9kp5sCz1LvqTIyOmU7Eaf2LgKQ4pz6Zm/bomDUcX
TJBzJzhYNKqCvCBOwQn4q6VsUX62uAyuX5quLVtOM6ybe2nWuQzqmSvhBpkuNgXX
NUT4gclT4bdE5cM7TQgpddgB8p5BO4uRcEmAd3S8Nj3Fz/lCpdY=
=SC4N
-----END PGP SIGNATURE-----

--=-2AQ1hzKpsCodCCgwu1uf--

