Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125B6EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jul 2023 22:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjGEWXS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjGEWXR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 18:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1563A9
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 15:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA146173A
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jul 2023 22:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74644C433C7;
        Wed,  5 Jul 2023 22:23:15 +0000 (UTC)
Date:   Wed, 5 Jul 2023 18:23:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org, Tony Jones <tonyj@suse.com>
Subject: Re: [PATCH] libtracefs: Add explicit pthread dependency to meson
Message-ID: <20230705182313.39b60d76@gandalf.local.home>
In-Reply-To: <20230615174349.8810-1-dwagner@suse.de>
References: <20230615174349.8810-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Jun 2023 19:43:49 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> Older version of meson do not add automatically the pthread dependency.
> Thus add it explicitly to the build.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

Applied. Thanks Daniel!

-- Steve

> ---
>  meson.build         | 1 +
>  samples/meson.build | 4 ++--
>  src/meson.build     | 4 ++--
>  utest/meson.build   | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
