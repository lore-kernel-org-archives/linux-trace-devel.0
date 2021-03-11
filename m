Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58DAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4535E64FD6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhCKOz1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:55:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhCKOzZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:55:25 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116A164F93;
        Thu, 11 Mar 2021 14:55:24 +0000 (UTC)
Date:   Thu, 11 Mar 2021 09:55:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark v2: Change the logic for opening trace-cmd
 files
Message-ID: <20210311095523.54934f40@gandalf.local.home>
In-Reply-To: <42d08f5e-d681-715b-9f40-5763c4332394@gmail.com>
References: <20210310121135.1620453-1-tz.stoyanov@gmail.com>
        <20210310164839.475d10be@gandalf.local.home>
        <42d08f5e-d681-715b-9f40-5763c4332394@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 16:15:59 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Have you tested that this works with the Timestamp synchronization 
> patches that are not upstreamed yet?

I was in the process of doing so, but haven't done it yet :-/

Will do today.

-- Steve
