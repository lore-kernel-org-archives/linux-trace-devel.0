Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D854CC169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 22:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFBF421924
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 22:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBHWIl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 17:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfBHWIl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 17:08:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E09A20811;
        Fri,  8 Feb 2019 22:08:40 +0000 (UTC)
Date:   Fri, 8 Feb 2019 17:08:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] trace-cmd: Fixed logic in
 tracecmd_read_page_record()
Message-ID: <20190208170838.5f0faa1f@gandalf.local.home>
In-Reply-To: <20190208134918.5618-4-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
        <20190208134918.5618-4-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Feb 2019 15:49:14 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Fixed the logic in tracecmd_read_page_record() when
> searching for the next event in the event from the
> ring buffer. In the current logic, in the case when
> last_record is not NULL (we are searching for the second one)
> the check "if (ptr != last_record->data)" always fails.
> 

Nice catch.

Let's change the change log and subject:

Subject trace-cmd: Fix tracecmd_read_page_record() to read more than one event

 The kbuffer_next_event() will return the next event on the sub buffer.
 If we pass in the last_record to tracecmd_read_page_record(), it
 initializes the sub buffer, and by calling kbuffer_next_event()
 (instead of kbuffer_read_event()), the second event on the sub buffer
 is returned. This causes the match of the last_record not to match if
 the last_record happens to be the first event on the sub buffer.


> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  lib/trace-cmd/trace-input.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 33ad7d1..5d64ca8 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1688,18 +1688,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
>  			goto out_free;
>  		}
>  
> -		do {
> +		ptr = kbuffer_read_event(kbuf, &ts);
> +		while (ptr < last_record->data) {
>  			ptr = kbuffer_next_event(kbuf, NULL);
>  			if (!ptr)
>  				break;
> -		} while (ptr < last_record->data);
> +			if (ptr == last_record->data)
> +				break;
> +		}
>  		if (ptr != last_record->data) {
>  			warning("tracecmd_read_page_record: could not find last_record");
>  			goto out_free;
>  		}
> -	}
> +		ptr = kbuffer_next_event(kbuf, &ts);
> +	} else
> +		ptr = kbuffer_read_event(kbuf, &ts);
>  
> -	ptr = kbuffer_read_event(kbuf, &ts);

Also, instead of the above "} else" clause, we can just move the

	ptr = kbuffer_read_event(kbuf, &ts);

before the if condition testing last_record.

-- Steve

>  	if (!ptr)
>  		goto out_free;
>  

