Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB51C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 01:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0303F61413
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 01:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhEMBx4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 21:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhEMBx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 21:53:56 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B08861411;
        Thu, 13 May 2021 01:52:46 +0000 (UTC)
Date:   Wed, 12 May 2021 21:52:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] libtraceevent: Rename tep_vwarning() to
 tep_vprint()
Message-ID: <20210512215244.2b95404c@oasis.local.home>
In-Reply-To: <20210507095022.1079364-4-tz.stoyanov@gmail.com>
References: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
        <20210507095022.1079364-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  7 May 2021 12:50:21 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/src/event-utils.h b/src/event-utils.h
> index 1951557..0617a28 100644
> --- a/src/event-utils.h
> +++ b/src/event-utils.h
> @@ -9,10 +9,11 @@
>  #include <ctype.h>
>  #include <stdarg.h>
>  
> +void tep_warning(const char *fmt, ...);
>  void tep_info(const char *fmt, ...);
>  /* Can be overridden */
> -void tep_warning(const char *fmt, ...);
> -int tep_vwarning(const char *name, const char *fmt, va_list ap);
> +int tep_vprint(const char *name, enum tep_loglevel level,
> +	       bool print_err, const char *fmt, va_list ap);
>  
>  #define min(x, y) ({				\
>  	typeof(x) _min1 = (x);			\

I have the following build error on trace-cmd:

In file included from trace-util.c:23:
/usr/local/include/traceevent/event-utils.h:16:9: error: unknown type name ‘bool’
   16 |         bool print_err, const char *fmt, va_list ap);
      |         ^~~~

Needs to include <stdbool.h> in event-utils.h, can not rely that this
would exist in the use cases.

I'll add it to this patch, unless I find other issues for a v3.

-- Steve
