Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4783BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 16:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EE061158
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 16:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbhDZQL2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:11:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:47074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZQL1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 12:11:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619453445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aJbchuIpsdPYw7zPUFw/ZYXSwofmdM2RyMq4LfZD1eQ=;
        b=dQa5ldu6lEBJCxmgYHj7ZqzWeg209ejLKENjTOqjLBl+okMS880/zWvoh+NLmyjDxoz5hu
        UCFLLodxvRQH/qImqNZgJXu+M84U+SyXJILoKvNXlMfZ8sBwLbmkGaTprPZ3OajpR+fz+Q
        f9Mlaw/f/zw58kR2ifnbQHBdyLCuz6k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 054ABABB1;
        Mon, 26 Apr 2021 16:10:45 +0000 (UTC)
Message-ID: <9c7968f1bc98a12754ea129906e727b9c344f06c.camel@suse.com>
Subject: Re: Instructions for clock sync for tracing host/guest
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Mon, 26 Apr 2021 18:10:43 +0200
In-Reply-To: <20210426115014.34db8808@gandalf.local.home>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
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
         <f7b417bf1604145b216156036d06f93585f7316d.camel@suse.com>
         <20210426115014.34db8808@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IOu5+4GXd5W1ro7Bs/N9"
User-Agent: Evolution 3.40.0 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-IOu5+4GXd5W1ro7Bs/N9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-04-26 at 11:50 -0400, Steven Rostedt wrote:
> On Mon, 26 Apr 2021 17:38:09 +0200
> Dario Faggioli <dfaggioli@suse.com> wrote:
> >=20
> > With the PID of the creating process you can tell (e.g., still from
> > /proc) the number of the vm-fd, and we have everything to reach TSC
> > offsets in debugfs... Isn't that so?
>=20
> I'm not sure what you mean here.
>=20
So:

ps -eT |grep "CPU 0/KVM"
  PID  SPID TTY          TIME CMD
 7037  7050 ?        00:26:31 CPU 0/KVM

That's vCPU 0's host task. It's a thread whose host PID is 7050. With
trace_cmd, you'll see kvm_enter events happening in task 7050, so
that's indeed a really good way to retrieve such PID.

The process that created this vCPU thread is 7037, which in my case is
in fact QEMU:

ps aux |grep 7037
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
qemu      7037  336 17.8 63578168 11647320 ?   Sl   Apr26 1489:18 /usr/bin/=
qemu-system-x86_64 -name guest=3Dvm-kvm...

This QEMU process (7037) is the one that created the VM itself, with
the appropriate ioctl, which returned to it the VM-fd:

ls -lR /proc/7037/fd/*|grep kvm-vm
lrwx------ 1 qemu qemu 64 Apr 26 22:01 /proc/7037/fd/14 -> anon_inode:kvm-v=
m

So, in this case, it's fd 14. And, in fact, in debugfs, we have:

ls /sys/kernel/debug/kvm/ -l                                         =20
drwxr-xr-x 34 root root 0 Apr 26 16:41 7037-14

Hope is clearer (and ideally even useful :-P)

Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-IOu5+4GXd5W1ro7Bs/N9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCG5gMACgkQFkJ4iaW4
c+7tGhAA77vNRBLg1LxANiyNPhxf7J/TTkTOogFB7Joc9yby5Qp4/7d6K9CMLxtM
ArpRGghWcv+YRIXWpNVjPzDZZ95AIFZXQ/EMfIKcU9lYxlARcee1Z7IP96PGZ3CV
0WFt745uAgFulJkiUcRKvolC/H5ySX/qIbXCNNAUh/6DPJr3DIDYEOXaPpEH1BuC
P4TY7dVWaYuCFSNPTDJ7Q/MeMGs3Yb0HyTofXIeFyvrME+pQ5KIGEPkClihvAIQh
rNrNs9StEv9hIL1F/wd2v1XvWT4lbUTxJMGyK7v0W3qhsQXsCNnVTLrzHMJcXtkG
ZyFMbR/Iwjb9L9zO19qLyDBs8QbYk5IVthXpXKa9booZEwxUf7QEtbTniuPapO1B
9aJReEzNFUI9dd0aUNfQ/U+0/vCM9sn5LOOYdj6vZ/HBTSPYtmhvPYq2y3nBO5AZ
/1u1MZ1B3mPs00QSKxthpr8JmHcD0FGiBlpfXGwzPkj8XRFjE3txNRCgCjKnJOCb
RxWwECFXvGGez3RdYBKNK9INmnJsouPNlBX+J+FOXLXvabHT0WPt2E4YSaVq4+Ye
fBfVYvmTMqpa5/x99zGfm4HBJIfs29GDOxYJr6AoTVd0sv0dWgqdoqoHuXQdpbWD
1PYvOxwBFV8rqKylGNF1UdM3Fzi1gYrYPB2wcB589kjwgM1OiFc=
=w7fN
-----END PGP SIGNATURE-----

--=-IOu5+4GXd5W1ro7Bs/N9--

