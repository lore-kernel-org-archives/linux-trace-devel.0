Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B47C43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 16:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiGKQng (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGKQnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 12:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569FB30B
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 09:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA9BB80E40
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0B1C34115;
        Mon, 11 Jul 2022 16:43:28 +0000 (UTC)
Date:   Mon, 11 Jul 2022 12:43:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: unbreak parallel build
Message-ID: <20220711124326.75f06c4d@gandalf.local.home>
In-Reply-To: <20220624210726.84857-1-jengelh@inai.de>
References: <20220624210726.84857-1-jengelh@inai.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 24 Jun 2022 23:07:26 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> Entering a directory concurrently is worse than anything the
> "recursive make considered harmful" essay could ever think of.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>


Applied, thanks Jan!

-- Steve
