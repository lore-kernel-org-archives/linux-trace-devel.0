Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f47.google.com ([74.125.82.47]:46966 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752847AbdLRPeN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 10:34:13 -0500
Received: by mail-wm0-f47.google.com with SMTP id r78so30020116wme.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Dec 2017 07:34:12 -0800 (PST)
Message-ID: <1513611250.2904.6.camel@gmail.com>
Subject: Re: [RFC PATCH v3 5/9] trace-cmd: Move libparsevent *.c files in
 lib/pevent
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Date: Mon, 18 Dec 2017 17:34:10 +0200
In-Reply-To: <20171213104928.17c0f34c@gandalf.local.home>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
         <20171212162534.31144-6-vladislav.valtchev@gmail.com>
         <20171212192116.5e99d9aa@gandalf.local.home>
         <1513166659.2565.37.camel@gmail.com>
         <20171213104928.17c0f34c@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 2017-12-13 at 10:49 -0500, Steven Rostedt wrote:
> I didn't mean the DEFAULT_TARGET when I said "the above", I was just
> referring to OBJS, which I now see that could be somewhat ambiguous in
> what I meant.
> 
> > While OBJS = is a "coding style" thing in order to have all the
> > objects added with +=, one per line.
> 
> I like the "+=" but do we really need to initialize it to nothing
> first? Doesn't make work if you just simply remove the "OBJS =" blank
> line, and a "OBJS += blah" will make OBJS equal to "blah" if OBJS
> doesn't exist yet.
> 

OK, by just using OBJS += ... works.
But: it is a dangerous in case the parent file had an OBJS variable exported:
in that case, the variable won't be cleared first and we'll end up with the wrong
objects.

I copied the practice of using OBJS = and later OBJS += ... from the original Makefile:

PLUGIN_OBJS =
PLUGIN_OBJS += plugin_jbd2.o
PLUGIN_OBJS += plugin_hrtimer.o
PLUGIN_OBJS += plugin_kmem.o
PLUGIN_OBJS += plugin_kvm.o
PLUGIN_OBJS += plugin_mac80211.o
PLUGIN_OBJS += plugin_sched_switch.o
PLUGIN_OBJS += plugin_function.o
PLUGIN_OBJS += plugin_xen.o
PLUGIN_OBJS += plugin_scsi.o
PLUGIN_OBJS += plugin_cfg80211.o
PLUGIN_OBJS += plugin_blk.o
PLUGIN_OBJS += plugin_tlb.o 

Would you like the empty assignment to be removed also from there?

Vlad
