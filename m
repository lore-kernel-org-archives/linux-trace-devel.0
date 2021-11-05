Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F2BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CCB06120A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhKEOsE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhKEOsE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 10:48:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138BE6120A;
        Fri,  5 Nov 2021 14:45:23 +0000 (UTC)
Date:   Fri, 5 Nov 2021 10:45:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 11/12] libtracefs: Remove man page compile artifact
Message-ID: <20211105104522.33513da3@gandalf.local.home>
In-Reply-To: <CAPpZLN4u7oW9+nbmcHBvh5QWjQyEm40hXFtFAiP4vYvt=tD7pQ@mail.gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
        <20211105121624.398717-12-tz.stoyanov@gmail.com>
        <20211105102426.76a20a4b@gandalf.local.home>
        <CAPpZLN6E1f3KCnCxS_=D=Qjv2zxB3tiunie4uMZGBHJXm7BvHw@mail.gmail.com>
        <CAPpZLN4u7oW9+nbmcHBvh5QWjQyEm40hXFtFAiP4vYvt=tD7pQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Nov 2021 16:40:17 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > "make doc" generates it on my machine, and "make doc_clean" removes it.  
> 
> hmm I'm wrong - only the second is true, "make doc_clean" removes it.
> That should be fixed.

Ah, yeah. :-)

-- Steve
