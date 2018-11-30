Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36810 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeK3N0X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 08:26:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id g9so2008366plo.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Nov 2018 18:18:44 -0800 (PST)
Date: Thu, 29 Nov 2018 18:18:42 -0800
From: Joel Fernandes <joel@joelfernandes.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, wanghaibin.wang@huawei.com,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracepoint: fix bad trace value in trace_kvm_exit()
Message-ID: <20181130021842.GA104630@google.com>
References: <1543376123-23800-1-git-send-email-yuzenghui@huawei.com>
 <20181127225431.0e51a52f@vmware.local.home>
 <38bdc3d6-d371-af23-eda3-78a0392fbc83@huawei.com>
 <20181128213442.08e90ed4@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128213442.08e90ed4@vmware.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, Nov 28, 2018 at 09:34:42PM -0500, Steven Rostedt wrote:
> On Thu, 29 Nov 2018 10:21:55 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > On 2018/11/28 11:54, Steven Rostedt wrote:
> > > On Wed, 28 Nov 2018 03:35:23 +0000
> > > Zenghui Yu <yuzenghui@huawei.com> wrote:
> > >   
> > >> After enabling KVM event tracing, almost all of trace_kvm_exit()'s
> > >> printk shows
> > >>
> > >> 	"kvm_exit: IRQ: ..."
> > >>
> > >> even if the actual exception_type is NOT IRQ.  More specifically,
> > >> trace_kvm_exit() is defined in virt/kvm/arm/trace.h by TRACE_EVENT.
> > >>
> > >> This slight problem may have existed after commit e6753f23d961
> > >> ("tracepoint: Make rcuidle tracepoint callers use SRCU"). There are
> > >> two variables in trace_kvm_exit() and __DO_TRACE() which have the
> > >> same name, *idx*. Thus the actual value of *idx* will be overwritten
> > >> when tracing. Fix it by adding a simple prefix.  
> > > 
> > > Nice catch! I'll apply it tomorrow and start testing it then.  
> > 
> > Thanks Steven!
> > 
> 
> FYI, I renamed your subject to:
> 
>  tracepoint: Use __idx instead of idx in DO_TRACE macro to make it unique
> 
> to make the name more specific to the fix and not the symptom.
> 
> Thanks!

Thanks!

Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>

 - Joel
