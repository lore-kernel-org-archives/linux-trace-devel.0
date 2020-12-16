Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208A9C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE48233A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgLPU3c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgLPU3c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:29:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5CA6233A2;
        Wed, 16 Dec 2020 20:28:51 +0000 (UTC)
Date:   Wed, 16 Dec 2020 15:28:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Re-enable the build of KernelShark v1
Message-ID: <20201216152850.7cf69fc8@gandalf.local.home>
In-Reply-To: <20201216130715.181002-1-y.karadz@gmail.com>
References: <20201216130715.181002-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Dec 2020 15:07:15 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> --- a/lib/traceevent/parse-utils.c
> +++ b/lib/traceevent/parse-utils.c
> @@ -9,8 +9,6 @@
>  #include <stdarg.h>
>  #include <errno.h>
>  
> -#include "event-utils.h"
> -
>  #define __weak __attribute__((weak))
>  
>  void __vwarning(const char *fmt, va_list ap)
> -- 

Is this needed?

I removed this hunk, and it still builds fine for me. After I did the
dependency change mentioned in the other email.

-- Steve
