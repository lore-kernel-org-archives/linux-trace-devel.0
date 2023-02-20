Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9545C05027
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Feb 2023 18:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjBTSRs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Feb 2023 13:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjBTSRr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Feb 2023 13:17:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D6220552
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Feb 2023 10:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 276B3B80D9A
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Feb 2023 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF40C433D2;
        Mon, 20 Feb 2023 18:17:43 +0000 (UTC)
Date:   Mon, 20 Feb 2023 13:17:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     psykose <alice@ayaya.dev>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: fix some missing commas in big endian
 blocks
Message-ID: <20230220131741.606891e8@gandalf.local.home>
In-Reply-To: <20230220175241.15424-1-alice@ayaya.dev>
References: <20230220175241.15424-1-alice@ayaya.dev>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Feb 2023 18:52:41 +0100
psykose <alice@ayaya.dev> wrote:

> the lack of a trailing comma makes the array definition invalid, since elements
> must be comma delimited in the initialiser. so, add one in the big endian case
> too.

Thanks. I was also wondering if anyone was doing anything with big endian
these days ;-)

-- Steve


> 
> Signed-off-by: psykose <alice@ayaya.dev>
> ---
