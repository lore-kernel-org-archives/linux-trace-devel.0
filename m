Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88ACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 14:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhLHOsr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:48:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47394 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhLHOsq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 09:48:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14620B82015
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Dec 2021 14:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70391C00446;
        Wed,  8 Dec 2021 14:45:12 +0000 (UTC)
Date:   Wed, 8 Dec 2021 09:45:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>
Subject: Re: [PATCH v2] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211208094511.3efadb41@gandalf.local.home>
In-Reply-To: <20211208143402.28076-1-vincent.whitchurch@axis.com>
References: <20211208143402.28076-1-vincent.whitchurch@axis.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 8 Dec 2021 15:34:02 +0100
Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:

> Do not segfault if the event cannot be found for some reason and
> tep_find_event_by_record() returns NULL.
> 
> With this patch:
> 
>  kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
> [UNKNOWN EVENT][UNKNOWN EVENT] (NULL):               [UNKNOWN EVENT]
>  kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>

Hi Vincent,

I already applied the update.

  https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/commit/?id=196a3a63c466204f3e8f4fa35194fc9ab7cb1ab7

Sorry, I waited a bit but your reply sounded like you wanted me to do it.

-- Steve
