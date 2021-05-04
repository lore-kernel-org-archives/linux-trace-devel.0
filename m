Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11DCC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 21:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A330C613DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 May 2021 21:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhEDVYI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 May 2021 17:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhEDVYH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 May 2021 17:24:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444C9613CB;
        Tue,  4 May 2021 21:23:12 +0000 (UTC)
Date:   Tue, 4 May 2021 17:23:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, joelaf@google.com
Subject: Re: [PATCH] trace-cmd: Add support for non-qemu VMs
Message-ID: <20210504172310.5a510ec9@gandalf.local.home>
In-Reply-To: <20210426103528.634418-1-tz.stoyanov@gmail.com>
References: <20210426103528.634418-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 13:35:28 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Current host-guest tracing implementation assumes that qemu runs the VMs
> and uses qemu specific logic to collect various information:
>  - PID of the process, running the guest VM. In case of KVM, this PID
>    is used  to get the KVM guest TSC clock parameters, needed for better
>    host and guest trace timestamps synchronization.
>  - PIDs of each thread, running a guest virtual CPU. This is used for
>    better trace visualisation. It helps to map the host task to a vCPU
>    and to visualise them together.
> In case qemu is not used to run the VMs, host-guest tracing fails. As
> that information is not mandatory, we can easily support non-qemu VMs.
> Changes, proposed by the patch:
>  - if PID of the process, running the guest VM, is not available - fail
>    back to a PTP-like algorithm for trace timestamps synchronization.
>  - if PIDs of the threads, running guest virtual CPUs, are not available
>    write -1 in the trace file metadata.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---

We need to fix this for qemu as well. I just upgraded my test box to
Fedora-33 and it renamed qemu from qemu-system-x86 to qemu-kvm, and I hit
the same issue that Joel did with his code. And this patch just removes the
use of KVM synchronization for my box.

I'll try to find other ways to get this information than the hack we
currently have. Relying on the application name is not robust at all. But
unfortunately, there's currently no way that I can find that exports the
CID of tasks. Perhaps this is going to require a kernel change. To have a
netstat functionality for vsockets.

-- Steve
