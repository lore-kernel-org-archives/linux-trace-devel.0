Return-Path: <SRS0=a4MR=OP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbeLFOlI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Dec 2018 09:41:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>,
        Wang Haibin <wanghaibin.wang@huawei.com>,
        linux-trace-devel@vger.kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 09/41] tracepoint: Use __idx instead of idx in DO_TRACE macro to make it unique
Date: Thu,  6 Dec 2018 15:38:49 +0100
Message-Id: <20181206142950.461941444@linuxfoundation.org>
In-Reply-To: <20181206142949.757402551@linuxfoundation.org>
References: <20181206142949.757402551@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

commit 0c7a52e4d4b5c4d35b31f3c3ad32af814f1bf491 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/tracepoint.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -166,7 +166,7 @@ static inline struct tracepoint *tracepo
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
 		void *__data;						\
-		int __maybe_unused idx = 0;				\
+		int __maybe_unused __idx = 0;				\
 									\
 		if (!(cond))						\
 			return;						\
@@ -182,7 +182,7 @@ static inline struct tracepoint *tracepo
 		 * doesn't work from the idle path.			\
 		 */							\
 		if (rcuidle) {						\
-			idx = srcu_read_lock_notrace(&tracepoint_srcu);	\
+			__idx = srcu_read_lock_notrace(&tracepoint_srcu);\
 			rcu_irq_enter_irqson();				\
 		}							\
 									\
@@ -198,7 +198,7 @@ static inline struct tracepoint *tracepo
 									\
 		if (rcuidle) {						\
 			rcu_irq_exit_irqson();				\
-			srcu_read_unlock_notrace(&tracepoint_srcu, idx);\
+			srcu_read_unlock_notrace(&tracepoint_srcu, __idx);\
 		}							\
 									\
 		preempt_enable_notrace();				\
