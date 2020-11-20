Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A95C56202
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 13:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5962C2236F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 13:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mDMjpFtO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgKTNnY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 08:43:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:49290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbgKTNnY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 08:43:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605879802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tCDsQj6tpdtm2iyRBssF1fODDeRllwGPFgtsMTC3qxQ=;
        b=mDMjpFtOk8KMiXMpTevE0GIGE3h5IFRVt+lg+br97GPuGcyn0rxg+KaT1pG+Rz6Ym5+p5s
        xAZGW8fzG0syx3uoIZHkCd5780KLArCJX2II3wsCq3EdrD/HbJdSAGgkBEim4v+ZfCDWQi
        7d6RD8Tfb1Zr1Jdx9NTV/1hf/LDXMew=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F5B3ABD6;
        Fri, 20 Nov 2020 13:43:22 +0000 (UTC)
Message-ID: <849f846631f3014c3eff7f37a7d61493e2af66a9.camel@suse.com>
Subject: Accuracy of traces sync [Was: Re: [PATCH] Fix `make -jN trace-cmd
 gui`]
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Fri, 20 Nov 2020 14:43:21 +0100
In-Reply-To: <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com>
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
         <20201119220910.1a8ec625@oasis.local.home>
         <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
         <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-h8Y6z9ysSZ7DVD1MKL11"
User-Agent: Evolution 3.38.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-h8Y6z9ysSZ7DVD1MKL11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-20 at 14:32 +0200, Yordan Karadzhov (VMware) wrote:
> On 20.11.20 =D0=B3. 14:06 =D1=87., Dario Faggioli wrote:
> > >=20
> > Yep, sure! I followed the talks you've been giving about it at
> > events, and I even played a little with what you have here:
> >=20
> > https://github.com/yordan-karadzhov/kernel-shark-2.alpha
> >=20
> > The host-guest tracing part, as I think you can guess.
>=20
> Ciao Dario,
>
Hey!

> I am very happy to hear that. The timestamp synchronization patches
> for=20
> trace-cmd are almost ready to go upstream.
>=20
Yes, I tried those patches!

In fact, now that I have you here, do you mind if I change the subject
and ask a quick question about them?

So, you often say that "the accuracy of the synchronization protocol is
XX ms". Now, I guess that means that an event in the guest and the
corresponding event in the host (or vice versa) are XX ms apart. And
that's even after the synchronization of the two traces, is that right?

Question is, how do you measure that? Sure, I can look manually for an
occurrence of the pattern that I described above: i.e., an event in the
guest, then the corresponding one in the host and compute the
difference between the timestamps.

But do you have a way to do so automatically, or with a script/program,
etc?

I saw that the series included a patch which was meant at debugging and
profiling PTP, but even with that one applied and having it generate
the graphs, I have not been able to get that info without manual
inspection.

> And we are currently reviewing a beta version of KernelShark_2 that
> will=20
> include the guest/host visualization.
> As Steven said: stay tuned!
>=20
You bet I will. :-P

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-h8Y6z9ysSZ7DVD1MKL11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl+3x/kACgkQFkJ4iaW4
c+59yw//QIdq3fb1fciqQulR6pcZnaV5B9aTsbiD7wTG64vUf6GAmsjrnYy6ckpU
6a4ExQFNiRbXpoZltvhi2PyiK/aMIF2/dyhNwlZNixWccH3u/bF0kKY92nWX7jHr
OdopbZMr7StxnRdigchkJfzbl5H/qw4Fv1+TV7EJaP8HU5i5W1xSdkc7jBBazDen
oWaj/0oLoUO2ONC4A5pjDeDI4OhaH9CtiRhnAMeSD03x9xoCXMgbr8MnUgsjFJnT
PBewRCJEVawAkO669hcKgVP4fnHmhji9/N0K7MmI9egij54ciZBYjMelQ9ChOwVp
nv4wYgTZkv9hsJ6AIgzQ7dywoJrFaew76kIqBtJtbZYuMb8mtTgEE3cdbJgOaQpO
uLh7WZji6Buo06itGjRhTZG7TsJTPL/g6kd1qUw79eRXQXS7riDt2NFXV641ORA8
+2FDwm+j26kOoaXMOngkJjIZqchmXW63kr/9e4FyDaOx481vnzVctLs0z/gFiqOq
JTmcHjg9Dn6OqRn2zqdAzuex9bzqXVFoqMjVWxl5xUKrdvqP9K/aFwmRJsH3i2AU
5oTYnie/E3GhP08MKOoFPA/rm4fKLznRKuIxaWm2SNOJDZMqen28Rh56hBg7igZe
CCMBr9Ad32pp63jR9x7j/+gNG2sD619OiQQty2ibSc3aL5Iyv7Y=
=p37O
-----END PGP SIGNATURE-----

--=-h8Y6z9ysSZ7DVD1MKL11--

