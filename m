Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2847EC169C4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 17:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06D0218AE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 17:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfBKRuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfBKRuu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Feb 2019 12:50:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B67F218A4;
        Mon, 11 Feb 2019 17:50:49 +0000 (UTC)
Date:   Mon, 11 Feb 2019 12:50:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: Mapping vsock events from guest to host
Message-ID: <20190211125047.590e897e@gandalf.local.home>
In-Reply-To: <20190210211317.04f208f1@vmware.local.home>
References: <20190210211317.04f208f1@vmware.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


I did a bit more investigation on the guest side, and also followed the
kernel code to see how vsock works. I found the function that is called
that triggers the host to take over to read the vsock packet. It's
vp_notify:

/* the notify function used when creating a virt queue */
bool vp_notify(struct virtqueue *vq)
{
	/* we write the queue's selector into the notification register to
	 * signal the other end */
	iowrite16(vq->index, (void __iomem *)vq->priv);
	return true;
}


Now I did:

 # trace-cmd record -p function -l vp_notify -e vsock -e sched_waking -e sched_switch ./vsock-agent 824

Which gives me:

    sshd-2396    0.... 245253.091020: function:             vp_notify
    sshd-2396    0d... 245253.091075: sched_switch:         sshd:2396 [120] D ==> vsock-agent:29742 [120]
vsock-ag-29742   0.... 245253.091201: print:                tracing_mark_write: received 'hello'
vsock-ag-29742   0.... 245253.091213: virtio_transport_alloc_pkt: 3:824 -> 2:207129201 len=6 type=STREAM op=RW flags=0
vsock-ag-29742   0d... 245253.091215: sched_waking:         comm=kworker/0:1 pid=29648 prio=120 target_cpu=000
vsock-ag-29742   0d... 245253.091220: sched_switch:         vsock-agent:29742 [120] S ==> kworker/0:1:29648 [120]
kworker/-29648   0.... 245253.091224: function:             vp_notify
kworker/-29648   0d... 245253.091245: sched_switch:         kworker/0:1:29648 [120] R ==> vsock-agent:29742 [120]
vsock-ag-29742   0.... 245253.091250: print:                tracing_mark_write: wrote 'hello'
vsock-ag-29742   0.... 245253.091259: virtio_transport_alloc_pkt: 3:824 -> 2:207129201 len=0 type=STREAM op=SHUTDOWN flags=0x3
vsock-ag-29742   0d... 245253.091260: sched_waking:         comm=kworker/0:1 pid=29648 prio=120 target_cpu=000
vsock-ag-29742   0d... 245253.091264: sched_switch:         vsock-agent:29742 [120] R ==> kworker/0:1:29648 [120]
kworker/-29648   0d... 245253.091267: sched_switch:         kworker/0:1:29648 [120] R ==> vsock-agent:29742 [120]
vsock-ag-29742   0d... 245253.091290: sched_switch:         vsock-agent:29742 [120] D ==> swapper/0:0 [120]

The events of interest are:

vsock-ag-29742   0.... 245253.091213: virtio_transport_alloc_pkt: 3:824 -> 2:207129201 len=6 type=STREAM op=RW flags=0
vsock-ag-29742   0d... 245253.091215: sched_waking:         comm=kworker/0:1 pid=29648 prio=120 target_cpu=000
vsock-ag-29742   0d... 245253.091220: sched_switch:         vsock-agent:29742 [120] S ==> kworker/0:1:29648 [120]
kworker/-29648   0.... 245253.091224: function:             vp_notify

The vsock-agent allocates packet (that we see in the above event), and
then wakes up the kworker to do the work for it (it's not done by an
interrupt). The the kworker runs the virtio work queue that passes the
information to the host via the vp_notify.


As we can see, on my machine, the vp_notify is 11us after the transport
packet, and because other tasks can get in the way, they can cause a
nasty jitter. What's also bothersome about this is that we can see that
vp_notify is called with preemption and interrupts enabled. This means
that it is possible that the recording of the vp_notify() function
entry and the actual call to the iowrite can be interrupted!

Now, we really should be flexible and allow other methods (like the p2p
round trip as a backup if we can't do what I'm about to suggest).
We should enable the function tracer and only trace vp_notify (via
set_ftrace_filter, which works in instances). Enable sched_switch and
sched_wakeup events, also enable interrupt events. If we see the
vp_notify followed by a sched_switch without any interrupts happening,
(or a NEED_SCHED flag set in the event of the sched_switch) we can
safely assume that nothing preempted that vp_notify.

kworker/-29648   0.... 245253.091224: function:             vp_notify
kworker/-29648   0d... 245253.091245: sched_switch:         kworker/0:1:29648 [120] R ==> vsock-agent:29742 [120]

Like the above, we don't see a 'N' flag, nor any interrupts (although I
wasn't tracing them :-)

This compared to the kvm_exit on the host that we talked about should
be a fairly good estimate of how the client and host clocks are synced.

-- Steve


