Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbeK1Oyl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 09:54:41 -0500
Date: Tue, 27 Nov 2018 22:54:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: <joel@joelfernandes.org>, <wanghaibin.wang@huawei.com>,
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tracepoint: fix bad trace value in trace_kvm_exit()
Message-ID: <20181127225431.0e51a52f@vmware.local.home>
In-Reply-To: <1543376123-23800-1-git-send-email-yuzenghui@huawei.com>
References: <1543376123-23800-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 03:35:23 +0000
Zenghui Yu <yuzenghui@huawei.com> wrote:

> After enabling KVM event tracing, almost all of trace_kvm_exit()'s
> printk shows
> 
> 	"kvm_exit: IRQ: ..."
> 
> even if the actual exception_type is NOT IRQ.  More specifically,
> trace_kvm_exit() is defined in virt/kvm/arm/trace.h by TRACE_EVENT.
> 
> This slight problem may have existed after commit e6753f23d961
> ("tracepoint: Make rcuidle tracepoint callers use SRCU"). There are
> two variables in trace_kvm_exit() and __DO_TRACE() which have the
> same name, *idx*. Thus the actual value of *idx* will be overwritten
> when tracing. Fix it by adding a simple prefix.

Nice catch! I'll apply it tomorrow and start testing it then.

Thanks!

-- Steve

> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Wang Haibin <wanghaibin.wang@huawei.com>
> Cc: linux-trace-devel@vger.kernel.org
> ---
>  include/linux/tracepoint.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 538ba1a..e9de8ad 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -166,7 +166,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  		struct tracepoint_func *it_func_ptr;			\
>  		void *it_func;						\
>  		void *__data;						\
> -		int __maybe_unused idx = 0;				\
> +		int __maybe_unused __idx = 0;				\
>  									\
>  		if (!(cond))						\
>  			return;						\
> @@ -182,7 +182,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  		 * doesn't work from the idle path.			\
>  		 */							\
>  		if (rcuidle) {						\
> -			idx = srcu_read_lock_notrace(&tracepoint_srcu);	\
> +			__idx = srcu_read_lock_notrace(&tracepoint_srcu);\
>  			rcu_irq_enter_irqson();				\
>  		}							\
>  									\
> @@ -198,7 +198,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  									\
>  		if (rcuidle) {						\
>  			rcu_irq_exit_irqson();				\
> -			srcu_read_unlock_notrace(&tracepoint_srcu, idx);\
> +			srcu_read_unlock_notrace(&tracepoint_srcu, __idx);\
>  		}							\
>  									\
>  		preempt_enable_notrace();				\
