Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbeK2Nia (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 08:38:30 -0500
Date: Wed, 28 Nov 2018 21:34:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: <joel@joelfernandes.org>, <wanghaibin.wang@huawei.com>,
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tracepoint: fix bad trace value in trace_kvm_exit()
Message-ID: <20181128213442.08e90ed4@vmware.local.home>
In-Reply-To: <38bdc3d6-d371-af23-eda3-78a0392fbc83@huawei.com>
References: <1543376123-23800-1-git-send-email-yuzenghui@huawei.com>
        <20181127225431.0e51a52f@vmware.local.home>
        <38bdc3d6-d371-af23-eda3-78a0392fbc83@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 29 Nov 2018 10:21:55 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> On 2018/11/28 11:54, Steven Rostedt wrote:
> > On Wed, 28 Nov 2018 03:35:23 +0000
> > Zenghui Yu <yuzenghui@huawei.com> wrote:
> >   
> >> After enabling KVM event tracing, almost all of trace_kvm_exit()'s
> >> printk shows
> >>
> >> 	"kvm_exit: IRQ: ..."
> >>
> >> even if the actual exception_type is NOT IRQ.  More specifically,
> >> trace_kvm_exit() is defined in virt/kvm/arm/trace.h by TRACE_EVENT.
> >>
> >> This slight problem may have existed after commit e6753f23d961
> >> ("tracepoint: Make rcuidle tracepoint callers use SRCU"). There are
> >> two variables in trace_kvm_exit() and __DO_TRACE() which have the
> >> same name, *idx*. Thus the actual value of *idx* will be overwritten
> >> when tracing. Fix it by adding a simple prefix.  
> > 
> > Nice catch! I'll apply it tomorrow and start testing it then.  
> 
> Thanks Steven!
> 

FYI, I renamed your subject to:

 tracepoint: Use __idx instead of idx in DO_TRACE macro to make it unique

to make the name more specific to the fix and not the symptom.

Thanks!

-- Steve
