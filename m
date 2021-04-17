Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222EDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 06:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6116113D
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 06:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhDQGng (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 17 Apr 2021 02:43:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:43060 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhDQGnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 17 Apr 2021 02:43:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618641788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BEDcvX07CqIwUKwk0VNTKRgJdWemYMz+MjFIHVFQRbM=;
        b=gWyEq2D0ZhZlCHJBi2wbdDmlpoQms+GS/bSus0tWk1tY0b9GgNwDoiNf0SGZeZLjq0sB04
        COa9f8MNrZrN2cEJRfifX8Pke7oLAwx6lBh/N5fZ7JwGoN9+4r+ZFaW/NnvVlY+cZwo71Y
        XQbEbd9j2x6Ym3HcpINS3z7KPV6F63k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0796B062;
        Sat, 17 Apr 2021 06:43:08 +0000 (UTC)
Message-ID: <8cd07e86b6e728bc7b74b39d52833715cecdc24c.camel@suse.com>
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Date:   Sat, 17 Apr 2021 08:43:07 +0200
In-Reply-To: <20210416173235.11b0d1c0@gandalf.local.home>
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
         <70d698ef3074a50576da48587aaf4ce2eea9585f.camel@suse.com>
         <756cd31c-9dff-5f18-8daf-5fae5e62f947@gmail.com>
         <20210416173235.11b0d1c0@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7g8M82h7hbNIKaBbyQuv"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-7g8M82h7hbNIKaBbyQuv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-04-16 at 17:32 -0400, Steven Rostedt wrote:
> On Fri, 16 Apr 2021 22:48:38 +0200
> Stefano De Venuto <stefano.devenuto99@gmail.com> wrote:
> >=20
> > Yes. An example of those events is visible in this trace:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75367012:
> > kvm_entry:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 vcpu 0, rip 0xffffffff84a792b6
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75253942:
> > write_msr:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 c0011020, value 0
> > trace-tumbleweed.dat:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 <idle>-0=C2=A0=C2=A0=C2=A0=C2=A0 [000]14320175283462:
> > hrtimer_cancel:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hrtimer=3D0xffff900=
2fdc21a00
> > trace-tumbleweed.dat:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 <idle>-0=C2=A0=C2=A0=C2=A0=C2=A0 [000]14320175291336:
> > hrtimer_expire_entry: hrtimer=3D0xffff9002fdc21a00
> > function=3Dtick_sched_timer now=3D3601121397289
> > trace-tumbleweed.dat:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 <idle>-0=C2=A0=C2=A0=C2=A0=C2=A0 [000]14320175317345:
> > hrtimer_expire_exit:=C2=A0 hrtimer=3D0xffff9002fdc21a00
> > trace-tumbleweed.dat:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 <idle>-0=C2=A0=C2=A0=C2=A0=C2=A0 [000]14320175319329:
> > hrtimer_start:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hrtimer=3D0xff=
ff9002fdc21a00
> > function=3Dtick_sched_timer expires=3D3601125253926
> > softexpires=3D3601125253926 mode=3D0x0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75331517:
> > write_msr:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 c0011020, value 40000000000000
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75338548:
> > kvm_wait_lapic_expire: vcpu 0: delta 534432 (late)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75341750:
> > kvm_eoi:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 apicid 0 vector 236
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75343465:
> > kvm_pv_eoi:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 apicid 0 vector 236
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-1567=C2=A0 [001]143201=
75345704:
> > kvm_exit:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 vcpu 0 reason msr rip 0xffffffff84a792b4
> > info1 0x0000000000000001 info2 0x0000000000000000 intr_info
> > 0x00000000 error_code 0x00000000
>=20
> Is the above with the time negotiations working fine?
>=20
Yes. I think this is still with PTP.

But this time, this is actually all about the host.

> We do not yet support the guest shift, as we found that it was broken
> (I
> believe you reported that) and we do not have a machine available to
> that
> has that feature :-/
>=20
Sure, but the problem here is that write_msr, kvm_wait_lapic_expire,
kvm_eoi, kvm_pv_eoi in trace.dat (which is the host trace), despite
happening after the VMExit, are shown before kvm_exit.

This, we think, has to do to where the call to trace_kvm_exit() is in
the kernel, and that's why we said we'll send a patch to move it.

It was just an example of what and how one can use the simple little
tool that Stefano has made on top of libkshark, as it was what helped
us spot this problem. :-)

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-7g8M82h7hbNIKaBbyQuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB6g3sACgkQFkJ4iaW4
c+75Jw//ZWQuH8uplU81+lsnspOm/FyPAU1/1YKS0jLkUXjOCNFNJ6qEw44c2Y2p
IN7CBo8/cJmHokdYH6GqGYdpuzKAXU+2L5Jj44xlW3RmJHM5xVFoSseiWHdKdM5l
pKmroq1agQZM/DgK81dsFvmUBOFNFXAHLDsLwD20033DQiN2S2KjdJVQ24j3jCSy
HNdblvbpjK6mbUHblmyEE4sMp+fX0sHnGBzamcghghWkZro3c62JY7KjEO+6b2JC
IOHDlDtw6TFmsry7qj3N5IIqLqeDYtqB8gBuSrtvUnt6+H7HnoQW7OiqwhWK6o1p
Xt8faEGo3ShD4Omzyp3fX/bCSXtGcyd4eP00xVFafiqIDm5/jsHo9xI4G1vW4gCp
0yq8GKl7wLshG2D35RyId86wh/z4Bj/FRgJWLt5wd3fl/VTMFgvnTTCEn1gUiZAs
sGCsr14NckipsJ7+qXgCXXKC50783gi7sG7sUFKSrLDkrG+xQSZVIARlgbBKl30K
NfXW8M3juO66TYfSel49lneVG0szx0Ro12hq/a7sZPs7Sdm4J0iRNUDrClVPfGE8
ktf9AV9h6x5mEf8szU2VmXBgGPEsHCLOd3NeMngOyg4Ulr8R/8//XjQ34Nsiouo7
IkbMcrwkzVHvrvU0aqFh6tbJaSosY8DknkhOBbWJVn+xqy7XWF4=
=RMTg
-----END PGP SIGNATURE-----

--=-7g8M82h7hbNIKaBbyQuv--

