Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5C6C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A7123B01
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgLRStw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgLRStw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 13:49:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42A7F23B01;
        Fri, 18 Dec 2020 18:49:11 +0000 (UTC)
Date:   Fri, 18 Dec 2020 13:49:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/9] libtracefs: Initial support for man pages
Message-ID: <20201218134909.77bdeda6@gandalf.local.home>
In-Reply-To: <20201217094626.1402191-3-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Dec 2020 11:46:19 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +*#include <event-parse.h>*

tracefs.h already includes event-parse.h, and when it is installed, it's
not in the standard search path (unless you add pkg-config libtraceevent).

I would remove the reference to event-parse.h.

-- Steve


> +
> +Locations of tracing files and directories:
> +	char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
> +	void *tracefs_put_tracing_file*(char pass:[*]_name_);
> +	const char pass:[*]*tracefs_get_tracing_dir*(void);
> +	char pass:[*]*tracefs_find_tracing_dir*(void);
> +
> +Trace instances:
> +	struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
> +	int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
> +	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
> +	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
> +	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
> +	bool *tracefs_dir_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
> +	char pass:[*]*tracefs_instance_get_file*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
> +	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
> +	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
> +	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_file_, int pass:[*]_psize_);
> +	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
> +	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
> +	bool *tracefs_instance_exists*(const char pass:[*]_name_);
> +
> +Trace events:
> +	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
> +	char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
> +	int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
> +	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
> +	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
> +	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
> +
> +Trace helper functions:
> +	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
> +	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
> +	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
> +--
