Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63849C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25BD0613B5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhDEPKl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 11:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237769AbhDEPKl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 11:10:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF48C613B1;
        Mon,  5 Apr 2021 15:10:34 +0000 (UTC)
Date:   Mon, 5 Apr 2021 11:10:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/6] libtracefs: Option's bit masks to be owned by the
 instance
Message-ID: <20210405111033.4d45bf65@gandalf.local.home>
In-Reply-To: <8b7346e2-2ce3-0d8b-caab-dd873f00dde6@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
        <20210402131947.346235-6-y.karadz@gmail.com>
        <CAPpZLN5rj-O+fzxf=AR1NbUUDtyjJUXw5Kn5O8nSuZiK554p4g@mail.gmail.com>
        <8b7346e2-2ce3-0d8b-caab-dd873f00dde6@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 5 Apr 2021 18:01:41 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > This makes the API not thread safe. There should be no problem with
> > supported options, as they cannot be changed at runtime. I think it is
> > OK to limit the APIs , as I see no use case to call them from multiple
> > threads on the same instance, but this should be described in the
> > documentation.  
> 
> Discussing is this API is thread safe or not is not really relevant. 
> Even if you make tracefs_options_get_enabled() thread safe, this does 
> not change anything since the options can be already changed by the time 
> when you examine the bits of the mask.

You are correct, but you also do not want the update of the bitmask to be
corrupted. Thus I think a pthread_mutex() should be added to the updating
of the value, such that we don't have a read/modify/write corruption. Sure
the reader of the mask may get some stale data if its being updated. But it
shouldn't get corrupted data.


void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id)
{
	if (options && id > TRACEFS_OPTION_INVALID)
		options->mask |= (1ULL << (id - 1));
}

If two threads are doing this to the same mask, you can have an option set
that gets cleared by another writer, and even though the option is set
after the call, it will be clear in the mask. That is, it's not stale data,
it's incorrect data. That is, the readers after that corruption will get an
option not set, even though it is.

-- Steve
