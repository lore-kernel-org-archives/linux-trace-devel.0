Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368BBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJUCM5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 22:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJUCM4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 22:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFEE1F0422;
        Thu, 20 Oct 2022 19:12:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06599B82A1E;
        Fri, 21 Oct 2022 02:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213C3C433C1;
        Fri, 21 Oct 2022 02:12:51 +0000 (UTC)
Date:   Thu, 20 Oct 2022 22:12:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     richard clark <richard.xnu.clark@gmail.com>
Cc:     bristot@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question about 'for_each_kernel_tracepoint(...)' function
Message-ID: <20221020221255.5b3dffe1@gandalf.local.home>
In-Reply-To: <CAJNi4rMVUzfZJPge=ncaULD87wLQ4TwWS=oKDuC1hZMoWi0OjA@mail.gmail.com>
References: <CAJNi4rM0K=-wgJrS0iLMkam77JTO7oRxcP9VkHGbuTiVGBovMA@mail.gmail.com>
        <20221020111439.76e72230@gandalf.local.home>
        <CAJNi4rMVUzfZJPge=ncaULD87wLQ4TwWS=oKDuC1hZMoWi0OjA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 21 Oct 2022 09:43:14 +0800
richard clark <richard.xnu.clark@gmail.com> wrote:


> Ah, as you can see that I did it, but the result is not what I
> expected :-). Help?

Looking at the code, I see it does indeed only look at builtin tracepoints.

But if you want one module to have access to the tracepoints of another,
then you can have the first one export it.

EXPORT_SYMBOL_TRACEPOINT_GPL(function_event_a);

And then module b should have access to it.

-- Steve
