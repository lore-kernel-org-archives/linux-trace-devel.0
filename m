Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbeITJKZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 05:10:25 -0400
Date: Wed, 19 Sep 2018 23:29:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 4/7] kernel-shark-qt: Make kshark_read_at()
 non-static.
Message-ID: <20180919232913.63a73b05@vmware.local.home>
In-Reply-To: <20180919143657.19472-5-y.karadz@gmail.com>
References: <20180919143657.19472-1-y.karadz@gmail.com>
        <20180919143657.19472-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 19 Sep 2018 17:36:54 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> +/**
> + * @brief A thread-safe read of a record from a specific offset.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param offset: the offset into the file to find the record.
> + *
> + * @returns The returned pevent_record must be freed.
> + */
> +struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
> +				  uint64_t offset)
>  {
>  	/*
>  	 * It turns that tracecmd_read_at() is not thread-safe.

This code still has:

	/*
	 * It turns that tracecmd_read_at() is not thread-safe.
	 * TODO: Understand why and see if this can be fixed.
	 * For the time being use a mutex to protect the access.
	 */

Remind me to explain to you why this is the case. It wont be easy to
have it fixed.

-- Steve
