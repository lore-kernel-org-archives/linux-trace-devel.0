Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC529C43334
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jul 2022 08:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiGDIzj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jul 2022 04:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiGDIzi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jul 2022 04:55:38 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7427CB7F1;
        Mon,  4 Jul 2022 01:55:37 -0700 (PDT)
Received: from pwmachine.localnet (lfbn-lyo-1-1062-211.w86-248.abo.wanadoo.fr [86.248.131.211])
        by linux.microsoft.com (Postfix) with ESMTPSA id E029320DDC86;
        Mon,  4 Jul 2022 01:55:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E029320DDC86
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1656924936;
        bh=753qn467Cvr3a726KRzN40H4B1Qt8gfmorjxcMHm01U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAWKkEo+MgU2vTZ6nDAebIE5KigE7o0wa5xBZNtvBHLwbkMzo70bNZD1jyQ+L6Vx9
         v0pABJBglhYShgrDn7NRCfSRMrwGj7MBVLW5KxZ9PPYKJIppjohWOq5dQvymuqaMYG
         vYh7z4MAHuno6Ql6JZ++J51KhWYCHi+R18+PM3q0=
From:   Francis Laniel <flaniel@linux.microsoft.com>
To:     linux-trace-devel@vger.kernel.org, Will Deacon <will@kernel.org>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v2 0/1] Remove forget_syscall() from start_thread_common()
Date:   Mon, 04 Jul 2022 10:55:31 +0200
Message-ID: <2636542.mvXUDI8C0e@pwmachine>
Organization: Microsoft
In-Reply-To: <165667517849.792239.13818767623596011011.b4-ty@kernel.org>
References: <20220608162447.666494-1-flaniel@linux.microsoft.com> <165667517849.792239.13818767623596011011.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi.


Le vendredi 1 juillet 2022, 17:41:28 CEST Will Deacon a =E9crit :
> On Wed, 8 Jun 2022 17:24:45 +0100, Francis Laniel wrote:
> > First, I hope you are fine and the same for your relatives.
> >=20
> > With this contribution, I enabled using syscalls:sys_exit_execve and
> > syscalls:sys_exit_execveat as tracepoints on arm64.
> > Indeed, before this contribution, the above tracepoint would not print
> > their information as syscall number was set to -1 by calling
> > forget_syscall().
> >=20
> > [...]
>=20
> Applied to arm64 (for-next/misc), thanks!

Thank you for the merge!

> [1/1] arm64: Do not forget syscall when starting a new thread.
>       https://git.kernel.org/arm64/c/de6921856f99
>=20
> Cheers,


Best regards.


