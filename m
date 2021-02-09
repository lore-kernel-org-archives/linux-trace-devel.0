Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43439C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 12:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E6764EBA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 12:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhBIMZQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:25:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:60118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhBIMZO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 07:25:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612873466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a28HJ+OIjcxeq9WQHH/sBmAAuA4qRkNrkNBCZhAYYAk=;
        b=PGguu+Jw+P3/HJi326qhRbefQ2G9bOScX4A/MRGVYZdpAtG81aJrngcem0jah4HM+jfoYJ
        kEBNwjdti1RrdpBo38owMtNWCi2+3zHGjBVplVRYHrKObJCT5eoI1ZEYq//cLlKdDzaS4E
        e1gv11s1KuO+itBrzC6KsHeV9JxswNk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 39605B112;
        Tue,  9 Feb 2021 12:24:26 +0000 (UTC)
Message-ID: <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 09 Feb 2021 13:24:23 +0100
In-Reply-To: <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
         <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
         <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
         <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MXryG2Nk+ztHsP30oOK+"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-MXryG2Nk+ztHsP30oOK+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 13:44 +0200, Tzvetomir Stoyanov wrote:
> Hi Dario,
>=20
Hi again,

> On Tue, Feb 9, 2021 at 9:28 AM Dario Faggioli <dfaggioli@suse.com>
> wrote:
> >=20
> > Or at least, host and guest talk, and I see this: "Negotiated kvm
> > time
> > sync protocol with guest (null)" (is that "(null)" ok/intentional?
> > I
> > guess I can check the code... :-))
>=20
> That null looks like an error, the name of the guest VM should be
> printed there.
>
Yep, in fact, as I said, I tired this before and --now that I think
about it-- I do remember that the guest "name" was what was there.

BTW, if I can pester you a little bit more, now that it works I'm
trying to use this, and here's what I'm doing.

=3D=3D VM:
# echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksour=
ce
# echo x86-tsc > /sys/kernel/tracing/trace_clock
# trace-cmd agent

=3D=3D Host:
# echo x86-tsc > /sys/kernel/tracing/trace_clock
# trace-cmd record -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumblewe=
ed-jeos:823 -e sched:* -e syscalls:*_clock_nanosleep -e timer:hrtimer* slee=
p 1

And I do end up with the two files: trace.dat for the host and trace-
(null).dat (oh, well :-D) for the guest.

Now, just `trace-cmd report`-ing them, I get this (just some small
fragments, of course).

=3D=3D Host (trace.dat):
           <...>-24791 [001]308219686938467: sched_switch:         prev_com=
m=3Dsleep prev_pid=3D24791 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=
=3Dswapper/1 next_pid=3D0 next_prio=3D120
          <idle>-0     [001]308219691836595: hrtimer_cancel:       hrtimer=
=3D0xffff96694faec710
          <idle>-0     [001]308219691837544: hrtimer_expire_entry: hrtimer=
=3D0xffff96694faec710 function=3Dapic_timer_fn now=3D76856318840891
          <idle>-0     [001]308219691840271: sched_waking:         comm=3DC=
PU 0/KVM pid=3D9196 prio=3D120 target_cpu=3D001
          <idle>-0     [001]308219691849474: sched_wakeup:         comm=3DC=
PU 0/KVM pid=3D9196 prio=3D120 target_cpu=3D001
          <idle>-0     [001]308219691850914: hrtimer_expire_exit:  hrtimer=
=3D0xffff96694faec710
          <idle>-0     [001]308219691856548: sched_switch:         prev_com=
m=3Dswapper/1 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=
=3DCPU 0/KVM next_pid=3D9196 next_prio=3D120
       CPU 0/KVM-9196  [001]308219691876512: kvm_vcpu_wakeup:      wait tim=
e 2352265 ns, polling valid
       CPU 0/KVM-9196  [001]308219691880170: kvm_apic_accept_irq:  apicid 0=
 vec 236 (Fixed|edge)
       CPU 0/KVM-9196  [001]308219691884210: kvm_pv_tlb_flush:     vcpu 0 n=
eed_flush_tlb false


 =3D=3D Guest (trace-(null).dat):
           <...>-12068 [000]118613084443085: sched_stat_runtime:   comm=3Dt=
race-cmd pid=3D12068 runtime=3D97403 [ns] vruntime=3D5101562006274 [ns]
           <...>-12068 [000]118613084451479: sched_switch:         prev_com=
m=3Dtrace-cmd prev_pid=3D12068 prev_prio=3D120 prev_state=3DS =3D=3D> next_=
comm=3Dtrace-cmd next_pid=3D12070 next_prio=3D120
           <...>-12070 [000]118613084662730: sched_stat_runtime:   comm=3Dt=
race-cmd pid=3D12070 runtime=3D55912 [ns] vruntime=3D5101564964781 [ns]
           <...>-12070 [000]118613084665219: sched_switch:         prev_com=
m=3Dtrace-cmd prev_pid=3D12070 prev_prio=3D120 prev_state=3DS =3D=3D> next_=
comm=3Dswapper/0 next_pid=3D0 next_prio=3D120
          <idle>-0     [000]118613085002791: sched_waking:         comm=3Dk=
worker/0:0 pid=3D10458 prio=3D120 target_cpu=3D000
          <idle>-0     [000]118613085006567: sched_wakeup:         comm=3Dk=
worker/0:0 pid=3D10458 prio=3D120 target_cpu=3D000
          <idle>-0     [000]118613085011740: sched_switch:         prev_com=
m=3Dswapper/0 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=
=3Dkworker/0:0 next_pid=3D10458 next_prio=3D120
     kworker/0:0-10458 [000]118613085023034: sched_waking:         comm=3Dt=
race-cmd pid=3D12070 prio=3D120 target_cpu=3D000
     kworker/0:0-10458 [000]118613085023774: sched_stat_runtime:   comm=3Dk=
worker/0:0 pid=3D10458 runtime=3D4848 [ns] vruntime=3D5101561969629 [ns]
     kworker/0:0-10458 [000]118613085025356: sched_wakeup:         comm=3Dt=
race-cmd pid=3D12070 prio=3D120 target_cpu=3D000

So, the timestamps seems still a bit apart to me. Is this fine, and
hence there is some more post-processing that I should do (and, if yes,
what?). Or should they be already in sync?

I've also tried to open trace.dat in kernelshark2, and then append
trace-(null).dat but from the few that I see (as said in my other
email, kernelshark2 is not fully functional for me) the events from the
two traces are still completely separated.

I also tried with the following, but it's still the same:
# echo kvm-clock > /sys/devices/[...]/current_clocksource in the guest

Then, I've removed the last patch of the series, the one for "KVM
clock", after which, I was correctly (I think) seeing:

"Negotiated ptp time sync protocol with guest (null)"

But then again:

=3D=3D Host:
       CPU 0/KVM-9196  [001]249509851092735: kvm_exit:             vcpu 0 r=
eason PREEMPTION_TIMER rip 0x7f0da050b357 info1 0x0000000000000000 info2 0x=
0000000000000000 intr_info 0x00000000 error_code 0x00000000
       CPU 0/KVM-9196  [001]249509851096316: kvm_apic_accept_irq:  apicid 0=
 vec 236 (Fixed|edge)
       CPU 0/KVM-9196  [001]249509851112525: kvm_exit:             vcpu 0 r=
eason MSR_WRITE rip 0xffffffffac475164 info1 0x0000000000000000 info2 0x000=
0000000000000 intr_info 0x00000000 error_code 0x00000000
       CPU 0/KVM-9196  [001]249509851114034: kvm_hv_timer_state:   vcpu_id =
0 hv_timer 1
       CPU 0/KVM-9196  [001]249509851115032: kvm_msr:              msr_writ=
e 6e0 =3D 0x367b512478b0
           sleep-26457 [000]249509851765258: sched_process_exec:   filename=
=3D/usr/bin/sleep pid=3D26457 old_pid=3D26457
       CPU 0/KVM-9196  [001]249509853247850: kvm_exit:             vcpu 0 r=
eason EXTERNAL_INTERRUPT rip 0xffffffffad00015d info1 0x0000000000000000 in=
fo2 0x0000000000000000 intr_info 0x800000ec error_code 0x00000000
       CPU 0/KVM-9196  [001]249509853250399: hrtimer_cancel:       hrtimer=
=3D0xffff96709fc61980

=3D=3D Guest:
           <...>-12891 [000]125778006088605: sched_stat_runtime:   comm=3Dt=
race-cmd pid=3D12891 runtime=3D84358 [ns] vruntime=3D5110265291610 [ns]
           <...>-12891 [000]125778006095698: sched_switch:         prev_com=
m=3Dtrace-cmd prev_pid=3D12891 prev_prio=3D120 prev_state=3DS =3D=3D> next_=
comm=3Dtrace-cmd next_pid=3D12893 next_prio=3D120
           <...>-12893 [000]125778006320003: sched_stat_runtime:   comm=3Dt=
race-cmd pid=3D12893 runtime=3D58448 [ns] vruntime=3D5110268246764 [ns]
           <...>-12893 [000]125778006322729: sched_switch:         prev_com=
m=3Dtrace-cmd prev_pid=3D12893 prev_prio=3D120 prev_state=3DS =3D=3D> next_=
comm=3Dswapper/0 next_pid=3D0 next_prio=3D120
          <idle>-0     [000]125778021774505: hrtimer_cancel:       hrtimer=
=3D0xffff99d67bc21980
          <idle>-0     [000]125778021776481: hrtimer_expire_entry: hrtimer=
=3D0xffff99d67bc21980 function=3Dtick_sched_timer now=3D31370890644808
          <idle>-0     [000]125778021782895: hrtimer_expire_exit:  hrtimer=
=3D0xffff99d67bc21980

So, what am I missing? :-)

And, of course, thanks a lot again!
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-MXryG2Nk+ztHsP30oOK+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAifvcACgkQFkJ4iaW4
c+4nHg//fPSJ2Rm4CuK3yU+V6nk6S5d8BezeZYmUSuuQT1kv7L3OIx/DEETpBVJM
BAJh1Eb8r2KyriOkF37fY+w3eeOjBXCuUjnswVFPysXoqRws2YwPafI++tTScKSk
GJTT+6mCTPFfWh/d8IIt4sayXM0iksISvlSgSUmQMG14ElDyd2jCM7DYunvuzV16
jXSdiMVUB50zjOCIOBwJxo8Lfp7tBwAFzukh7t+LNo7bvwIvTrKOA30mus2eDNEx
6WYcA0+828u3Z3gJVGokP+hn0RVnF6FPk7tw5bIiHlD1siNLEVgVQr+i46zQmFIr
3R9NFFAXO6Q4vdOHYpHqmdw0VmEvOQH1WDiiBlLTKcCcfge7IvBemmeCsU7tnX7m
QmibHAI4GVksqpBhk4PpCk0Wtri2gf+m03JoxD4MHFH4gUvvQtraIKjbtQoVJ6sA
1T4iCtW3/NMkwOP9EdHpYnA+5YGYzzYabJh5qFaWqotIfif5laOrCvT40w4nJHQr
tZLbsNfcXMos+6t1cheRohnMC4qTXMDfXctPZls5wydDbWJmhILo9CgDkfT9EOw0
yFzjhLBA35ByjaVbKDv0SsxQDv4FuyxwLjgyBRdFJLzdeL6W4jKNE+V0w1X93tU7
TnqSZMq5HFCBo+8Yp7U2SMnsUB6NvY7AsNsKgXPBd1hNfvBn39Q=
=9yA+
-----END PGP SIGNATURE-----

--=-MXryG2Nk+ztHsP30oOK+--

