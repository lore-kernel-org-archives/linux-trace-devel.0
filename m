Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFD5C4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 13:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0BB560F57
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 13:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhGZNS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 09:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233788AbhGZNS6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 09:18:58 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D45560F55;
        Mon, 26 Jul 2021 13:59:26 +0000 (UTC)
Date:   Mon, 26 Jul 2021 09:59:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark: Treat all tracing headers as library
 headers
Message-ID: <20210726095925.184b3826@oasis.local.home>
In-Reply-To: <20210726094141.191579-2-y.karadz@gmail.com>
References: <20210726094141.191579-1-y.karadz@gmail.com>
        <20210726094141.191579-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Jul 2021 12:41:41 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> 1. Note that this patch actually fixes a build failure, caused by the
> following commit in libtracefs:
> 880885d (libtracefs: Remove "traceevent/" from referencing libtraceevent headers)
> It seems that so far the discovery of the headers was working more or
> less by chance.

Yep, it was "by chance", that we just happened to include the headers
in the main directory in the same paths as were added in the files. But
if we ever changed those paths, the files would not be updated and the
compile would break.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

to both patches.

Thanks Yordan.

-- Steve
