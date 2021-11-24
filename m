Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B9AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhKXRZS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236319AbhKXRZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:25:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9F56069B;
        Wed, 24 Nov 2021 17:22:05 +0000 (UTC)
Date:   Wed, 24 Nov 2021 12:22:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] trace-cmd library: Helper logic to update the
 trace buffer offset
Message-ID: <20211124122203.51a1dd40@gandalf.local.home>
In-Reply-To: <20211111150805.86419-4-tz.stoyanov@gmail.com>
References: <20211111150805.86419-1-tz.stoyanov@gmail.com>
        <20211111150805.86419-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:08:04 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1395,6 +1395,20 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
> +{


>  
> +static int update_buffer_cpu_offset(struct tracecmd_output *handle,
> +				    const char *name, tsize_t offset)
> +{

Let's not have patches that add static functions that are not used.

They should be added when they are used. I may just merge the patches.

-- Steve
