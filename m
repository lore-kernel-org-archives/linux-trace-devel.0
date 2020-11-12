Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3DBC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 05:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74FC9208FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 05:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgKLFiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgKLBbd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 20:31:33 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFEC206F1;
        Thu, 12 Nov 2020 01:31:32 +0000 (UTC)
Date:   Wed, 11 Nov 2020 20:31:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] libtracefs: Add new tracefs API
 tracefs_instances_walk()
Message-ID: <20201111203130.38d68859@oasis.local.home>
In-Reply-To: <20201110122249.911664-6-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
        <20201110122249.911664-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 10 Nov 2020 14:22:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
\> +
> +/**
> + * tracefs_instances_walk - Iterate through all ftrace instances in the system
> + * @callback: user callback, called for each instance. Instance name is passed
> + *	      as input parameter. If the @callback returns non-zero,
> + *	      the iteration stops.
> + * @context: user context, passed to the @callback.
> + *
> + * Returns -1 in case of an error, 0 otherwise.
> + */
> +int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
> +{
> +	struct dirent *dent;
> +	char *path = NULL;
> +	DIR *dir = NULL;
> +	struct stat st;
> +	int fret = -1;
> +	int ret;
> +
> +	path = tracefs_get_tracing_file("instances");
> +	if (!path)
> +		return -1;
> +	ret = stat(path, &st);
> +	if (ret < 0 || !S_ISDIR(st.st_mode))
> +		goto out;
> +
> +	dir = opendir(path);
> +	if (!dir)
> +		goto out;
> +	fret = 0;
> +	while ((dent = readdir(dir))) {
> +		char *instance;
> +
> +		if (strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0)
> +			continue;
> +		instance = trace_append_file(path, dent->d_name);
> +		ret = stat(instance, &st);
> +		free(instance);
> +		if (ret < 0 || !S_ISDIR(st.st_mode))
> +			continue;
> +		if (callback(dent->d_name, context))

Should we notify the caller of this function if the callback returned
non zero?


> +			break;
> +	}
> +
> +out:

Hmm, would dir ever be anything but non NULL here?

-- Steve

> +	if (dir)
> +		closedir(dir);
> +	tracefs_put_tracing_file(path);
> +	return fret;
> +}
