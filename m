Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F69C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADF261175
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhDZPiy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:38:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:60560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233674AbhDZPiy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 11:38:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619451491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NE/nOYcCJgqf7zG4903OowW4W6tisIEClYe3ON1BBeE=;
        b=KESNHBmqMUL5TyKhsffzg+PW/EfdTqbwpgTKRfdzwf+h+RNNzSdx8x3ex41oDSaidUCWiw
        a9hYT5pH2Fx6TsgZJmI1DylVwn0gUhdGvaVjbPbskywMKkmW+fNMtcufL0qDRJXdPwjObM
        4SpAeQa99hY2YxSpqgIEb0xfer/koik=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8AFCFAB87;
        Mon, 26 Apr 2021 15:38:11 +0000 (UTC)
Message-ID: <f7b417bf1604145b216156036d06f93585f7316d.camel@suse.com>
Subject: Re: Instructions for clock sync for tracing host/guest
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 17:38:09 +0200
In-Reply-To: <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
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
         <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
         <20210426105111.288280bb@gandalf.local.home>
         <CAPpZLN7q_nQg8A65P4w3OjoN8GiujpCnYwjBJVYbWyLBkb1OHQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K88ReqSTb+UWIx1wtEnq"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-K88ReqSTb+UWIx1wtEnq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 18:02 +0300, Tzvetomir Stoyanov wrote:
> On Mon, Apr 26, 2021 at 5:51 PM Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >=20
> > We see that our process (PID 160552) wakes up 129046 which then
> > wakes up
> > 129042, which does a kvm_entry for vcpu 0. Since process 160552 is
> > communicating with the guest, we know that this series of events
> > will wake
> > up the guest we want to map the thread and the vCPU of the guest
> > with.
> >=20
> > As it was thread 129042 that called kvm_entry, it's the thread that
> > is
> > mapped to vcpu 0 of the guest we are tracing.
>=20
> For a complete mapping, some handshake logic should be implemented -
> to force the guest to use all its CPUs, and to ensure we have the
> mapping for each vCPU.
> The other approach could be to look in /proc - the relation between
> KVM thread 129042 and the VM process is there.
>=20
Yeah, that was kind of my point. Any VMEnter, from any of the vCPUs
will give us a PID, the one of a vCPU thread. From that PID, we can
look up the PID of the process that created the vCPU (although, I don't
know how, except scanning).

With the PID of the creating process you can tell (e.g., still from
/proc) the number of the vm-fd, and we have everything to reach TSC
offsets in debugfs... Isn't that so?

What about the vhost cid and port? If they're on the command line (as
they are for QEMU), of course we have them in /proc too. IDK if crossvm
(and other VMMs) also have them on the  command line, though.

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-K88ReqSTb+UWIx1wtEnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCG3mEACgkQFkJ4iaW4
c+7Y6g//YNjNawJz6wdMlNgUKI9nsq77dMg6u+Z26W1vwlXR4biSffZGD81XreqU
rowxwIzOXOtu8Rgl0cKMKG3RHpnHvbTIHMzNen/YKPeC49Pef5b2Ntb7V53r66pp
U2yzWSIuEkdfdtsysj27bTgDuT4hDHhhsp9aUE76vhBlRLnK7SIefr4bIf4Apxyf
VC5N9DW3rnvKtywewEZu1OqQmaDgt+NHJy/AOkku4W81Zyi7Os3d4/JQ9JmmVVju
i+Mu8oEHNHE15a1rHKuizEr7ZMEBSAnyQuX/fyYdro4zjQ99DnVQoMvM+u07ojM5
4I8IbBqf2YpGtreZ7Jfi1o+0Pb3Eq+oaO8X4qfBxNdXvo/1vkP14LSorEsMoc06l
VJspdMw7YW9n4OJbYuJZ7QgJuwsmGOKNuHAXN/5UERf5LBLZqdVfbk9Zrsubye3N
Y5vB9MRjwrKpvcZ5JgNjX9MR2URZX5BIdj8wO6KjzekYdms6PyKAcv6tOnB3xpOK
zVX2rrVe4gZP2xovqOiNl+RvH9tWPKmCEbxohOpRtx9sClHkwFGUoAlRGuaFuFke
IgKo3PqFqMYzxQNGZjrxwuWjsDr0W27EvH6w9koIBShe0n83cECHWHKLe873l7Df
4tWQAkWfYafkIfq0bLuBt7LPQKQ27GqO2Yfnmif0qnDZo9b7PSM=
=RfaO
-----END PGP SIGNATURE-----

--=-K88ReqSTb+UWIx1wtEnq--

