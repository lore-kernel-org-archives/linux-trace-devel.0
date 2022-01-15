Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270CBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiAOQVW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiAOQVW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:21:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBB7C061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:21:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8B160E01
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 16:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA01CC36AE3;
        Sat, 15 Jan 2022 16:21:20 +0000 (UTC)
Date:   Sat, 15 Jan 2022 11:21:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 00/25] Trace file version 7 - sections
Message-ID: <20220115112119.222fa765@gandalf.local.home>
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:23 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduce the next version of the trace-cmd trace file - 7. Major changes
> since version 6 is more flexible extendable structure of the file, based on
> independent sections.
> 
> v7 changes:
>  - Rebased on top of the latest master.
>  - Introduced new metadata strings section.
>  - Use 8 bytes for section size. 

I finished my review of this series. Looks good!

I'm hoping that v8 will be the final one.

Thanks Tzvetomir,

-- Steve
