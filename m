Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC497C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 00:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6EFE60C3E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 00:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhDOAmP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 20:42:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:36210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhDOAmO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 20:42:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618447311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u/7DWqK+KH2xCdJetKy2G8NR7twfetAs1zlOuqKquYk=;
        b=gcww7yqzF1KdJV+NjrAq7ro8n7W8HiEQJ6CcXoi9s7IKSwLmci25S36xUW2nOXa6PcnO3M
        7vYZQF2awBnpc1olvOyEOo+ge8iKdYOsYj/Gref3fvCg8PUZaEMefc30XB3SIoOd2P7ScX
        WodlTmgOBY8dbt/IqJDg+C6Ye2YKLic=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 52938B0B8;
        Thu, 15 Apr 2021 00:41:51 +0000 (UTC)
Message-ID: <6176e02b5b82e9be10351ea386ba2cb8573d7f5b.camel@suse.com>
Subject: Re: A KernelShark plugin for Xen traces analysis
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Enrico Bini <enrico.bini@unito.it>
Date:   Thu, 15 Apr 2021 02:41:49 +0200
In-Reply-To: <f44f994d-32da-0610-57d8-e3a30bbb278c@citrix.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
         <20210413114614.4971caff@gandalf.local.home>
         <094c4b3f-3988-c51f-3a69-cfbc8d6a45bf@citrix.com>
         <20210414094300.7fbd6887@gandalf.local.home>
         <f44f994d-32da-0610-57d8-e3a30bbb278c@citrix.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-42X2G7kQJlH4RwMaJMhn"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-42X2G7kQJlH4RwMaJMhn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-14 at 21:05 +0100, Andrew Cooper wrote:
> On 14/04/2021 14:43, Steven Rostedt wrote:
> >=20
> > What I would envision how this would work, is that you would
> > produce a
> > set of tracing files. One for each guest (including Dom0), and one
> > for the
> > Xen hypervisor itself. The trick is to have a way to synchronize
> > the time
> > stamps. What we just did with KVM is to have all the tracing record
> > the
> > CPUs TSC, including the shift and multiplier that the CPU might
> > change for
> > the guests. Then we have a way to convert the TSC to nanoseconds.
> > This way
> > all tracing data has the same clock. It's somewhat complicated to
> > get
> > right, and requires access to how the guests clocks are modified by
> > the CPU.
>=20
> Xen certainly has enough information to describe what TSC rate/epoch
> each guest is seeing, but I doubt any of this is coherently exposed
> at
> the moment.
>=20
Yeah. In KVM its in, e.g.:

/sys/kernel/debug/kvm/85276-13/vcpu0/tsc-offset

Where 85276-13 is a combination of the PID of the main QEMU process and
one of the KVM file descriptors.

> > The Xen plugin would then need to read the how the threads in
> > xen.dat map
> > to the virtual CPUs of each of the guest files. Which would give
> > you the
> > layering.
>=20
> Looks good.=C2=A0 I suspect we might need to do a little work on Xen's
> trace
> data to make this mesh together nicely.=C2=A0 In particular, Xen doesn't
> have
> a terribly good scheme on unique IDs for "a VM".
>=20
True. However, Linux recycles PIDs too, doesn't it?

I mean, if PID 1234 is running when I start tracing and it dies and,
after a while, another task with PID 1234 is started KernelShark will
probably treat and display them as if they were the same task? Or
wouldn't it?

Currently, the Xen plugin combines the domain ID and the vCPU ID to
come up with a PID, that then will be used for assigning a color to
each vCPU.

This is pretty much arbitrary and can be changed, but it of course has
to be something that we can extract from from the trace event records
or, at least, from the trace file (e.g., as Andrew said, we do have
per-VM UUIDs, but they're currently not there).

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-42X2G7kQJlH4RwMaJMhn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB3i80ACgkQFkJ4iaW4
c+5oSg//b6TIvtCT4ZzBV+RfogiF9rSsbjCz8gJdaRjw+qA2M9VHQBOt77FX64/3
7q2MA8N1sxnYWiOX7vesF0xqOmMfleiee0THrLNmLQPuZQanfVUHjrPDdb9GTZC4
czUHFQnn1jtoj2GY+Xmfbl+7K47EmRJEnGSOV2JXNjPd/tuuDcFCozwdkCqrIIyb
1kuUK+cnEHQTxUAqndpd0WNpwfwX1CfnKS5YNDkvkOmC3sRX790MtcJ8Mvloqk1r
A/+VIYwGiRBJf2ewHmWsmBpx2u7L+0WjSvZYQbSiNbXhbQMS+ml8UVK9u7dFKQ2k
Idcv0Z/BN7PWGrmhag60MelWc4YHFro5J6NLULtE8KmY0s85n4Hkph2UVGnefoWB
WCXPG4cGoTgLbiDxcL9A50JxOA7v6v/7lxkZCZWde1F86umKEU7Niphad5ikh4Pz
4dZzVhXIlfm+LtbS0DUnq1RiqXEFjATaBWImqvidSHHFPe2jl2apezQ7C+o3Tcdz
HsMCadTHSb3RX6MJ6d/kv46/e38CA5bYTj7C0hyaVyKHxet4xAGMCCbEDIVYRgzy
MtWlKu6swyoNLYfjH/Av02xMp+0areZm3xhY67HE7BD+N8/3JzkLbZQPlv70Y2aj
HZvxukeiED5862MPwVGk9IytB6sTaMD3mLK61AUyPIvpIsfjhbU=
=grG+
-----END PGP SIGNATURE-----

--=-42X2G7kQJlH4RwMaJMhn--

