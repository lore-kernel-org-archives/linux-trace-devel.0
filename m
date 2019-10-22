Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAC9CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 19:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EC121783
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 19:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbfJVTKJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbfJVTKJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 15:10:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF0821783;
        Tue, 22 Oct 2019 19:10:08 +0000 (UTC)
Date:   Tue, 22 Oct 2019 15:10:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v12 7/9] trace-cmd: Implemented new API
 tracecmd_add_option_v()
Message-ID: <20191022151007.77224d78@gandalf.local.home>
In-Reply-To: <20190828085746.26231-8-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
        <20190828085746.26231-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 11:57:44 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracecmd_add_option - add options to the file
> + * @handle: the output file handle name
> + * @id: the id of the option
> + * @size: the size of the option data
> + * @data: the data to write to the file.
> + *
> + * Returns handle to update option if needed.
> + *  Just the content can be updated, with smaller or equal to
> + *  content than the specified size.
> + */
> +struct tracecmd_option *
> +tracecmd_add_option(struct tracecmd_output *handle,
> +		    unsigned short id, int size, const void *data)
> +{
> +	struct iovec vect;
> +
> +	vect.iov_base = (void *) data;

Remove the space between (void *) and data.

> +	vect.iov_len = size;
> +	return tracecmd_add_option_v(handle, id, &vect, 1);
> +}
> +
>  int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
>  {
>  	cpus = convert_endian_4(handle, cpus);
> @@ -979,6 +1013,56 @@ int tracecmd_write_options(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +int tracecmd_append_options(struct tracecmd_output *handle)

Hmm, this was added with no users, and was not mentioned in the change
log. Probably belongs in another patch.

-- Steve

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
> +
> +	return 0;
> +}
> +
>  int tracecmd_update_option(struct tracecmd_output *handle,
>  			   struct tracecmd_option *option, int size,
>  			   const void *data)

