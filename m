Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02F1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C39A6145E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhENNTT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233889AbhENNTQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:19:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AD36145E;
        Fri, 14 May 2021 13:18:04 +0000 (UTC)
Date:   Fri, 14 May 2021 09:18:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Better warning print-out
Message-ID: <20210514091803.2115f6fc@gandalf.local.home>
In-Reply-To: <20210514122825.162203-1-y.karadz@gmail.com>
References: <20210514122825.162203-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 15:28:25 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I see no new line when the messages are printed from KernelShark.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/trace-seq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/trace-seq.c b/src/trace-seq.c
> index 8d5ecd2..6aee07a 100644
> --- a/src/trace-seq.c
> +++ b/src/trace-seq.c
> @@ -22,7 +22,7 @@
>  #define TRACE_SEQ_CHECK(s)						\
>  do {									\
>  	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
> -		      "Usage of trace_seq after it was destroyed"))	\
> +		      "Usage of trace_seq after it was destroyed\n"))	\
>  		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
>  } while (0)
>  
> @@ -85,7 +85,7 @@ static void expand_buffer(struct trace_seq *s)
>  	char *buf;
>  
>  	buf = realloc(s->buffer, s->buffer_size + TRACE_SEQ_BUF_SIZE);
> -	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory")) {
> +	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory\n")) {
>  		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
>  		return;
>  	}

This comes from the Linux kernel which doesn't require the message to
contain a new line.

Would this patch work instead?

diff --git a/include/asm/bug.h b/include/asm/bug.h
index 550223f..de8f8fe 100644
--- a/include/asm/bug.h
+++ b/include/asm/bug.h
@@ -5,7 +5,7 @@
 #include <linux/compiler.h>
 #include <stdio.h>
 
-#define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
+#define __WARN_printf(arg...)	do { fprintf(stderr, arg); fprintf(stderr, "\n");} while (0)
 
 #define WARN(condition, format...) ({		\
 	int __ret_warn_on = !!(condition);	\
