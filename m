Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37638C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 15:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhLHPKr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 10:10:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45710 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhLHPKr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 10:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B2E7CE216C
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Dec 2021 15:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE95C00446;
        Wed,  8 Dec 2021 15:07:10 +0000 (UTC)
Date:   Wed, 8 Dec 2021 10:07:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, kernel <kernel@axis.com>
Subject: Re: [PATCH v2] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211208100709.54663893@gandalf.local.home>
In-Reply-To: <20211208150004.GA15557@axis.com>
References: <20211208143402.28076-1-vincent.whitchurch@axis.com>
        <20211208094511.3efadb41@gandalf.local.home>
        <20211208150004.GA15557@axis.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 8 Dec 2021 16:00:05 +0100
Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:

> No worries, thanks.  I did think it would be easier for you to commit
> it.  I pulled before reworking the patch but I didn't see your commit.
> It turns out I was using a clone from the following (wrong) git which
> hasn't been updated in months...
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/

Ug, I try to keep that one up to date. I have three repos for trace-cmd and
two for libtracefs and libtraceevent (kernel.org and github). I've been
focused on the libraries for some time, and after updating trace-cmd, I
was thinking to myself "Hmm, isn't there another repo I update?"

I'll go and update that one too :-/

-- Steve
