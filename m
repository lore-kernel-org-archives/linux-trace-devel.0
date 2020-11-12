Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D04C5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57ED020B80
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKLTOc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKLTOc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 14:14:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACDD020B80;
        Thu, 12 Nov 2020 19:14:31 +0000 (UTC)
Date:   Thu, 12 Nov 2020 14:14:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] libtracefs: Combine allocate and create APIs
 into one
Message-ID: <20201112141430.3e8d03e8@gandalf.local.home>
In-Reply-To: <20201112091109.1239169-5-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
        <20201112091109.1239169-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 11:11:07 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +struct tracefs_instance *tracefs_instance_create(const char *name)
>  {
> +	struct tracefs_instance *inst = NULL;
>  	struct stat st;
>  	char *path;
>  	int ret;
>  
> -	path = tracefs_instance_get_dir(instance);
> +	inst = instance_alloc(name);
> +	if (!inst)
> +		return NULL;
> +
> +	path = tracefs_instance_get_dir(inst);
>  	ret = stat(path, &st);
> -	if (ret < 0)
> -		ret = mkdir(path, 0777);
> -	else
> -		ret = 1;
> +	if (ret < 0) {
> +		/* Cannot create the top instance, if it does not exist! */
> +		if (!name)
> +			goto error;
> +		if (mkdir(path, 0777))

Not something you have to address now (but perhaps add a new patch?).
This should not be 0777, but instead be a macro, and define it as 0770, or
possibly even look at the permissions of the top level and use whatever
that is set as?

Again, this doesn't affect this series, but something we should change in
the near future.

-- Steve


> +			goto error;
> +		inst->flags |= FLAG_INSTANCE_NEWLY_CREATED;
> +	}
>  	tracefs_put_tracing_file(path);
> -	return ret;
> +	return inst;
> +
> +error:
> +	tracefs_instance_free(inst);
> +	return NULL;
>  }
>  
