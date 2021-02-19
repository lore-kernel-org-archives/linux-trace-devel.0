Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1205AC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 14:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FC964DDA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 14:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSO1l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 09:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhBSO1Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 09:27:25 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4981B64E46;
        Fri, 19 Feb 2021 14:26:44 +0000 (UTC)
Date:   Fri, 19 Feb 2021 09:26:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add new API for open trace marker file
Message-ID: <20210219092642.0f496a19@gandalf.local.home>
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

> Added new API for opening trace_marker file of given instance:
>    tracefs_trace_marker_get_fd();
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>

As I wrote the perf-trace.c program, I was thinking what we really should
have is the following API. We can keep this API, but what would be nice is:


	int tracefs_print_init(struct tracefs_instance *instance);

	int tracefs_print(struct tracefs_instance *instance,
			 const char *fmt, ...);

	int tracefs_vprint(struct tracefs_instance *instance,
			   const char *fmt, va_list ap);

	void tracefs_print_reset(struct tracefs_instance *instance);

Where tracefs_print_init() will open the trace_marker for that instance
(NULL being the top level), and storing it in the instance structure.

tracefs_print() and tracefs_vprint() will check if the trace_marker file
has already been opened (tracefs_print_init() was previously called), and
if not, it will open it and keep it open. Then it will write to the
trace_marker file the passed in print data after formatting it (see my
trace_print in perf-trace.c).

The tracefs_print_reset() will simply close the trace_marker file if it was
previously opened, note, so will any of the destructors of the instance.

We could also have:

	int tracefs_raw_print_init(struct tracefs_instance *instance);

	int tracefs_raw_print(struct tracefs_instance *instance,
			  void *data, int len);

	void tracefs_raw_print_reset(struct tracefs_instance *instance);


That is the same, but instead of writing string data to the trace_marker,
it would write in memory into trace_marker_raw.

-- Steve
