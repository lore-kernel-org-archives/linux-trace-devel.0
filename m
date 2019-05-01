Return-Path: <SRS0=6oeL=TB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C490C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 00:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED35421743
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 May 2019 00:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfEAAwT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 20:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfEAAwT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 20:52:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CFDB20866;
        Wed,  1 May 2019 00:52:18 +0000 (UTC)
Date:   Tue, 30 Apr 2019 20:52:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 24/30] tools/lib/traceevent: Man pages for event
 filter APIs
Message-ID: <20190430205215.43a9fbce@oasis.local.home>
In-Reply-To: <20190412133811.15878-25-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-25-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:38:05 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +DESCRIPTION
> +-----------
> +Filters can be attached to traced events. They are useful for picking out only
> +the desired information, and not to flood the ring buffer with needless events.

Actually, these filters have nothing to do with the ring buffer. They
are helper functions to let the tools filter out various events when
outputting them.

There are filters that limit what goes into the ring buffer, but that's
in the kernel, it's not related to these.

-- Steve


> +Each event can be filtered based on its parameters, described in the event's
> +format file. This set of functions can be used to create, delete, modify and
> +attach event filters.
> +
> +The _tep_filter_alloc()_ function creates a new event filter. The _tep_ argument
> +is the trace event parser context.
> +
> +The _tep_filter_free()_ function frees an event filter and all resources that it
> +had used.
> +
> +The _tep_filter_reset()_ function removes all rules from an event filter and
> +resets it.
> +
> +The _tep_filter_add_filter_str()_ function adds a new rule to the _filter_. The
> +_filter_str_ argument is the filter string, that contains the rule.
> +
> +The _tep_event_filtered()_ function checks if the event with _event_id_ has
> +_filter_.
> +
> +The _tep_filter_remove_event()_ function removes a _filter_ for an event with
> +_event_id_.
> +
> +The _tep_filter_match()_ function tests if a _record_ matches given _filter_.
> +
> +The _tep_filter_copy()_ function copies a _source_ filter into a _dest_ filter.
> +
> +The _tep_filter_compare()_ function compares two filers - _filter1_ and _filter2_.
> +
> +The _tep_filter_make_string()_ function constructs a string, displaying
> +the _filter_ contents for given _event_id_.
> +
> +The _tep_filter_strerror()_ function copies the _filter_ error buffer into the
> +given _buf_ with the size _buflen_. If the error buffer is empty, in the _buf_
> +is copied a string, describing the error _err_.
> +
