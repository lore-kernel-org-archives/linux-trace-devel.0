Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F3BC4708D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Jan 2023 04:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjAFELn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 23:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAFELk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 23:11:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232FE6A0DE
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 20:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0E661CFE
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 04:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18A6C433EF
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Jan 2023 04:11:38 +0000 (UTC)
Date:   Thu, 5 Jan 2023 23:11:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] libtracefs: Have tracefs_cpu_stop() always
 suggesting nudging
Message-ID: <20230105231136.078fdc68@gandalf.local.home>
In-Reply-To: <20230105215252.224044-3-rostedt@goodmis.org>
References: <20230105215252.224044-1-rostedt@goodmis.org>
        <20230105215252.224044-3-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  5 Jan 2023 16:52:52 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The man page of tracefs_cpu_stop() states that if it returns 0 that it
> guaranteed to wake up a reader. Well, that doesn't appear to always be the
> case. Return 1 until we can figure it out.
> 

Hmm, I got my application working again without this change.

I'll hold off from applying it. Perhaps it was the application fault and
not the library.

-- Steve

> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/tracefs-record.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/src/tracefs-record.c b/src/tracefs-record.c
> index f998883134b8..9baec6780974 100644
> --- a/src/tracefs-record.c
> +++ b/src/tracefs-record.c
> @@ -429,15 +429,11 @@ int tracefs_cpu_stop(struct tracefs_cpu *tcpu)
>  		return ret;
>  
>  	/* Calling ioctl() on recent kernels will wake up the waiters */
> -	ret = ioctl(tcpu->fd, 0);
> -	if (ret < 0)
> -		ret = 1;
> -	else
> -		ret = 0;
> +	ioctl(tcpu->fd, 0);
>  
>  	set_nonblock(tcpu);
>  
> -	return ret;
> +	return 1;
>  }
>  
>  /**

