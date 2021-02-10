Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C9CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 23:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D462764E02
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 23:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhBJXeo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 18:34:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:40430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233779AbhBJXei (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 18:34:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613000031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+QLNKq9MIxFeswrRrflOKyRMFFxDlN4lsaLsYk3Xto=;
        b=PoNFdADxmk1Vhuu6Ks6qiUFHt/sfvwnV9YuNMruOuqa74UXxpNT1+nOKxIAPmVvB3Pe/k/
        7DeZWeGMv0t3VywirEOwLBAEKKLszC1QRlFDf8F3u00DWpv0UX/a/9ymfKK2Whmd65Yd49
        67Q8rUvapJ3L9giuIU9rHpCocRUJOZg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9167ACB7;
        Wed, 10 Feb 2021 23:33:51 +0000 (UTC)
Message-ID: <61a4854a6a0f66b649c307ad68f3ab8fdb4fc0d4.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Thu, 11 Feb 2021 00:33:50 +0100
In-Reply-To: <20210210165909.692edea3@gandalf.local.home>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
         <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
         <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
         <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
         <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
         <20210210165909.692edea3@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xnyoXfil3RaV9wqA3oFy"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-xnyoXfil3RaV9wqA3oFy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 16:59 -0500, Steven Rostedt wrote:
> On Tue, 09 Feb 2021 13:24:23 +0100
> Dario Faggioli <dfaggioli@suse.com> wrote:
> >=20
> > =3D=3D VM:
> > # echo tsc >
> > /sys/devices/system/clocksource/clocksource0/current_clocksource
> > # echo x86-tsc > /sys/kernel/tracing/trace_clock
> > # trace-cmd agent
> >=20
> > =3D=3D Host:
> > # echo x86-tsc > /sys/kernel/tracing/trace_clock
> > # trace-cmd record -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A
> > tumbleweed-jeos:823 -e sched:* -e syscalls:*_clock_nanosleep -e
> > timer:hrtimer* sleep 1
> >=20
>=20
> Note you can use -C x86-tsc on the command line which would handle
> the
> clocks for you. I believe it may update the agent as well, but if
> not, you
> can add it to the agent as well. Also "-p nop" shouldn't be needed,
> as that
> would happen automatically if "-p" is left off.
>=20
> =C2=A0trace-cmd record -e sched -e kvm -e 'hrtimer*' -C x86-tsc \
> =C2=A0=C2=A0 -A tumbleweed-jeos:823 -e sched -e '*_clock_nanosleep' -e
> 'hrtimer*' \
> =C2=A0=C2=A0 sleep 1
>=20
Right. That's better indeed.

> > And I do end up with the two files: trace.dat for the host and
> > trace-
> > (null).dat (oh, well :-D) for the guest.
>=20
> I believe my latest push should fix that ;-)
>=20
Yes, 27c464a74f8f54d0 (trace-cmd: Use instance->name for guests and not
tracefs instance name) fixes this for me.

I was also trying to do some debugging, out of curiosity. And in fact I
was not understanding where the name was being copied in the place
where tracefs_instance_get_name() looks for it. :-)

Thanks!
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-xnyoXfil3RaV9wqA3oFy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAkbV4ACgkQFkJ4iaW4
c+4I1g/+NeRCRVe057/OmV4me1OQTQ27SAyyzTIlIvscpk7NhkBI5206Aq0ga9aG
jY1uMAAnI0qEu5u8YxM7i2zxhv8j49fy0w49yVLM5OW5d06YL2eubFs1kK/bEeRO
jb31EdbipKE5ng9w6HL6Rd6LfesvwkesA8vt6s+WufhqPgDZeMx2fK3RyOaUSTFm
gPPEDe0AlWX8zZJzuTHqSC5sGW4AvAdTmBHxDUqhvnOnLEoDiUmc4WKUCHgikQs6
3c2cHN/lexFEXC79dicbtjOyEquarp8wcGFAjt0Ln/vGKuW0sfzefH/O8tp2tvl6
Y2PhhqmCGl+aWaDHe13sctxnRksbvigIcXgiNvA2q/WZfoFkmK/zzNbnTrtW5X8s
HU7qa3jJhpwUYh/aCpmJlUelzCeS9nEiA0u3pusW972FRDTmjNSCkhtNoHyuUOmB
Vw8HSlRVBmpygXYdZr+3RwRao4Mu2MHvBRbaLAkNMteJ1347KrdS6AFZZNfJOkEq
wckqOJzfCsbgDWbJHXWMHhA6IeCkiA2Oznws2wVIZPVi5Ua90Ng4QwdSTPyK6nXv
y5L1QFVLFAqu1e51TulGoHgDzNXtZTx061bnr/pLgHJTR4mvg3jeZF+F5Y44C991
9R1q5yWvOTH5KaPk1HXrkFYviIG0jw3Duz2zgBtHjNmoPIVPpzA=
=yQ8b
-----END PGP SIGNATURE-----

--=-xnyoXfil3RaV9wqA3oFy--

