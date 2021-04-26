Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8F1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FF8561107
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 13:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhDZN0y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 09:26:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:54690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233739AbhDZNYw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 09:24:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619443449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KY3YlGObSOOB5+/27rx+BUO9qwXOrmRHEMFnAC0lzR4=;
        b=XnjiM5ar+TPY2adRFmpTBtptZZ1G5NnY3Zm8ak/XJ038pR6hVt/BoW+PTyfgNzkmrFJ6JJ
        rdW79NWQdJzHnzTztRTG1fcq9Q1bTGHCk5ktD7Bdsok+q8DhX71lNSQJcllSty59WzOek3
        e0hBBhA3M4eTNMRlF2xZGbs7uVPJVqM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B72AABED;
        Mon, 26 Apr 2021 13:24:09 +0000 (UTC)
Message-ID: <d19c679218fcb43179a711740186781f3c29265a.camel@suse.com>
Subject: Re: Instructions for clock sync for tracing host/guest
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 15:24:01 +0200
In-Reply-To: <20210426085654.5a47e7e5@gandalf.local.home>
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
         <20210425142935.52078301@rorschach.local.home>
         <CAPpZLN7hhypY6+s5R+JX1u2e9Typ-1O1yC9mDoEcRYKLHYGFNw@mail.gmail.com>
         <20210426085654.5a47e7e5@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NKuz1kSOr2mWVBg/gVkp"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-NKuz1kSOr2mWVBg/gVkp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 08:56 -0400, Steven Rostedt wrote:
> On Mon, 26 Apr 2021 13:39:32 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > >=20
> > > There, I see the guest vcpu 0 is controlled by the host thread
> > > with pid
> > > 129042 and vcpu 1 is controlled by host thread pid 129043.=C2=A0=20
> >=20
> > It works only in case of one VM, if there are more than one -
> > cannot
> > map kvm_entry event to specific VM.
>=20
> =C2=A0# trace-cmd record -e sched_wakeup -e kvm_entry
>=20
> And have this:
>=20
> =C2=A0=C2=A0=C2=A0 vsock-client-159876 [000]1346877108580652: sched_wakeu=
p:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> vhost-128994:129046 [120] success=3D1 CPU:006
>=20
> =C2=A0=C2=A0=C2=A0 vhost-128994-129046 [006]1346877108678708: sched_wakeu=
p:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> CPU 0/KVM:129042 [120] success=3D1 CPU:007
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU 0/KVM-129042 [007]13468771092900=
44: kvm_entry:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0
> vcpu 0
>=20
Mmm... This is quite interesting. But there's something I don't think
I'm understanding.


> Instead of looking at vsock-client, look at the current pid and see
> what
> "vhost" it wakes up, then see what what thread it wakes up, and then
> see if
> it calls kvm_entry. we don't even need to know if it is a vhost. Just
> trace
> everything that our current thread wakes up and what those wake up
> until
> something calls kvm_entry.
>=20
So, what's the mapping (like, mapping between what and what) that we
are interested in here, and what kind of into trick with vsock-client
is helping us gather, that we don't already have by "just" looking at
the kvm_entry events?

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-NKuz1kSOr2mWVBg/gVkp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCGvvEACgkQFkJ4iaW4
c+5fTg//X3VX7F/+Hu6NNTwWk0y+k07/fpuJ2OhLS5BZG5MIvOBT3yqYjyQ1CnkO
q72HNCkOoYyDWbjp4RzQlF1+jw/a22LpzwIjQqRGR1/w+ap+sRj/rx1N/ePjDDdl
5hA8GLc9ZwQ0Z9NqHw3PQ+HX+mUMKLFWOA7Xwf+wYkBzV7AUM+JzR1xdvHQMMCFL
q8UrlELpnl+vGUXfc76nG0ykFVxRB49X0cEjbYgeaeGl8ZYXMiM3q4uGfsc6YIh1
1Qt6C6YsoGOS/1cxnutaK9q1FLuPwUnhAgooquHTN3CadUSN2KGmlqgIYO0+Fc7P
eDnJzi8LnTeDIi6ydQIUSU6Ow6/h7XSN8abfCZMi6kVtkpBqmgY342wN9LE8hpzs
m2xO3mYtv/Ox/XHXrDzqCurr5mFM6bf+aSL1Iz2Yf+TsCvVupm87k7Gtz4kCI8yG
0SXmnjt+yM+Cb+/RWTBhzkRqT6S5gMPG/GqMPMLSBlC0Ag+YMDgLqui2JNxV+rLY
D/zX7vNCIJuQFxSSA1ZTvO9UKfH/mv0r/xe3VMJbR8hFITM6066/sgjMBgeIeM/l
IakZYsU8tQpLVz3leOwRTHxBhng/+ReNSgSEdPboehZA9VRfQSIYria+5iintOqj
zI6sj/2PACrRC1ffriIGVs0IMLUgfl1c5H17RrwIN6D63TJrD6g=
=8MhE
-----END PGP SIGNATURE-----

--=-NKuz1kSOr2mWVBg/gVkp--

