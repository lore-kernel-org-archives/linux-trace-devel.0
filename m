Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8257C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A200361477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhF3PJH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 11:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235352AbhF3PJG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 11:09:06 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8262D61420;
        Wed, 30 Jun 2021 15:06:37 +0000 (UTC)
Date:   Wed, 30 Jun 2021 11:06:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix bug in tep_print_event()
Message-ID: <20210630110635.57411548@oasis.local.home>
In-Reply-To: <20210630141913.20675-1-y.karadz@gmail.com>
References: <20210630141913.20675-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 30 Jun 2021 17:19:13 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> {
>  	struct print_event_type type;
> -	char *format = strdup(fmt);
> -	char *current = format;
> -	char *str = format;
> +	char *format, *current, *str;

Nit, but please keep the above each on a separate line.

	char *current;
	char *format;
	char *str;

I try to avoid having pointers on a single line, it's just easier to
manage when they are separate.

Thanks!

-- Steve

>  	int offset;
>  	va_list args;
>  	struct tep_event *event;
>  
> +	event = tep_find_event_by_record(tep, record);
> +	if (!event) {
> +		trace_seq_printf(s, "[UNKNOWN EVENT]");
> +		return;
> +	}
> +
> +	str = current = format = strdup(fmt);
>  	if (!format)
>  		return;
