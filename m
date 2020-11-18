Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2096FC5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B993D221EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgKRVoU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgKRVoT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 16:44:19 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB03246DE;
        Wed, 18 Nov 2020 21:44:18 +0000 (UTC)
Date:   Wed, 18 Nov 2020 16:44:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 5/8] libtracefs: Combine allocate and create APIs
 into one
Message-ID: <20201118164416.4cf12941@oasis.local.home>
In-Reply-To: <20201117074557.180602-6-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
        <20201117074557.180602-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 17 Nov 2020 09:45:54 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  
> +static mode_t get_trace_file_permissions(char *name)
> +{
> +	mode_t rmode = 0;
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracefs_get_tracing_file(name);
> +	if (!path)
> +		return 0;
> +	ret = stat(path, &st);
> +	if (ret)
> +		goto out;
> +	rmode = st.st_mode & ACCESSPERMS;
> +out:
> +	tracefs_put_tracing_file(path);
> +	return rmode;
> +}
> +
> +/**
> + * tracefs_instance_is_new - Check if the instance is newly created by the library
> + * @instance: Pointer to an ftrace instance
> + *

This part should be a separate patch. I decided to break it up into two
patches (the following emails) instead of having you send another
version. Just let me know if what I have is good for you.

-- Steve
