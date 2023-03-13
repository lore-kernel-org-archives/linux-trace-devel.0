Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8908C6FD19
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 16:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCMQQe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 12:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCMQQd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 12:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6B45B5EB
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 09:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDAB9612C5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 16:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6540C433EF;
        Mon, 13 Mar 2023 16:16:13 +0000 (UTC)
Date:   Mon, 13 Mar 2023 12:16:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH RFC] libtraceevent: Improve exception handling in
 parse_arg_add()
Message-ID: <20230313121612.3b16fcf1@gandalf.local.home>
In-Reply-To: <94b6775c-406e-4b17-2984-84f1bb54f375@web.de>
References: <94b6775c-406e-4b17-2984-84f1bb54f375@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 12 Mar 2023 10:02:24 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> Hello,
> 
> I hope that the advice “If there is no cleanup needed then just return directly.”

                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


> can be taken better into account.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.3-rc1#n532
> 
> Another improvable implementation detail was detected by the means of
> the semantic patch language (Coccinelle software).
> How will the chances evolve to integrate the following change suggestion?
> 
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index e655087..1ca5fdd 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -6388,22 +6388,20 @@ static int parse_arg_add(struct tep_print_parse **parse, char *format,
>  
>      parg = calloc(1, sizeof(*parg));
>      if (!parg)
> -        goto error;
> +        return -1;
> +
>      parg->format = strdup(format);
> -    if (!parg->format)
> -        goto error;
> +    if (!parg->format) {
> +        free(parg);
           ^^^^^^^^^^

That's clean up.

-- Steve

> +        return -1;
> +    }
> +
>      parg->type = type;
>      parg->arg = arg;
>      parg->len_as_arg = len_as_arg;
>      parg->ls = ls;
>      *parse = parg;
>      return 0;
> -error:
> -    if (parg) {
> -        free(parg->format);
> -        free(parg);
> -    }
> -    return -1;
>  }
>  
>  static int parse_arg_format(struct tep_print_parse **parse,
> 
> 
> Regards,
> Markus

