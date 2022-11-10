Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2765C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 05:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiKJFrM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 00:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKJFrL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 00:47:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3331E1403E
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 21:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8548B820CB
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Nov 2022 05:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF94C433D6;
        Thu, 10 Nov 2022 05:47:07 +0000 (UTC)
Date:   Thu, 10 Nov 2022 00:47:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org, mhiramat@kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2] tracing: Dump instance traces into dmesg on
 ftrace_dump_on_oops
Message-ID: <20221110004705.50a8a147@rorschach.local.home>
In-Reply-To: <20221110031019.3005130-1-joel@joelfernandes.org>
References: <20221110031019.3005130-1-joel@joelfernandes.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 10 Nov 2022 03:10:19 +0000
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

> Currently ftrace only dumps the global trace buffer on an OOPs. For
> debugging a production usecase, I'd like to dump instance traces as
> well, into the kernel logs. The reason is we cannot use the global trace
> buffer as it may be used for other purposes.
> 
> This patch adds support for dumping the trace buffer instances along
> with the global trace buffer.
> 
> The instance traces are dumped first, and then the global trace buffer.
> 
> Cc: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>

Please send kernel related patches to LKML and to
linux-trace-kernel@vger.kernel.org.

linux-trace-devel is for user space tooling.

I had a patch to update MAINTAINERS, but it seems that it was never
applied. :-/

Thanks!

-- Steve


