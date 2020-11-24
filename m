Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55691C6379D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 15:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1CD8206FB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 15:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389913AbgKXPs5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:48:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388538AbgKXPs5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 10:48:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B668206F7;
        Tue, 24 Nov 2020 15:48:55 +0000 (UTC)
Date:   Tue, 24 Nov 2020 10:48:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>
Cc:     linux-trace-devel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-kernel@vger.kernel.org, broonie@kernel.org
Subject: Re: [RFC PATCH v2] tracing: Remove duplicate `type` field from
 regmap `regcache_sync` trace event
Message-ID: <20201124104854.430801a9@gandalf.local.home>
In-Reply-To: <20201124135730.9185-1-pduplessis@efficios.com>
References: <20201124135730.9185-1-pduplessis@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 Nov 2020 08:57:30 -0500
Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:

> I have an error saying that `regcache_sync` has 2 fields named `type`
> while using libtraceevent.
> 
> Erase the `int field` type, which is not assigned. This field is
> introduced by mistake and this commit removes it.
> 
> Fixes commit 593600890110c ("regmap: Add the regcache_sync trace event")
> 
> Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> ---
>  drivers/base/regmap/trace.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/base/regmap/trace.h b/drivers/base/regmap/trace.h
> index d4066fa079ab..9abee14df9ee 100644
> --- a/drivers/base/regmap/trace.h
> +++ b/drivers/base/regmap/trace.h
> @@ -126,7 +126,6 @@ TRACE_EVENT(regcache_sync,
>  		__string(       name,           regmap_name(map)	)
>  		__string(	status,		status			)
>  		__string(	type,		type			)
> -		__field(	int,		type			)
>  	),
>  
>  	TP_fast_assign(

