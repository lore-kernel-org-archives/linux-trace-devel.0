Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0129C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jun 2022 08:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiFBI4C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiFBI4B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 04:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD41A8E17
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jun 2022 01:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6652461177
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jun 2022 08:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2AFC385A5;
        Thu,  2 Jun 2022 08:55:58 +0000 (UTC)
Date:   Thu, 2 Jun 2022 04:55:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Harald Seiler <hws@denx.de>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add missing ) in tracefs_sql docs
Message-ID: <20220602045554.6350d133@rorschach.local.home>
In-Reply-To: <20220531235806.47553-1-hws@denx.de>
References: <20220531235806.47553-1-hws@denx.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  1 Jun 2022 01:58:06 +0200
Harald Seiler <hws@denx.de> wrote:

> Fix a small typo.
> 
> Signed-off-by: Harald Seiler <hws@denx.de>

Applied, thanks Harald!

-- Steve
