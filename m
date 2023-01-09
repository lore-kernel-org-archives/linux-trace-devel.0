Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F03DC5479D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 23:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbjAIXvb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbjAIXv3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 18:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E619BDFCC
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 15:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8B9B810AB
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 23:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D4C433EF;
        Mon,  9 Jan 2023 23:51:03 +0000 (UTC)
Date:   Mon, 9 Jan 2023 18:51:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] Replace LFS64 interfaces off64_t and lseek64
Message-ID: <20230109185100.7b0cf697@gandalf.local.home>
In-Reply-To: <20230109225315.1284538-1-raj.khem@gmail.com>
References: <20230109225315.1284538-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  9 Jan 2023 14:53:14 -0800
Khem Raj <raj.khem@gmail.com> wrote:

> Musl does not define these interfaces unless -D_LARGEFILE64_SOURCE is
> defined and that too it is transitional until apps switch to using 64-bit
> off_t. We pass -D_FILE_OFFSET_BITS=64 in makefiles already therefore
> original lseek and off_t are already 64bit
> 
> This fixes build with latest musl which has dropped LFS64 interfaces [1]
> 
> [1] https://git.musl-libc.org/cgit/musl/commit/?id=246f1c811448f37a44b41cd8df8d0ef9736d95f4i
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---

FYI, when submitting patches, please have the subject state the project, as
the mailing list covers multiple projects, and the subjects are used to
determine which project its for.

Subject: trace-cmd: Replace LFS64 interfaces off64_t and lseek64

You don't need to resubmit, I can add it, but just for future submissions.

Thanks!

-- Steve
