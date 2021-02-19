Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E99BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 03:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124F264ED5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 03:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSDIH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:08:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhBSDID (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 22:08:03 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B15564ECD;
        Fri, 19 Feb 2021 03:07:22 +0000 (UTC)
Date:   Thu, 18 Feb 2021 22:07:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] libtracefs: New APIs for enable / disable
 tracing
Message-ID: <20210218220720.2ffdcf01@oasis.local.home>
In-Reply-To: <20210112092024.605705-4-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
        <20210112092024.605705-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Jan 2021 11:20:20 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> These new APIs can be used to enable / disable tracing in given ftrace
> instance:
>   tracefs_trace_is_on();
>   tracefs_trace_on();
>   tracefs_trace_off();
>   tracefs_trace_on_get_fd();
>   tracefs_trace_on_fd();
>   tracefs_trace_off_fd();
> 

I just realized we don't have:

tracefs_trace_marker_get_fd();

Which we should, as it's one of the files we want to have the file
descriptor for to write directly without having to open it each time.

(I could have used it right now)

-- Steve
