Return-Path: <SRS0=jdea=3M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325F1C35240
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 23:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06BAF20718
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 23:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgAWXiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 18:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729288AbgAWXiS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 18:38:18 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB09B20718;
        Thu, 23 Jan 2020 23:38:17 +0000 (UTC)
Date:   Thu, 23 Jan 2020 18:38:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] trace-cmd,kernel-shark: New libtracefs APIs for
 loading ftrace events
Message-ID: <20200123183816.748989b7@rorschach.local.home>
In-Reply-To: <20200117135544.598235-5-tz.stoyanov@gmail.com>
References: <20200117135544.598235-1-tz.stoyanov@gmail.com>
        <20200117135544.598235-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Jan 2020 15:55:43 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The functionality related to loading local ftrace events
> to a pet handler is moved from libtracecmd to libtracefs.

I'm assuming you meant tep handler? Or is it some kind of security
animal? ;-)

(I'll update it)

-- Steve


> 
> The following libtracecmd APIs are removed:
>   tracecmd_local_events();
>   tracecmd_fill_local_events();
> 
> The following new library APIs are introduced:
>   tracefs_local_events();
>   tracefs_fill_local_events();
>   tracefs_local_events_system();
> 
> The APIs are reimplemented to reuse functionality from
>  tracefs_event_systems() and
>  tracefs_system_events()

