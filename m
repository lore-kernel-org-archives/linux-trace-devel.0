Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C5CC11F64
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E094D61CFA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 22:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhF1WJF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 18:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233750AbhF1WJE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 18:09:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD39A61CEB;
        Mon, 28 Jun 2021 22:06:36 +0000 (UTC)
Date:   Mon, 28 Jun 2021 18:06:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5] libtracefs: Add APIs for data streaming
Message-ID: <20210628180620.676a3af1@oasis.local.home>
In-Reply-To: <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
References: <20210625142737.6c028a93@oasis.local.home>
        <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Jun 2021 11:58:10 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Nit: When looping you check the value of 'ret' 3 times.
>       The same can be done with only 2 checks.
> 
> 	while (*(volatile bool *)keep_going) {
> 		ret = read(in_fd, buf, BUFSIZ);
> 		if (ret <= 0)
> 			break;
> 
> 		ret = write(out_fd, buf, ret);
> 		if (ret <= 0)
> 			break;
> 
> 		bread += ret;
> 	}

I ended up doing it this way:

	while (*(volatile bool *)keep_going) {
		int r;
		ret = read(in_fd, buf, BUFSIZ);
		if (ret <= 0)
			break;
		r = ret;
		ret = write(out_fd, buf, r);
		if (ret < 0)
			break;
		bread += ret;
		/* Stop if we can't write what was read */
		if (ret < r)
			break;
	}


Because if it can't write the amount that was read, it shouldn't
continue any more. And since the documentation states, it returns what
was transferred, we should only return the amount that was written. Of
course, then we get stuck with a case that the buffer was read, and
lost. But if the write fails to write everything given to it, there's
probably other issues with the system (target ran out of disk space?).
(Hmm, I may state the above in a comment there).

Anyway, I'll be posting the v6 soon.

-- Steve
