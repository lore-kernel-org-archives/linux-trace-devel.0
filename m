Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B468FC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FE5420B80
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgKLTYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKLTYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 14:24:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239D620B80;
        Thu, 12 Nov 2020 19:24:00 +0000 (UTC)
Date:   Thu, 12 Nov 2020 14:23:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] trace-cmd: Add new libtrasefs API to get the
 current trace clock
Message-ID: <20201112142358.0299e18c@gandalf.local.home>
In-Reply-To: <20201112091109.1239169-7-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
        <20201112091109.1239169-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 11:11:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  static void report_clock(struct buffer_instance *instance)
>  {
> -	char *str;
> -	char *cont;
>  	char *clock;
>  
> -	str = get_instance_file_content(instance, "trace_clock");
> -	if (!str)
> -		return;
> -
> -	clock = strstr(str, "[");
> -	if (!clock)
> -		goto out;
> -	clock++;
> -
> -	cont = strstr(clock, "]");
> -	if (!cont) /* should never happen */
> -		goto out;
> -
> -	*cont = '\0';
> +	if (instance)
> +		clock = tracefs_get_clock(instance->tracefs);
> +	else
> +		clock = tracefs_get_clock(NULL);

Small nit, but I find it cleaner in a case that both sides of an if
condition do basically the same thing with a different variable, to just
set the variable:

	struct tracefs_instance *tracefs = instance ? instance->tracefs : NULL;

	[..]

	clock = tracefs_get_clock(tracefs);

Other than that, the rest looks good.

Thanks Tzvetomir!

-- Steve


>  
>  	/* Default clock is "local", only show others */
> -	if (strcmp(clock, "local") == 0)
> -		goto out;
> +	if (clock && !strcmp(clock, "local") == 0)
> +		printf("\nClock: %s\n", clock);
>  
> -	printf("\nClock: %s\n", clock);
> -
> - out:
> -	free(str);
> +	free(clock);
>  }
>  
>  static void report_cpumask(struct buffer_instance *instance)
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index c42fea12..78eda481 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -511,6 +511,33 @@ static void test_instances_walk(void)
>  	}
>  }
>  
