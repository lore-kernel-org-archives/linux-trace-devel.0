Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5218EC5479D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 20:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbjAIUrI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 15:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbjAIUqo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 15:46:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CED674598
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 12:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF53E6137B
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 20:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA462C433D2;
        Mon,  9 Jan 2023 20:46:40 +0000 (UTC)
Date:   Mon, 9 Jan 2023 15:46:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Replace LFS64 interfaces off64_t and lseek64
Message-ID: <20230109154638.100a3fd5@gandalf.local.home>
In-Reply-To: <CAMKF1spKBjcryWCXN9xHJ-n37JSBe+h0Wc6v=Scj_QxKkp0hsg@mail.gmail.com>
References: <20230107010245.1290391-1-raj.khem@gmail.com>
        <20230109130539.62a15985@gandalf.local.home>
        <CAMKF1spKBjcryWCXN9xHJ-n37JSBe+h0Wc6v=Scj_QxKkp0hsg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 9 Jan 2023 11:42:13 -0800
Khem Raj <raj.khem@gmail.com> wrote:

> Right, I should have said we are already using 64bit functions. I did
> not see it since in yocto
> it was already being added by distro settings.
> I think we need to add -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE and remove
> -D_LARGEFILE64_SOURCE, I can update this in v2.

OK, adding the -D_FILE_OFFSET_BITS=64 does appear to expand off_t.

-- Steve
