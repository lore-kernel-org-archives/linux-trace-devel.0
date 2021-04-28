Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D5BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42FA461419
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbhD1NUv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235630AbhD1NUu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:20:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3453661411;
        Wed, 28 Apr 2021 13:20:05 +0000 (UTC)
Date:   Wed, 28 Apr 2021 09:20:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Silence a logical-not-parentheses warning
Message-ID: <20210428092003.14555460@gandalf.local.home>
In-Reply-To: <20210428052540.3364743-1-irogers@google.com>
References: <20210428052540.3364743-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Apr 2021 22:25:40 -0700
Ian Rogers <irogers@google.com> wrote:

> Clang 12 generates a warning of:
> ./tracecmd/trace-stat.c:719:15: error: logical not is only applied to the left hand side of this comparison [-Werror,-Wlogical-not-parentheses]
>         if (clock && !strcmp(clock, "local") == 0)
>                      ^                       ~~
> ./tracecmd/trace-stat.c:719:15: note: add parentheses after the '!' to evaluate the comparison first
>         if (clock && !strcmp(clock, "local") == 0)
>                      ^
>                       (                          )
> ./tracecmd/trace-stat.c:719:15: note: add parentheses around left hand side expression to silence this warning
>         if (clock && !strcmp(clock, "local") == 0)
>                      ^
>                      (                      )
> 
> Silence by using "!= 0" as done elsewhere in the code.

Thanks, this does look like a nice clean up, and not just a removal of a
warning on Clang.

-- Steve


> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tracecmd/trace-stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
> index 3112787..cb92622 100644
> --- a/tracecmd/trace-stat.c
> +++ b/tracecmd/trace-stat.c
> @@ -716,7 +716,7 @@ static void report_clock(struct buffer_instance *instance)
>  	clock = tracefs_get_clock(tracefs);
>  
>  	/* Default clock is "local", only show others */
> -	if (clock && !strcmp(clock, "local") == 0)
> +	if (clock && strcmp(clock, "local") != 0)
>  		printf("\nClock: %s\n", clock);
>  
>  	free(clock);

