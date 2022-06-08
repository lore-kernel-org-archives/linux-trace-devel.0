Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F43CC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbiFHQZW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245441AbiFHQZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:25:21 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33C9E1D30D9;
        Wed,  8 Jun 2022 09:25:13 -0700 (PDT)
Received: from pwmachine.home (154.pool92-186-13.dynamic.orange.es [92.186.13.154])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4ECC120BE646;
        Wed,  8 Jun 2022 09:25:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4ECC120BE646
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654705512;
        bh=5IubNmv2NULJZ2ZnKWCXIaqVZ3j/e0L6iFydn2hpb6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDNkcnRsjTZYtoKoHS3vnsqKz/PHyBxHlf1KrDBckmo+aYFG4R0QBmFchkXwwESap
         OzVZPluc99tUgKQ3xE4H4zqSvDucir5wUoBUcYm7rOHCTeM9R7mUWwOPEYQFH9eSs4
         /yaLTgJX0tfjvDASBT0mFjGNqgJNP67BqTudSwLg=
From:   Francis Laniel <flaniel@linux.microsoft.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] arm64: Do not forget syscall when starting a new thread.
Date:   Wed,  8 Jun 2022 17:24:46 +0100
Message-Id: <20220608162447.666494-2-flaniel@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608162447.666494-1-flaniel@linux.microsoft.com>
References: <20220608162447.666494-1-flaniel@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch enables exeve*() to be traced with syscalls:sys_exit_execve
tracepoint.
Previous to it, by calling forget_syscall(), this tracepoint would not
print its information as syscall is -1.
So, this patch removes call to forget_syscall() and set regs->syscallno
to its previous value.

Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
---
 arch/arm64/include/asm/processor.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9e58749db21d..86eb0bfe3b38 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -272,8 +272,9 @@ void tls_preserve_current_state(void);
 
 static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 {
+	s32 previous_syscall = regs->syscallno;
 	memset(regs, 0, sizeof(*regs));
-	forget_syscall(regs);
+	regs->syscallno = previous_syscall;
 	regs->pc = pc;
 
 	if (system_uses_irq_prio_masking())
-- 
2.25.1

