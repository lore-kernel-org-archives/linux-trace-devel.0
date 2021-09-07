Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D437EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 19:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D9361108
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 19:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhIGTNE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 15:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhIGTNE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 15:13:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673C4610C8;
        Tue,  7 Sep 2021 19:11:57 +0000 (UTC)
Date:   Tue, 7 Sep 2021 15:11:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtracefs: Fix sometimes uninitialized warning.
Message-ID: <20210907151155.63708118@gandalf.local.home>
In-Reply-To: <CAP-5=fWsxhZOkmpzFopqFQG+ZtbehZvT7NZ0bLzD7HhkZ4Qu1Q@mail.gmail.com>
References: <20210902224840.2518539-1-irogers@google.com>
        <20210907105723.327be286@gandalf.local.home>
        <CAP-5=fWsxhZOkmpzFopqFQG+ZtbehZvT7NZ0bLzD7HhkZ4Qu1Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 7 Sep 2021 11:53:48 -0700
Ian Rogers <irogers@google.com> wrote:

> Thanks Steve, I think the error handling in this function could use
> some TLC. For example, the code:

100% agree. That's one reason I haven't tagged an official release with it
yet ;-)


> 
> ret = append_filter(synth, and_or, NULL, 0, NULL);
> ret = append_filter(synth, TRACEFS_FILTER_OPEN_PAREN,
>     NULL, 0, NULL);
> 
> doesn't check the value of ret. Assuming the return values are checked
> then plumbing these up makes sense. Fwiw, there is evidence that going
> in the direction of asserts/aborts is useful:
> https://www.microsoft.com/en-us/research/publication/assessing-the-relationship-between-software-assertions-and-code-qualityan-empirical-investigation/

I'm sure it is. But I still hate it when a library aborts my own work, so
I'm biased ;-)

> 
> I can resend the patch with something like:
> 
> fprintf(stderr, "Error invalid filter type '%d'", filter->type);
> return ERANGE;
> 
> Does that fit the expected convention?

Looks as good as any.

If you want to send patches that makes the return handling a bit more
complete and robust, that would be more than welcomed.

-- Steve
