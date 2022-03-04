Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05E8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 18:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbiCDST5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241562AbiCDST4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 13:19:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE1390FD2
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Mar 2022 10:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B858B82B5D
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Mar 2022 18:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD0CC340E9;
        Fri,  4 Mar 2022 18:19:00 +0000 (UTC)
Date:   Fri, 4 Mar 2022 13:18:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] trace-cmd: Use a structure to describe a
 compression protocol
Message-ID: <20220304131859.308694df@gandalf.local.home>
In-Reply-To: <20220304055658.440904-2-tz.stoyanov@gmail.com>
References: <20220304055658.440904-1-tz.stoyanov@gmail.com>
        <20220304055658.440904-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  4 Mar 2022 07:56:54 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Changed the tracecmd_compress_proto_register() function to use a
> structure instead of list of arguments to describe new compression
> protocol. That approach is more flexible and allows to extend the API in
> the future without changing the already implemented protocols.
> 
> Suggested-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>

Hi Tzvetomir,

Just an FYI. Sebastian gave an "Acked-by" to these patches previously. It
should be added to the follow up patches if the patches haven't changed.
And you can even keep them if the patch changed slightly (like to fix the
crash I reported).

Otherwise, the Acked-by's will likely be dropped. If I didn't notice this,
they would have been.

So, unless the patch changes in logic, all new versions should contain
Acked/Reviewed-by tags that you have received from previous versions.

  https://lore.kernel.org/all/Yh8Wq4KAGJ6WtqKc@breakpoint.cc/

Just so you know for future patches.

-- Steve
