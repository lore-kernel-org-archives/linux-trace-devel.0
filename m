Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8180C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25166103B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhKCQ0v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232829AbhKCQ0r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 12:26:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70CDE60F58;
        Wed,  3 Nov 2021 16:24:08 +0000 (UTC)
Date:   Wed, 3 Nov 2021 12:24:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] libtracefs: Add new public macros for bits
 manipulations
Message-ID: <20211103122406.7a21859c@gandalf.local.home>
In-Reply-To: <20211103154417.246999-2-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Nov 2021 17:44:07 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/include/tracefs.h b/include/tracefs.h
> index a2cda30..fa7f316 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -10,6 +10,10 @@
>  #include <sched.h>
>  #include <event-parse.h>
>  
> +#define TRACEFS_BIT_SET(M, B)	do { (M) |= (1ULL << (B)); } while (0)
> +#define TRACEFS_BIT_TEST(M, B)	((M) & (1ULL<<(B)))
> +#define TRACEFS_BIT_CLEAR(M, B)	do { (M) &= ~(1ULL << (B)); } while (0)

Does this really need to be public?

I was thinking that this would just be used internally, and thus in the
tracefs-local.h.

-- Steve

> +
>  char *tracefs_get_tracing_file(const char *name);
