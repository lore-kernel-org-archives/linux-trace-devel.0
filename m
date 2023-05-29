Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27855C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 May 2023 08:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjE2Iu1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 May 2023 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjE2IuS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 May 2023 04:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C92C2
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 01:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8897611EA
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 May 2023 08:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D880C433EF;
        Mon, 29 May 2023 08:50:14 +0000 (UTC)
Date:   Mon, 29 May 2023 04:50:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Handle %c
Message-ID: <20230529045010.0b1e22ca@rorschach.local.home>
In-Reply-To: <20230508224121.12861-1-dsahern@kernel.org>
References: <20230508224121.12861-1-dsahern@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  8 May 2023 16:41:21 -0600
David Ahern <dsahern@kernel.org> wrote:

> Use of %c in tracepoints is throwing off the argument order when printing
> event data via perf. Handle '%c' in parse_arg_format.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied, Thanks David!

-- Steve

> ---
>  src/event-parse.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index acf7fde4ead9..12c6f560019b 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -6486,6 +6486,7 @@ static int parse_arg_format(struct tep_print_parse **parse,
>  			*arg = (*arg)->next;
>  			ret++;
>  			return ret;
> +		case 'c':
>  		case 'd':
>  		case 'u':
>  		case 'i':

