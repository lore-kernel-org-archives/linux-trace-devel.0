Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC87C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D28C564E3F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 22:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBWWW7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 17:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhBWWW6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 17:22:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5B764E00;
        Tue, 23 Feb 2021 22:22:16 +0000 (UTC)
Date:   Tue, 23 Feb 2021 17:22:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add new API for open trace marker file
Message-ID: <20210223172214.03b05e3c@gandalf.local.home>
In-Reply-To: <20210219055353.2244340-1-tz.stoyanov@gmail.com>
References: <20210219055353.2244340-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Feb 2021 07:53:53 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +/**
> + * tracefs_trace_marker_get_fd - Get a file descriptor of "trace_marker" in
> + * given instance
> + * @instance: ftrace instance, can be NULL for the top instance
> + *
> + * Returns -1 in case of an error, or a valid file descriptor to "trace_marker"
> + * file for reading and writing. The returned FD must be closed with close().
> + */
> +static inline int tracefs_trace_marker_get_fd(struct tracefs_instance *instance)
> +{
> +	return tracefs_instance_file_open(instance, "trace_marker", O_RDWR);

And this should be opened with "O_WRONLY", as trace_marker can't be read.

-- Steve

> +}
> +
