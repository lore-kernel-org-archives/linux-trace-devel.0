Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D98C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 03:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CBC960F94
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 03:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhJMDRb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 23:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhJMDRa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 23:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BA8F60C41;
        Wed, 13 Oct 2021 03:15:20 +0000 (UTC)
Date:   Tue, 12 Oct 2021 23:15:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] trace-cmd: Dump fraction bits from
 TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20211012231519.2e86e607@oasis.local.home>
In-Reply-To: <20210923094526.765059-4-tz.stoyanov@gmail.com>
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
        <20210923094526.765059-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 23 Sep 2021 12:45:26 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Dump the fraction bits from the extended TRACECMD_OPTION_TIME_SHIFT
> option.

This just says what the patch does, it does not say why.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-dump.c | 102 ++++++++++++++++++++++++++++++------------
>  1 file changed, 73 insertions(+), 29 deletions(-)
