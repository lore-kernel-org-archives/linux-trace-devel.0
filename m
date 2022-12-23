Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E918C4167B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 17:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiLWRJA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 12:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiLWRI7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 12:08:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122CE73
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 09:08:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6684B82079
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 17:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D76C433D2;
        Fri, 23 Dec 2022 17:08:55 +0000 (UTC)
Date:   Fri, 23 Dec 2022 12:08:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221223120851.5c3ad824@gandalf.local.home>
In-Reply-To: <20221223073243.bjjstqyueyseluic@carbon.lan>
References: <20221221170844.10977-1-dwagner@suse.de>
        <20221221170844.10977-3-dwagner@suse.de>
        <20221223000338.19bacc93@rorschach.local.home>
        <20221223073243.bjjstqyueyseluic@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 23 Dec 2022 08:32:43 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> > And since this holds libtracecmd, does it really need a dependency?  
> 
> IIRC, I saw that the CFLAGS from libtraceevent are used for the
> trace-cmd, but I might just miss something. If trace-cmd doesn't use
> libtraceevent or libtracefs directly than it should be possible to drop
> these direct dependencies.

No, I believe that trace-cmd still uses libtracefs and libtraceevent
directly.

-- Steve
