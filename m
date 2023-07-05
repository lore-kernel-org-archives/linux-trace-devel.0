Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECDBEB64DA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jul 2023 22:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjGEWWk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGEWWk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 18:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABFFA9
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 15:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96846173A
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 22:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AD8C433C7;
        Wed,  5 Jul 2023 22:22:37 +0000 (UTC)
Date:   Wed, 5 Jul 2023 18:22:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracefs-perf: Add missing headers for syscall() and
 SYS_* defines
Message-ID: <20230705182235.6cf94b41@gandalf.local.home>
In-Reply-To: <20230614072759.316154-1-raj.khem@gmail.com>
References: <20230614072759.316154-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Jun 2023 00:27:59 -0700
Khem Raj <raj.khem@gmail.com> wrote:

> These headers are needed to provide prototype definitions for functions
> e.g. close(), syscall(), getpagesize(), getpid()
> 
> The issue is observed with clang-16+ compiler on musl systems
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>

Applied. Thanks Khem!

-- Steve

> ---
>  src/tracefs-perf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/tracefs-perf.c b/src/tracefs-perf.c
> index 96d12cd..62c1508 100644
> --- a/src/tracefs-perf.c
> +++ b/src/tracefs-perf.c
> @@ -1,4 +1,5 @@
> -#include <asm/unistd.h>
> +#include <unistd.h>
> +#include <sys/syscall.h>
>  #include <sys/mman.h>
>  #include <signal.h>
>  #include <linux/perf_event.h>

