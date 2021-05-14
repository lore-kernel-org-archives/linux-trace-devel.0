Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA0BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6F56144C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhENNeS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232021AbhENNeS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:34:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64BE6145D;
        Fri, 14 May 2021 13:33:06 +0000 (UTC)
Date:   Fri, 14 May 2021 09:33:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 7/7] kernel-shark: Quiet the warning printing from
 libtraceevent
Message-ID: <20210514093305.7d469db0@gandalf.local.home>
In-Reply-To: <20210514121826.161749-8-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
        <20210514121826.161749-8-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 15:18:26 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> All those warning messages are not really relevant for the users
> of the GUI.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-tepdata.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 4a84141..323383f 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -45,6 +45,14 @@ static bool init_thread_seq(void)
>  	return seq.buffer != NULL;
>  }
>  
> +//! @cond Doxygen_Suppress
> +
> +void tep_warning(const char *fmt, ...) {}
> +
> +void pr_stat(const char *fmt, ...) {}
> +
> +//! @endcond
> +
>  /** Structure for handling all unique attributes of the FTRACE data. */
>  struct tepdata_handle {
>  	/** Page event used to parse the page. */

We released libtraceevent 1.3 that has the new logging by Tzvetomir. You
can set it to be quiet without the need to redefine these functions (which
have also been labeled as deprecated).

-- Steve
