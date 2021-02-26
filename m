Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0F1C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 19:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F39064F1F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 19:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZTnp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 14:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBZTnp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 14:43:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B8D264F1B;
        Fri, 26 Feb 2021 19:43:03 +0000 (UTC)
Date:   Fri, 26 Feb 2021 14:43:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] trace-cmd: Add validation for reading and
 writing trace.dat files
Message-ID: <20210226144302.5553d704@gandalf.local.home>
In-Reply-To: <20210226121306.216757-5-tz.stoyanov@gmail.com>
References: <20210226121306.216757-1-tz.stoyanov@gmail.com>
        <20210226121306.216757-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Feb 2021 14:13:05 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -1409,7 +1497,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  {
>  	struct tracecmd_output *handle = NULL;
>  	struct tracecmd_input *ihandle;
> -	struct tep_handle *pevent;
>  	int fd2;
>  
>  	/* Move the file descriptor to the beginning */
> @@ -1425,6 +1512,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  	ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
>  	if (!ihandle)
>  		return NULL;
> +	tracecmd_read_headers(ihandle);
>  
>  	/* move the file descriptor to the end */
>  	if (lseek(fd, 0, SEEK_END) == (off_t)-1)
> @@ -1437,11 +1525,11 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
>  
>  	handle->fd = fd;
>  
> -	/* get endian and page size */
> -	pevent = tracecmd_get_tep(ihandle);

Actually this clean up of removing the duplicate pevent should have been a
separate patch as well. I'll take this as is (as the patches seem to be
solid), but for the future, try to keep small clean ups like this as
separate patches. One advantage is, if someone is supporting an older
version of trace-cmd, they may want to backport the clean up, but not the
feature.

-- Steve

