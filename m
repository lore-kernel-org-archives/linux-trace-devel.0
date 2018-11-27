Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbeK1Hgh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 02:36:37 -0500
Date: Tue, 27 Nov 2018 15:37:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 03/11] kernel-shark-qt: Avoid race condition in
 kshark_get_event_name_easy()
Message-ID: <20181127153729.302c7a87@gandalf.local.home>
In-Reply-To: <20181121151356.16901-5-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
        <20181121151356.16901-5-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 21 Nov 2018 15:14:21 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Calling tep_data_event_from_type() is not thread-safe (potential
> race condition). This patch protects the access to it by using the
> mutex associated with the input file.

Tzvetomir sent patches to handle the race condition here. I'll work to
apply his.

-- Steve

> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/libkshark.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index fa85171..89ae769 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -1147,7 +1147,18 @@ const char *kshark_get_event_name_easy(struct kshark_entry *entry)
>  		}
>  	}
>  
> +	/*
> +	 * Calling tep_data_event_from_type() is not thread-safe (potential
> +	 * race condition).
> +	 * TODO: See if we can add a thread-safe version of the
> +	 * function. For the time being use a mutex to protect the access.
> +	 */
> +	pthread_mutex_lock(&kshark_ctx->input_mutex);
> +
>  	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
> +
> +	pthread_mutex_unlock(&kshark_ctx->input_mutex);
> +
>  	if (event)
>  		return event->name;
>  
