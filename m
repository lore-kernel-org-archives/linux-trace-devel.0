Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39B9C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 15:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6264EBD
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 15:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhBIP3w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 10:29:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:57868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231995AbhBIP3p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 10:29:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612884537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wxtCXvTMGD/0rul5BFWXtNtOKixnwhDtYhD4mxei3Nw=;
        b=CZiWnwvLgWAqYMiisNULZmhOqpxXQ+fxLJRRUotCG2XjOJeT3yNROfpczky0JLIrTJHPz7
        cHNyp6sK0vmbhf6xuqMKlpb9x+OUmU0Fe0qywLEx4aC5YI6RlglBS2GhTpXKhiNV1IKA74
        hLn7s9r5a2uDyiVf64r8ITPtIDcnJr4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 933B0AD62;
        Tue,  9 Feb 2021 15:28:57 +0000 (UTC)
Message-ID: <56a35d33639ef7668678fd7f87dab995b2d6a3a7.camel@suse.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Date:   Tue, 09 Feb 2021 16:28:56 +0100
In-Reply-To: <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
         <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
         <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
         <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
         <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
         <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
         <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
         <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tNs48KFvMLsr1XGZaM/1"
User-Agent: Evolution 3.38.3 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


--=-tNs48KFvMLsr1XGZaM/1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-02-09 at 15:00 +0200, Tzvetomir Stoyanov wrote:
> On Tue, Feb 9, 2021 at 2:24 PM Dario Faggioli <dfaggioli@suse.com>
> wrote:
> >=20
> > So, the timestamps seems still a bit apart to me. Is this fine, and
> > hence there is some more post-processing that I should do (and, if
> > yes,
> > what?). Or should they be already in sync?
>=20
> The timestamps, recorded in both files are not synchronised. That's
> why you are seeing the original timestamps. The offsets between both
> clocks are recorded in the metadata of the guest trace file.=C2=A0
>
Ah, sure! So I was right about me being missing something: I was
missing this. :-)

> You can verify
> this using "trace-cmd dump --options trace-guest.dat" and
> "trace-cmd dump --options trace.dat"
> When both files are opened together, then that metadata is used to
> align
> guest's timestamps to the host time.
>
Right.

>  Currently trace-cmd report does not
> have support for opening more trace files as a session, yet. This is
> in our
> short todo list.
>=20
Ok, is there a WiP already, or someone working on it? I'm asking
because maybe I can help.

In fact, I am helping some University students with their theses, and
I'm planning to have them doing something in the area of virtualization
tracing. In fact, I will have quite a few other questions in the
upcoming days (hoping you guys don't mind)... But, IAC, something like
this could be a place from where to start.

>=20
> Currently using KernelShark2-beta is the only way to display host and
> guests tracing files, as a session. There is logic for synchronising
> timestamps,
> using metadata from the files. What repo are you using for getting
> the
> KernelShark2-beta ?
> Yordan can give more details on that.
>=20
Yes, I was already using the right repo (https://github.com/yordan-
karadzhov/kernel-shark-v2.beta ) but missed a rebase/update. And in
fact, Yordan pointed me to it, and know things are a lot better (still
not perfect, but that's for the other thread).

> > "Negotiated ptp time sync protocol with guest (null)"
>=20
> That "null" really bothers me, as I cannot reproduce it. The logic
> for
> getting the
> guest name, cid and port uses "/proc/<qemu pid>/cmdline". Please, can
> you send
> me that string, from /proc/...=C2=A0
>
Sure. Brace yourself, though. It's a qemu command line, and you know
that qemu command line are, well, a bit long ;-P

/usr/bin/qemu-system-x86_64-nameguest=3Dtumbleweed-jeos,debug-threads=3Don-
S-
objectsecret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/doma=
in
-1-tumbleweed-jeos/master-key.aes-machinepc-q35-
5.2,accel=3Dkvm,usb=3Doff,dump-guest-core=3Doff,memory-backend=3Dpc.ram-
cpuSkylake-Server-IBRS,ss=3Don,vmx=3Don,pdcm=3Don,hypervisor=3Don,tsc-
adjust=3Don,clflushopt=3Don,umip=3Don,md-clear=3Don,stibp=3Don,arch-
capabilities=3Don,ssbd=3Don,xsaves=3Don,ibpb=3Don,amd-stibp=3Don,amd-
ssbd=3Don,pschange-mc-no=3Don,pku=3Doff-m4096-objectmemory-backend-
ram,id=3Dpc.ram,size=3D4294967296-overcommitmem-lock=3Doff-
smp1,sockets=3D1,cores=3D1,threads=3D1-uuid57a61f7b-506e-49d8-a8d7-
63b5baae8534-no-user-config-nodefaults-
chardevsocket,id=3Dcharmonitor,fd=3D29,server,nowait-
monchardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol-
rtcbase=3Dutc,driftfix=3Dslew-globalkvm-pit.lost_tick_policy=3Ddelay-no-hpe=
t-
no-shutdown-globalICH9-LPC.disable_s3=3D1-globalICH9-LPC.disable_s4=3D1-
bootstrict=3Don-devicepcie-root-
port,port=3D0x10,chassis=3D1,id=3Dpci.1,bus=3Dpcie.0,multifunction=3Don,add=
r=3D0x2-
devicepcie-root-
port,port=3D0x11,chassis=3D2,id=3Dpci.2,bus=3Dpcie.0,addr=3D0x2.0x1-devicep=
cie-
root-port,port=3D0x12,chassis=3D3,id=3Dpci.3,bus=3Dpcie.0,addr=3D0x2.0x2-
devicepcie-root-
port,port=3D0x13,chassis=3D4,id=3Dpci.4,bus=3Dpcie.0,addr=3D0x2.0x3-devicep=
cie-
root-port,port=3D0x14,chassis=3D5,id=3Dpci.5,bus=3Dpcie.0,addr=3D0x2.0x4-
devicepcie-root-
port,port=3D0x15,chassis=3D6,id=3Dpci.6,bus=3Dpcie.0,addr=3D0x2.0x5-devicep=
cie-
root-port,port=3D0x16,chassis=3D7,id=3Dpci.7,bus=3Dpcie.0,addr=3D0x2.0x6-
deviceqemu-xhci,p2=3D15,p3=3D15,id=3Dusb,bus=3Dpci.2,addr=3D0x0-devicevirti=
o-
serial-pci,id=3Dvirtio-serial0,bus=3Dpci.3,addr=3D0x0-
blockdev{"driver":"file","filename":"/var/lib/libvirt/images/openSUSE-
Tumbleweed-JeOS.x86_64-15.1.0-kvm-and-xen-
Snapshot20210205.qcow2","node-name":"libvirt-1-storage","auto-read-
only":true,"discard":"unmap"}-blockdev{"node-name":"libvirt-1-
format","read-only":false,"driver":"qcow2","file":"libvirt-1-
storage","backing":null}-devicevirtio-blk-
pci,bus=3Dpci.4,addr=3D0x0,drive=3Dlibvirt-1-format,id=3Dvirtio-
disk0,bootindex=3D1-netdevtap,fd=3D31,id=3Dhostnet0,vhost=3Don,vhostfd=3D32=
-
devicevirtio-net-
pci,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:77:d6:ea,bus=3Dpci.1,addr=3D=
0x0-
chardevpty,id=3Dcharserial0-deviceisa-
serial,chardev=3Dcharserial0,id=3Dserial0-
chardevsocket,id=3Dcharchannel0,fd=3D33,server,nowait-
devicevirtserialport,bus=3Dvirtio-
serial0.0,nr=3D1,chardev=3Dcharchannel0,id=3Dchannel0,name=3Dorg.qemu.guest=
_age
nt.0-deviceusb-tablet,id=3Dinput0,bus=3Dusb.0,port=3D1-
spiceport=3D5900,addr=3D0.0.0.0,disable-ticketing,seamless-migration=3Don-
deviceqxl-
vga,id=3Dvideo0,ram_size=3D67108864,vram_size=3D67108864,vram64_size_mb=3D0=
,vga
mem_mb=3D16,max_outputs=3D1,bus=3Dpcie.0,addr=3D0x1-devicevirtio-balloon-
pci,id=3Dballoon0,bus=3Dpci.5,addr=3D0x0-objectrng-
random,id=3Dobjrng0,filename=3D/dev/urandom-devicevirtio-rng-
pci,rng=3Dobjrng0,id=3Drng0,bus=3Dpci.6,addr=3D0x0-
sandboxon,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcecon=
tr
ol=3Ddeny-devicevhost-vsock-pci,id=3Dvsock0,guest-
cid=3D3,vhostfd=3D26,bus=3Dpci.7,addr=3D0x0-msgtimestamp=3Dontoolbox-dario

> or just "ps afx | grep qemu",=C2=A0
>
Also a mess. But here you go:

# ps afx | grep qemu
12952 ?        S      0:00  |   |   \_ ssh -l root -T -e none --
192.168.0.31 sh -c 'which virt-ssh-helper 1>/dev/null 2>&1; if test $?
=3D 0; then     virt-ssh-helper 'qemu:///system'; else    if 'nc' -q 2>&1
| grep "requires an argument" >/dev/null 2>&1; then ARG=3D-q0;else
ARG=3D;fi;'nc' $ARG -U /var/run/libvirt/libvirt-sock; fi'
 8758 pts/9    S+     0:00  |   |   |               \_ grep --
color=3Dauto qemu
 9168 ?        Sl   224:55  |   \_ /usr/bin/qemu-system-x86_64 -name
guest=3Dtumbleweed-jeos,debug-threads=3Don -S -object
secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/domain-1-
tumbleweed-jeos/master-key.aes -machine pc-q35-
5.2,accel=3Dkvm,usb=3Doff,dump-guest-core=3Doff,memory-backend=3Dpc.ram -cp=
u
Skylake-Server-IBRS,ss=3Don,vmx=3Don,pdcm=3Don,hypervisor=3Don,tsc-
adjust=3Don,clflushopt=3Don,umip=3Don,md-clear=3Don,stibp=3Don,arch-
capabilities=3Don,ssbd=3Don,xsaves=3Don,ibpb=3Don,amd-stibp=3Don,amd-
ssbd=3Don,pschange-mc-no=3Don,pku=3Doff -m 4096 -object memory-backend-
ram,id=3Dpc.ram,size=3D4294967296 -overcommit mem-lock=3Doff -smp
1,sockets=3D1,cores=3D1,threads=3D1 -uuid 57a61f7b-506e-49d8-a8d7-
63b5baae8534 -no-user-config -nodefaults -chardev
socket,id=3Dcharmonitor,fd=3D29,server,nowait -mon
chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol -rtc base=3Dutc,driftfix=
=3Dslew
-global kvm-pit.lost_tick_policy=3Ddelay -no-hpet -no-shutdown -global
ICH9-LPC.disable_s3=3D1 -global ICH9-LPC.disable_s4=3D1 -boot strict=3Don -
device pcie-root-
port,port=3D0x10,chassis=3D1,id=3Dpci.1,bus=3Dpcie.0,multifunction=3Don,add=
r=3D0x2
-device pcie-root-
port,port=3D0x11,chassis=3D2,id=3Dpci.2,bus=3Dpcie.0,addr=3D0x2.0x1 -device=
 pcie-
root-port,port=3D0x12,chassis=3D3,id=3Dpci.3,bus=3Dpcie.0,addr=3D0x2.0x2 -d=
evice
pcie-root-port,port=3D0x13,chassis=3D4,id=3Dpci.4,bus=3Dpcie.0,addr=3D0x2.0=
x3 -
device pcie-root-
port,port=3D0x14,chassis=3D5,id=3Dpci.5,bus=3Dpcie.0,addr=3D0x2.0x4 -device=
 pcie-
root-port,port=3D0x15,chassis=3D6,id=3Dpci.6,bus=3Dpcie.0,addr=3D0x2.0x5 -d=
evice
pcie-root-port,port=3D0x16,chassis=3D7,id=3Dpci.7,bus=3Dpcie.0,addr=3D0x2.0=
x6 -
device qemu-xhci,p2=3D15,p3=3D15,id=3Dusb,bus=3Dpci.2,addr=3D0x0 -device vi=
rtio-
serial-pci,id=3Dvirtio-serial0,bus=3Dpci.3,addr=3D0x0 -blockdev
{"driver":"file","filename":"/var/lib/libvirt/images/openSUSE-
Tumbleweed-JeOS.x86_64-15.1.0-kvm-and-xen-
Snapshot20210205.qcow2","node-name":"libvirt-1-storage","auto-read-
only":true,"discard":"unmap"} -blockdev {"node-name":"libvirt-1-
format","read-only":false,"driver":"qcow2","file":"libvirt-1-
storage","backing":null} -device virtio-blk-
pci,bus=3Dpci.4,addr=3D0x0,drive=3Dlibvirt-1-format,id=3Dvirtio-
disk0,bootindex=3D1 -netdev tap,fd=3D31,id=3Dhostnet0,vhost=3Don,vhostfd=3D=
32 -
device virtio-net-
pci,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:77:d6:ea,bus=3Dpci.1,addr=3D=
0x0 -
chardev pty,id=3Dcharserial0 -device isa-
serial,chardev=3Dcharserial0,id=3Dserial0 -chardev
socket,id=3Dcharchannel0,fd=3D33,server,nowait -device
virtserialport,bus=3Dvirtio-
serial0.0,nr=3D1,chardev=3Dcharchannel0,id=3Dchannel0,name=3Dorg.qemu.guest=
_age
nt.0 -device usb-tablet,id=3Dinput0,bus=3Dusb.0,port=3D1 -spice
port=3D5900,addr=3D0.0.0.0,disable-ticketing,seamless-migration=3Don -devic=
e
qxl-
vga,id=3Dvideo0,ram_size=3D67108864,vram_size=3D67108864,vram64_size_mb=3D0=
,vga
mem_mb=3D16,max_outputs=3D1,bus=3Dpcie.0,addr=3D0x1 -device virtio-balloon-
pci,id=3Dballoon0,bus=3Dpci.5,addr=3D0x0 -object rng-
random,id=3Dobjrng0,filename=3D/dev/urandom -device virtio-rng-
pci,rng=3Dobjrng0,id=3Drng0,bus=3Dpci.6,addr=3D0x0 -sandbox
on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcecontrol=3D=
deny
-device vhost-vsock-pci,id=3Dvsock0,guest-
cid=3D3,vhostfd=3D26,bus=3Dpci.7,addr=3D0x0 -msg timestamp=3Don

It's a bit of an unusual setup, as the VM (and hence QEMU too) is
running inside a podman container. But it seems the info you're after
is indeed present on the commandline.

> to see
> what is wrong with
> our parsing logic.
> Also, if you have any ideas how to get name, cid and port of running
> libvirt VMs -
> please share. The current approach parsing the qemu command line is a
> work
> around, not a final solution.
>=20
Mmm... not sure. I'll have a look at the code where you go and fetch
it, and see if anything comes to mind.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-tNs48KFvMLsr1XGZaM/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmAiqjgACgkQFkJ4iaW4
c+7tJw//cPNLRPd9EXr7kYlv+ws1I9SICvLj+4xg4SqLCLiZfWnGqGLyV8lHBzCW
pEv0p1Pprt8nK3BvAgC/4YbXIi1c2KxjWziX4j05utHkNaIKNoKjggy0bkI3AIJO
SmNAeNSTFVUZC3iar2Rj8GvvZfvDR8pI1hTNEGn1wk69fyczJ5EM6bb5cuRpqmH5
J2pIUc/9tV4xwNmh/0vyqah6AISfTG95gFeujeP2G8AGd8noZO+4pObATplR8UJ2
A5QsKThwqFaMlmJrFCiWWB02Jno6axbkQr5s73FI06icy64Vup+WP7T7qz90Ebn5
X6MFK+46BBzPKGpLIg3XUGg7JaTIPwFu3EmvK4M6n3ZTxcRANnYNjYGJMJJQMJeX
Ld2Dd224qBHR52ckNPEr1+V04Q2nVeL7HbRbsay8Q3Ik+YjOcFEIs7IPcq/9nhtV
D2fVywcSoirX5brGCafRSYNPRwmWRopGrH2iMvwYoeYb6z+ole9iE4i1LsqCn6Ln
xWN3YB8/BHuH24Er/fOTWTo6+WxJwaM8VQtmQfsV9j7rrws/PobSuNOK01AheevG
Q5rbi2A400AKlniQpfZYRrjxBeP0cBsRq/oU3KJb0icP9oZ+yln5jZRN6NOJQuhn
R0/0UP9B9G4WrW2u5TXYLbtA74D3fDwEjbsblEufvza+0DSupYo=
=tkHp
-----END PGP SIGNATURE-----

--=-tNs48KFvMLsr1XGZaM/1--

