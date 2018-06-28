Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936267AbeF1Xoq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 19:44:46 -0400
Date: Thu, 28 Jun 2018 19:44:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] kernel-shark-qt: Add filtering to the C API of
 KernelShark
Message-ID: <20180628194443.75b7b1e6@gandalf.local.home>
In-Reply-To: <20180628163012.21477-7-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-7-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 19:30:09 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * @brief This function loops over the array of entries specified by "data"
> + * and "n_entries" and sets the "visible" fields of each entry according to
> + * the criteria provided by the filters of the session's context. The field
> + * "filter_mask" of the session's context is used to control the level of
> + * visibility/invisibility of the entries which are filtered-out.
> + * @param kshark_ctx: kshark_ctx: Input location for the session context

Double "kshark_ctx:"

-- Steve


> + * pointer.
> + * @param data: Input location for the trace data to be filtered.
> + * @param n_entries: The size of the inputted data.
> + */
> +void kshark_filter_entries(struct kshark_context *kshark_ctx,
> +			   struct kshark_entry **data,
> +			   size_t n_entries);
> +
>  #ifdef __cplusplus
>  }
>  #endif
> -- 
