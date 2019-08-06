Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13A0C31E40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 03:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBDBF214C6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 03:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHFDVH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 23:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729170AbfHFDVH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 23:21:07 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB89216B7;
        Tue,  6 Aug 2019 03:21:06 +0000 (UTC)
Date:   Mon, 5 Aug 2019 23:21:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] parse-events: deref pointer for proper sizeof()
Message-ID: <20190805232103.04c6ad28@oasis.local.home>
In-Reply-To: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
References: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  5 Aug 2019 19:26:45 +0900
Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---

Hi Sergey,

Thanks for sending these!

-- Steve

>  parse-events.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 3d59d92..807fc53 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -2058,7 +2058,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  			goto out_free;
>  
>  		field = malloc_or_die(sizeof(*field));
> -		memset(field, 0, sizeof(field));
> +		memset(field, 0, sizeof(*field));
>  
>  		value = arg_eval(arg);
>  		field->value = strdup(value);

