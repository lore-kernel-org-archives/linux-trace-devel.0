Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DCCC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7655164EB8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhBIFdq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 00:33:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:37366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhBIFdp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 00:33:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612848778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gI16Pg9Np2k691OraOnMzCvr3hGnjQl2YjyVQ4Pu1QM=;
        b=pmC1hxm1l/D7k7XmvJdeANDzXNg14vUu50JRB4epkS+/8AISRsWtYMBBSIOwqs3zbhLdal
        qhdEXMlU12iLpWE7x8Z4fwvEHkSwaLs7b9k+OL6YQ7TkUaE8Ucpt/JqIp57iXwRGwUJ6HR
        s0HaTBuG9zZsCYmnqEVDfZZSNdF9lp0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7CBCCAD8C;
        Tue,  9 Feb 2021 05:32:58 +0000 (UTC)
Message-ID: <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Date:   Tue, 09 Feb 2021 06:32:57 +0100
In-Reply-To: <20210208061743.510964-1-tz.stoyanov@gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-IFnnoGrle9p5pwDRYi+M"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-IFnnoGrle9p5pwDRYi+M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, 2021-02-08 at 08:17 +0200, Tzvetomir Stoyanov (VMware) wrote:
> Basic infrastructure for host - guest timestamp synchronization and a
> PoC implementation of PTP-like and KVM algorithms.=20
>=20
I'm trying to play with trace-cmd agent & clock syncronization, so I
applied this series.

However, when I try to connect to a VM where I have the agent running,
I'm seeing this (on the host):

# ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:h=
rtimer* -A tumbleweed-jeos:8888 -e all sleep 1
trace-cmd: No such file or directory
  Failed to receive trace response -107

I tried to do a strace, still on the host, and this is what I see (the
last part of the output):

rt_sigaction(SIGINT, {sa_handler=3D0x4116a5, sa_mask=3D[INT], sa_flags=3DSA=
_RESTORER|SA_RESTART, sa_restorer=3D0x7f29f1b55b70}, {sa_handler=3DSIG_DFL,=
 sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
openat(AT_FDCWD, "/var/lib/trace-cmd/virt/(null)/trace-pipe-cpu0.out", O_RD=
ONLY|O_NONBLOCK) =3D -1 ENOENT (No such file or directory)
socket(AF_VSOCK, SOCK_STREAM, 0)        =3D 4
connect(4, {sa_family=3DAF_VSOCK, sa_data=3D"\0\0\270\"\0\0\3\0\0\0\0\0\0\0=
"}, 16) =3D 0
openat(AT_FDCWD, "/sys/kernel/debug/tracing/trace_clock", O_RDONLY) =3D 6
read(6, "local global counter uptime perf"..., 8192) =3D 62
read(6, "", 8192)                       =3D 0
close(6)                                =3D 0
write(4, "\0\0\0<\0\0\0\6\0\0\0\20\0\0\0\0\0\0\0\0\347\366+n\204\271\35\334=
", 28) =3D 28
write(4, "\0\0\0\0\0\0\0\v\0\0\0\2-e\0all\0\0\0\0\1\0\0\0\5ptp\0\0", 32) =
=3D 32
read(4, "", 12)                         =3D 0
dup(2)                                  =3D 6
fcntl(6, F_GETFL)                       =3D 0x402 (flags O_RDWR|O_APPEND)
fstat(6, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(0x88, 0x9), ...}) =3D 0
write(6, "trace-cmd: No such file or direc"..., 37trace-cmd: No such file o=
r directory
) =3D 37
close(6)                                =3D 0
write(2, "  ", 2  )                       =3D 2
write(2, "Failed to receive trace response"..., 37Failed to receive trace r=
esponse -107) =3D 37
write(2, "\n", 1
)                       =3D 1
exit_group(2)                           =3D ?
+++ exited with 2 +++

Finally, if I use `--debug` both on the host and in the VM, here's what
I get.

Guest:
# ./tracecmd/trace-cmd agent -p 8888 --debug
listening on @3:8888
msg received: 6 (TRACE_REQ) [60]
Segmentation fault

Host:
# ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:h=
rtimer* -A tumbleweed-jeos:8888 -e all sleep 1
msg send: 6 (TRACE_REQ) [60]
trace-cmd: No such file or directory
  Failed to receive trace response -107

Am I doing something wrong? :-)

If necessary, I can provide more info about my setup, or do more tests.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-IFnnoGrle9p5pwDRYi+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAiHokACgkQFkJ4iaW4
c+5BjhAAh2tC+AlrBZeJpZUUfAeXiogHWGISkGfik4IAPRywHDQs/+Wzcn1i9MOb
r/oS/SPGPBGR2KJhEMUJPuFCzToSJiYifODWbU8JicvRYYm6nlpNUYffbWs0cCBV
j7co8uW3Y4z/9SRwLI12RJqPqrOJR6J6iq65aIm5pg5qQ1+zNlLoAWOz1eUnnnBN
vnSiboMdFQ8YpWPNj5EaKxNc3HJJzcjUwBXwZaf6BZ1nnaox9lZQnXhHUGMh7MVq
NTrb9/ZfZH8TnXb63OjINCaCtEb1qO9ueezU/JCaDc0VbIHORNlB2a096bQICpo6
JKaMzVtkuV5fnbdIRFQ9qcgHyOCKXW27MOIZa+qX0wdE+wOjszM4+XEUxjDClLRJ
rlWAH9LC7o0x7fOVY7DON2aIBKF4QTwKA2JAu0/kry+maeaYzI5hB//gX0sNV3jk
+yFohLGTE6CrtHC9C3velPz/Q9opHHS4lAQkIeQMwz/GUWHE5Q9uTqI9fzSmXbu6
OWGCrTnUZOpAfhRNAgnHZh+McuB5RTAiJuk+7SZw1dt1xfy0E9IgO2v36nLfvnoC
loUoAn0plrN2KESyL26QMpzVqd2MVpuuSjq6NcrvtZSLopCFdTtMP6Olx0GEBmYd
w1jEqCBbhpI/8LO1xgZm5z+dTedoBcJwJpxbCqp0Ip9IVZTyGmg=
=TVN8
-----END PGP SIGNATURE-----

--=-IFnnoGrle9p5pwDRYi+M--

