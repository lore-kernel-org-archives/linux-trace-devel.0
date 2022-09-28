Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB7FC32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 21:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiI1VY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 17:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiI1VY4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 17:24:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA99B3BC6F
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 14:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1353AB82206
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 21:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CACC433C1;
        Wed, 28 Sep 2022 21:24:49 +0000 (UTC)
Date:   Wed, 28 Sep 2022 17:26:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] Initialize field_size prior to use
Message-ID: <20220928172600.5baabfe6@gandalf.local.home>
In-Reply-To: <20220928210931.1803799-1-irogers@google.com>
References: <20220928210931.1803799-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Sep 2022 14:09:31 -0700
Ian Rogers <irogers@google.com> wrote:

> Building with CC=clang yields:
> 
> ```
>   COMPILE FPIC       event-parse.o
> event-parse.c:4313:17: warning: variable 'field_size' is uninitialized when used here [-Wuninitialized]
>                                            offset, field_size)) {
>                                                    ^~~~~~~~~~
> event-parse.c:4108:25: note: initialize the variable 'field_size' to silence this warning
>         unsigned int field_size;
>                                ^
>                                 = 0
> 1 warning generated.
> ```
> 
> dynamic_offset_field will compute the length of the field and so use
> that to give field_size a legitimate value.

Actually the field_size is not needed here.

I have a patch pending to fix this:

  https://patchwork.kernel.org/project/linux-trace-devel/patch/20220923123014.489e0e39@gandalf.local.home/

-- Steve

> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  src/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 980e980..b3e0ea7 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -4308,7 +4308,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
>  	case TEP_PRINT_DYNAMIC_ARRAY:
>  		/* Without [], we pass the address to the dynamic data */
>  		dynamic_offset_field(tep, arg->dynarray.field, data, size,
> -				     &offset, NULL);
> +				     &offset, &field_size);
>  		if (check_data_offset_size(event, arg->field.name, size,
>  					   offset, field_size)) {
>  			val = (unsigned long)data;

