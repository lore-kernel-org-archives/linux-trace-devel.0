Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE3CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F44611AD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 17:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhDNRbs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:31:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:51702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350540AbhDNRbj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 13:31:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618421477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8AdUsV5+m18DdyjTG3g+kQeVCexQmrWCAmXwuTMijAQ=;
        b=Vd3sU9pDC4cBGP/+vh7Wp180dWo7vPTf7Hzq2wy0nr2Kwtd+J6Ijr3QAj+Dfb3Fx0vq6t+
        hcrZ6aCUMUNHy9HIWIPL5KoTcPw1utDQik1PPxFV2u2DTv1UywyXZga+OC31Xls6v79b4w
        wEIG1yOwTCpuCAICsr99LnDMfTXPtAw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31858B007;
        Wed, 14 Apr 2021 17:31:17 +0000 (UTC)
Message-ID: <eefc512b8c1ac26c4eaae81e79ee0243901a3de2.camel@suse.com>
Subject: Re: A KernelShark plugin for Xen traces analysis
 =?UTF-8?Q?=E2=80=8B?=
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Enrico Bini <enrico.bini@unito.it>
Date:   Wed, 14 Apr 2021 19:31:15 +0200
In-Reply-To: <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
         <f33b39a5-9bbd-934f-a9cd-c536a0ba7416@citrix.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qc+CrObLu0osWbgfz4gY"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-qc+CrObLu0osWbgfz4gY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-04-13 at 16:33 +0100, Andrew Cooper wrote:
> On 13/04/2021 15:28, Giuseppe Eletto wrote:
> >=20
> > You will need the development version of KernelShark, available
> > here:
> > https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git
> >=20
> > A screenshot of the plugin in action is available here:
> > https://github.com/giuseppe998e/kernelshark-xentrace-plugin/raw/master/=
.github/img/ks-xentrace.png
> >=20
> > I'm happy to receive whatever feedback you may have about it,
> > and to answer any question.
>=20
> Very nice.
>=20
> A couple of questions.=C2=A0 Which Xen libraries do you currently use map
> the
> frames?
>
Err... If I understood the question none, as the plugin loads and
parses a file, as it is produced by `xentrace`. :-)

But maybe I didn't understand the question?


> For the screenshot, there are a lot of examples where you have a
> dom:vcpu pair, and a number rendered in hex.=C2=A0 Throughout the
> hypervisor,
> we're standardising on d$v$ as a format, and e.g. d[IDLE]v$ for some
> of
> the magic domid's (0x7ff0 ... 0x7fff).
>=20
Yes, the content of the "info" column is currently a bit "raw". I
believe it should be made more similar to what `xenalyze --dump-all`
looks like, rather than to what xentrace_format` does (just to make and
example that people that have used these two tools can understand).

This is just due to the fact that we wanted to let the Xen and
KernelShark communities know about this work as soon as Giuseppe got it
working properly and reliably, to gather any kind of feedback, decide
where this should live, in the long run, (in Xen? In KS? In its own
project?), etc. :-)

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-qc+CrObLu0osWbgfz4gY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmB3JuMACgkQFkJ4iaW4
c+5XohAAkqpWChAgyY1C4y+vXJwHP5m+MjpnA8Cf9bLtSdZW+Brpu1SNA1/Ru51J
FVzt28RrvInag6xEMdVBNv3CmEQKAsq21D0C293ldO7Xc/qcKwo+lxRHR1pUOpkc
+2PSO/mDl/z8pAgVfThyzD1r0cg9G4m2F/L0Yr+98Demc2d5q4Tdwsw89O86eohl
f9hdPgr3M/IavYZRCBvWW2muBVsE9QDTUCeoTpfJw/RslsUXlremEo7EqttYNJnv
/oKUX49DfTZTVZoA0scDnEzDgjfQHTkmmstNWKHT401niFfa9WYcUmaKLnVGnPJv
IGuXlY38RSEPO6WathL7yleQ0qJ2C7WzzdGKNrw21k+8JnHyTepMk5L3B1BI2Oj3
uaSLdfBmqSaC7QY3ym7VA0mEnSkG7o4tgst9DK/C4CSaktI/kZuQmYKu9jBerJlk
Iqr0IIboPuGgvyuGwPPfBdDQMFlH4efyr2l6s3veMQMhvgwmMTFNVXTXti+c/yNC
pMeNT/TejIL3yyuXihC8dsSUwd29V4MIIRl33mTkyCnMhhqC8eQnPCMAAKVm9Sfh
UMH5w4qyMV306+MHyOWYC1UZzPBTu6GLNvfGMjQOphaTAiRk3thRsfMvgorgNLXC
NzXPBq5e39GaHtCwMdo8yrc7Fp70YpxIjBTdF65CSo+5pM0k8wk=
=3hdl
-----END PGP SIGNATURE-----

--=-qc+CrObLu0osWbgfz4gY--

