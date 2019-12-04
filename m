Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE68CC43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8992C20674
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfLDVr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 16:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfLDVr1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 16:47:27 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F7A20674;
        Wed,  4 Dec 2019 21:47:26 +0000 (UTC)
Date:   Wed, 4 Dec 2019 16:47:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 08/18] trace-cmd: Implement new API
 tracecmd_add_option_v()
Message-ID: <20191204164724.3b1d7662@gandalf.local.home>
In-Reply-To: <20191203103522.482684-9-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:12 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -1046,6 +1083,57 @@ int tracecmd_write_options(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +int tracecmd_append_options(struct tracecmd_output *handle)
> +{
> +	struct tracecmd_option *options;
> +	unsigned short option;
> +	unsigned short endian2;
> +	unsigned int endian4;
> +	off_t offset;
> +	int r;
> +
> +	/* If already written, ignore */
> +	if (handle->options_written)
> +		return 0;
> +
> +	if (lseek64(handle->fd, 0, SEEK_END) == (off_t)-1)
> +		return -1;
> +	offset = lseek64(handle->fd, -2, SEEK_CUR);
> +	if (offset == (off_t)-1)
> +		return -1;
> +
> +	r = pread(handle->fd, &option, 2, offset);
> +	if (r != 2 || option != TRACECMD_OPTION_DONE)
> +		return -1;
> +
> +	list_for_each_entry(options, &handle->options, list) {
> +		endian2 = convert_endian_2(handle, options->id);
> +		if (do_write_check(handle, &endian2, 2))
> +			return -1;
> +
> +		endian4 = convert_endian_4(handle, options->size);
> +		if (do_write_check(handle, &endian4, 4))
> +			return -1;
> +
> +		/* Save the data location in case it needs to be updated */
> +		options->offset = lseek64(handle->fd, 0, SEEK_CUR);
> +
> +		if (do_write_check(handle, options->data,
> +				   options->size))
> +			return -1;
> +	}
> +
> +	option = TRACECMD_OPTION_DONE;
> +
> +	if (do_write_check(handle, &option, 2))
> +		return -1;
> +
> +	handle->options_written = 1;
> +	handle->options_written = 1;

I think I'm seeing double.

-- Steve

> +
> +	return 0;
> +}
> +
>  int tracecmd_update_option(struct tracecmd_output *handle,
>  			   struct tracecmd_option *option, int size,
>  			   const void *data)

