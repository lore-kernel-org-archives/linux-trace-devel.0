Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7413BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Oct 2021 18:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A42F60ED4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Oct 2021 18:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhJLS06 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhJLS06 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 14:26:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09CEF60E9C;
        Tue, 12 Oct 2021 18:24:55 +0000 (UTC)
Date:   Tue, 12 Oct 2021 14:24:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtraceevent: Fix for print_field
Message-ID: <20211012142454.16459432@gandalf.local.home>
In-Reply-To: <20210920183715.33377-1-irogers@google.com>
References: <20210920183715.33377-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Sep 2021 11:37:15 -0700
Ian Rogers <irogers@google.com> wrote:

> Correct a typo in an operator which resolves a clang warning:
> 
> src/event-parse.c:5408:41: error: converting the enum constant to a boolean [-Werror,-Wint-in-bool-context]
>         if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
>                                                ^
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 8057fb5..7063758 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -5405,7 +5405,7 @@ void static inline print_field(struct trace_seq *s, void *data,
>  	if (!parse || event->flags & TEP_EVENT_FL_FAILED)
>  		goto out;
>  
> -	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
> +	if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_STRING))

Bah, I should have caught this in my review.

Another example of the usefulness of clang errors.

Applied, thanks Ian!

-- Steve

>  		goto out;
>  
>  	start_parse = parse;

