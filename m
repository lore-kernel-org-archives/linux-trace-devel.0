Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DE2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 04:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhKXELK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 23:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhKXELK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 23:11:10 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 259AC60F5D;
        Wed, 24 Nov 2021 04:08:01 +0000 (UTC)
Date:   Tue, 23 Nov 2021 23:07:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] trace-cmd: Use the new flow when creating
 output handler
Message-ID: <20211123230758.3be21343@rorschach.local.home>
In-Reply-To: <20211111150730.86323-1-tz.stoyanov@gmail.com>
References: <20211111150730.86323-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:07:30 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -4437,6 +4456,30 @@ static void write_guest_file(struct buffer_instance *instance)
>  	free(temp_files);
>  }
>  
> +static struct tracecmd_output *create_output(struct common_record_context *ctx)
> +{
> +	struct tracecmd_output *out;
> +	int fd;
> +
> +	fd = open(ctx->output, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);

I stopped at this patch because I really dislike the above.

Why don't we have:

	tracecmd_output_allocate(file);

and
	tracecmd_output_allocate_fd(fd);

Where tracecmd_output_allocate(file) does:

struct tracecmd_output *tracecmd_output_allocate(const char *file)
{
	int fd;

	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
	if (fd < 0)
		return NULL;
	return tracecmd_output_allocate_fd(fd);
}

?

Then we could remove a lot of these duplicate opens all over the place.

Although, I'm not sure I like the name allocate. It probably should be called:

tracecmd_output_create();

and we keep tracecmd_output_allocate() as is?

-- Steve


> +	if (fd < 0)
> +		return NULL;
> +
> +	out = tracecmd_output_allocate(fd);
> +	if (!out)
> +		goto error;
> +	if (tracecmd_output_write_headers(out, listed_events))
> +		goto error;
> +	return out;
> +error:
> +	if (out)
