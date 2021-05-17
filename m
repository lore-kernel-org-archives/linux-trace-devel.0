Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B1EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 23:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C37B61350
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 23:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhEQX3u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 19:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhEQX3t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 19:29:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CE5B610CC;
        Mon, 17 May 2021 23:28:32 +0000 (UTC)
Date:   Mon, 17 May 2021 19:28:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Final fixes before KS 2.0
Message-ID: <20210517192831.15d5773c@gandalf.local.home>
In-Reply-To: <20210517192104.0272eb84@gandalf.local.home>
References: <20210517142140.286153-1-y.karadz@gmail.com>
        <20210517192104.0272eb84@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 May 2021 19:21:04 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 17 May 2021 17:21:33 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> > v2 changes:
> >  - Still showing all CPU plots from the new trace file when
> >    appending [PATCH kernel-shark: Preserve open graphs when
> >    appending data].
> >  - Setting "seq.buffer" to NULL after calling trace_seq_destroy()
> >    in [PATCH kernel-shark: Fix the checking if "trace_seq" was destroyed]
> >  - [PATCH kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX]
> >    is new.  
> 
> Hi Yordan,
> 
> I was playing a bit with kernelshark, and found that if I load a file and
> append one, exit, load them again, then click:
> 
>   File -> Sessions -> Restore Last Session
> 
> It crashes.
> 
> Looks to be something is freed and then reused, because when I ran it under
> gdb, it crashed in allocation of memory (asprintf). That usually means that
> something was freed twice, someplace else. Or freed and then used.
> 

Running valgrind, reported this:

==6862== Invalid read of size 8
==6862==    at 0x494CA89: map_collection_back_request (libkshark-collection.c:474)

static int
map_collection_back_request(const struct kshark_entry_collection *col,
			    struct kshark_entry_request *req)
{
	size_t req_first, req_end;
	ssize_t col_index;
	int req_count;

	col_index = map_collection_request_init(col, req, false, &req_end);
	if (col_index == KS_EMPTY_BIN)
		return 0;

	/*
	 * Now loop over the intervals of the collection going backwards till
	 * the end of the inputted request and create a separate request for
	 * each of those interest.
	 */
	req_count = 1;
	while (col_index >= 0 && req_end <= col->break_points[col_index]) {

// col_index can be zero entering this loop.

		if (req_end >= col->resume_points[col_index]) {
			/*
			 * The last entry of the original request is inside
			 * the "col_index" collection interval. Close the
			 * collection request here and return.
			 */
			req->n = req->first - req_end + 1;
			break;
		}

		/*
		 * The last entry of the original request is outside of the
		 * "col_index" interval. Close the collection request at the
		 * end of this interval and move to the next one. Try to make
		 * another request there.
		 */
		req->n = req->first -
			 col->resume_points[col_index] + 1;

		--col_index;

// col_index is decremented (-1)

		if (req_end > col->break_points[col_index]) {

Reading a negative index in an array.

Which is where valgrind reported. But I don't think this is what caused the
crash.

-- Steve

