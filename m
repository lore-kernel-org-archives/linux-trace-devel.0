Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C068C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFA4E610CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 17:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhIMR55 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239619AbhIMR54 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 13:57:56 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FA4B60EE3;
        Mon, 13 Sep 2021 17:56:40 +0000 (UTC)
Date:   Mon, 13 Sep 2021 13:56:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] libtracefs: Transform
 tracefs_hist_add_sort_key()
Message-ID: <20210913135633.075dfe75@oasis.local.home>
In-Reply-To: <7ae3ea27-082c-c5d8-c13b-e1da96d348aa@gmail.com>
References: <20210910163857.324696-1-y.karadz@gmail.com>
        <20210910163857.324696-3-y.karadz@gmail.com>
        <20210910160101.2ef82513@gandalf.local.home>
        <7ae3ea27-082c-c5d8-c13b-e1da96d348aa@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 13 Sep 2021 15:26:51 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > How about if we call this:
> > 
> > 	tracefs_hist_replace_sort_keys()
> > 
> > I think that would be a more intuitive name.  
> 
> The user may call this function with a histogram that has no sort keys added.
> So there will be nothing to replace.
> What about naming it 'tracefs_hist_set_sort_keys()'?

Nothing is something to replace?

Or we remove this completely, and have a:

 tracefs_hist_reset_sort_keys()

Which removes all sort keys, and let you to start with a clean plate.
Thus, the above would really just be "reset" followed by "add".

-- Steve
