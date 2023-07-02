Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC9DEB64DC
	for <linux-trace-devel@archiver.kernel.org>; Sun,  2 Jul 2023 01:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjGBBjU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 Jul 2023 21:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGBBjT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 Jul 2023 21:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68351703
        for <linux-trace-devel@vger.kernel.org>; Sat,  1 Jul 2023 18:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F56460B56
        for <linux-trace-devel@vger.kernel.org>; Sun,  2 Jul 2023 01:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BACEC433C7;
        Sun,  2 Jul 2023 01:39:17 +0000 (UTC)
Date:   Sat, 1 Jul 2023 21:39:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     avidanborisov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] trace-cmd record: Improvements to --daemonize
 option
Message-ID: <20230701213915.482b5ff6@rorschach.local.home>
In-Reply-To: <20230626091635.3002827-1-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
        <20230626091635.3002827-1-avidanborisov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Jun 2023 12:16:31 +0300
avidanborisov@gmail.com wrote:

> From: Avidan Borisov <avidanborisov@gmail.com>
> 
> Hi Steven,

Thanks Avidan,

I'm currently traveling and then we have two US holidays for Monday and
Tuesday, I'll try to get to it within a week or two.

Also, when sending a v2, please make it a new thread and do not reply
to the previous version. It makes it more visible, otherwise, the
second version gets lost in the thread of the first.

Thanks,

-- Steve


> 
> This is the second version of my patch series for adding the --daemonize option to trace-cmd record, incorporating your feedback.
> 
> Changes since v1:
> - Replaced all instances of "he" with "the user".
> - Fixed the issue with the `break` statement in the switch case.
> - Added a usage example of --daemonize to the man page.
> 
> Let me know if there are any further changes required.
> 
> Thanks,
> Avidan
> 
> Avidan Borisov (4):
>   trace-cmd record: Add --daemonize
>   trace-cmd: export pidfile functions from trace-listen.c
>   trace-cmd record: Create a pidfile when using --daemonize
>   trace-cmd record: Add --daemonize example to man page
> 
>  .../trace-cmd/trace-cmd-record.1.txt          |  33 ++++
>  tracecmd/include/trace-local.h                |   4 +
>  tracecmd/trace-listen.c                       |  32 ++--
>  tracecmd/trace-record.c                       | 142 +++++++++++++++++-
>  tracecmd/trace-usage.c                        |   3 +
>  5 files changed, 194 insertions(+), 20 deletions(-)
> 

