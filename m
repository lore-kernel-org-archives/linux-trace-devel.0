Return-Path: <SRS0=SJyJ=7R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CA7C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 15:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B988120738
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 15:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFDPvm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgFDPvm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 11:51:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D728020738;
        Thu,  4 Jun 2020 15:51:41 +0000 (UTC)
Date:   Thu, 4 Jun 2020 11:51:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] trace-cmd: Add description of "-G" option
Message-ID: <20200604115140.560f4eeb@gandalf.local.home>
In-Reply-To: <20200603121506.49992-6-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
        <20200603121506.49992-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Jun 2020 15:15:06 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -53,6 +53,7 @@ static struct usage_help usage_help[] = {
>  		"          --module filter module name\n"
>  		"          --by-comm used with --profile, merge events for related comms\n"
>  		"          --profile enable tracing options needed for report --profile\n"
> +		"          -G when profiling, set soft and hard irqs as global\n"

This should be in with the other "simple" options (those with a single
character). The long options "--foo" should always be at the end after all
simple ones.

Thanks!

-- Steve

>  		"          --func-stack perform a stack trace for function tracer\n"
>  		"             (use with caution)\n"
>  		"          --max-graph-depth limit function_graph depth\n"
