Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47E3C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 00:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450F720B1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 00:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aAG5f+Q/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgKZAPS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:15:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:47066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbgKZAPR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 19:15:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606349716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=foszx9X3HUm4e1n119qMEHX3U0bDc/l3zKIjZsfyUTk=;
        b=aAG5f+Q/nkYgQTQ492bJ6yDWCD02PLaHnQiRZjRpDcWCXPJF89Zq0QMZ5y98lgkG8NGk86
        L6odP1WJ48JTR2e4y68VTwv5yzcH38ywmgd+Ml29aYl81KKlSkUTALYBDOJrV2Dr+lzSph
        oXPDkEgq62vLji4MJc4q7XMVZrKeGJc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3A7CAAD60;
        Thu, 26 Nov 2020 00:15:16 +0000 (UTC)
Message-ID: <4aafe6e3fd34a17ab4c9bf4514b5a9b7d65ca6ea.camel@suse.com>
Subject: Re: Accuracy of traces sync [Was: Re: [PATCH] Fix `make -jN
 trace-cmd gui`]
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Date:   Thu, 26 Nov 2020 01:15:09 +0100
In-Reply-To: <20201120090828.4b62d4b7@gandalf.local.home>
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
         <20201119220910.1a8ec625@oasis.local.home>
         <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
         <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com>
         <849f846631f3014c3eff7f37a7d61493e2af66a9.camel@suse.com>
         <20201120090828.4b62d4b7@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0zaJd4zEV+a0b6MVnaE3"
User-Agent: Evolution 3.38.2 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-0zaJd4zEV+a0b6MVnaE3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-20 at 09:08 -0500, Steven Rostedt wrote:
> On Fri, 20 Nov 2020 14:43:21 +0100
> Dario Faggioli <dfaggioli@suse.com> wrote:
> >=20
> > So, you often say that "the accuracy of the synchronization
> > protocol is
> > XX ms". Now, I guess that means that an event in the guest and the
>=20
> Note, we are usually microsecond (us) apart, not millisecond (ms) ;-)
>=20
Ah, yes, sure... And sorry about that! I know it us, I'm not sure how I
ended up writing ms. That would be quite terrible indeed! :-D

> > corresponding event in the host (or vice versa) are XX ms apart.
> > And
> > that's even after the synchronization of the two traces, is that
> > right?
>=20
> At plumbers we talked with Thomas Gleixner and he suggested ideas of
> how to
> get to the actual shifts used in the hardware that should give us
> exact
> timestamp offsets. We are currently working on that.=C2=A0
>
Yes, I remember that, I attended the BoF.

> But in the mean time,
> the P2P is giving us somewhere between 5 and 10 us accuracy. And
> that's
> simply because the jitter of the vsock connection (which is used for
> the
> synchronization at start and end of the traces) has a 5 to 10 us
> jitter,
> and it's not possible to get a more accurate than the medium that is
> being
> used.
>=20
Yes, with a student that I was helping with his thesis, we applied one
debug patch to trace-cmd that you have on this list, and we tried the
different synchronization strategies, frequency, etc.

> > Question is, how do you measure that? Sure, I can look manually for
> > an
> > occurrence of the pattern that I described above: i.e., an event in
> > the
> > guest, then the corresponding one in the host and compute the
> > difference between the timestamps.
>=20
> You mean, how we measure the accuracy? It's usually done by seeing
> when we
> have events from the guest showing up when we should be in the host
> (it's
> like seeing events from userspace when you are in the kernel).
>=20
Ok, makes sense. I need to try it first hand to make sure I've properly
understood it, though. I'll collect some more tracing and looks for
situations like these.

Thanks!

> > But do you have a way to do so automatically, or with a
> > script/program,
> > etc?
>=20
> We have talked about having something scan to find cases where the
> guest
> event happens in kernel and do some post processing shifting, but
> haven't
> gotten there yet.=C2=A0
>
Yep, as said, I was thinking at it as a way to measure how accurately
the traces are synched, but indeed once one has it, it can even use it
to actually synch them better.

But I understand how it's rather tricky.

> If the hardware settings can work, then there will be no
> need to do so.
>=20
Indeed. Well, perhaps it could still be useful, as a test/check whether
things are working? :-)

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-0zaJd4zEV+a0b6MVnaE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl++840ACgkQFkJ4iaW4
c+6NyBAAx/xPIYCgBQ4+pXIsB7dK5U8vqhoYAvksubla2tKFPbmF+iBL6W2bAemh
9TFePr00Crs59Ku9rLZdEoHxuSSZqK5O6/JpyzJWm1Knpn1kdqccYho57q7UoUH7
KQY2gXkSA3auDnywcI9vryBIWBSvjvyOxseo6ILVLWEBQTxMpl8QUIXw6HZbkzsp
0wiHlpeP3AP1z7Is74RrBGRVAv+9RhUaHuCo8HqYIVGn2LOnyPbKGywUmAF+NIcs
EvONJtaUFgqYdMosuvtHLrUc3ObXmsQX8rsQcotURdjUsIb1RBVQvdja0K3p5K8a
phANKOAH3dIZB/rR9Nnaih/+HgceMIb/kG20S4HlB+w4BIKEJ9dee1xG+3hGDLfB
RY7XBIZmovTg9i1n+0qDI7PJmILi+0HslecXJvZbiEo7Pw/rtJTQt4qG01AFvnhy
ErVnHNHVMnj2QOgp+FKfsuDnsgUZUUNjIVtuH5ZWGqfdMMu3D7i414ysy5gaZkUG
g/PoPTcRQt+ubsv6etHAlwOdpSEV6XZFynarnbLcrfAENPKkJzJaeQMZDP0BAXN8
dRle0WohOniDW3jOc0qIM3RHPBXJtqfhoBP/ob5TCyIjlXwzAJ20fCewomtfSoqA
sK6SbIayljJoyrNCkwbwe3phnBj1geT2s9EjaAS3Io5Q3SAbXGU=
=jeq8
-----END PGP SIGNATURE-----

--=-0zaJd4zEV+a0b6MVnaE3--

