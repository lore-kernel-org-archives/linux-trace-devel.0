Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3CBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86EF6117A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhDNRq0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:46:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231582AbhDNRq0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 13:46:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618422364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2g8ziAmus50KijmlfayMO50WIIrzdytTdjaNvghJ58=;
        b=ao2AhT7UTj0JIVaK5t4IyuMTfJKKRO7BIDbqsrzO0+mYsB8cwBzZaXLZqwLsxrD81gkvvK
        +GM7Htw8lIHLO/RSo86y7BrZL+MJ9Bv07sHDjiX6M1lCR80tcPxZ/gvdw4UCsQY+I2UzFl
        6LEWu9R/4jWoCRi8RRYoiZyh+MEbM/A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 06DBFAD8E;
        Wed, 14 Apr 2021 17:46:04 +0000 (UTC)
Message-ID: <14510b1d24a35281362ebb0a904cd5753289f5a4.camel@suse.com>
Subject: Re: A KernelShark plugin for Xen traces analysis
 =?UTF-8?Q?=E2=80=8B?=
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Enrico Bini <enrico.bini@unito.it>
Date:   Wed, 14 Apr 2021 19:46:02 +0200
In-Reply-To: <8b43ae47-9d7e-a95c-4573-852d09f99662@gmail.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
         <8b43ae47-9d7e-a95c-4573-852d09f99662@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8OcG1gDXAnyfPWWORqPr"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-8OcG1gDXAnyfPWWORqPr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-04-14 at 12:25 +0300, Yordan Karadzhov (VMware) wrote:
> It is great to see such progress in the development of the Xen
> plugin.
>=20
> Can you share with us what are your plans for continuing this work.
> Is=20
> this a first prototype of the plugin, or it is an almost final
> version?
>=20
I'm only going to say that the plugin is working well with the traces
that we've thrown at it so far, so I'd say it's past the prototype
phase. :-P

As I was telling to Andrew on xen-devel, there is indeed some room for
improvement, e.g., the content of the 'Info' column is a bit "raw", and
can be made less cryptic and hence more useful.

To me (but this is just my personal opinion) a rather interesting thing
is whether something like this plugin should live in its own project or
will it be better be integrated in either Xen or KS sources...

And I'll now leave any further comments to Giuseppe himself. :-)

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-8OcG1gDXAnyfPWWORqPr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB3KloACgkQFkJ4iaW4
c+66HA/+LnOVRnSSmZcyQsHrM/cjOrh/o8lfz85ZhVRCpVNOVb4dfglzKsO5shw/
BPiOwcUc8nH4PA6ThZDYu0CkkzNS7ztOW65DhxW5i+LFRIosyeZFKdFUcn8Gbum5
FTHVGRyTeVtjNhufiDLqZnKsNC+nclTPhT/NDIaDFnomjgwJuHYu4EGwAnDhzAZp
DP8cz5XtM67NNO2CAiOuh1t4nDbNq6tSbmVeTexvyW4WHnpAIl2f73y0Ufhsq5Ff
effjPSil1+Y8zvyIhg+fueIKeyA8Zk7+scnBeS2y+apTNrLNmpqxG9ksAU2Fuf8i
CspVIdZl6sCiy+mdRPW+/zvOr5WSHdbgJJwreN+5WYdv3IkxZ0Nt1GzbvSG0206P
jV7+gwJTBIvmo+NfvmKMrvjpvNTt7hmPszx6XMQMnfUs57mVxgPNa7DyNQjtOS1t
CgRRbgZhI7dAnPI5HZ7rEOagkyXmum8c6W9wA3eiWDn8sJNrRADupQJiI1Vsj+MD
qLp3dHDCgA0rcXWqPHu3JfzAWh02dn+/2twVYKFeW0lT3Sn32N0Px2mMo3dLMxE0
joRDFG164T0HZsMxR+esTxE8LAuK++3t24bjgPDjN/FElqVq8b/4zdoi4mlkQNyu
+yli1UdpWqj+tszEgZTn4sDFDeoaLAl80rik1Zh5Oj3mPwlkfEU=
=OjGt
-----END PGP SIGNATURE-----

--=-8OcG1gDXAnyfPWWORqPr--

