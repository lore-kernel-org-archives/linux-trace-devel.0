Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C5EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 18:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiLOSxD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 13:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiLOSws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 13:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54D237229
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 10:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8281061EC0
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 18:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF68C433D2;
        Thu, 15 Dec 2022 18:52:46 +0000 (UTC)
Date:   Thu, 15 Dec 2022 13:52:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: libtraceevent and threads
Message-ID: <20221215135245.12a879d7@gandalf.local.home>
In-Reply-To: <871qp0wol3.fsf@balbi.sh>
References: <871qp0wol3.fsf@balbi.sh>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Dec 2022 19:42:32 +0200
Felipe Balbi <balbi@kernel.org> wrote:

> Hi,
> 
> I was playing with binding `libtraceevent' to rust today. Generating the
> bindings with rust's `bindgen' is very straight forward. When I moved to
> porting the existing tests to rust, I found out that running a single
> test always worked, while running all tests caused random allocation
> failures and (apparent) corruption of the trace_seq buffer.
> 
> Upon further investigating the issue, I noticed that asking `cargo' to
> run tests in a single thread (essentially one test at a time), always
> gave me good results, but as soon as I let `cargo' run 2 threads (or
> more) failures would show.
> 
> I appears that this is because `libtraceevent' keeps some global state
> and that prevents different threads to keep their own "context" of the
> library.
> 
> I can't say for sure, but it seems that the culprit here is:
> 
> 	static const char *input_buf;
> 
> in line 31 of src/event-parse.c. Would there be a way to hide that
> perhaps as part of `struct tep_handle'?

Ah sure. I think we discovered this once before and was meaning to change
it. There may have been issues where we needed to design things
differently. I don't recall.

But if you want to send patches to move that to the tep handle and make it
work, I'm all for it.

-- Steve
