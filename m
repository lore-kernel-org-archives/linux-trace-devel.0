Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA38AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BCF64EBC
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBIGJt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBIGJr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 01:09:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D24C061786
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 22:09:07 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id my11so978907pjb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 22:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g73D9RkdtTVfgVRvKm3V+PJcKjpeHBPi2R5FJ/sk+/Q=;
        b=nlcZ0cxhISJpxco1Ycc6ZX0NoClzQ12TXJ42EQbQwbh5ZEXjsfi/OK5lqIRbFuTesG
         +Q6gl0PLJoE2IPvb8qQYIR9nbNZZASkz9w1vmogGt2u8Rh7PCMXeY24lKP8hhaLdo96l
         OuPQkw51T0xpaK5/SyLen26N1zk4TZb5dnpKja5IygWjeLSkz9tsjNCevxjPOXn12StC
         f5PWTPOITMrZbcFNzPZ/4FCVaZfAWaUAbeLC8OvABHQHu+cT5fT8eoypS2jHfl4KYcc7
         //Cos458HFw9wde154WMBQ930KRIUcgJ4ZCYkjDl2TLjxYWn43B+ygCFqlRQxX/ZeVlF
         3wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g73D9RkdtTVfgVRvKm3V+PJcKjpeHBPi2R5FJ/sk+/Q=;
        b=Pv1OFNUxMd/R/VMK+hFq/2cOo3vj3Qy3ZPqZxgV76Qz8XRPiB9VwIEyK2k+kaMQG/S
         emO5CX4kE6hBNV3skruBGKe6rugVzidxDtOXWZ2u+gaYe73vgDdlScsMfVVzcA6AHC/Q
         vXX8j/2AI5/+EczlW2ryHvOfQigUQ+L5JZ1OvJxm40WmdBQ1/q+paqbz5hEIBSu4LIiD
         uFtSieWDDquxOtKUgufwJglNr05RCdHJAGnq7bfHKqmHUkTiiB8wK0mzycSaWyJ/WqTz
         TVNLjafqdELczVwlPH/tp3NONmqRD+9vi77mt6d1w4A+iowg5SIfY9UTv1RvAI2saZ2r
         9z7Q==
X-Gm-Message-State: AOAM530JEEe1MsP1OvwUp3h3ooAwIBxpcyTgRiPLm1Pty+4YU/2eztbd
        7V/LkHlZoCe/654fuJTIRk66GNqJnOydWew6FUyMEp4wwyxrqw==
X-Google-Smtp-Source: ABdhPJyM9B1M4VvKk8sUM3/wBJhk83ceAgDL6/E+b9jysRX6QPN8yIFoNa45oPqS0f+sNrRukQeI5iy56LHHYTy8Dj8=
X-Received: by 2002:a17:903:22c2:b029:de:45c0:69f2 with SMTP id
 y2-20020a17090322c2b02900de45c069f2mr19898891plg.26.1612850946755; Mon, 08
 Feb 2021 22:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
 <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com> <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
In-Reply-To: <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 08:08:50 +0200
Message-ID: <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 9, 2021 at 8:03 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> Hi Dario,
>
> On Tue, Feb 9, 2021 at 7:32 AM Dario Faggioli <dfaggioli@suse.com> wrote:
> >
> > Hello,
> >
> > On Mon, 2021-02-08 at 08:17 +0200, Tzvetomir Stoyanov (VMware) wrote:
> > > Basic infrastructure for host - guest timestamp synchronization and a
> > > PoC implementation of PTP-like and KVM algorithms.
> > >
> > I'm trying to play with trace-cmd agent & clock syncronization, so I
> > applied this series.
> >
> > However, when I try to connect to a VM where I have the agent running,
> > I'm seeing this (on the host):
> >
> > # ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:8888 -e all sleep 1
> > trace-cmd: No such file or directory
> >   Failed to receive trace response -107
> >
> > I tried to do a strace, still on the host, and this is what I see (the
> > last part of the output):
> >
> > rt_sigaction(SIGINT, {sa_handler=0x4116a5, sa_mask=[INT], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f29f1b55b70}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
> > openat(AT_FDCWD, "/var/lib/trace-cmd/virt/(null)/trace-pipe-cpu0.out", O_RDONLY|O_NONBLOCK) = -1 ENOENT (No such file or directory)
> > socket(AF_VSOCK, SOCK_STREAM, 0)        = 4
> > connect(4, {sa_family=AF_VSOCK, sa_data="\0\0\270\"\0\0\3\0\0\0\0\0\0\0"}, 16) = 0
> > openat(AT_FDCWD, "/sys/kernel/debug/tracing/trace_clock", O_RDONLY) = 6
> > read(6, "local global counter uptime perf"..., 8192) = 62
> > read(6, "", 8192)                       = 0
> > close(6)                                = 0
> > write(4, "\0\0\0<\0\0\0\6\0\0\0\20\0\0\0\0\0\0\0\0\347\366+n\204\271\35\334", 28) = 28
> > write(4, "\0\0\0\0\0\0\0\v\0\0\0\2-e\0all\0\0\0\0\1\0\0\0\5ptp\0\0", 32) = 32
> > read(4, "", 12)                         = 0
> > dup(2)                                  = 6
> > fcntl(6, F_GETFL)                       = 0x402 (flags O_RDWR|O_APPEND)
> > fstat(6, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x9), ...}) = 0
> > write(6, "trace-cmd: No such file or direc"..., 37trace-cmd: No such file or directory
> > ) = 37
> > close(6)                                = 0
> > write(2, "  ", 2  )                       = 2
> > write(2, "Failed to receive trace response"..., 37Failed to receive trace response -107) = 37
> > write(2, "\n", 1
> > )                       = 1
> > exit_group(2)                           = ?
> > +++ exited with 2 +++
> >
> > Finally, if I use `--debug` both on the host and in the VM, here's what
> > I get.
> >
> > Guest:
> > # ./tracecmd/trace-cmd agent -p 8888 --debug
> > listening on @3:8888
> > msg received: 6 (TRACE_REQ) [60]
> > Segmentation fault
> >
> > Host:
> > # ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:8888 -e all sleep 1
> > msg send: 6 (TRACE_REQ) [60]
> > trace-cmd: No such file or directory
> >   Failed to receive trace response -107
> >
> > Am I doing something wrong? :-)
> >
> > If necessary, I can provide more info about my setup, or do more tests.
>
> There are a few limitations that we are working to address:
>  1. Ensure that vhost_vsock module is loaded on the host.
>  2. You should add a vsock device manually to your VM config, I use
> "virsh edit <vm name>" to add:
>    <vsock model='virtio'>
>       <cid auto='yes'/>
>       <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
> function='0x0'/>
>     </vsock>
> somewhere in the <devices> </devices> section.
>
Also, please note that there are two patches that should be applied also,
not part of v28 version of the patchset:
  "trace-cmd: Fix plist allocation check in trace-msg.c"
   https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203165431.792152a4@gandalf.local.home/
 "trace-cmd: Fix SEGFAULT when no tsync_protos are supplied"
   https://patchwork.kernel.org/project/linux-trace-devel/patch/20210203171018.5b82a0a7@gandalf.local.home/


> >
> > Thanks and Regards
> > --
> > Dario Faggioli, Ph.D
> > http://about.me/dario.faggioli
> > Virtualization Software Engineer
> > SUSE Labs, SUSE https://www.suse.com/
> > -------------------------------------------------------------------
> > <<This happens because _I_ choose it to happen!>> (Raistlin Majere)
>
>
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
