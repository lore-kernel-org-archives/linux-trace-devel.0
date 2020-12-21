Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 812B2C433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 16:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB4322525
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 16:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgLUQwA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 11:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLUQwA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 11:52:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0FC22C9C;
        Mon, 21 Dec 2020 16:51:19 +0000 (UTC)
Date:   Mon, 21 Dec 2020 11:51:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] libtracefs man pages: APIs for managing trace
 instances.
Message-ID: <20201221115117.1d9e5f0b@gandalf.local.home>
In-Reply-To: <20201221060252.177890-5-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
        <20201221060252.177890-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Dec 2020 08:02:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +RETURN VALUE
> +------------
> +The _tracefs_instance_create()_ function returns a pointer to a newly allocated
> +tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
> +_tracefs_instance_free()_.
> +
> +The _tracefs_instance_destroy()_ function returns -1 in case of an error,
> +or 0 otherwise.
> +
> +The _tracefs_instance_is_new()_ function returns true if the
> +_tracefs_instance_create() that allocated _instance_ also created the

Missing underscore after "_tracefs_instance_create()", which caused a
run-away underlining. I fixed it.

-- Steve


> +trace instance in the system, or false if the trace instance already
> +existed in the system when _instance_ was allocated by
> +_tracefs_instance_create()_.
> +
