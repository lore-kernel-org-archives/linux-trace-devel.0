Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 19:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiBRT2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:28:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBRT2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 14:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8935865
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 11:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F18260FF1
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 19:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36677C340E9;
        Fri, 18 Feb 2022 19:28:31 +0000 (UTC)
Date:   Fri, 18 Feb 2022 14:28:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: Rotation of instance traces
Message-ID: <20220218142829.166ce9f6@gandalf.local.home>
In-Reply-To: <20220218142216.535d56c6@gandalf.local.home>
References: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
        <20220218142216.535d56c6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Feb 2022 14:22:16 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Now to be able to do things like splice, and zero copy from the ring
> buffer, when you read the ring buffer it swaps out a sub buffer from the
> writable portion of the ring buffer and makes it into the "reader_page".
> The reader page is now own by the reader, and will never be written to.

I need to correct that statement about never being written to. It can be.
If the current write head is on the page as it gets swapped out and becomes
the reader page. A new write will happen on the reader page, but once the
writer walks off the reader page and into the main ring buffer, it will
never touch the reader page again.

The read logic detects this, and will do copies of the page to send it to
the user as it can not give the page itself to the user with the writer
still on it.

-- Steve

