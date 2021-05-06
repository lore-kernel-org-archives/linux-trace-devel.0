Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D89C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CA861154
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 18:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhEFSMw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 14:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231585AbhEFSMw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 14:12:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B86661289;
        Thu,  6 May 2021 18:11:53 +0000 (UTC)
Date:   Thu, 6 May 2021 14:11:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
Message-ID: <20210506141151.2f31f263@gandalf.local.home>
In-Reply-To: <20210428134730.187533-4-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
        <20210428134730.187533-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Apr 2021 16:47:24 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The KS_DEFINE_PLUGIN_CONTEXT macro implements methods that are used
> to deal with plugin-specific context objects. However, when this macro
> is used in multiple plugins and those plugins are loaded together
> the symbol resolving fails, resulting in undefined behavior. Namely,
> version of the function from one plugin, being called by another
> plugin. Here we make sure that the methods defined in
> KS_DEFINE_PLUGIN_CONTEXT are not visible outside of the corresponding
> plugin.
> 
> Fixing: 15df009 (kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro)
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark-plugin.h     | 22 ++++++++++++++++++----
>  src/plugins/sched_events.c |  3 +++
>  src/plugins/sched_events.h |  3 +--
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
> index c110616..752dbeb 100644
> --- a/src/libkshark-plugin.h
> +++ b/src/libkshark-plugin.h
> @@ -24,6 +24,8 @@ extern "C" {
>  /* Quiet warnings over documenting simple structures */
>  //! @cond Doxygen_Suppress
>  
> +#define __hidden __attribute__((visibility ("hidden")))
> +
>  #define _MAKE_STR(x)	#x
>  
>  #define MAKE_STR(x)	_MAKE_STR(x)
> @@ -364,11 +366,14 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
>  	__ok;								\
>  })									\
>  
> -/** General purpose macro defining methods for adding plugin context. */
> +/**
> + * General purpose macro defining methods for adding plugin context.
> + * Do not use this macro in header files.
> + */
>  #define KS_DEFINE_PLUGIN_CONTEXT(type)					\
>  static type **__context_handler;					\
>  static ssize_t __n_streams = -1;					\
> -static inline type *__init(int sd)					\
> +__hidden type *__init(int sd)						\

This is strange, because static inline should never be a problem in this
regard (otherwise things will break elsewhere too).

static is never exported (it's stronger than "hidden").

Can you show me how you see this error, because this solution does not make
any sense.

-- Steve
