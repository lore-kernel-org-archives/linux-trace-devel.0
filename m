Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7627BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiCBPxU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiCBPxT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A89D5F4B
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9047B82081
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Mar 2022 15:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FB6C340F1;
        Wed,  2 Mar 2022 15:52:31 +0000 (UTC)
Date:   Wed, 2 Mar 2022 10:52:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] trace-cmd: Use errno from zlib, if available
Message-ID: <20220302105230.179ad64a@gandalf.local.home>
In-Reply-To: <Yh8Zkh7nQhLZnpsU@breakpoint.cc>
References: <20220302045131.387658-1-tz.stoyanov@gmail.com>
        <20220302045131.387658-4-tz.stoyanov@gmail.com>
        <Yh8Zkh7nQhLZnpsU@breakpoint.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Mar 2022 08:15:30 +0100
Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> I was thinking about returning the error for compress/decompress via the
> return value and not touching errno at all.

I know you hate the use of ERRNO in libraries and tooling, but we've decided
to go that way for all of trace-cmd and the libraries (libtraceevent and
libtracefs). This is just being consistent with all the other callers, and
to do it differently will create an inconsistency in the API.

-- Steve
