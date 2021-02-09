Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CA0C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 07:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC5D64EB4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 07:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBIH3l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:29:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:57660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBIH3j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 02:29:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612855732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MF3tn2UT9ksgJ+Qf7GWVLAbEPN1E5KhgJDPuY5r2MbA=;
        b=kfvQ3n+S275y1jDoo1kErkfh2UG5+EepWuhY/tCbNDfxwVlvE0jMhQPvEat15RI27FIyxK
        hxGbL4h1PpMoX2LP8zFkeFoGiwNTs43VL8GoUAljiGgcNfvGHJo612UYD41X3NTFq4RXdm
        tvYUbrktr7pHDUGsmHd9og0k88vCPJg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1DAABB018;
        Tue,  9 Feb 2021 07:28:52 +0000 (UTC)
Message-ID: <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 09 Feb 2021 08:28:51 +0100
In-Reply-To: <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
         <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xaPUalb6KAGmxxQGK9/s"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-xaPUalb6KAGmxxQGK9/s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 08:08 +0200, Tzvetomir Stoyanov wrote:
>=20
> Also, please note that there are two patches that should be applied
> also,
> not part of v28 version of the patchset:
>
Aha!

> =C2=A0 "trace-cmd: Fix plist allocation check in trace-msg.c"
> =C2=A0=C2=A0 =20
> https://patchwork.kernel.org/project/linux-trace-devel/patch/202102031654=
31.792152a4@gandalf.local.home/
> =C2=A0"trace-cmd: Fix SEGFAULT when no tsync_protos are supplied"
> =C2=A0=C2=A0 =20
> https://patchwork.kernel.org/project/linux-trace-devel/patch/202102031710=
18.5b82a0a7@gandalf.local.home/
>=20
I just applied both, and it now seems that things work!

Or at least, host and guest talk, and I see this: "Negotiated kvm time
sync protocol with guest (null)" (is that "(null)" ok/intentional? I
guess I can check the code... :-))

Thanks a lot. :-)
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-xaPUalb6KAGmxxQGK9/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAiObMACgkQFkJ4iaW4
c+5Z1Q/+L+Zdf0tnbO9GPys5+iytAtQbnW1PDXH1mihnuitnIpAtNGP7Jke13Y2d
L69D/5M2wZ971RdhWyclFotcqxsoRKQxWcSqW9rm7vDY7xdkNMY6mP+lR7LzET8l
dZrTIiuCU0xVYZXCaTKEgCDU3YFU+XVrdNBqYSTE44+uEDhYEgW0XXzTK7/UPFdj
6yiSya/L0pZE3snTX1ky5546UqelKZVNPPZPiMmblhWkdCPIemDAIV0ctNzBbAFx
S08Y/rUbfu2slS1UPtT0Vi4Lz687+KK0AALxeZrps14chdbA/xMcGjZywsWDNxbX
XPKKB+GY4IAPmWslbeyW4ijCFrajfYDQaNm+MOp9ZQW8juQZHo051bCD5xWIe8xz
JKWrFx0ZWylq6+YamuToAyIZhsqCzW9DzFCgIYFcbKX6zQbIookFu/yg1XSxrgCS
P2ORqrjq+qg5/I9kZE9HY80RXJ4PTN7SpXy++sYzUOd64ABwgkS7nCbDxOSsZaoa
6z7u5tmcikGKHzPmXn2Lugo1chci7d8zakUdaKcuQDFnMH2DYRYsrxwIMD4tlx1c
xVw0Za7qkU9s0oBVulsKhSw9pRlOhiuAFeOrW/fMTeve/JaJEkp02Tw+nxi8yHnH
YTSgDlNmx4aGnRaLX5UVMOikB6JRGTGvcNvyPCN6+W8OBc9HPwo=
=Vu3C
-----END PGP SIGNATURE-----

--=-xaPUalb6KAGmxxQGK9/s--

