Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1B2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 14:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 427DA6101C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 14:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhDZOMa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 10:12:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:58552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230250AbhDZOM3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 10:12:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619446307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=spBuogY9lenf5ABCHTlIkRtw7yS2Dx1jRigEPMSw3pk=;
        b=dkNjtEeggSwJf+0g58HGERCBtuRU8BM4zcSeGtiw9uKQpbaCTRqT0FB4O4c+uJ4JJwy5LC
        pNv0irt+8OiPXsXR3KwRGlCimtT51tSsMcsl06MLRR3VwgPbMSznlb9FbeXeE5ztFspFtH
        QHH9w+12M0PXqiYVZsAc9V4TFgdoQ3o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63BD9ABC2;
        Mon, 26 Apr 2021 14:11:47 +0000 (UTC)
Message-ID: <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
Subject: Re: Instructions for clock sync for tracing host/guest
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 16:11:46 +0200
In-Reply-To: <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
         <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
         <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
         <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
         <20210422153845.3e6e9304@gandalf.local.home>
         <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
         <20210422154830.52f3e4f5@gandalf.local.home>
         <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
         <20210422160313.2eee1f77@gandalf.local.home>
         <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
         <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
         <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
         <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
         <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
         <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
         <20210426084408.581364d9@gandalf.local.home>
         <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9C++k96srgQ52zl8CZLu"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-9C++k96srgQ52zl8CZLu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 15:59 +0300, Tzvetomir Stoyanov wrote:
> On Mon, Apr 26, 2021 at 3:44 PM Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >=20
> >=20
> > We need to find a way to do this without qemu. It's only the thread
> > mapping
> > that is missing here, nothing else. And KVM sync should still work.
>=20
> The problem is to find the VM specific directory in the KVM debugfs,
> where the VM TSC parameters are. The name of the directory is
> /sys/kernel/debug/kvm/<some PID>-<number>/
> The PID is the qemu process which runs the VM. I wonder how it looks
> in crosvm ?
>=20
I can't double check as I don't have a crossvm environment handy, but I
guess it looks the same, and the PID is the one of whatever task in
crossvm issues the KVM_CREATE_VM ioctl (and the fd returned by such
call).

In QEMU, such process then creates one thread for each vCPU... Again, I
don't really know for sure, but I guess it would be similar in crossvm?

If yes, AFAICT, kvm_entry events can tell us the PIDs of such threads.
So the challenge here is getting from the PID of a thread to the PID of
the process that created it.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-9C++k96srgQ52zl8CZLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCGyiIACgkQFkJ4iaW4
c+7saQ/9FI49Mlt3MbDGNJCVJQLqNi5BhviPpRV4UBdp0loAFuBOosgEkujvaOCA
cdQ9vIllsKF+4qVQ3vIbV4CZBJEVhq+QoGg1c4WVgDn7HtimPpsymmYvT5gKrsL6
Z0kc8bN4cmmPMv8J+r8YhwlbcccWYn0dxuupL/rtu1b5u+ntV1DCSbG+bCOrfyhd
17r0WarnmNM/VvMjoJ/n+hMQf1BO1Pa1aTnrB8qZBYmfvvcqew5HnVPyPA5Fir5U
XCdiMKz610RelWFZ2LSf1/CVfFOydhqYbbAAMlQ4tLphG9dXFDYac8TJOzduJ3Gp
qEcG509/lpWgSW6dg68679AheZMuD6yDaKjLp1EDJUKJI7Dgai8SHv1M6Y2SydtP
KcpFEj+QAfTTC/odW6CZKkBtnn/HYgd2N0EzjpRfwCGclUCmRZ6/AOmYILaOE+QG
krP9R9QY28di1jPzHB2fPdKcTPRLlbXcxq4FkXP5af8KUXb9qahQsimDM2faB73q
ElIMC95fEA0OtNZz1ovDm7zHjmEZutHdz3QIiDCgxZpD450LLW05Cj5CIiVdUvQb
bNtSK5o1jSYJdvtPJbnqEdDUVpX+mSbcG576IlfmHXSfkVeYLkT9c33EMUbICbiC
k9LndgxGsLAm040Tm8apEdSvndbEnxxcAXyLXj8UAk5QDveMZME=
=1x+V
-----END PGP SIGNATURE-----

--=-9C++k96srgQ52zl8CZLu--

