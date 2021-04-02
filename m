Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE89C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E086108B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhDBON5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBON4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 10:13:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC8DF610E7;
        Fri,  2 Apr 2021 14:13:54 +0000 (UTC)
Date:   Fri, 2 Apr 2021 10:13:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH 3/6] libtracefs: Encapsulate "struct
 tracefs_options_mask"
Message-ID: <20210402101353.153208c3@gandalf.local.home>
In-Reply-To: <20210402131947.346235-4-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
        <20210402131947.346235-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  2 Apr 2021 16:19:44 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> @@ -197,6 +201,13 @@ enum tracefs_option_id tracefs_option_id(const char *name)
>  	return TRACEFS_OPTION_INVALID;
>  }
>  
> +static void tracefs_option_set(struct tracefs_options_mask *options,
> +			       enum tracefs_option_id id)

Patch is fine, but lets rename this function to:

	trace_option_set()

As functions named "tracefs_*()" should be used only by functions that are
for the API or will be for the API (staging functions).

-- Steve


> +{
> +	if (options && id > TRACEFS_OPTION_INVALID)
> +		options->mask |= (1ULL << (id - 1));
> +}
> +
>  static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
>  						      bool enabled)
>  {
