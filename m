Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965DCC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 19:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691C760FF1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 19:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhDPT24 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243512AbhDPT2s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3826060FF1;
        Fri, 16 Apr 2021 19:28:23 +0000 (UTC)
Date:   Fri, 16 Apr 2021 15:28:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] trace-cmd: Get the timestamp of the first
 recorded event as TSC offset
Message-ID: <20210416152821.2d954280@gandalf.local.home>
In-Reply-To: <20210416103409.24597-4-tz.stoyanov@gmail.com>
References: <20210416103409.24597-1-tz.stoyanov@gmail.com>
        <20210416103409.24597-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 13:34:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +int get_first_ts_instance(struct buffer_instance *instance)
> +{
> +	struct tracecmd_ts_corrections corrections;
> +	unsigned long long first_ts = 0;
> +	enum kbuffer_long_size long_size;
> +	enum kbuffer_endian endian;
> +	struct kbuffer *kbuf = NULL;

Small nit, but I'll leave it as it doesn't really hurt anything. But
assigning kbuf to NULL isn't needed. It gets assigned in the
kbuffer_alloc() before it is ever referenced, and the only error path
before that is a return. But if we ever add another error path, it's safe
to have it NULL.

-- Steve


> +	unsigned long long ts;
> +	unsigned int flags;
> +	int first_ts_cpu;
> +	bool first = true;
> +	char *page;
> +	char *file;
> +	int psize;
> +	int ret;
> +	int i;
> +
> +	psize = getpagesize();
> +	page = calloc(1, psize);
> +	if (!page)
> +		return -1;
> +
> +	if (tracecmd_host_bigendian())
> +		endian = KBUFFER_ENDIAN_BIG;
> +	else
> +		endian = KBUFFER_ENDIAN_LITTLE;
> +	if (sizeof(long) == 8)
> +		long_size = KBUFFER_LSIZE_8;
> +	else
> +		long_size = KBUFFER_LSIZE_4;
> +
> +	kbuf = kbuffer_alloc(long_size, endian);
> +	if (!kbuf)
> +		goto out;
> +
