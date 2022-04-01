Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4071C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Apr 2022 19:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236511AbiDATjd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiDATjd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Apr 2022 15:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261B21AAA52
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 12:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A57AC61740
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Apr 2022 19:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88078C340EE;
        Fri,  1 Apr 2022 19:37:39 +0000 (UTC)
Date:   Fri, 1 Apr 2022 15:37:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org, vineethrp@google.com,
        rostedt@google.com
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220401153737.7c444426@gandalf.local.home>
In-Reply-To: <20220329191801.429691-1-joel@joelfernandes.org>
References: <20220329191801.429691-1-joel@joelfernandes.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Mar 2022 19:18:01 +0000
Joel Fernandes <joel@joelfernandes.org> wrote:

> For some systems like Android, /tmp/ does not exist. Use the /data/
> directory for message cache.
> 
> With this, host guest tracing works on Android VM running on ChromeOS.
> 
> Cc: Vineeth Pillai <vineethrp@google.com>
> Signed-off-by: Joel Fernandes <joel@joelfernandes.org>
> ---
>  lib/trace-cmd/include/private/trace-cmd-private.h |  3 ++-
>  lib/trace-cmd/trace-msg.c                         | 10 ++++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 6934376..492ad9c 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -377,7 +377,8 @@ enum tracecmd_msg_flags {
>  };
>  
>  /* for both client and server */
> -#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
> +#define MSG_CACHE_FILE  "/tmp/trace_msg_cacheXXXXXX"
> +#define MSG_CACHE_FILE2 "/data/trace_msg_cacheXXXXXX"

Hmm,

I think I rather have an environment variable that can override the
default, and not just hardcode in paths that might work.

export TRACECMD_TEMPDIR="/data"

-- Steve
