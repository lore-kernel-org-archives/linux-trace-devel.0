Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35072C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbiFHPVd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245580AbiFHPU3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 11:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651823B3EF
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 08:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C66A0611DB
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 15:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6192C341C4;
        Wed,  8 Jun 2022 15:17:34 +0000 (UTC)
Date:   Wed, 8 Jun 2022 11:17:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org, Ian Rogers <irogers@google.com>
Subject: Re: [PATCH] libtraceevent: Reset right arg when copying
 TEP_PRINT_OP
Message-ID: <20220608111733.283dce42@gandalf.local.home>
In-Reply-To: <20220606195859.771436-1-namhyung@kernel.org>
References: <20220606195859.771436-1-namhyung@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jun 2022 12:58:59 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> When processing a TEP_PRINT_OP type arg, the original arg was copied
> to the left arg and resets itself.  But it misses the reset the right
> in some places and it could result in a use-after-free.
> 
> A fuzzer test found out that something like below can trigger it
> 
>   print fmt: "", c * ((3 * t)[
> 
> At the time it sees the "[" token, the arg would have like
> 
>   arg->type = TEP_PRINT_OP
>   arg->op.op = "*"
>   arg->op.left = (arg of 3)
>   arg->op.right = (arg of t)
> 
> and it creates a new left and copies the contents.  Also it resets
> itself with
> 
>   arg->op.op = "["
>   arg->op.left = (new left)
> 
> But it can have the same arg->op.right if the process_array() fails
> before setting it.  It should reset the right pointer as it passed the
> ownership before.  The same thing can happend for process_cond().
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  src/event-parse.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied. Thanks Namhyung!

-- Steve
