Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C16DC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 15:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiCPPOl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 11:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357984AbiCPPOL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 11:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22346C1DD
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 08:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D536162F
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 15:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8279EC340E9;
        Wed, 16 Mar 2022 15:11:58 +0000 (UTC)
Date:   Wed, 16 Mar 2022 11:11:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark: CPU plots dialog ease spotting empty
 CPUs
Message-ID: <20220316111156.26570a80@gandalf.local.home>
In-Reply-To: <20220316110356.70d84b3a@gandalf.local.home>
References: <20220316143717.272899-1-y.karadz@gmail.com>
        <20220316143717.272899-2-y.karadz@gmail.com>
        <20220316110356.70d84b3a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Mar 2022 11:03:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Although, I found that if I select more that 16 CPU plots at a time it
> hangs. I can add that to the BZ. (I noticed this before these patches).

Strange, it hung just before posting this, but trying it again, I can't
reproduce the lockup :-/

I'll play some more with it.

-- Steve
