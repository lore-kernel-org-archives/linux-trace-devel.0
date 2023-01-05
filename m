Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2315C46467
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 00:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjAEA75 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 19:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjAEA7l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 19:59:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9BD3057E
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 16:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A2FE6185D
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 00:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EC3C433D2;
        Thu,  5 Jan 2023 00:58:04 +0000 (UTC)
Date:   Wed, 4 Jan 2023 19:58:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: fix makefile cscope target
Message-ID: <20230104195802.5843614a@gandalf.local.home>
In-Reply-To: <Y7YRrHaV+V6v+9WZ@mail.google.com>
References: <Y7YRrHaV+V6v+9WZ@mail.google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 5 Jan 2023 12:54:20 +1300
Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com> wrote:

> existing cscope target using sh pipes was broken and cscope was throwing
> the following error:
> 
> 	$ make cscope
> 	[..]
> 	cscope: no source files found
> 
> fix cscope target by writing files to be indexed into a separate file
> called cscope.files which cscope reads by default
> 

Thanks Paulo.

I don't use cscope, so I never tested it. In fact, I had to install it to
test this patch after I applied it ;-)

Anyway, I added it to the queue.

Thanks!

-- Steve

