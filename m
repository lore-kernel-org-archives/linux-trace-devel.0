Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB0BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 20:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796FC61A3C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 20:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCYU4O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 16:56:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:39230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCYUzp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 16:55:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616705743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3VfPe5ytwFivyYXwTXxlEptQEfs03cyz3RRJOvqsjuc=;
        b=Z+JklyVVt0g/gvaMqT0bswxymztMmmgwhTbS35JrycakhdYNmVkc/trzREcVDeeGxp3lTH
        lBRv5/oM8MGkYRzuZqW0v1ObfexR62YhYJSH2rqZVNk6Nim2XI5kVOsuzO499ZssG9vi8d
        /k/273RCPYAguov397/hm6Lc6y89oko=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89A37ACBF;
        Thu, 25 Mar 2021 20:55:43 +0000 (UTC)
Message-ID: <3871a1520068e44bf339e430bef2fcf55cbc1cdb.camel@suse.com>
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Thu, 25 Mar 2021 21:55:42 +0100
In-Reply-To: <20210322105624.40aa27b1@gandalf.local.home>
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
         <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com>
         <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
         <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
         <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
         <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
         <CAPpZLN7ChRzU1b2t1KSbT+MB0An=CJJxnDizaO41K=XSz8sb6g@mail.gmail.com>
         <20210322105624.40aa27b1@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ksnTe6fXwiUUM+MAro5X"
User-Agent: Evolution 3.38.4 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-ksnTe6fXwiUUM+MAro5X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-03-22 at 10:56 -0400, Steven Rostedt wrote:
> On Mon, 22 Mar 2021 12:13:09 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>=20
> > Confirmed, the problem is in the trace-cmd logic that works with
> > the
> > KVM scaling.=C2=A0 Looks like tsc-scaling-ratio is the default KVM
> > scaling
> > on your machine, (1 << 32), and in that case the scaling should be
> > ignored in our calculations. I still have no solution, going to
> > analyze how the KVM scaling works.
>=20
> I'm guessing that this was run on a AMD CPU, as the default scaling
> (the
> one to ignore) is 1 << 32 for AMD and for Intel it's 1 << 48.
>=20
BTW, yes. Stefano could give us details (lscpu or anything) if
necessary, but this indeed is AMD.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-ksnTe6fXwiUUM+MAro5X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmBc+M4ACgkQFkJ4iaW4
c+6Q8xAAunJYCrjkrOcmowcErYupDVCi2jCGVSC643g2A4ZK60VpNdL83JZjhgHt
h29jSD9QK26q0JFpK/W67dCWEawfYjjPbyU2DtYNMZS4NNuz7oNk53SAyLSqwl2B
z1h6uR1wkYdZfvXI2hO68kummPWW9jl/Ys6VHh0eAQGx8o9xDmzMlBqL3wXu8dmQ
T3X5h8WmvAqRtzQfh55NpP8Ek1d5bPzum9VrXUOn0iL9nsrQqf0Te9B7/bjV0CVv
XwaE66en8YTlDisvxLeEpeZcoVMaoSg80XZh1I51zpNB2F9YU/kxEzQwwh1klsfK
klR9lpiShmX1LwXDiw8JY0VrCL6oy8agB3zMncGM65I6soAnoxdDWqdvzf5vBQN2
5KxlBlU3OeTOvAro0bZl1udANirYEA8R4VFZbNB6fv8L+IMXDQdA14MvUmxy0JtZ
3xdYCHu/BMUODLtSXopL7X8CBMXS71ZgxFVU6Porb7OF+VWjCN2YIiBSAQMl1s0C
NCqHfBFrU8I0i4smRdNob5qG1esjZPTYteh1Mz7D2pClA6p5mB7sDBMRMa/atMmg
qY1wOUUpkMVsH7T6/0IOII5T0t6Tf96u9Sl9sGzmOe09z4k/iKtRK+o+wu0TATel
lQVcxymk5YJlPwJpyCEbWLhQ6LbxDbBXj1JPQUiVOOvr8+j6M5Y=
=3Gpy
-----END PGP SIGNATURE-----

--=-ksnTe6fXwiUUM+MAro5X--

