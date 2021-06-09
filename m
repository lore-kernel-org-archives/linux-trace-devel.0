Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E527CC47095
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 05:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4E861278
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Jun 2021 05:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhFIFp3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 01:45:29 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36177 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhFIFp2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 01:45:28 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AOzoxRay1IFcU2ZFv+Up4KrPwK71zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uA6ilfq+V98jzuSWftN9VYhAdcLO7Scy9qBHnlaKdiLN5VYtKHjOW21?=
 =?us-ascii?q?dAR7sN0WKN+VHd8mHFh4xg/JYlQuxFBNr8AUMSt6vHyQOzeuxO/OW6?=
X-IronPort-AV: E=Sophos;i="5.83,260,1616454000"; 
   d="scan'208";a="512484602"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 07:43:09 +0200
Date:   Wed, 9 Jun 2021 07:43:08 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] libtraceevent: Handle parsing of "(REC)->" case
In-Reply-To: <20210608172744.796e93b7@gandalf.local.home>
Message-ID: <alpine.DEB.2.22.394.2106090741080.2930@hadrien>
References: <20210608172744.796e93b7@gandalf.local.home>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Tue, 8 Jun 2021, Steven Rostedt wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> If a trace event wraps the special __entry variable to dereference it with
> parenthesis, it shows up in the trace event format file wrapping the
> "(REC)" as well. For example, the "func_repeats" event passed the __entry
> into a helper macro in the TP_printk() portion, and the macro correctly
> wrapped its parameter in parenthesis. This caused the output to show:
>
>  "(((u64)(REC)->top_delta_ts << 32) | (REC)->bottom_delta_ts)"
>
> The parser then failed to parse the "(REC)->" portion, as it expected the
> "->" to appear directly after the "REC". This is not a requirement, and
> the parser should be able to handle such cases.
>
> When this occurred, trace-cmd would error with the following message:
>
> trace-cmd: No such file or directory
>   Error: expected type 4 but read 5

For the record, I have tried tracing two programs with Linux v5.13-rc4 or
rc5 and both of them had this problem, while they didn't have this problem
when traced with the same arguments with earlier Linux versions.  So it
may be systematic for Linux v5.13.

julia

>
> Fixes: 6582b0a ("tools/events: Add files to create libtraceevent.a")
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>
> Changes since v1:
>     Update the change log to show the error message, in case
>     it happens again, it can be something to reference.
>
>  src/event-parse.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 97c1a97..1217491 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2311,8 +2311,19 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
>  	char *field;
>  	char *token;
>
> -	if (read_expected(TEP_EVENT_OP, "->") < 0)
> -		goto out_err;
> +	type = read_token_item(&token);
> +	/*
> +	 * Check if REC happens to be surrounded by parenthesis, and
> +	 * return if that's the case, as "(REC)->" is valid.
> +	 * but return TEP_EVENT_ITEM.
> +	 */
> +	if (type == TEP_EVENT_DELIM && strcmp(token, ")") == 0) {
> +		*tok = token;
> +		return TEP_EVENT_ITEM;
> +	}
> +
> +	if (test_type_token(type, token,  TEP_EVENT_OP, "->"))
> +		goto out_free;
>
>  	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
>  		goto out_free;
> @@ -2338,7 +2349,6 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
>
>   out_free:
>  	free_token(token);
> - out_err:
>  	*tok = NULL;
>  	return TEP_EVENT_ERROR;
>  }
> @@ -3033,6 +3043,17 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>  	if (type == TEP_EVENT_ERROR)
>  		goto out_free;
>
> +	/*
> +	 * If REC is surrounded by parenthesis, the process_arg()
> +	 * will return TEP_EVENT_ITEM with token == ")". In
> +	 * this case, we need to continue processing the item
> +	 * and return.
> +	 */
> +	if (type == TEP_EVENT_ITEM && strcmp(token, ")") == 0) {
> +		free_token(token);
> +		return process_entry(event, arg, tok);
> +	}
> +
>  	if (test_type_token(type, token, TEP_EVENT_DELIM, ")"))
>  		goto out_free;
>
> --
> 2.29.2
>
>
