Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727293AbeH2UaL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 16:30:11 -0400
Date: Wed, 29 Aug 2018 12:32:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] kernel-shark-qt: Restore the alignment in
 libkshark-configio.c
Message-ID: <20180829123227.7ce86b23@gandalf.local.home>
In-Reply-To: <20180829162927.20200-2-y.karadz@gmail.com>
References: <20180829162927.20200-1-y.karadz@gmail.com>
        <20180829162927.20200-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 29 Aug 2018 19:29:25 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The alignment of the function arguments has to be fixed after the
> naming convention changes.
> 
> This version of the patch contains a number of improvements suggested
> by Steven Rostedt. Thanks Steven!

I don't think I need credit for a whitespace fix patch ;-)

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/libkshark-configio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
> index 484da93..cdc8c76 100644
> --- a/kernel-shark-qt/src/libkshark-configio.c
> +++ b/kernel-shark-qt/src/libkshark-configio.c
> @@ -1034,7 +1034,7 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
>  
>  	for (i = 0; events[i]; i++) {
>  		str = tep_filter_make_string(adv_filter,
> -						events[i]->id);
> +					     events[i]->id);
>  		if (!str)
>  			continue;
>  
> @@ -1137,7 +1137,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
>  			 json_object_get_string(jcond));
>  
>  		ret = tep_filter_add_filter_str(adv_filter,
> -						   filter_str);
> +						filter_str);
>  		if (ret < 0)
>  			goto fail;
>  	}
> @@ -1149,7 +1149,7 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
>  	char error_str[200];
>  	int error_status =
>  		tep_strerror(kshark_ctx->pevent, ret, error_str,
> -							 sizeof(error_str));
> +						      sizeof(error_str));
>  
>  	if (error_status == 0)
>  		fprintf(stderr, "filter failed due to: %s\n", error_str);
