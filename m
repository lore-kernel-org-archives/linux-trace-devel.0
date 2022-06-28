Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D4CC43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 13:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbiF1N7T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 09:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347087AbiF1N7O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 09:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD2035A8F;
        Tue, 28 Jun 2022 06:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F1CB81C0C;
        Tue, 28 Jun 2022 13:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FAAC341CA;
        Tue, 28 Jun 2022 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656424721;
        bh=CWQNxDDBP/tNZ4n4DV0ftah0XCTJRVxQi9UavitD9Gk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L861fPLThL71cmpBDM+iagVfpZ4YUJMReqNc/E2Cn44ZMGZ2ILrMewBPwSD113LpB
         1OB5GIBhyn0EGhyU9KS7onCHLYdRdXP0geJGUVM76csBPY9oImn2DyDVIQ39tI+Q4Y
         PWN/bq/SRwma2nKOk2IQi36hVHRZVpq1YJppAkN+rtOz/M8B7xBBmE9yhpTIqhrRpU
         KaXiAVUA80WuyVRKRA2sdWrhbk0jhLjC+0IPAWFyXNoYEhhypiU60Pynt6JxvHLAIB
         W0b0TjxwxUHf4Q9rVSKOFcbUcoPfvmTknPBvAVs5V4SVOtnWXSLY5yakA7QNo1GPqW
         VXj3rUxExJB0w==
Date:   Tue, 28 Jun 2022 14:58:35 +0100
From:   Will Deacon <will@kernel.org>
To:     Francis Laniel <flaniel@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] arm64: Do not forget syscall when starting a new
 thread.
Message-ID: <20220628135834.GA24116@willie-the-truck>
References: <20220608162447.666494-1-flaniel@linux.microsoft.com>
 <20220608162447.666494-2-flaniel@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608162447.666494-2-flaniel@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jun 08, 2022 at 05:24:46PM +0100, Francis Laniel wrote:
> This patch enables exeve*() to be traced with syscalls:sys_exit_execve
> tracepoint.
> Previous to it, by calling forget_syscall(), this tracepoint would not
> print its information as syscall is -1.
> So, this patch removes call to forget_syscall() and set regs->syscallno
> to its previous value.
> 
> Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/processor.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 9e58749db21d..86eb0bfe3b38 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -272,8 +272,9 @@ void tls_preserve_current_state(void);
>  
>  static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
>  {
> +	s32 previous_syscall = regs->syscallno;
>  	memset(regs, 0, sizeof(*regs));
> -	forget_syscall(regs);
> +	regs->syscallno = previous_syscall;

I'm still unsure about this. Even if we preserve the syscall number here,
won't all the arguments be reported as 0?

I also looked quickly at the 32-bit arch/arm/ code and it looks like the
same behaviour exists there (module CONFIG_BINFMT_ELF_FDPIC).

Will
