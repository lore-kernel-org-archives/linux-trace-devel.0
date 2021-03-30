Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB349C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 21:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DFDA61953
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 21:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhC3Vhi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 17:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232641AbhC3VhY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 17:37:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2706195C;
        Tue, 30 Mar 2021 21:37:23 +0000 (UTC)
Date:   Tue, 30 Mar 2021 17:37:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] trace-cmd: Add internal API to check if tsc2nsec is
 supported
Message-ID: <20210330173721.11cb0daf@gandalf.local.home>
In-Reply-To: <20210329125821.97496-2-tz.stoyanov@gmail.com>
References: <20210329125821.97496-1-tz.stoyanov@gmail.com>
        <20210329125821.97496-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 29 Mar 2021 15:58:18 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new internal API is added to check is tsc to nanoseconds conversion is
> supported:
>  bool trace_tsc2nsec_is_supported(void);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/include/trace-local.h | 2 ++
>  tracecmd/trace-record.c        | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 7773e9fc..6a4c5f51 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -341,4 +341,6 @@ static inline bool is_digits(const char *s)
>  	return true;
>  }
>  
> +bool trace_tsc2nsec_is_supported(void);
> +
>  #endif /* __TRACE_LOCAL_H */
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 5e69cf48..5c9d800f 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -5827,6 +5827,11 @@ static int get_tsc_nsec(int *shift, int *mult)
>  }
>  #endif
>  
> +bool trace_tsc2nsec_is_supported(void)
> +{
> +	return (get_tsc_nsec(NULL, NULL) == 0);

Return is not a function, no need for the external parenthesis.

-- Steve

> +}
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,

