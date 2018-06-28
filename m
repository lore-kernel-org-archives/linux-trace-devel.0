Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeF1Uch (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 16:32:37 -0400
Date: Thu, 28 Jun 2018 16:32:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180628163235.3a2422f7@gandalf.local.home>
In-Reply-To: <20180628163012.21477-4-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
        <20180628163012.21477-4-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 28 Jun 2018 19:30:06 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> new file mode 100644
> index 0000000..8f4059a
> --- /dev/null
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -0,0 +1,475 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +

[..]
> +}
> +
> +bool kshark_instance(struct kshark_context **context)
> +{
> +	if (*context == NULL && kshark_context_handler == NULL) {
> +		/* No kshark_context exists. Create a default one. */
> +		bool status = kshark_default_context(context);
> +		if (status)
> +			return status;
> +	} else if (*context != NULL) {
> +		/* Use the context provided by the user. */
> +		if (kshark_context_handler)
> +			kshark_free(kshark_context_handler);
> +
> +		kshark_context_handler = *context;
> +	} else {
> +		/*
> +		 * No context is provided by the user, but the context handler
> +		 * is already set. Use the context handler.
> +		 */
> +		*context = kshark_context_handler;
> +	}
> +
> +	if (!seq.buffer)
> +		trace_seq_init(&seq);
> +
> +	if (!seq.buffer)
> +		return false;
> +
> +	return true;
> +}
> +
[..]

> diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
> new file mode 100644
> index 0000000..da5359a
> 

> +
> +/**
> + * @brief Initialize a kshark session. This function must be called before
> + * calling any other kshark function. If the session has been initialized,
> + * this function can be used to obtain the session's context.
> + * @param kshark_ctx: Optional input/output location for context pointer.
> + * Only valid on return true.
> + * @returns true on success, or false on failure.
> +
> + */
> +bool kshark_instance(struct kshark_context **kshark_ctx);
> +

Keeping with the Linux styling, it is preferred to have the descriptive
comments above the C function and not the prototype.

I understand the rational for having it above the prototype, because
you would think that's where people may look if they don't have the
source (just the headers). But realistically, people who use etags and
such, when they want to see a function, the vim and emacs commands will
bring the user to the C code and not the prototype. This is why Linux
enforces the comments above the C code.

Please keep the comments above the C function (move them to the .c file)
If you are using the headers for documentation, it would probably be
easier to read about them from the output of the doxygen documentation.

-- Steve
