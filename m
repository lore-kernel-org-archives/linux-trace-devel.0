Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2D7C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Nov 2022 15:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiK1PZT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Nov 2022 10:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiK1PYz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Nov 2022 10:24:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F624947
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 07:24:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF1E461207
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Nov 2022 15:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA801C433C1;
        Mon, 28 Nov 2022 15:24:12 +0000 (UTC)
Date:   Mon, 28 Nov 2022 10:24:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <beanhuo@iokpp.de>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] libtracefs: Fix wrong return value in
 tracefs_tracing_dir_is_mounted()
Message-ID: <20221128102410.5ccf784d@gandalf.local.home>
In-Reply-To: <20221128132106.291101-1-beanhuo@iokpp.de>
References: <20221128132106.291101-1-beanhuo@iokpp.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Nov 2022 14:21:06 +0100
Bean Huo <beanhuo@iokpp.de> wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> If it eventually mounts successfully, it should return 1 instead of
> 0, otherwise it will make the caller's verification logic more complicated

The man page shows:

  The tracefs_tracing_dir_is_mounted() returns 1 if the tracing directory is
  already mounted, 0 if it is not, and -1 on error.

If you only want to mount it and not care if it was already mounted then
use tracefs_tracing_dir(), as it will return the path of the mount point
and try to mount it if it is not already, or NULL if it could not mount it.

This function is specifically created to tell the application if it mounted
or not, so that it could unmount it when it is done. We have applications
that do this.

So, no, I'm not taking this change. It breaks the use case for this
function.

-- Steve


> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  src/tracefs-utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 777912e..5d6e977 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -188,7 +188,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
>  		return -1;
>  	if (path)
>  		*path = dir;
> -	return 0;
> +	return 1;
>  }
>  
>  /**

