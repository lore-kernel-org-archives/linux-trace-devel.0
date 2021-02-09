Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECA7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28B664E31
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhBIRCO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhBIRCD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 12:02:03 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CCEC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 09:01:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m6so12305006pfk.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Feb 2021 09:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N6tI45ersI+yX2d9hLuOBYMr533C+XrALL+jFKpFJhU=;
        b=DeVEq9Gc289ULEi48UI+/DOAbKrp/0W1ZAFwCytzV4FzvJ/5EmXf70QpsRVtjZioHk
         g+8L/HRPs2qEt0hzk3qaRGNji+RVQcWk96sSD/32pEjOhWt63ukxB8zPtwNgqOWmlXHd
         +KlDXDrLiKoNWxlIg6ZBXHap4uvigmVdkcBax30kP65SG7InH/npVtq1oxuK5f72lB1L
         o52qlfZazabrdkB6nGtcdRuMInTk0SPkFWjHt9C2T0+yAAmwQjVeb/w9lqXarGEMRaOF
         kPb1zODE/raRvD7EUFXBwJoEIoJsPS9oWyF2igysJPvn3Lvu8I4YeXAADYnwrzSbbn54
         kJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N6tI45ersI+yX2d9hLuOBYMr533C+XrALL+jFKpFJhU=;
        b=RmxtcdbkugX6Xq2sgMFIhwNsqgsfsPoeP8+SE589RlvJ5h4b7413jaHa9cM2lK8VZ7
         KCCYw6kTnKyit3nJzYui9Not5b6mS0HSIsIN8dAJBZi49tVjRShwSmvPbsqqEozk1i2X
         l3dmHRWaA/JWw+Oa/+nnQreTdEWXhHKIkxzuZWScKdi+IXx1Hvc9nE3YZzXLo5CYWdyT
         QatfxJLqqn+YtNBec8ASoH063Tg9m0a+1/Ad30hp8sBqPD7oSaV8IF/G+s3lV1In6uMn
         OMGiyUVpwo7Ve4bEI2AzJY05PPwY6AB4rERxJGDcrupx0sai0Bdbl9oGZr7ioUPmGZwb
         T3dA==
X-Gm-Message-State: AOAM532yu3liA7RbpodtNfX0gjymFbfeeMi0t5vNuRR4n/b8SiOxKxDr
        DPW7oaVV1kq/lkPkSGAx1yLeCqUag/axrnqtC3o=
X-Google-Smtp-Source: ABdhPJyxFh69Gtytgo+YHYSECVdX2kGwkrCAFaKeYs7acA24MWnVn82+UGex4Cqb2D9gXlb0pUmZJzecv4JT46N9NQA=
X-Received: by 2002:a63:fc58:: with SMTP id r24mr22184280pgk.307.1612890081554;
 Tue, 09 Feb 2021 09:01:21 -0800 (PST)
MIME-Version: 1.0
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
 <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com> <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
 <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
 <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com> <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
 <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com> <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
 <56a35d33639ef7668678fd7f87dab995b2d6a3a7.camel@suse.com>
In-Reply-To: <56a35d33639ef7668678fd7f87dab995b2d6a3a7.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 19:01:04 +0200
Message-ID: <CAPpZLN5wdN1V5JTbpdPZQmYx2avnxUJCcZaExGb6-yP1Ly-Ktw@mail.gmail.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 9, 2021 at 5:28 PM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Tue, 2021-02-09 at 15:00 +0200, Tzvetomir Stoyanov wrote:
> > On Tue, Feb 9, 2021 at 2:24 PM Dario Faggioli <dfaggioli@suse.com>
> > wrote:
> > >
> > > So, the timestamps seems still a bit apart to me. Is this fine, and
> > > hence there is some more post-processing that I should do (and, if
> > > yes,
> > > what?). Or should they be already in sync?
> >
> > The timestamps, recorded in both files are not synchronised. That's
> > why you are seeing the original timestamps. The offsets between both
> > clocks are recorded in the metadata of the guest trace file.
> >
> Ah, sure! So I was right about me being missing something: I was
> missing this. :-)
>
> > You can verify
> > this using "trace-cmd dump --options trace-guest.dat" and
> > "trace-cmd dump --options trace.dat"
> > When both files are opened together, then that metadata is used to
> > align
> > guest's timestamps to the host time.
> >
> Right.
>
> >  Currently trace-cmd report does not
> > have support for opening more trace files as a session, yet. This is
> > in our
> > short todo list.
> >
> Ok, is there a WiP already, or someone working on it? I'm asking
> because maybe I can help.

None is working on that yet, any help is highly appreciated :) I just
created an issue in Bugzilla  for that:
https://bugzilla.kernel.org/show_bug.cgi?id=211657

>
> In fact, I am helping some University students with their theses, and
> I'm planning to have them doing something in the area of virtualization
> tracing. In fact, I will have quite a few other questions in the
> upcoming days (hoping you guys don't mind)... But, IAC, something like
> this could be a place from where to start.
>
> >
> > Currently using KernelShark2-beta is the only way to display host and
> > guests tracing files, as a session. There is logic for synchronising
> > timestamps,
> > using metadata from the files. What repo are you using for getting
> > the
> > KernelShark2-beta ?
> > Yordan can give more details on that.
> >
> Yes, I was already using the right repo (https://github.com/yordan-
> karadzhov/kernel-shark-v2.beta ) but missed a rebase/update. And in
> fact, Yordan pointed me to it, and know things are a lot better (still
> not perfect, but that's for the other thread).
>
> > > "Negotiated ptp time sync protocol with guest (null)"
> >
> > That "null" really bothers me, as I cannot reproduce it. The logic
> > for
> > getting the
> > guest name, cid and port uses "/proc/<qemu pid>/cmdline". Please, can
> > you send
> > me that string, from /proc/...
> >
> Sure. Brace yourself, though. It's a qemu command line, and you know
> that qemu command line are, well, a bit long ;-P
>
> /usr/bin/qemu-system-x86_64-nameguest=tumbleweed-jeos,debug-threads=on-

That "-nameguest=tumbleweed-jeos" is the thing that we are looking for
while trying
to figure out the name of the quest, but looks like we should improve
our parser or
better find a more reliable way for getting that information.

> S-
> objectsecret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain
> -1-tumbleweed-jeos/master-key.aes-machinepc-q35-
> 5.2,accel=kvm,usb=off,dump-guest-core=off,memory-backend=pc.ram-
> cpuSkylake-Server-IBRS,ss=on,vmx=on,pdcm=on,hypervisor=on,tsc-
> adjust=on,clflushopt=on,umip=on,md-clear=on,stibp=on,arch-
> capabilities=on,ssbd=on,xsaves=on,ibpb=on,amd-stibp=on,amd-
> ssbd=on,pschange-mc-no=on,pku=off-m4096-objectmemory-backend-
> ram,id=pc.ram,size=4294967296-overcommitmem-lock=off-
> smp1,sockets=1,cores=1,threads=1-uuid57a61f7b-506e-49d8-a8d7-
> 63b5baae8534-no-user-config-nodefaults-
> chardevsocket,id=charmonitor,fd=29,server,nowait-
> monchardev=charmonitor,id=monitor,mode=control-
> rtcbase=utc,driftfix=slew-globalkvm-pit.lost_tick_policy=delay-no-hpet-
> no-shutdown-globalICH9-LPC.disable_s3=1-globalICH9-LPC.disable_s4=1-
> bootstrict=on-devicepcie-root-
> port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2-
> devicepcie-root-
> port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1-devicepcie-
> root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2-
> devicepcie-root-
> port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3-devicepcie-
> root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4-
> devicepcie-root-
> port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5-devicepcie-
> root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6-
> deviceqemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0-devicevirtio-
> serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0-
> blockdev{"driver":"file","filename":"/var/lib/libvirt/images/openSUSE-
> Tumbleweed-JeOS.x86_64-15.1.0-kvm-and-xen-
> Snapshot20210205.qcow2","node-name":"libvirt-1-storage","auto-read-
> only":true,"discard":"unmap"}-blockdev{"node-name":"libvirt-1-
> format","read-only":false,"driver":"qcow2","file":"libvirt-1-
> storage","backing":null}-devicevirtio-blk-
> pci,bus=pci.4,addr=0x0,drive=libvirt-1-format,id=virtio-
> disk0,bootindex=1-netdevtap,fd=31,id=hostnet0,vhost=on,vhostfd=32-
> devicevirtio-net-
> pci,netdev=hostnet0,id=net0,mac=52:54:00:77:d6:ea,bus=pci.1,addr=0x0-
> chardevpty,id=charserial0-deviceisa-
> serial,chardev=charserial0,id=serial0-
> chardevsocket,id=charchannel0,fd=33,server,nowait-
> devicevirtserialport,bus=virtio-
> serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_age
> nt.0-deviceusb-tablet,id=input0,bus=usb.0,port=1-
> spiceport=5900,addr=0.0.0.0,disable-ticketing,seamless-migration=on-
> deviceqxl-
> vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vga
> mem_mb=16,max_outputs=1,bus=pcie.0,addr=0x1-devicevirtio-balloon-
> pci,id=balloon0,bus=pci.5,addr=0x0-objectrng-
> random,id=objrng0,filename=/dev/urandom-devicevirtio-rng-
> pci,rng=objrng0,id=rng0,bus=pci.6,addr=0x0-
> sandboxon,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontr
> ol=deny-devicevhost-vsock-pci,id=vsock0,guest-
> cid=3,vhostfd=26,bus=pci.7,addr=0x0-msgtimestamp=ontoolbox-dario
>
> > or just "ps afx | grep qemu",
> >
> Also a mess. But here you go:
>
> # ps afx | grep qemu
> 12952 ?        S      0:00  |   |   \_ ssh -l root -T -e none --
> 192.168.0.31 sh -c 'which virt-ssh-helper 1>/dev/null 2>&1; if test $?
> = 0; then     virt-ssh-helper 'qemu:///system'; else    if 'nc' -q 2>&1
> | grep "requires an argument" >/dev/null 2>&1; then ARG=-q0;else
> ARG=;fi;'nc' $ARG -U /var/run/libvirt/libvirt-sock; fi'
>  8758 pts/9    S+     0:00  |   |   |               \_ grep --
> color=auto qemu
>  9168 ?        Sl   224:55  |   \_ /usr/bin/qemu-system-x86_64 -name
> guest=tumbleweed-jeos,debug-threads=on -S -object
> secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-
> tumbleweed-jeos/master-key.aes -machine pc-q35-
> 5.2,accel=kvm,usb=off,dump-guest-core=off,memory-backend=pc.ram -cpu
> Skylake-Server-IBRS,ss=on,vmx=on,pdcm=on,hypervisor=on,tsc-
> adjust=on,clflushopt=on,umip=on,md-clear=on,stibp=on,arch-
> capabilities=on,ssbd=on,xsaves=on,ibpb=on,amd-stibp=on,amd-
> ssbd=on,pschange-mc-no=on,pku=off -m 4096 -object memory-backend-
> ram,id=pc.ram,size=4294967296 -overcommit mem-lock=off -smp
> 1,sockets=1,cores=1,threads=1 -uuid 57a61f7b-506e-49d8-a8d7-
> 63b5baae8534 -no-user-config -nodefaults -chardev
> socket,id=charmonitor,fd=29,server,nowait -mon
> chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew
> -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global
> ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on -
> device pcie-root-
> port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2
> -device pcie-root-
> port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1 -device pcie-
> root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2 -device
> pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3 -
> device pcie-root-
> port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4 -device pcie-
> root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5 -device
> pcie-root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6 -
> device qemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0 -device virti876714o-
> serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0 -blockdev
> {"driver":"file","filename":"/var/lib/libvirt/images/openSUSE-
> Tumbleweed-JeOS.x86_64-15.1.0-kvm-and-xen-
> Snapshot20210205.qcow2","node-name":"libvirt-1-storage","auto-read-
> only":true,"discard":"unmap"} -blockdev {"node-name":"libvirt-1-
> format","read-only":false,"driver":"qcow2","file":"libvirt-1-
> storage","backing":null} -device virtio-blk-
> pci,bus=pci.4,addr=0x0,drive=libvirt-1-format,id=virtio-
> disk0,bootindex=1 -netdev tap,fd=31,id=hostnet0,vhost=on,vhostfd=32 -
> device virtio-net-
> pci,netdev=hostnet0,id=net0,mac=52:54:00:77:d6:ea,bus=pci.1,addr=0x0 -
> chardev pty,id=charserial0 -device isa-
> serial,chardev=charserial0,id=serial0 -chardev
> socket,id=charchannel0,fd=33,server,nowait -device
> virtserialport,bus=virtio-
> serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_age
> nt.0 -device usb-tablet,id=input0,bus=usb.0,port=1 -spice
> port=5900,addr=0.0.0.0,disable-ticketing,seamless-migration=on -device
> qxl-
> vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vga
> mem_mb=16,max_outputs=1,bus=pcie.0,addr=0x1 -device virtio-balloon-
> pci,id=balloon0,bus=pci.5,addr=0x0 -object rng-
> random,id=objrng0,filename=/dev/urandom -device virtio-rng-
> pci,rng=objrng0,id=rng0,bus=pci.6,addr=0x0 -sandbox
> on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
> -device vhost-vsock-pci,id=vsock0,guest-
> cid=3,vhostfd=26,bus=pci.7,addr=0x0 -msg timestamp=on
>
> It's a bit of an unusual setup, as the VM (and hence QEMU too) is
> running inside a podman container. But it seems the info you're after
> is indeed present on the commandline.
>
> > to see
> > what is wrong with
> > our parsing logic.
> > Also, if you have any ideas how to get name, cid and port of running
> > libvirt VMs -
> > please share. The current approach parsing the qemu command line is a
> > work
> > around, not a final solution.
> >
> Mmm... not sure. I'll have a look at the code where you go and fetch
> it, and see if anything comes to mind.

Thanks a lot, Dario!

>
> Thanks and Regards
> --
> Dario Faggioli, Ph.D
> http://about.me/dario.faggioli
> Virtualization Software Engineer
> SUSE Labs, SUSE https://www.suse.com/
> -------------------------------------------------------------------
> <<This happens because _I_ choose it to happen!>> (Raistlin Majere)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
