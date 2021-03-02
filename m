Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188F2C4360C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5EC64F2B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhCCAB7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351399AbhCBOWg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 09:22:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BAF464F04;
        Tue,  2 Mar 2021 14:13:33 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:13:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/8] trace-cmd: Create API tracecmd_read_pre_headers()
Message-ID: <20210302091331.3fc3ee7c@gandalf.local.home>
In-Reply-To: <CAPpZLN5fdY+rb6s=X6bNykiqrjuTprvZxay9iDSEQxJXHURh3A@mail.gmail.com>
References: <20210301143724.540985351@goodmis.org>
        <20210301143856.948525416@goodmis.org>
        <CAPpZLN5fdY+rb6s=X6bNykiqrjuTprvZxay9iDSEQxJXHURh3A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Mar 2021 06:49:18 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> While looking at these changes, I think it could be more flexible instead of
> introducing a new API, to enhance the existing tracecmd_read_headers().
> We can add an additional (optional) parameter to point out what headers
> to be read, i.e. the desired new state of reading the file. Something like that:
>    int tracecmd_read_headers(struct tracecmd_input *handle, int state);
> It will read the file from its current file_state to the desired state.
> The API could be called multiple times, to progress the reading of the
> file, header by header if needed, or a bunch of headers.
> 

I actually like this idea. The only downside of it, is that we need to make
the states part of the API (export them).

-- Steve
