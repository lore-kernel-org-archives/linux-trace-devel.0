Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9CEC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDB264E6C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhBXUMs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235499AbhBXUKp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3277864F26;
        Wed, 24 Feb 2021 20:10:15 +0000 (UTC)
Date:   Wed, 24 Feb 2021 15:10:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <Viktor.Rosendahl@bmw.de>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: Adding latency tracking to trace-cmd
Message-ID: <20210224151013.5ece2f65@gandalf.local.home>
In-Reply-To: <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
References: <20210224115408.1c76ee3f@gandalf.local.home>
        <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 19:22:48 +0000
<Viktor.Rosendahl@bmw.de> wrote:

> I would be interested to work on the feature but I would probably need
> permission from my employer, also in case I do it as a spare time project.

Totally understand.

> 
> For this reason, I will need some time come to a decision. I will get back to
> you when I know the answer.

No rush. I'll add the "quick fix" (which I Cc'd you on). I'm trying to get
people to feel comfortable in contributing to trace-cmd and the libraries
associated with it.

Having "trace-cmd" in the database of acceptable open source projects to
contribute to at companies like BMW will help facilitate that as well.

Thanks,

-- Steve
