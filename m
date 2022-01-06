Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81873C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 18:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242812AbiAFScH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 13:32:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiAFScG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 13:32:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7DE61CF4
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 18:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1B7C36AEB;
        Thu,  6 Jan 2022 18:32:05 +0000 (UTC)
Date:   Thu, 6 Jan 2022 13:32:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/2]kernel-shark:add new plugin for xenomai
 cobalt_switch_context events
Message-ID: <20220106133204.35d71b6b@gandalf.local.home>
In-Reply-To: <5de4819d-2f49-86c0-900d-a4aa585b67ec@gmail.com>
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
        <20220106121854.106d5b27@gandalf.local.home>
        <5de4819d-2f49-86c0-900d-a4aa585b67ec@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 6 Jan 2022 19:32:56 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Hi Steven,
> Happy New Year!

Happy New Year to you too Yordan!

> 
> I already replayed, asking for some minor corrections.
> https://lore.kernel.org/all/bb1741d5-600a-82a9-d8bc-91222400e129@gmail.com/
> I think the plugin is almost ready.

Strange, I didn't receive it. I wonder if I got booted from the email lists
because I had my mail server offline for too long (/me goes check).

> 
> BTW have you finished the renovation of your office? If yes, I will send you a review for your trace-cruncher patch.
>

Yes, I just finished. Now I'm trying to catch up on everything and also
work on some things that I may not be able to work on when I start working
again.

Cheers,

-- Steve
