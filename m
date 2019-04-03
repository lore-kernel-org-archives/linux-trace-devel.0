Return-Path: <SRS0=MeYK=SF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368F7C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 12:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106102148E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Apr 2019 12:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfDCMzR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 08:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfDCMzR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 08:55:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC2D2147C;
        Wed,  3 Apr 2019 12:55:16 +0000 (UTC)
Date:   Wed, 3 Apr 2019 08:55:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v9 11/11] trace-cmd: Add splice() recording from
 FIFO without additional pipe buffer
Message-ID: <20190403085515.1652201a@gandalf.local.home>
In-Reply-To: <20190402134540.32321-12-kaslevs@vmware.com>
References: <20190402134540.32321-1-kaslevs@vmware.com>
        <20190402134540.32321-12-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  2 Apr 2019 16:45:40 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> +/*
> + * Returns -1 on error.
> + *          or bytes of data read.
> + */
> +static long direct_splice_data(struct tracecmd_recorder *recorder)
> +{
> +	struct pollfd pfd = {
> +		.fd = recorder->trace_fd,
> +		.events = POLLIN,
> +	};
> +	long read;
> +	int ret;
> +
> +	ret = poll(&pfd, 1, POLL_TIMEOUT_MS);
> +	if (ret < 0)
> +		return -1;
> +
> +	if (!(pfd.revents | POLLIN))
> +		return 0;

Why the polling code, and not just block on splice?

-- Steve

> +
> +	read = splice(recorder->trace_fd, NULL, recorder->fd, NULL,
> +		      recorder->pipe_size, recorder->trace_fd_flags);
> +	if (read < 0) {
> +		if (errno == EAGAIN || errno == EINTR)
> +			return 0;
> +
> +		warning("recorder error in splice input");
> +		return -1;
> +	}
> +
> +	return read;
> +}
> +
