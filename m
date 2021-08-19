Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F904C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0F4C610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhHSQuN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 12:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSQuN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 12:50:13 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C76610A5;
        Thu, 19 Aug 2021 16:49:36 +0000 (UTC)
Date:   Thu, 19 Aug 2021 12:49:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 4/5] libtraceevent: Optimize tep_print_fields()
Message-ID: <20210819124929.741d6453@oasis.local.home>
In-Reply-To: <20210812085929.54832-5-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
        <20210812085929.54832-5-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 11:59:28 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> -void tep_print_field(struct trace_seq *s, void *data,
> -		     struct tep_format_field *field)
> +void static inline _tep_print_field(struct trace_seq *s, void *data,
> +				    struct tep_format_field *field,
> +				    struct tep_print_parse **parse_ptr)

Same here. We should call this simply "print_field()".

-- Steve

>  {
>  	struct tep_event *event = field->event;
> +	struct tep_print_parse *start_parse;
>  	struct tep_print_parse *parse;
>  	bool has_0x;
