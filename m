Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:15171 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbeK2NZw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 08:25:52 -0500
Subject: Re: [PATCH] tracepoint: fix bad trace value in trace_kvm_exit()
To: Steven Rostedt <rostedt@goodmis.org>
CC: <joel@joelfernandes.org>, <wanghaibin.wang@huawei.com>,
        <linux-trace-devel@vger.kernel.org>
References: <1543376123-23800-1-git-send-email-yuzenghui@huawei.com>
 <20181127225431.0e51a52f@vmware.local.home>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <38bdc3d6-d371-af23-eda3-78a0392fbc83@huawei.com>
Date: Thu, 29 Nov 2018 10:21:55 +0800
MIME-Version: 1.0
In-Reply-To: <20181127225431.0e51a52f@vmware.local.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 2018/11/28 11:54, Steven Rostedt wrote:
> On Wed, 28 Nov 2018 03:35:23 +0000
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
>> After enabling KVM event tracing, almost all of trace_kvm_exit()'s
>> printk shows
>>
>> 	"kvm_exit: IRQ: ..."
>>
>> even if the actual exception_type is NOT IRQ.  More specifically,
>> trace_kvm_exit() is defined in virt/kvm/arm/trace.h by TRACE_EVENT.
>>
>> This slight problem may have existed after commit e6753f23d961
>> ("tracepoint: Make rcuidle tracepoint callers use SRCU"). There are
>> two variables in trace_kvm_exit() and __DO_TRACE() which have the
>> same name, *idx*. Thus the actual value of *idx* will be overwritten
>> when tracing. Fix it by adding a simple prefix.
> 
> Nice catch! I'll apply it tomorrow and start testing it then.

Thanks Steven!

Zenghui

> 
> Thanks!
> 
> -- Steve
> 
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Cc: Joel Fernandes <joel@joelfernandes.org>
>> Cc: Wang Haibin <wanghaibin.wang@huawei.com>
>> Cc: linux-trace-devel@vger.kernel.org
>> ---
>>   include/linux/tracepoint.h | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
>> index 538ba1a..e9de8ad 100644
>> --- a/include/linux/tracepoint.h
>> +++ b/include/linux/tracepoint.h
>> @@ -166,7 +166,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>>   		struct tracepoint_func *it_func_ptr;			\
>>   		void *it_func;						\
>>   		void *__data;						\
>> -		int __maybe_unused idx = 0;				\
>> +		int __maybe_unused __idx = 0;				\
>>   									\
>>   		if (!(cond))						\
>>   			return;						\
>> @@ -182,7 +182,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>>   		 * doesn't work from the idle path.			\
>>   		 */							\
>>   		if (rcuidle) {						\
>> -			idx = srcu_read_lock_notrace(&tracepoint_srcu);	\
>> +			__idx = srcu_read_lock_notrace(&tracepoint_srcu);\
>>   			rcu_irq_enter_irqson();				\
>>   		}							\
>>   									\
>> @@ -198,7 +198,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>>   									\
>>   		if (rcuidle) {						\
>>   			rcu_irq_exit_irqson();				\
>> -			srcu_read_unlock_notrace(&tracepoint_srcu, idx);\
>> +			srcu_read_unlock_notrace(&tracepoint_srcu, __idx);\
>>   		}							\
>>   									\
>>   		preempt_enable_notrace();				\
> 
> 
> .
> 
