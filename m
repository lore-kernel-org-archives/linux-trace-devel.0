Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE26BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 21:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B726103D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 21:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDNVv6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 17:51:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:45146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhDNVv4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 17:51:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618437093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fyx9vlsOHGOYIIT42w0AhSKt3/73aRp0v4Jr2WTKp84=;
        b=I117XwifSnF/0PMJp99RVD37wz5ZP2iy37UyHu+b3086tUQfbsw5rte3lGDchwJGoSfnl0
        9sxMi5fAlddCJAUJtWPreMDMfbWu443eYu8wkq1QBZYRC62f65+SC0cRdOGENCNTa0OQeu
        6caZ70JI8fe0b6AcRnpbrH0zf1OXZFU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3BC9BAE78;
        Wed, 14 Apr 2021 21:51:33 +0000 (UTC)
Message-ID: <f99d5176df0298e8057e21f24a627832121b7aa8.camel@suse.com>
Subject: Re: A KernelShark plugin for Xen traces analysis
 =?UTF-8?Q?=E2=80=8B?=
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Enrico Bini <enrico.bini@unito.it>
Date:   Wed, 14 Apr 2021 23:51:31 +0200
In-Reply-To: <7184a7d7-6bca-4106-d70e-8cf9d5b227fb@citrix.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
         <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
         <eefc512b8c1ac26c4eaae81e79ee0243901a3de2.camel@suse.com>
         <7184a7d7-6bca-4106-d70e-8cf9d5b227fb@citrix.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PG2JFKkoV8wEkuAFwNPi"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-PG2JFKkoV8wEkuAFwNPi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-14 at 19:11 +0100, Andrew Cooper wrote:
> On 14/04/2021 18:31, Dario Faggioli wrote:
> > > A couple of questions.=C2=A0 Which Xen libraries do you currently use
> > > map
> > > the
> > > frames?
> > >=20
> > Err... If I understood the question none, as the plugin loads and
> > parses a file, as it is produced by `xentrace`. :-)
> >=20
> > But maybe I didn't understand the question?
>=20
> Ah no - that answer's my question.=C2=A0 I'd blindly assumed that the
> plugin
> was talking directly to Xen to obtain the tracebuffer.
>=20
Right. No, KernelShark, for Linux, "just" reads trace-data file
produced by trace-cmd. So we adopted the same model and made it "just"
read a trace-data file, in our case produced by xentrace.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-PG2JFKkoV8wEkuAFwNPi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB3Y+MACgkQFkJ4iaW4
c+7q0w/+NlMki+7+D+3hMDgjz+dAjBpw5KL6YtcIGK2W8gZn+gwNORsAxPmq7HHN
PzEvkvGZSVn0sr9logV/Jq6Q9eABr6ueHYI8qQeccCeAj5QudTM4/ee9qK9SLDeZ
e/YPN1ya1u8UWvRj3xrJoL1OFhNdHR9OrhC2NeTmCL2zu199YORosUGjpBuXnPhJ
YcW5dcjwlwR3wD/lvB/Rh0N6Rt5JpMy/9h2qS/J62M8sLak9YGMns8tAjrTBhK2d
P4dHRfO1JjLlFaiPFdgUkTy33OQQ8kMfXDchUPeGUscrCFQ6yJbdvqc0l/zxQnWQ
wF0CKTuoQAGMMA39j/azawI4cYtT3+OzEvcXOeWljwjLiQqMGhfD1adiuiIyD6KO
OSue/fQ2pi1I5ur5zCFcM7vUrNSds0+v/BiLM5TzC+mtmzJxrkWw/fnCPJ6KazIu
lvqxnWi9APeDgnrwCiMtyYfdfWlS2qA9Z/WrjktYtdmPHwloeknx7gYIAoX0ndMt
HDjDhMRTG92z60VivEJEh5epRqraIo81lXa8LQRpC7orYvmi1sVz+opBfFuYYAjC
8x2OhF5VbAURQiZiSqFHJ/r6HQ1E3vBNn9oHeVJ9cHKE3MJAGwmlSCWGTEWk3Ub/
mHmlDMvvSyeR7t9P//wGLDk92FaPvkjZkjZ6lx7+h1uWs0JnsQQ=
=ZS6J
-----END PGP SIGNATURE-----

--=-PG2JFKkoV8wEkuAFwNPi--

