Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739DAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 05:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLWFDo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 00:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLWFDo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 00:03:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0665B6595
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 21:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DFEF61E47
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Dec 2022 05:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73250C433D2;
        Fri, 23 Dec 2022 05:03:41 +0000 (UTC)
Date:   Fri, 23 Dec 2022 00:03:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221223000338.19bacc93@rorschach.local.home>
In-Reply-To: <20221221170844.10977-3-dwagner@suse.de>
References: <20221221170844.10977-1-dwagner@suse.de>
        <20221221170844.10977-3-dwagner@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Dec 2022 18:08:44 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Add support for building the project with meson.
> 
> trace-cmd depends on a statically linked libtracecmd
> (e.g. trace_perf_open, trace_perf_close, trace_perf_init).
> 
> That means before kicking off the trace-cmd build a statically build
> libtracecmd needs to be available:
> 
>   cd lib
>   meson setup --prefix=/tmp/trace-cmd --default-library=static .build
>   meson compile -C .build
>   meson install -C .build
> 

I get this:

   Run-time dependency audit found: NO (tried pkgconfig and cmake)

   meson.build:77:0: ERROR: Dependency "audit" not found, tried pkgconfig and cmake

audit is an optional dependency. Is there a way to do that? And add
defines set if it is not?

What's the reason for the "get_option('audit')"?

Doesn't seem to be working as expected.

> then
> 
>   cd ..
>   export PKG_PATH_PATH=/tmp/trace-cmd/lib64/pkgconfig
>   meson setup .build


> +cc = meson.get_compiler('c')
> +
> +prefixdir = get_option('prefix')
> +bindir    = join_paths(prefixdir, get_option('bindir'))
> +mandir    = join_paths(prefixdir, get_option('mandir'))
> +htmldir   = join_paths(prefixdir, get_option('htmldir'))
> +
> +conf = configuration_data()
> +
> +libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
> +libtracefs_dep = dependency('libtracefs', version: '>= 1.6.3', required: true)
> +libtracecmd_dep = dependency('libtracecmd', version: '>= 1.3.0', required: true,

I'm guessing you just looked at the latest version and added them?

Min versions are:

  libtraceevent is 1.5
  libtracefs 1.6

And since this holds libtracecmd, does it really need a dependency?

-- Steve
