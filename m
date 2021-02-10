Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37296C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED28264E79
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 14:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhBJOwm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 09:52:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:51080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230419AbhBJOwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 09:52:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612968707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/P95KsPZZw8f9LqulyCRw92eSQLeQJAaPGM8qaii0Ow=;
        b=CN1iW45pLYGkkB4ReBEXs5sAUw20cpeiZNpQmh5vsQD6hJIwzuSoE3Kr3dmcZERAXHQMYU
        QECTCpe69BYZQEGGQPKx2rDQvkZD15A7UWzs4YjKuXBG710ZGbFZdEnwbissEoU1lU/4p7
        W5Pq4xmB8s02vXImQ5jYWLCCg+EJcqQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 982D4AC43;
        Wed, 10 Feb 2021 14:51:47 +0000 (UTC)
Message-ID: <c047a5892fccdd5cd9550cba81fd16c71950fd8e.camel@suse.com>
Subject: Re: Kernelshark v2 all-black plots area
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Wed, 10 Feb 2021 15:51:46 +0100
In-Reply-To: <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
         <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
         <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
         <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ADdBB9Qwqk0yel9Gcugh"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-ADdBB9Qwqk0yel9Gcugh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-10 at 13:21 +0200, Yordan Karadzhov (VMware) wrote:
> On 9.02.21 =D0=B3. 18:13 =D1=87., Dario Faggioli wrote:
> > Indeed it does, thanks a lot again.
> >=20
> > Now, if I try "KVM Combo Plot":
> > - I still see super weird results if I use the KVM clock from last
> > =C2=A0=C2=A0 patch in Tzvetomir series (but I guess I'll report it ther=
e).
>=20
> Can you share a screenshot of the one that looks weird. And please do
> some deeper zooming because it is very hard to judge about the
> quality=20
> of the sync from such a broad time window.
>=20
Sure, let me try.

So, while tracing, I see this, so I think I'm in fact using the KVM
clock (ignore the "(null)" thing, we're dealing with it in another
thread):

  Negotiated kvm time sync protocol with guest (null)

When start KernelShark 2 on trace.dat (the host trace), I see this on
the terminal:

 ./kernel-shark-v2.beta.git/bin/kernelshark trace.dat=20
loading plugin "sched_events" from /home/dario/Sources/tracing/kernel-shark=
-v2.beta.git/lib/plugin-sched_events.so
loading plugin "missed_events" from /home/dario/Sources/tracing/kernel-shar=
k-v2.beta.git/lib/plugin-missed_events.so
loading plugin "event_field_plot" from /home/dario/Sources/tracing/kernel-s=
hark-v2.beta.git/lib/plugin-event_field_plot.so
loading plugin "latency_plot" from /home/dario/Sources/tracing/kernel-shark=
-v2.beta.git/lib/plugin-latency_plot.so
loading plugin "kvm_combo" from /home/dario/Sources/tracing/kernel-shark-v2=
.beta.git/lib/plugin-kvm_combo.so
--> KVM combos init menu
--> latency_plot init menu
plugin_latency_add_menu 0x100aea0
--> event_field init menu
plugin_efp_add_menu 0xf51510
--> sched init menu
Loading  "trace.dat"
version =3D 6

And this is how the GUI looks:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host.png

Then, I append the trace-(null).dat file (the guest trace). I do see
this on the terminal:

overriding event (1) ftrace:function with new print handler
overriding event (10) ftrace:funcgraph_exit with new print handler
overriding event (11) ftrace:funcgraph_entry with new print handler
<-- sched close 0
<-- missed_events close 0
<-- KVM combos close 0
--> KVM combos init 0=20
--> missed_events init 0
--> sched init 0
--> KVM combos init 1=20
plugin "kvm_combo" failed to initialize on stream /home/dario/Sources/traci=
ng/trace-(null).dat
--> missed_events init 1
--> sched init 1

And the GUI looks like this:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host_guest.pn=
g

The guest has 1 vCPU and is pinned to host pCPU 1. There are two `yes`
task running inside it. On the host, there are two `yes` task too, also
pinned to vCPU 1, so that there's some resource contention.

This is the very same configuration of the other experiment, for which
I showed the screenshot in the other email, when using PTP.

There, things were kind of ok. Here, it seems that the host events are
gone, but if I zoom a lot at the very beginning of the trace, I do see
them again:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host_guest-zo=
om.png

Point is that the traces are not in sync. Actually, it looks to me that
the timestamps of the guest traces are the most weird part, as they
look rather big, not really consistent among each other and some are
even negative!

IAC, the events from the two traces are shown as two completely
disjoint sets:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host_guest-ev=
ents.png
http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host_guest-ev=
ents-zoom.png.png

If I try a KVM-Combo, this is how it looks (not really surprisingly):

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host_guest-co=
mbo.png

Note that if I just open the guest trace in a new session, it looks
fine:

http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-guest.png

I'm uploading the two trace files here, in case it could be useful:

http://xenbits.xen.org/people/dariof/ks2-debug/

> > - If I use PTP, that kind of works.
> >=20
> > If I trace a `sleep 1` on the host, the result is like this:
> >=20
> > http://xenbits.xen.org/people/dariof/kernelshark-v2-ptp.png
>=20
> Is this a PTP synchronization?
>=20
It is, yes.

> > So, there is ~ 1 sec of data from the guest, coming from trace-cmd
> > agent. The host, however, went on and traced a little bit longer,
> > even
> > after closing the connection. It's not too terrible, I'm just
> > curious
> > whether this is known or it's something weird and it's only me
> > seeing
> > it.
>=20
> I think this is normal.
>=20
Right.

> But anyway Ceco (Tzvetomir) is the right person to answer questions=20
> about the timestamp synchronization. Unfortunately he is on vacation=20
> till the end of the week.
>=20
Sure, no problem!

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-ADdBB9Qwqk0yel9Gcugh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAj8wIACgkQFkJ4iaW4
c+5Mwg/+LVPX7gZ5j1CmLTgvUuxSAqUXlLC3eZ9Pu81XsLBJArzN7GvNp49y2Tn7
qJQePJ7LzxD2vcAANyUVW5abfR+ToPYkVSFX0ItXJk1imXuwusxkU0fJTH4pRmnp
dczOIMtDFfabOw1QbPfB8CwzW/CYkxVIjAQ7E68dgrxvAi5M7D2Va8SMbAxxB2Ch
9iI83Iskbk61sqJpJHsiagy3jipNFv8/ohHo6bJMUHGPKy5Q24yke96Phs2iUrlT
L+bDH0EJ1GcqBkjpFAFjduo/X/xkLtz1w4KestjvsYe7PEDBor1L78raVLncLZla
93avvM7+wqkCK+mbvCO72eSRHF5eHNmZuWax2KjAkkS2CbLaqN8DWDwzN66ncvnF
lxoU/Gq+Pi1sxPjRdORUvy6kz3MPoG0xUpcnulxIpm5KiYZZ4iPekuvxwDca9Lh6
/QN3w5e84Ab07c+tAPzYtgZh/xFwcwofPfeo2mFAzhs5N0PhQgJBtl7s7PBhF3jW
AP/C0q6Aoy6q5B4xnrvOaYwGu8UGqYrcMvOxCrkCpdyZlmKHQwNvRAYhtgU7QjOW
T45kZ/eWYJRhIYUCWD95UvD8IvFZmnj3Ebel4MWSIiy0rEq7SfsnAZGEiSlVAZlX
Tix/M1fKdkdtvuO9E+6+CbQ0rHtf98MnnjUIkw0XTnZpyLeNFk8=
=twYO
-----END PGP SIGNATURE-----

--=-ADdBB9Qwqk0yel9Gcugh--

