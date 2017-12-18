Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934176AbdLRSCQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 13:02:16 -0500
Date: Mon, 18 Dec 2017 13:02:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/9] trace-cmd: Move libparsevent *.c files in
 lib/pevent
Message-ID: <20171218130214.19ced49d@gandalf.local.home>
In-Reply-To: <1513611250.2904.6.camel@gmail.com>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
        <20171212162534.31144-6-vladislav.valtchev@gmail.com>
        <20171212192116.5e99d9aa@gandalf.local.home>
        <1513166659.2565.37.camel@gmail.com>
        <20171213104928.17c0f34c@gandalf.local.home>
        <1513611250.2904.6.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 18 Dec 2017 17:34:10 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> I copied the practice of using OBJS = and later OBJS += ... from the original Makefile:
> 
> PLUGIN_OBJS =
> PLUGIN_OBJS += plugin_jbd2.o
> PLUGIN_OBJS += plugin_hrtimer.o
> PLUGIN_OBJS += plugin_kmem.o
> PLUGIN_OBJS += plugin_kvm.o
> PLUGIN_OBJS += plugin_mac80211.o
> PLUGIN_OBJS += plugin_sched_switch.o
> PLUGIN_OBJS += plugin_function.o
> PLUGIN_OBJS += plugin_xen.o
> PLUGIN_OBJS += plugin_scsi.o
> PLUGIN_OBJS += plugin_cfg80211.o
> PLUGIN_OBJS += plugin_blk.o
> PLUGIN_OBJS += plugin_tlb.o 
> 
> Would you like the empty assignment to be removed also from there?

Heh, I didn't remember doing that. But I did :-p

This is too minor to debate. Just use the "OBJS =".

Thanks,

-- Steve
