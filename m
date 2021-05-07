Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71918C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 00:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26379610FA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 00:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhEGAdH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 20:33:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:49350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhEGAdG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 20:33:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620347526; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wyXECh/mXWdFzLIskNGLGbUSUTGQwnwaZB22fKrkQsE=;
        b=uAsyWaVWZzNLWq+J45mMxsLGsJWUCSQ5d6ibK/OWD0mJO0M1iDAMIpaA41la4iiH8G3iQn
        yuYjGmsyh2vzpi8FOkOFuSZ0p9t4kbUQAlS35IusHkpyX0rFIbrxLZzrfw7sRv3eeRA9WJ
        mjKRfOqcehrrp4Sm3Y7z2G4eihFODiI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3F4EB02A;
        Fri,  7 May 2021 00:32:06 +0000 (UTC)
Message-ID: <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Fri, 07 May 2021 02:32:05 +0200
In-Reply-To: <20210506171400.7c00b731@gandalf.local.home>
References: <20210506171400.7c00b731@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PD/uQG60RlU/zlsxyfbA"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-PD/uQG60RlU/zlsxyfbA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-06 at 17:14 -0400, Steven Rostedt wrote:
> Searching for the qemu task to find what task the CID is for is not a
> reliable method, as the qemu executable may be called different names
> on
> different systems, and qemu may not even be used.
>=20
> Instead, trace the sched_waking and kvm_exit events and do a vsock
> connection to the CID. By doing so, you can find the task that runs the
> guest.
>=20
> =C2=A0trace-cmd wakes up "vhost-<pid>"
> =C2=A0vhost-<pid> wakes up "CPUX/KVM"
> =C2=A0CPUX/KVM calls "kvm_exit"
>=20
This may very well be me, but I don't get why we need to follow the
wakeup chains.

Doesn't a VMExit always happen in the thread that runs the vCPU anyway?

I mean, just by tracing 'kvm:kvm_exit', I get:

 <...>-74350 [003] 903542.374465: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74355 [012] 903542.374465: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74350 [003] 903542.374470: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74355 [012] 903542.374470: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74355 [012] 903542.374485: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74355 [012] 903542.374487: kvm_exit:             reason HLT rip 0xff=
ffffffacca465d info 0 0
 <...>-74350 [003] 903542.374488: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0
 <...>-74350 [003] 903542.374490: kvm_exit:             reason HLT rip 0xff=
ffffffacca465d info 0 0
 <...>-74341 [126] 903542.374813: kvm_exit:             reason MSR_WRITE ri=
p 0xffffffffac4757d4 info 0 0

This tells us already that 74341, 74350 and 74355 are the pids of some
vcpu threads on the host.

At this point, /proc will tell us that these are in fact vcpus of the
same VM, and which is the PID of the thread group leader that we want
to use in /sys/kernel/debug/kvm:

grep Tgid /proc/{74341,74350,74355}/status
/proc/74341/status:Tgid:        74306
/proc/74350/status:Tgid:        74306
/proc/74355/status:Tgid:        74306

ls /sys/kernel/debug/kvm/
74306-19

What am I missing?

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-PD/uQG60RlU/zlsxyfbA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCUioUACgkQFkJ4iaW4
c+7LGw//T7oVwGkmI6YQppKYSEM43d/6cTn4IkMmbEHOHJzO9zkB9ZcfGIQQ2CPR
Z0jzlHGSEjcnbwlqDhdVJ3SlF7J3BuAIiwSa9U/M2tskf5U2bgG7Qa80ErxzOqSB
xg2OozTapmEDoxfSjimOYXa9oVgE/5PdmyZjCYH32ROtjy/5xyFG5vK+jO0s+56D
08O2V1v868hkSdJ8Zh5pqGEbVxG0Mye14DJT9p02ihV7oYqFFI6juHZKt6AJuKtT
no8rPYXV+dSXuYzb6JwdsrO7uCZB8PDZE+0qtVISdIcbWGnqLioOgMM/7BlwA84w
OlfYleufZjU3bQvohQwHzY0+Xht6guKkmfPmn8OqvhaTWnFcea0Sq9kIx9yEJI/0
o1+5n6zAzUMZxC/odpYNFeJxCSIAge88fekuhih6HQCjzR818cktCnI3Gn+VJdE5
fTEhjUC4D+4hag3eZLsLOy1vg3J/FQ14KPWW/fWeOQQ+O8EpIlaWdCycfbLA0mz/
sv+CL6vWwlgwvnmS5uwqYaKVMnohQHJp4JOzJkpYLBbGLgOvcYcJNIvkmdhzs3fa
YhJrV6P/ObbuiR/Hbf2ImCIfAqblElE4tdTbIqOG18U/dYl8OM2u6CTgMbOP+/6q
av1/ogxxRhLCBmBUg9wCLo+7sJkWJPfjNHZCwrlZvBocZ+5R83g=
=TLEu
-----END PGP SIGNATURE-----

--=-PD/uQG60RlU/zlsxyfbA--

