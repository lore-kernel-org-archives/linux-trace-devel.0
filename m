Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37724C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 00:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKJAgb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJAga (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 19:36:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453972733
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 16:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81D0615C2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 00:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ACAC433D6;
        Thu, 10 Nov 2022 00:36:28 +0000 (UTC)
Date:   Wed, 9 Nov 2022 19:36:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Bergin <peter@berginkonsult.se>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: make it build against musl C library
Message-ID: <20221109193626.3e3134c5@rorschach.local.home>
In-Reply-To: <20221101105803.191324-1-peter@berginkonsult.se>
References: <20221101105803.191324-1-peter@berginkonsult.se>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  1 Nov 2022 11:58:03 +0100
Peter Bergin <peter@berginkonsult.se> wrote:

> Add missing header file to make it compile with musl C library.
> 
> Signed-off-by: Peter Bergin <peter@berginkonsult.se>

Applied. Thanks Peter!

-- Steve
