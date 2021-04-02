Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E08C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC26F61104
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 14:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhDBOSA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBOR7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 10:17:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0176108B;
        Fri,  2 Apr 2021 14:17:58 +0000 (UTC)
Date:   Fri, 2 Apr 2021 10:17:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH 4/6] libtracefs: Move the "options" code to 
 tracefs-instance.c
Message-ID: <20210402101756.36879d49@gandalf.local.home>
In-Reply-To: <20210402131947.346235-5-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
        <20210402131947.346235-5-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  2 Apr 2021 16:19:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> We would like the instance object to own two bit masks (struct
> tracefs_options_mask) associated with all supported and all enabled
> options. However, the definition of the instance itself is not public,
> hence the code implementing the "options" related APIs has to in the
> same source file as the definition of the instance.

The above is not true. We can keep the code in tracefs-tools.c and make it
"public" for the internal use of the library, but not part of the API. To
do so, you place shared structures and functions in include/tracefs-local.h,
and mark all non static functions with "__hidden" which will keep it from
being used outside the library.

Do you still feel that the moving of this code is needed?

-- Steve


> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/tracefs-instance.c | 266 +++++++++++++++++++++++++++++++++++++++++
>  src/tracefs-tools.c    | 266 -----------------------------------------
>  2 files changed, 266 insertions(+), 266 deletions(-)

