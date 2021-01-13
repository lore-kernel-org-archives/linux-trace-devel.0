Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCFCC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 22:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3730A2339D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jan 2021 22:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbhAMWKc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jan 2021 17:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbhAMWKG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jan 2021 17:10:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E87423136;
        Wed, 13 Jan 2021 22:01:12 +0000 (UTC)
Date:   Wed, 13 Jan 2021 17:01:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add new API tracecmd_open_head()
Message-ID: <20210113170110.261ae555@gandalf.local.home>
In-Reply-To: <20200409132825.79475-3-tz.stoyanov@gmail.com>
References: <20200409132825.79475-1-tz.stoyanov@gmail.com>
        <20200409132825.79475-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Apr 2020 16:28:25 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Add an API to create a tracecmd_handle from a file,
> read and parse only the trace headers from the file.
> This allows to implement opening a trace file on
> stages - reading the trace headers and reading the trace data.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h |  1 +
>  lib/trace-cmd/trace-input.c   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 3f96bbde..e22aa251 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -143,6 +143,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
>  struct tracecmd_input *tracecmd_alloc(const char *file);
>  struct tracecmd_input *tracecmd_alloc_fd(int fd);
>  struct tracecmd_input *tracecmd_open(const char *file);
> +struct tracecmd_input *tracecmd_open_head(const char *file);
>  struct tracecmd_input *tracecmd_open_fd(int fd);
>  void tracecmd_ref(struct tracecmd_input *handle);
>  void tracecmd_close(struct tracecmd_input *handle);

Hi Tzvetomir,

I was thinking, before we release libtracecmd, we should add
tracecmd_open() and tracecmd_open_fd() to the library. Just because I find
that tracecmd_open_head() is a awkward name to have alone and only makes
sense if there's already a tracecmd_open(). It will also help with
differentiating the different functions.

I know we were going to only have functions that kernelshark uses, but that
may be a little too limiting.

Thanks!

-- Steve
