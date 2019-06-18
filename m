Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDD3C31E5E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A5502147A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfFRQUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 12:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbfFRQUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 12:20:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3913F20B1F;
        Tue, 18 Jun 2019 16:20:15 +0000 (UTC)
Date:   Tue, 18 Jun 2019 12:20:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] trace-cmd: Fix crash when trace-cmd is executed
 with args "profile -F sleep 1"
Message-ID: <20190618122009.0998021e@gandalf.local.home>
In-Reply-To: <20190605111937.17894-1-tstoyanov@vmware.com>
References: <20190605111937.17894-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  5 Jun 2019 14:19:36 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> @@ -973,6 +984,17 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
>  	cpu_data->page_cnt--;
>  
>  	free(page);
> +
> +	for (index = cpu_data->nr_pages - 1; index > 0; index--)
> +		if (cpu_data->pages[index])
> +			break;
> +	if (index < (cpu_data->nr_pages - 1)) {
> +		pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
> +		if (!pages)
> +			return;
> +		cpu_data->pages = pages;
> +		cpu_data->nr_pages = index + 1;
> +	}
>  }
>  

Heads up. Johannes found a regression that this code above causes
reading a 1.7G file where the above code makes it go from reading it in
5 seconds, to over 2 minutes!

I bisected it down to this commit (saw a small, but not so drastic
performance issue it my tests). I asked Johannes to revert the commit,
and he said that it removed the regression.

He said he'll report this in the Bugzilla, but we should be looking at
changing the realloc() logic.

-- Steve
