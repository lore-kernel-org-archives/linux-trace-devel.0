Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBC9C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 22:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB32C619A3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 22:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCVW3c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhCVW3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 18:29:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78202619A3;
        Mon, 22 Mar 2021 22:29:18 +0000 (UTC)
Date:   Mon, 22 Mar 2021 18:29:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Prefer using const pointer arguments
Message-ID: <20210322182917.622f6126@gandalf.local.home>
In-Reply-To: <64861357-e2ef-e2aa-239c-9b8a96a5bf9b@gmail.com>
References: <20210322142912.26521-1-y.karadz@gmail.com>
        <20210322114721.118c83ae@gandalf.local.home>
        <64861357-e2ef-e2aa-239c-9b8a96a5bf9b@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 18:59:42 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I understand your preference to keep the flexibility of those API, 
> however generally spiking those are "getter" functions and they are not 
> supposed to modify the encapsulated object. If we allow the "getters" of 
> the API to modify the encapsulated object (tracefs_instancein this case) 
> this will be a bit of hacking stile of programing. At least for me, 
> having a firm and intuitive design of the API is more valuable than the 
> inconvenience that this reduced flexibility can potentially bring.

Is there an immediate need for this change? I.e. python complains about it,
or some other reason.

I'd like to hold off on changing this. This shouldn't break APIs, as the
code should still link fine if we decide to change it later.

I looked at various other libraries to see if they use const pointers for
"getter" functions. It's somewhat inconsistent. I'll look at more
libraries, and see how they are done. I'm more interested in keeping with
precedent here. C does some things differently that C++.

-- Steve
