Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbeK3O05 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 09:26:57 -0500
Message-Id: <20181130031907.694438604@goodmis.org>
Date: Thu, 29 Nov 2018 22:18:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Wang Haibin <wanghaibin.wang@huawei.com>,
        linux-trace-devel@vger.kernel.org, stable@vger.kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] tracepoint: Use __idx instead of idx in DO_TRACE macro to make it
 unique
References: <20181130031829.268422593@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Zenghui Yu <yuzenghui@huawei.com>

After enabling KVM event tracing, almost all of trace_kvm_exit()'s
printk shows

	"kvm_exit: IRQ: ..."

even if the actual exception_type is NOT IRQ.  More specifically,
trace_kvm_exit() is defined in virt/kvm/arm/trace.h by TRACE_EVENT.

This slight problem may have existed after commit e6753f23d961
("tracepoint: Make rcuidle tracepoint callers use SRCU"). There are
two variables in trace_kvm_exit() and __DO_TRACE() which have the
same name, *idx*. Thus the actual value of *idx* will be overwritten
when tracing. Fix it by adding a simple prefix.

Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Wang Haibin <wanghaibin.wang@huawei.com>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRCU")
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 538ba1a58f5b..e9de8ad0bad7 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -166,7 +166,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
 		void *__data;						\
-		int __maybe_unused idx = 0;				\
+		int __maybe_unused __idx = 0;				\
 									\
 		if (!(cond))						\
 			return;						\
@@ -182,7 +182,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		 * doesn't work from the idle path.			\
 		 */							\
 		if (rcuidle) {						\
-			idx = srcu_read_lock_notrace(&tracepoint_srcu);	\
+			__idx = srcu_read_lock_notrace(&tracepoint_srcu);\
 			rcu_irq_enter_irqson();				\
 		}							\
 									\
@@ -198,7 +198,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 									\
 		if (rcuidle) {						\
 			rcu_irq_exit_irqson();				\
-			srcu_read_unlock_notrace(&tracepoint_srcu, idx);\
+			srcu_read_unlock_notrace(&tracepoint_srcu, __idx);\
 		}							\
 									\
 		preempt_enable_notrace();				\
-- 
2.19.1
