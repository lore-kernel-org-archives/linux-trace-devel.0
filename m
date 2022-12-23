Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74123C3DA79
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 19:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiLWTZv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 14:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiLWTZu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 14:25:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AF0B5A
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 11:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B42B82101
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 19:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7316C433D2;
        Fri, 23 Dec 2022 19:25:45 +0000 (UTC)
Date:   Fri, 23 Dec 2022 14:25:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] libtracecmd: Add initial support for meson
Message-ID: <20221223142543.3c5029a3@gandalf.local.home>
In-Reply-To: <20221223101502.12269-2-dwagner@suse.de>
References: <20221223101502.12269-1-dwagner@suse.de>
        <20221223101502.12269-2-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 23 Dec 2022 11:15:01 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> +++ b/lib/meson.build
> @@ -0,0 +1,109 @@
> +# SPDX-License-Identifier: LGPL-2.1
> +#
> +# Copyright (c) 2022 Daniel Wagner, SUSE LLC
> +
> +project(
> +    'libtrace-cmd', ['c'],
> +    meson_version: '>= 0.50.0',
> +    license: 'GPL-2.0',
> +    version: '1.3.0',
> +    default_options: [
> +      'c_std=gnu99',
> +      'buildtype=release',

The default buildtype should be debug. If someone downloads the source,
they are probably going to debug it. I found this annoying when I went to
use gdb, and there were no symbols present.

-- Steve


> +      'prefix=/usr/local',
> +      'warning_level=1',
> +    ]
> +)
