Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDB2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Oct 2022 15:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJTPOm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 11:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJTPOl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 11:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB4F2CDE7;
        Thu, 20 Oct 2022 08:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83128B8279A;
        Thu, 20 Oct 2022 15:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87859C433D7;
        Thu, 20 Oct 2022 15:14:35 +0000 (UTC)
Date:   Thu, 20 Oct 2022 11:14:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     richard clark <richard.xnu.clark@gmail.com>
Cc:     bristot@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question about 'for_each_kernel_tracepoint(...)' function
Message-ID: <20221020111439.76e72230@gandalf.local.home>
In-Reply-To: <CAJNi4rM0K=-wgJrS0iLMkam77JTO7oRxcP9VkHGbuTiVGBovMA@mail.gmail.com>
References: <CAJNi4rM0K=-wgJrS0iLMkam77JTO7oRxcP9VkHGbuTiVGBovMA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 20 Oct 2022 17:32:57 +0800
richard clark <richard.xnu.clark@gmail.com> wrote:

> Hi,
> Can this function only find the trace points defined in the kernel

It should find all tracepoints.

> image? I want to define a trace event in my kernel module A, then B
> module to register a probe callback function for that event TP in A. I
> want to kick off a timer in A and call the traced function
> periodically, thus I can monitor the events happening in A from B.

You could also export the tracepoint from A and reference it directly in B.

> 
> Can I do that, is it possible?
> 

Try it and find out. Why ask?

-- Steve
