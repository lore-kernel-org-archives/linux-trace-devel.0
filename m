Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE3CC53210
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 16:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbjADQKV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 11:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239860AbjADQJl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 11:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398E44085D
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 08:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E43D4B8172C
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 16:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3F7C433EF;
        Wed,  4 Jan 2023 16:09:19 +0000 (UTC)
Date:   Wed, 4 Jan 2023 11:09:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230104110916.4f652a96@gandalf.local.home>
In-Reply-To: <20221228082927.3499-1-dwagner@suse.de>
References: <20221228082927.3499-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Dec 2022 09:29:27 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Introduce Meson as build framework for building libtracefs. This
> lives besides the Makefiles until all the expected initial fallouts
> have been dealed with.
> 
> The build steps are:
> 
>   # configure using .build as build directory and install destination
>   # /tmp/test
>   meson --prefix=/tmp/libtracefs .build
> 
>   # trigger the build
>   ninja -C .build
> 
>   # install the library
>   ninja -C .build install
> 
> In case you want to build/install the documentation the setup is
> 
>   meson -Ddocs-build=true .build
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

This also doesn't build the static library libtracefs.a.

We have environments that we need to build trace-cmd statically. As
trace-cmd depends on libtraceevent and libtracefs, that means both need a
static library as well.

-- Steve
