Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6593C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 16:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9028522B51
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 16:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgLUQSz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 11:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLUQSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 11:18:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166C922B51;
        Mon, 21 Dec 2020 16:18:14 +0000 (UTC)
Date:   Mon, 21 Dec 2020 11:18:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] libtracefs man pages: APIs for working with
 trace systems and events.
Message-ID: <20201221111812.7631fbbc@gandalf.local.home>
In-Reply-To: <20201221060252.177890-4-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
        <20201221060252.177890-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Dec 2020 08:02:47 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
> +char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
> +int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +Trace systems and events related APIs.
> +
> +The _tracefs_event_systems()_ function returns array of strings with the
> +names of all registered trace systems, located in the given _tracing_dir_
> +directory. This could be NULL or the location of the tracefs mount point
> +for the trace systems of the local machine, or it may be a path to a copy
> +of the tracefs directory from another machine. The last entry in the array
> +is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
> +
> +The _tracefs_system_events()_ function returns array of strings with the
> +names of all registered trace events for given trace system specified by
> +_system_, located in the given _tracing_dir_ directory. This could be NULL
> +or the location of the tracefs mount point for the trace systems of the
> +local machine, or it may be a path to a copy of the tracefs directory
> +from another machine. The last entry in the array as a NULL pointer.
> +The array must be freed with _tracefs_list_free()_ API.
> +
> +The _tracefs_interate_raw_events()_ function will read the tracefs raw
> +data buffers and call the specified _callback_ function for every event it
> +encounters. An initialized _tep_ handler is required (See
> +_tracefs_local_events_(3)). If _instance_ is NULL, then the toplevel
> +tracefs buffer is used, otherwise the buffer for the corresponding
> +_instance_ is read. To filter only on a subset of CPUs, _cpus_ and
> +_cpu_size_ may be set to only call _callback_ with events that occurred on
> +the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
> +function will be called for all events, and _cpu_size_ is ignored. The
> +_callback_ function will be called with the following parameters: A
> +pointer to a struct tep_event that corresponds to the type of event the
> +record is; The record representing the event; The CPU that the event
> +occurred on; and a pointer to user specified _context_. If the _callback_

I changed "_context_" to "_callback_context_" as it should match the name
used above in the function prototype.

-- Steve

> +returns non-zero, the iteration stops.
