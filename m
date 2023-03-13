Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72910C6FD19
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 16:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCMQk7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 12:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCMQk6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 12:40:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EC58A67
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 09:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FAB5B811A2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67F3C433EF;
        Mon, 13 Mar 2023 16:40:52 +0000 (UTC)
Date:   Mon, 13 Mar 2023 12:40:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Ian Rogers <irogers@google.com>,
        linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] libtracefs: Fix the label usage in check_option()
Message-ID: <20230313124050.05750d39@gandalf.local.home>
In-Reply-To: <dc6bda64-4909-160f-dc94-b0a7ac999234@web.de>
References: <dc6bda64-4909-160f-dc94-b0a7ac999234@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 12 Mar 2023 18:21:13 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> Date: Sun, 12 Mar 2023 18:10:36 +0100
> 
> The label “out” was used to jump to a source code place after some
> failure cases. This implementation detail hindered better exception handling.

"out" is a perfectly fine name.

> 
> Use more appropriate labels instead.
> 
> * Reorder jump targets at the end.

Why?

> 
> * Delete a condition check.

Why?

> 
> * Omit an extra initialisation (for the variable “fd”)
>   which became unnecessary with this change.
> 
> Fixes: f7951864c7766ba3d683e8676fe0e497991796b2 ("libtracefs: Unit tests for tracing options APIs")

What was fixed???

> Signed-off-by: Markus Elfring <Markus.Elfring@web.de>
> ---
>  utest/tracefs-utest.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index e0e3c07..d1ff6cf 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c

This is a test file. It's run in tests.

-- Steve
