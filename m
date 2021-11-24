Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87710C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 03:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbhKXDkm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240863AbhKXDkk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 22:40:40 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C4B160F50;
        Wed, 24 Nov 2021 03:37:31 +0000 (UTC)
Date:   Tue, 23 Nov 2021 22:37:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] trace-cmd library: New API for allocating an
 output handler
Message-ID: <20211123223729.3cbec889@rorschach.local.home>
In-Reply-To: <20211111150321.85979-2-tz.stoyanov@gmail.com>
References: <20211111150321.85979-1-tz.stoyanov@gmail.com>
        <20211111150321.85979-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:03:12 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracecmd_output_allocate - allocate new output handler to a trace file
> + * @handle: file descriptor to an empty file, it can be -1 if the handler
> + *	    will not write to a file

Nit, but technically, the parameter description should fit on one line.
If more needs to be said about it, it can be done in the description,
where every reference of the name has the "@" attached to it.

I only mentioned this because I noticed it in a few places already.

-- Steve

> + *
> + * This API only allocates a handler and performs minimal initialization.
> + * No data is written in the file.
> + *
> + * Returns pointer to a newly allocated file descriptor, that can be used
> + * with other library APIs. In case of an error, NULL is returned. The returned
> + * handler must be freed with tracecmd_output_close() or tracecmd_output_free()
> + */
> +struct tracecmd_output *tracecmd_output_allocate(int fd)
> +{
> +	struct tracecmd_output *handle;
> +
> +	handle = calloc(1, sizeof(*handle));
> +	if (!handle)
> +		return NULL;
> +
> +	handle->fd = fd;
> +
> +	handle->file_version = FILE_VERSION;
> +
> +	handle->page_size = getpagesize();
> +	handle->big_endian = tracecmd_host_bigendian();
> +
> +	list_head_init(&handle->options);
> +
> +	handle->file_state = TRACECMD_FILE_ALLOCATED;
> +
> +	return handle;
> +}
> +
> +
>  static int select_file_version(struct tracecmd_output *handle,
>  				struct tracecmd_input *ihandle)
>  {

