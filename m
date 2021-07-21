Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39BFC12002
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 13:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFE16120A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Jul 2021 13:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhGUMcE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Jul 2021 08:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235330AbhGUMbv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 08:31:51 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A92461029;
        Wed, 21 Jul 2021 13:12:27 +0000 (UTC)
Date:   Wed, 21 Jul 2021 09:12:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Haoran Luo <www@aegistudio.net>
Cc:     mingo@redhat.com, linux-trace-devel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH v2 1/1] tracing: fix bug in rb_per_cpu_empty() that
 might cause deadloop.
Message-ID: <20210721091220.0a5c3cbb@oasis.local.home>
In-Reply-To: <YPeZeEP3oSEUHscl@aegistudio>
References: <YPeZeEP3oSEUHscl@aegistudio>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 03:50:16 +0000
Haoran Luo <www@aegistudio.net> wrote:

> +	/*
> +	 * If writers are committing on the head page, we just need
> +	 * to care about there're committed data, and the reader will
> +	 * swap reader page with head page when it is to read data.
> +	 */
> +	if (commit == head)
> +		return rb_page_commit(commit) == 0;
> +
> +	/*
> +	 * Writers are committing on page other than reader page and
> +	 * head page, there should always be content to read.
> +	 */
> +	return false;
>  }
>  

I like the patch, but could you swap the above two operations. I find
that return conditional in the if condition rather ugly. That is, can
you instead have:


	/*
	 * If writers are committing on a page other than the reader
	 * page and head page, there should always be content to read.
	 */
	if (commit != head)
		return false;

	/*
	 * Writers are committing on the head page, we just need
	 * to care about there're committed data, and the reader will
	 * swap reader page with head page when it is to read data.
	 */
	return rb_page_commit(commit) == 0;

-- Steve
