Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A09C48BCF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 23:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD043611C2
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 23:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhFLXCw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 12 Jun 2021 19:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLXCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 12 Jun 2021 19:02:52 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78EB361186;
        Sat, 12 Jun 2021 23:00:51 +0000 (UTC)
Date:   Sat, 12 Jun 2021 19:00:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Subject: Re: [PATCH 2/2] libtraceevent: Changed angled brackets to double
 quotes.
Message-ID: <20210612190049.7e09d8c6@rorschach.local.home>
In-Reply-To: <20210612014501.890593-3-irogers@google.com>
References: <20210612014501.890593-1-irogers@google.com>
        <20210612014501.890593-3-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Jun 2021 18:45:01 -0700
Ian Rogers <irogers@google.com> wrote:

> From: Claire Jensen <cjense@google.com>
> 
> Signed-off-by: Claire Jensen <cjense@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/event-utils.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/event-utils.h b/src/event-utils.h
> index d377201..44f7968 100644
> --- a/src/event-utils.h
> +++ b/src/event-utils.h
> @@ -10,7 +10,7 @@
>  #include <stdarg.h>
>  #include <stdbool.h>
>  
> -#include <event-parse.h>
> +#include "event-parse.h"

Thanks for the update, but event-parse.h is part of the exported
library and even though it happens to be local to this file, we use the
'<' and '>' to denote that it is a library header and not a local one.

-- Steve


>  
>  void tep_warning(const char *fmt, ...);
>  void tep_info(const char *fmt, ...);

