Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E98DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun,  3 Apr 2022 17:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbiDCRhQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 3 Apr 2022 13:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiDCRhQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 3 Apr 2022 13:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1798C1A3B6
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 10:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6E406125D
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 17:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A32C340ED;
        Sun,  3 Apr 2022 17:35:20 +0000 (UTC)
Date:   Sun, 3 Apr 2022 13:35:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org, rostedt@google.com,
        vineethrp@google.com, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220403133518.0ace34a5@rorschach.local.home>
In-Reply-To: <Ykm8MfLnjrcRf/64@google.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
        <20220401153737.7c444426@gandalf.local.home>
        <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
        <20220401190629.32564bd2@gandalf.local.home>
        <Ykm1jBpdD0+NjsTW@google.com>
        <Ykm8MfLnjrcRf/64@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 3 Apr 2022 15:24:33 +0000
Joel Fernandes <joel@joelfernandes.org> wrote:

> Something like the following seems to work, and the file grows to only 4KB.
> Note with memfd, the file name does not have to be unique and the fd entry
> in the process denotes the file's uniqueness.
> 
> I'll roll it into a patch, let me know if you disagree:

I'm OK with this, but I would really like a "Reviewed-by" from Tzvetomir.

Go ahead and send a real patch.

Thanks,

-- Steve

> 
> ---8<---
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 6934376..3aee139 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -377,7 +377,6 @@ enum tracecmd_msg_flags {
>  };
>  
>  /* for both client and server */
> -#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
>  struct tracecmd_msg_handle {
>  	int			fd;
>  	short			cpu_count;
> @@ -386,7 +385,6 @@ struct tracecmd_msg_handle {
>  	bool			done;
>  	bool			cache;
>  	int			cfd;
> -	char			cfile[sizeof(MSG_CACHE_FILE)];
>  };
>  
>  struct tracecmd_tsync_protos {
> diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
> index 03b853e..1472f20 100644
> --- a/lib/trace-cmd/trace-msg.c
> +++ b/lib/trace-cmd/trace-msg.c
> @@ -593,11 +593,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
>  int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
>  {
>  	if (msg_handle->cfd < 0) {
> -		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
> -		msg_handle->cfd = mkstemp(msg_handle->cfile);
> +		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
>  		if (msg_handle->cfd < 0)
>  			return -1;
> -		unlink(msg_handle->cfile);
>  	}
>  	msg_handle->cache = true;
>  	return 0;

