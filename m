Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA14C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 16:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhLIQ07 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:26:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59118 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbhLIQ06 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 11:26:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7B71CE26DA
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 16:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93394C004DD;
        Thu,  9 Dec 2021 16:23:21 +0000 (UTC)
Date:   Thu, 9 Dec 2021 11:23:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] libtracefs: APIs for inspecting hist/synth
 objects
Message-ID: <20211209112320.7692ea87@gandalf.local.home>
In-Reply-To: <20211209104524.5354-1-y.karadz@gmail.com>
References: <20211209104524.5354-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Dec 2021 12:45:21 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Changes in v2:
>  - Dropping patch 'libtracefs: New API for getting the raw format of a
>    histogram'. This patch must be redesigned.
> 
>  - Adding patch 'libtracefs: New APIs for getting the raw format of
>    synth event'.
> 
>  - Number of fixes suggested by Steven in his review.
> 
> 
> Yordan Karadzhov (VMware) (3):
>   libtracefs: Rename the 'tracefs_get_hist_*()' APIs
>   libtracefs: Add new API for getting synth event name

I pulled in the above two patches.

>   libtracefs: New APIs for getting the raw format of synth event

You only need to resend an update to the above.

Thanks!

-- Steve

> 
>  Documentation/libtracefs-hist.txt   |  24 ++++-
>  Documentation/libtracefs-synth2.txt |  14 ++-
>  include/tracefs.h                   |  12 ++-
>  src/tracefs-hist.c                  | 132 +++++++++++++++++++++++-----
>  4 files changed, 154 insertions(+), 28 deletions(-)
> 

