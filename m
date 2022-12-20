Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAC8C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 16:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiLTQfd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLTQfd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 11:35:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054EEDFE7
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 08:35:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918BE614FE
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 16:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD30C433D2;
        Tue, 20 Dec 2022 16:35:30 +0000 (UTC)
Date:   Tue, 20 Dec 2022 11:35:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Do not truncate multi-line events
Message-ID: <20221220113528.42b11c25@gandalf.local.home>
In-Reply-To: <c1919b51-f030-ecf0-74a4-0894b177cb28@gmail.com>
References: <20221214154404.5897fc23@gandalf.local.home>
        <c1919b51-f030-ecf0-74a4-0894b177cb28@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Dec 2022 18:33:44 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Sorry for the delay of my replay.

No problem. It's that time of year ;-)

> This patch looks good to me. I am going to apply it.

Great! Thanks for continuing to maintain KernelShark!

-- Steve
