Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51069CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22847222BD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389602AbfJRPSo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732682AbfJRPSo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 11:18:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A83222BD;
        Fri, 18 Oct 2019 15:18:44 +0000 (UTC)
Date:   Fri, 18 Oct 2019 11:18:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Check if ftrace file exists, before
 writing in it.
Message-ID: <20191018111842.6217f8f8@gandalf.local.home>
In-Reply-To: <20191018145759.15335-2-tz.stoyanov@gmail.com>
References: <20191018145759.15335-1-tz.stoyanov@gmail.com>
        <20191018145759.15335-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Oct 2019 17:57:59 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> ---
>  tracecmd/trace-record.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 81aca1f..c65731f 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -813,11 +813,14 @@ static int
>  write_instance_file(struct buffer_instance *instance,
>  		    const char *file, const char *str, const char *type)
>  {
> +	struct stat st;
>  	char *path;
>  	int ret;
>  
>  	path = get_instance_file(instance, file);
> -	ret = write_file(path, str, type);
> +	ret = stat(path, &st);

This is fine for now, but perhaps in the future we should check if it
is writable by the user. Hmm, we could move that check to the
write_file() itself. But that will require changing other locations
that expect write_file() to die. Which in the long run, we want to
remove that assumption.

Thanks for the patch, I just applied it.

-- Steve

> +	if (ret == 0)
> +		ret = write_file(path, str, type);
>  	tracecmd_put_tracing_file(path);
>  
>  	return ret;

