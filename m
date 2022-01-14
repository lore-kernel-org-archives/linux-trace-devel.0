Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E504C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 21:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiANVG6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:06:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36622 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiANVG5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 16:06:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC2BAB82A34
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 21:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FD7C36AE5;
        Fri, 14 Jan 2022 21:06:55 +0000 (UTC)
Date:   Fri, 14 Jan 2022 16:06:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] libtracefs: Update main man page
Message-ID: <20220114160653.583f25ef@gandalf.local.home>
In-Reply-To: <20220114095950.41334-3-tz.stoyanov@gmail.com>
References: <20220114095950.41334-1-tz.stoyanov@gmail.com>
        <20220114095950.41334-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 Jan 2022 11:59:50 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> All API functions of the library should be listed in the main man page,
> "man libtracefs". Some of the newly added APIs are missing there,
> updated the list.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---

I took this patch and pushed it up.

-- Steve
