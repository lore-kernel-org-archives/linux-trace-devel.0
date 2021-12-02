Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463CDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 14:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357341AbhLBPCx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:02:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37514 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357701AbhLBPCw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 10:02:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3BD5CE230A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 14:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11EBC00446;
        Thu,  2 Dec 2021 14:59:26 +0000 (UTC)
Date:   Thu, 2 Dec 2021 09:59:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] libtracefs: New API for clearing filter on event
Message-ID: <20211202095925.74a45f52@gandalf.local.home>
In-Reply-To: <20211130143422.127433-2-y.karadz@gmail.com>
References: <20211130143422.127433-1-y.karadz@gmail.com>
        <20211130143422.127433-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Nov 2021 16:34:22 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> @@ -81,6 +84,8 @@ freed with *free*().
>  
>  *tracefs_event_apply_filter*() returns 0 on success and -1 on error.
>  
> +*tracefs_event_clear_filter*() returns 0 on success and -1 on error.
> +

I just applied Tzvetomir's patches, and he renamed the function to:

  tracefs_event_filter_apply()

Can you resubmit a rebased version of this patch and rename he function to:

  tracefs_event_filter_clear()

Thanks,

-- Steve
