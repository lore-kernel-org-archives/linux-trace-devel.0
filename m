Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F33DC48BD7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D05320B1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfF0Pl5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfF0Pl5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:41:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19C9B20656;
        Thu, 27 Jun 2019 15:41:56 +0000 (UTC)
Date:   Thu, 27 Jun 2019 11:41:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: avoid using uninitialized handle
Message-ID: <20190627114154.7ac73718@gandalf.local.home>
In-Reply-To: <20190627152710.177848-1-gthelen@google.com>
References: <20190627152710.177848-1-gthelen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Jun 2019 08:27:10 -0700
Greg Thelen <gthelen@google.com> wrote:

> The put_together_file() 'out' error path uses uninitialized handle.
> Unconditionally initialize handle.

Yep, that's true.

> 
> Fixes: 9ed499fccef5 ("trace-cmd: Fix record --date flag when sending tracing data to a listener")

Thanks, I'll add this to the queue.

-- Steve

> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  tracecmd/trace-listen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 3106022eeb39..9132582768ac 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -626,7 +626,7 @@ static void stop_all_readers(int cpus, int *pid_array)
>  static int put_together_file(int cpus, int ofd, const char *node,
>  			     const char *port, bool write_options)
>  {
> -	struct tracecmd_output *handle;
> +	struct tracecmd_output *handle = NULL;
>  	char **temp_files;
>  	int cpu;
>  	int ret = -ENOMEM;

