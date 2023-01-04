Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A876BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 15:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbjADPqB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 10:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbjADPpa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 10:45:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AD7395C5
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 07:45:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D8C61775
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 15:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E8DC433D2;
        Wed,  4 Jan 2023 15:45:28 +0000 (UTC)
Date:   Wed, 4 Jan 2023 10:45:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104104526.067d42f5@gandalf.local.home>
In-Reply-To: <20221228082906.3272-1-dwagner@suse.de>
References: <20221228082906.3272-1-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Dec 2022 09:29:06 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Introduce Meson as build framework for building libtraceevent. This
> lives besides the Makefiles until all the expected initial fallouts
> have been dealed with.
> 
> The build steps are:
> 
>   # configure using .build as build directory and install destination
>   # /tmp/test
>   meson --prefix=/tmp/libtraceevent .build
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
> ---

It's still missing the building of the static library libtraceevent.a.

-- Steve
