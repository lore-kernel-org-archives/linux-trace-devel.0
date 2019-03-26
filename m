Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1B8C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063032084B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfCZUCq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732032AbfCZUCq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:02:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 894FD2075C;
        Tue, 26 Mar 2019 20:02:45 +0000 (UTC)
Date:   Tue, 26 Mar 2019 16:02:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] tools/lib/traceevent: remove call to exit() from
 tep_filter_add_filter_str()
Message-ID: <20190326160243.1d8da575@gandalf.local.home>
In-Reply-To: <20190326154328.28718-9-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
        <20190326154328.28718-9-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Mar 2019 17:43:28 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch removes call to exit() from tep_filter_add_filter_str(). A library
> function should not force the application to exit. In the current implementation
> tep_filter_add_filter_str() calls exit() when a special "test_filters" mode is
> set, used only for debugging purposes. When this mode is set and a filter is
> added - its string is printed to the console and exit() is called. This patch
> changes the logic - when in "test_filters" mode, the filter string is still
> printed, but the exit() is not called. It is up to the application to track when
> "test_filters" mode is set and to call exit, if needed.

I applied this one too (after changing tep back to pevent so that it
will apply without the other patches).

I'll start testing these and then send them to Arnaldo when complete.

Thanks!

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/parse-filter.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 298694356277..552592d153fb 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -1346,9 +1346,6 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
>  
>  	free_events(events);
>  
> -	if (rtn >= 0 && tep->test_filters)
> -		exit(0);
> -
>  	return rtn;
>  }
>  

