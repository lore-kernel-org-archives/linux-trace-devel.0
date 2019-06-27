Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414EDC48BD7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2383120B7C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0Pk1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfF0Pk1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:40:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BAD20B1F;
        Thu, 27 Jun 2019 15:40:26 +0000 (UTC)
Date:   Thu, 27 Jun 2019 11:40:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: always initialize write_record() len
Message-ID: <20190627114024.2588bc93@gandalf.local.home>
In-Reply-To: <20190627152502.174918-1-gthelen@google.com>
References: <20190627152502.174918-1-gthelen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Jun 2019 08:25:02 -0700
Greg Thelen <gthelen@google.com> wrote:

Hi Greg,

> write_record() uses an uninitializedd 'len' when record->size is 0.  I'm
> not sure how likely this case is.

Hmm, yeah, I guess it can be zero, as it's the data size, not the
record true size. If we had a zero size data record, I guess it would
still exist.

> 
> To be safe and silence compiler warning, unconditionally initialize len.

Looks good to me. I'll add it to the queue.

Thanks!

-- Steve

> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  tracecmd/trace-split.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
> index d27b3c65badc..6c8a774e13d0 100644
> --- a/tracecmd/trace-split.c
> +++ b/tracecmd/trace-split.c
> @@ -80,7 +80,7 @@ static int write_record(struct tracecmd_input *handle,
>  	unsigned long long diff;
>  	struct tep_handle *pevent;
>  	void *page;
> -	int len;
> +	int len = 0;
>  	char *ptr;
>  	int index = 0;
>  	int time;
> @@ -106,12 +106,8 @@ static int write_record(struct tracecmd_input *handle,
>  		return 0;
>  	}
>  
> -	if (record->size) {
> -		if (record->size < 28 * 4)
> -			len = record->size / 4;
> -		else
> -			len = 0;
> -	}
> +	if (record->size && (record->size < 28 * 4))
> +		len = record->size / 4;
>  
>  	time = (unsigned)diff;
>  	time = create_type_len(pevent, time, len);

