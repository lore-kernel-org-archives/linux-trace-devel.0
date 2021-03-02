Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C7CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE5EA64F2B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhCBX5G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379444AbhCBB2q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 20:28:46 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F41C760C3E;
        Tue,  2 Mar 2021 01:28:04 +0000 (UTC)
Date:   Mon, 1 Mar 2021 20:28:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
Message-ID: <20210301202803.3529949d@oasis.local.home>
In-Reply-To: <CAK7tX=b4qPFcC+uGHfbBT3v90+qhHuBoLF=HgqUMmD0b00PF6A@mail.gmail.com>
References: <1614705310-5887-1-git-send-email-sameeruddin.shaik8@gmail.com>
        <20210301131754.11f0be38@gandalf.local.home>
        <CAK7tX=b4qPFcC+uGHfbBT3v90+qhHuBoLF=HgqUMmD0b00PF6A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 3 Mar 2021 06:46:26 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> what if we store the indices of the failed filters in an integer array
> and return them back?

There's not much difference if we return an array of pointers to the
filters or an array of integers to the index. I was just thinking about
how I would use the interface. When having a working interface, we
should write a few robust programs to see how easy it is to use, and
that will help in making the API appropriate. This needs to be done
*before* we accept it. This particular API is going to be widely used,
and it needs to be simple and robust.

> let's return the number of bytes written, also we will calculate the
> complete filters length and return it, if there is difference,
> we will loop into the integer array and print the erroneous filters

Not sure how that is helpful. How would you use the number of bytes
written?

> 
> Let's fix the number of parameters to this function:)

Not sure what you mean by that.


Here's how I envision this interface.

	char **errs;
	char *filters[] = {
		"sched*", "spin_*", NULL
	};
	int ret;


	ret = tracefs_function_filter(NULL, filters, NULL, &errs);
	if (ret < 0) {
		int i;

		printf("Failed to apply: ");
		for (i = 0; errs[i]; i++) {
			if (i)
				printf(", ");
			printf("'%s'", errs[i]);
		}
		printf("\n";
		exit(ret);
	}

-- Steve
