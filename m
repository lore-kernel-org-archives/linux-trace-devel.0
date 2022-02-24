Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888F3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 01:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiBXBxB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 20:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiBXBwv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 20:52:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3853A3CFC8
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 17:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0596B8235A
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 01:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1BAC340E7;
        Thu, 24 Feb 2022 01:52:19 +0000 (UTC)
Date:   Wed, 23 Feb 2022 20:52:17 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add define for ALL dynamic events
Message-ID: <20220223205217.2d7ea5b0@rorschach.local.home>
In-Reply-To: <20220214080241.634290-1-tz.stoyanov@gmail.com>
References: <20220214080241.634290-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Feb 2022 10:02:41 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some of the tracefs APIs for dynamic events accept bitmask of events. If
> a caller wants to address all types of events, it should list them in
> the bitmask. This logic is fragile. When a new type of dynamic event is
> introduced, the API callers should be modified. That's why a new define
> is added, part of the library API, to address all types of dynamic
> events.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

And of course, after I release 1.3, I discovered I forgot about this patch :-p

Well, it's usually a tradition to release a .1 right after a .0 due to
something stupid I did :-/

-- Steve
