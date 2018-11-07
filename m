Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbeKGXnR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 18:43:17 -0500
Date: Wed, 7 Nov 2018 09:12:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: kaslevs@vmware.com
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Add VM kernel tracing using VSOCK socket for transport
Message-ID: <20181107091243.5c601baa@gandalf.local.home>
In-Reply-To: <20181106145902.13301-1-kaslevs@vmware.com>
References: <20181106145902.13301-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  6 Nov 2018 16:59:02 +0200
kaslevs@vmware.com wrote:

> From: Slavomir Kaslev <kaslevs@vmware.com>
> 
> To test, start a VM and assign it a valid (> 2) unused CID:
> 
>     you@host # qemu-system-x86_64 \
>         -name guest2 --uuid 7edfdf4a-cb9e-11e8-b38a-173b58342476 \
>         -m 4096 -boot d -enable-kvm -smp 3 -net nic -net user -hda $HOME/vm/guest2.img \
>         -fsdev local,id=host,path=$HOME,security_model=mapped \
>         -device virtio-9p-pci,fsdev=host,mount_tag=host \
>         -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 \
>         -chardev pipe,id=charchannel1,path=/var/lib/test/fifo0 \
>         -device virtserialport,bus=virtio-serial0.0,nr=3,chardev=charchannel1,id=channel1,name=fifo0 \
>         -device vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid=3

It would be more helpful to specify what parameters are needed and why.
The above isn't useful for me, as I run my guests with libvirt, and can
hard code in extra parameters. But if I don't know what I need to hard
code in, I can't simulate it.

-- Steve


> 
> and start `trace-cmd agent` on the guest as root:
> 
>      you@guest2 # trace-cmd agent
> 
> Finally, start `trace-cmd record` on the host (running as root is only necessary
> if the host will be traced too):
> 
>      you@host $ trace-cmd record -A guest2 -e irq -e sched
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
>
