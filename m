Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF8DC5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2452D20B80
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgKLTKE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgKLTKE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 14:10:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D2A20B80;
        Thu, 12 Nov 2020 19:10:03 +0000 (UTC)
Date:   Thu, 12 Nov 2020 14:10:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] libtracefs: Change get name API to return
 constant string
Message-ID: <20201112141002.5eb30000@gandalf.local.home>
In-Reply-To: <20201112091109.1239169-3-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
        <20201112091109.1239169-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 11:11:05 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The tracefs_instance_get_name() API returns a pointer to internal
> string. This string is not meant to be changed by the API callers,
> that's why it should be constant.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h      |  2 +-
>  lib/tracefs/tracefs-events.c   | 12 ++----------
>  lib/tracefs/tracefs-instance.c |  2 +-
>  tracecmd/trace-record.c        |  2 +-
>  utest/tracefs-utest.c          |  2 +-
>  5 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> index 8ee7ba6e..1cf8de48 100644
> --- a/include/tracefs/tracefs.h
> +++ b/include/tracefs/tracefs.h
> @@ -24,7 +24,7 @@ struct tracefs_instance *tracefs_instance_alloc(const char *name);
>  void tracefs_instance_free(struct tracefs_instance *instance);
>  int tracefs_instance_create(struct tracefs_instance *instance);
>  int tracefs_instance_destroy(struct tracefs_instance *instance);
> -char *tracefs_instance_get_name(struct tracefs_instance *instance);
> +const char *tracefs_instance_get_name(struct tracefs_instance *instance);
>  char *
>  tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
>  char *tracefs_instance_get_dir(struct tracefs_instance *instance);
> diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
> index 8e825f50..6b796382 100644
> --- a/lib/tracefs/tracefs-events.c
> +++ b/lib/tracefs/tracefs-events.c
> @@ -481,11 +481,7 @@ next_event:
>  			failure = ret;
>  	}
>  
> -	if (events) {
> -		for (i = 0; events[i]; i++)
> -			free(events[i]);
> -		free(events);
> -	}
> +	tracefs_list_free(events);
>  	return failure;
>  }
>  
> @@ -564,11 +560,7 @@ static int fill_local_events_system(const char *tracing_dir,
>  	/* always succeed because parsing failures are not critical */
>  	ret = 0;
>  out:
> -	if (systems) {
> -		for (i = 0; systems[i]; i++)
> -			free(systems[i]);
> -		free(systems);
> -	}
> +	tracefs_list_free(systems);
>  	return ret;
>  }
>  

The above looks like it belongs in its own patch (not related to this
change).

-- Steve

