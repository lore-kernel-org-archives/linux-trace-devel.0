Return-Path: <SRS0=llO+=4X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C74C10F25
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 20:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7E8206E2
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 20:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFUN7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 15:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgCFUN7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 15:13:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CC90206D7;
        Fri,  6 Mar 2020 20:13:58 +0000 (UTC)
Date:   Fri, 6 Mar 2020 15:13:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH 0/2] KernelShark2.0: Use libtracefs APIs to access
 tracefs
Message-ID: <20200306151356.4bbeef14@gandalf.local.home>
In-Reply-To: <20200306092902.48786-1-tz.stoyanov@gmail.com>
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  6 Mar 2020 11:29:00 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>
> 
> The tracefs library provides APIs for accessing files from tracefs.
> The library is part of trace-cmd, it is installed as part of trace-cmd
> installation. KernelShark uses some of those APIs and must be linked with
> the library
> 
> Tzvetomir (VMware)  Stoyanov (2):
>   KernelShark2.0: Link KernelShark to libtracefs
>   KernelShark2.0: Use libtracefs APIs to access tracefs
> 

I added these patches to the latest kernelshark-2.0 and it still doesn't
work for me. I did a little debugging, and noticed that it fails while
reading the guest trace.dat file with:

plugin "kvm_combo" failed to initialize on stream /tmp/trace-host-Fedora21.

It seems to require that the guest trace.dat file has kvm events?

Note, as I build my guest kernel with a make localmodconfig, which disables
all modules that are not necessary to boot the box, there is no kvm events
there. I can see why the host may need them, but not the guest. I'll
rebuild my guest kernel with kvm events and see if that solves this (but
that shouldn't be the case).

-- Steve
