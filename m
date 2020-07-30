Return-Path: <SRS0=u2KR=BJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780D4C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 21:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DCF2084D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Jul 2020 21:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgG3V2q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 17:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbgG3V2q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 17:28:46 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584D320829;
        Thu, 30 Jul 2020 21:28:45 +0000 (UTC)
Date:   Thu, 30 Jul 2020 17:28:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tools lib traceevent: Fix memory leak in
 process_dynamic_array_len
Message-ID: <20200730172843.653cd9f4@oasis.local.home>
In-Reply-To: <20200730150236.5392-1-pduplessis@efficios.com>
References: <20200730150236.5392-1-pduplessis@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Arnaldo,

Can you pull this into your tree under urgent?

 https://lore.kernel.org/linux-trace-devel/20200730150236.5392-1-pduplessis@efficios.com/

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


On Thu, 30 Jul 2020 11:02:36 -0400
Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:

> I compiled with AddressSanitizer and I had these memory leaks while I
> was using the tep_parse_format function:
> 
>     Direct leak of 28 byte(s) in 4 object(s) allocated from:
>         #0 0x7fb07db49ffe in __interceptor_realloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10dffe)
>         #1 0x7fb07a724228 in extend_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:985
>         #2 0x7fb07a724c21 in __read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1140
>         #3 0x7fb07a724f78 in read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1206
>         #4 0x7fb07a725191 in __read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1291
>         #5 0x7fb07a7251df in read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1299
>         #6 0x7fb07a72e6c8 in process_dynamic_array_len /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:2849
>         #7 0x7fb07a7304b8 in process_function /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3161
>         #8 0x7fb07a730900 in process_arg_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3207
>         #9 0x7fb07a727c0b in process_arg /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1786
>         #10 0x7fb07a731080 in event_read_print_args /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3285
>         #11 0x7fb07a731722 in event_read_print /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3369
>         #12 0x7fb07a740054 in __tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6335
>         #13 0x7fb07a74047a in __parse_event /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6389
>         #14 0x7fb07a740536 in tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6431
>         #15 0x7fb07a785acf in parse_event ../../../src/fs-src/fs.c:251
>         #16 0x7fb07a785ccd in parse_systems ../../../src/fs-src/fs.c:284
>         #17 0x7fb07a786fb3 in read_metadata ../../../src/fs-src/fs.c:593
>         #18 0x7fb07a78760e in ftrace_fs_source_init ../../../src/fs-src/fs.c:727
>         #19 0x7fb07d90c19c in add_component_with_init_method_data ../../../../src/lib/graph/graph.c:1048
>         #20 0x7fb07d90c87b in add_source_component_with_initialize_method_data ../../../../src/lib/graph/graph.c:1127
>         #21 0x7fb07d90c92a in bt_graph_add_source_component ../../../../src/lib/graph/graph.c:1152
>         #22 0x55db11aa632e in cmd_run_ctx_create_components_from_config_components ../../../src/cli/babeltrace2.c:2252
>         #23 0x55db11aa6fda in cmd_run_ctx_create_components ../../../src/cli/babeltrace2.c:2347
>         #24 0x55db11aa780c in cmd_run ../../../src/cli/babeltrace2.c:2461
>         #25 0x55db11aa8a7d in main ../../../src/cli/babeltrace2.c:2673
>         #26 0x7fb07d5460b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)
> 
> The token variable in the process_dynamic_array_len function is
> allocated in the read_expect_type function, but is not freed before
> calling the read_token function.
> 
> Free the token variable before calling read_token in order to plug the
> leak.
> 
> Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>
> ---
>  tools/lib/traceevent/event-parse.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5b36c589a029..ba4f33804af1 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2861,6 +2861,7 @@ process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *arg,
>  	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
>  		goto out_err;
>  
> +	free_token(token);
>  	type = read_token(&token);
>  	*tok = token;
>  

