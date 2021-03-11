Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AB8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964B064FBA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCKSdP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:33:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:38780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhCKScz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 13:32:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615487574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZMbQwxAmGV90KX/34EnNlonwLJnRdAlkm9qqe2yqofk=;
        b=qW7glVfP7WigCaP5mmxY9zZ4y1lTTHe5vVuWX6jahTSCAI0dNPwaVBrqpiTWi6sph6xlxN
        SM6PD8ON1zmHd+8frJ9f5rX4N/G12uixTJVyU2Nyxt+fPVuPTEx5snhNY128HXNxKdhD8M
        v6WD4R3gZLzarO54cDSUIv5JSvPBaSs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59F39AF4D;
        Thu, 11 Mar 2021 18:32:54 +0000 (UTC)
Message-ID: <09e8114cebcd10d171bd8b0557dbf69ef61b7298.camel@suse.com>
Subject: Re: [RFC] Open multiple trace files and, if possible, pair them
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Thu, 11 Mar 2021 19:32:53 +0100
In-Reply-To: <20210311125040.25339858@gandalf.local.home>
References: <20210305062807.2734-1-stefano.devenuto99@gmail.com>
         <CAPpZLN4iz6cEPBYGwk-hQwB+=XrZ=qXosZyZp6i+BFKp8gF04Q@mail.gmail.com>
         <7439b1cf24293f4af1674783c3c6ebf337652713.camel@suse.com>
         <20210311125040.25339858@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HPtD4NPxnNV5pxgSTrCT"
User-Agent: Evolution 3.38.4 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-HPtD4NPxnNV5pxgSTrCT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-11 at 12:50 -0500, Steven Rostedt wrote:
> On Thu, 11 Mar 2021 18:37:03 +0100
> Dario Faggioli <dfaggioli@suse.com> wrote:
> >=20
> > So, what would be the way forward here. I'm guessing re-doing the
> > patch
> > on top of the new API?
>=20
> With the new API it may not be necessary.
>=20
Right.

> As we are making it where the guest files will show the same output
> regardless of being paired or not by default. That is, we are going
> to
> store the synchronization information in each trace.dat file (for the
> host
> and all the guests), and the trace.dat files will display the same
> time
> stamp regardless of if it is being displayed with other trace.dat
> files or
> stand alone.
>=20
Yep, saw it.

In fact, my mistake was to think that opening multiple trace files
would still need some work. But, as a matter of fact, that also works
already, right?

In which case, we will "just" apply the patches with the new API and
continue our work on top of them.

And sorry for the noise. :-)

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-HPtD4NPxnNV5pxgSTrCT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmBKYlUACgkQFkJ4iaW4
c+5eqBAAoQawgAqaDYIW6Iy4WEOlU0uucF7ajY1xFt0+eoGHiqX6zdYzzPuoab+9
GP5QZC3yPZSBghXKz/9jcigzZzahVT0MO01XtSn9jttGi7HYlZ3ftIBc9tjyhhtD
MyUqGp05jCeoQQZOtt13J6dcmzvWXRaQOyxFBKL0FNSsTQUhORNl4NKXH5OuvXIC
1+XrkKL6+5c2jMQdYVVlOWZ8LuE0sQxo4PnvaXgdp3fJhqAacANPS44IuWm8/jAr
UW9vKLXbcnexmC6lsNw+wlXJjOkp4Ob+2yqgZ2QVDA98CHc0cTA2HjzqBYn0vj6Y
AVFn08vgh4bfsHC/J//lIYVHkLqc4hJ1QajInPA/gXHLAqUErNDCkDHDbg9EoQUz
04WqzDTbtCrlNUYLysJvW9xZWH1l0AmxWx7bb7FLgatc5GcVlLkXSeb7yt1V1Vwc
NGHJd3A1jTfwIZu8R7ElXadaguD8S84yD8zHCgDgLGfSC/N3C4rosjBQTsCmoGNd
Nf7xDZ8lC5fRrtAdAKgOInC/Jg1KlbxV3CgV3jpLom3uS6s2sjTIPzSBjhaEgiSR
V1EvN0HYOflOUWNs5C62YWRKMsSAcIajvOVOs46WI3UfIC4hRsm/uVKPJFFpdCI7
zPdreMtXNvaQAg1yOOJ8LT4Pzbja9PMSMVv45xTmMbzWNAkkjGc=
=aMLH
-----END PGP SIGNATURE-----

--=-HPtD4NPxnNV5pxgSTrCT--

