Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D00C07E9D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BD661261
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 03:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhGVDEv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Jul 2021 23:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGVDEu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 23:04:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F2D60698;
        Thu, 22 Jul 2021 03:45:25 +0000 (UTC)
Date:   Wed, 21 Jul 2021 23:45:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH 0/4] libtracefs: Creating synthetic events
Message-ID: <20210721234519.7e1f3d3c@oasis.local.home>
In-Reply-To: <20210722033917.367982-1-rostedt@goodmis.org>
References: <20210722033917.367982-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 23:39:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add an interface to libtracefs that makes it easy to create synthetic
> events. For example:
> 

I forgot to add (although it's in the man page)

	#define start_event "sched_waking"
	#define start_field "pid"

	#define end_event "sched_switch"
	#define end_field "next_pid"

	#define match_name "pid"

-- Steve


> 	struct tracefs_synth *synth;
> 	struct tep_handle *tep;
> 	struct trace_seq seq;
> 
> 	/* Load all events from the system */
> 	tep = tracefs_local_events(NULL);
> 	
> 	/* Initialize the synthetic event */
> 	synth = tracefs_synth_init(tep, "wakeup_lat",
> 				   NULL, start_event,
> 				   NULL, end_event,
> 				   match_name,
> 				   start_field, end_field);
> 
> 	/* The tep is no longer needed */
> 	tep_free(tep);
> 
> 
