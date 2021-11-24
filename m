Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A4EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 03:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhKXDtM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231872AbhKXDtM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 22:49:12 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAB860F58;
        Wed, 24 Nov 2021 03:46:02 +0000 (UTC)
Date:   Tue, 23 Nov 2021 22:46:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] trace-cmd library: New API for setting a
 custom kallsyms to an output handler
Message-ID: <20211123224601.39db5d1c@rorschach.local.home>
In-Reply-To: <20211111150658.86228-1-tz.stoyanov@gmail.com>
References: <20211111150658.86228-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:06:58 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms)
> +{
> +	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
> +		return -1;
> +
> +	free(handler->kallsyms);

Nit, this isn't a fast path, so the code could be a little cleaner with:

	handler->kallsyms = NULL;

here

> +	if (kallsyms) {
> +		handler->kallsyms = strdup(kallsyms);
> +		if (!handler->kallsyms)
> +			return -1;
> +	} else
> +		handler->kallsyms = NULL;

Then removing the else case.

-- Steve

> +
> +	return 0;
> +}
> +
