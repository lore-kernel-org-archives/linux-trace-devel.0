Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A45C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 03:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240565AbhKXDoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:44:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240538AbhKXDoT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 22:44:19 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB8D60F58;
        Wed, 24 Nov 2021 03:41:09 +0000 (UTC)
Date:   Tue, 23 Nov 2021 22:41:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] trace-cmd library: New API for setting a
 message context to an output handler
Message-ID: <20211123224108.26726fd4@rorschach.local.home>
In-Reply-To: <20211111150321.85979-3-tz.stoyanov@gmail.com>
References: <20211111150321.85979-1-tz.stoyanov@gmail.com>
        <20211111150321.85979-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:03:13 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracecmd_output_set_msg - associated an output file handler with network message handler
> + * @handle: output handler to a trace file.
> + * @msg_handle: network handler, allocated by tracecmd_msg_handle_alloc()
> + *
> + * This API associates an output file handler with a network stream. All subsequent API calls

Nit. You don't need to say "API". We know it's an API ;-)

  "Associate the output file handle @handle with a network stream @msg_handle.
   All transactions of @handle after this will send data over the network ...


> + * with this output file handler will send data over the network using the @msg_handle, instead
> + * of writing to a file.
> + * This API must be called after the handler file version is set and before

   "This must be called after the handler ..."

No need to update for this. I'll leave it be. But more FYI.

We could always clean up the comments at a later time. This doesn't
affect the API ;-)

-- Steve

> + * tracecmd_output_write_init().
> + *
> + * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
> + */
> +int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg_handle *msg_handle)
> +{
> +	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
> +		return -1;
> +
> +	handler->msg_handle = msg_handle;
> +
> +	return 0;
> +}
>  
>  static int select_file_version(struct tracecmd_output *handle,
>  				struct tracecmd_input *ihandle)

