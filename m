Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E68C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 19:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiLOTDz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 14:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLOTDw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 14:03:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B19A192BF
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 11:03:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EF061EC3
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 19:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED3C433F1;
        Thu, 15 Dec 2022 19:03:50 +0000 (UTC)
Date:   Thu, 15 Dec 2022 14:03:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v1 2/2] libtracefs: Fix compiler -Wmemsize-comparison
 warning
Message-ID: <20221215140349.3e6fe1e6@gandalf.local.home>
In-Reply-To: <20221215183151.2685460-2-irogers@google.com>
References: <20221215183151.2685460-1-irogers@google.com>
        <20221215183151.2685460-2-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Dec 2022 10:31:51 -0800
Ian Rogers <irogers@google.com> wrote:

> Fixes the following clang warning:
> 
> utest/tracefs-utest.c:828:75: error: size argument in 'strncmp' call is a comparison [-Werror,-Wmemsize-comparison]
>             (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
>                                                               ~~~~~~~~~~~~~~~~~~~^~~~
> utest/tracefs-utest.c:828:22: note: did you mean to compare the result of 'strncmp' instead?
>             (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
>                             ^                                                        ~
>                                                                                 )
> utest/tracefs-utest.c:828:56: note: explicitly cast the argument to size_t to silence this warning
>             (!save_debug || strncmp(save_debug, save_tracing, strlen(save_debug) != 0)))
>                                                               ^
>                                                               (size_t)(              )

This is why I hate lisp!

Thanks, I'll apply this.

-- Steve
