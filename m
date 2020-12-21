Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A5CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 17:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E48D22C9C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 17:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgLURWh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgLURWh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 12:22:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA832220F;
        Mon, 21 Dec 2020 17:21:56 +0000 (UTC)
Date:   Mon, 21 Dec 2020 12:21:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] libtracefs man pages: helper APIs for working
 with trace file system.
Message-ID: <20201221122154.2a8516e8@gandalf.local.home>
In-Reply-To: <20201221060252.177890-9-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
        <20201221060252.177890-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Dec 2020 08:02:52 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +DESCRIPTION
> +-----------
> +Various useful functions for working with trace file system.
> +
> +The _tracefs_tracers()_ function returns array of strings with the
> +names of supported tracer plugins, located in the given _tracing_dir_ directory.
> +This could be NULL or tracefs mount point, for trace systems in top instance,
> +or full path to a trace instance, for trace systems in that instance.
> +The last entry in the array as a NULL pointer. The array must
> +be freed with _tracefs_list_free()_ API.

The description above needs to be updated as well.

-- Steve

> +
> +The _tracefs_get_clock()_ function returns name of the current trace clock,
> +used in the given _instance_. If _instance_ is NULL, the clock of the main
> +trace instance is returned. The returned string must be freed with free().
> +
> +The _tracefs_list_free()_ function frees an array of strings, returned by
> +_tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
> +APIs.
> +
