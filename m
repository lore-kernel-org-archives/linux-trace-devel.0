Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DAAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 19:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiF1TG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiF1TGk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 15:06:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DB919036;
        Tue, 28 Jun 2022 12:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA578B81E05;
        Tue, 28 Jun 2022 19:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDE4C3411D;
        Tue, 28 Jun 2022 19:06:35 +0000 (UTC)
Date:   Tue, 28 Jun 2022 15:06:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V4 13/20] rv/reactor: Add the panic reactor
Message-ID: <20220628150634.30c511aa@gandalf.local.home>
In-Reply-To: <67e522ab57e64eee313af508a8c70f3cce33e525.1655368610.git.bristot@kernel.org>
References: <cover.1655368610.git.bristot@kernel.org>
        <67e522ab57e64eee313af508a8c70f3cce33e525.1655368610.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 16 Jun 2022 10:44:55 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> Sample reactor that panics the system when an exception is found. This
> is useful both to capture a vmcore, or to fail-safe a critical system.
> 
> Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Gabriele Paoloni <gpaoloni@redhat.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> ---
>  kernel/trace/rv/Kconfig         |  8 ++++++
>  kernel/trace/rv/Makefile        |  1 +
>  kernel/trace/rv/reactor_panic.c | 44 +++++++++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+)
>  create mode 100644 kernel/trace/rv/reactor_panic.c
> 
> diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
> index be8e3dab0a52..91a17b13a080 100644
> --- a/kernel/trace/rv/Kconfig
> +++ b/kernel/trace/rv/Kconfig
> @@ -60,4 +60,12 @@ config RV_REACT_PRINTK
>  	  Enables the printk reactor. The printk reactor emmits a printk()
>  	  message if an exception is found.
>  
> +config RV_REACT_PANIC
> +	bool "Panic reactor"
> +	depends on RV_REACTORS
> +	default y if RV_REACTORS

Just put default y if it already depends on RV_REACTORS.

-- Steve

> +	help
> +	  Enables the panic reactor. The panic reactor emmits a printk()
> +	  message if an exception is found and panic()s the system.
> +
>  endif # RV
> diff --git a/kernel/trace/rv/Makefile b/kernel/trace/rv/Makefile
