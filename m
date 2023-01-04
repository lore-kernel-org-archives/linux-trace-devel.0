Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6698AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 04:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbjADEJf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Jan 2023 23:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjADEJd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jan 2023 23:09:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFE91582D
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Jan 2023 20:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCDFB811DA
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 04:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58055C433EF;
        Wed,  4 Jan 2023 04:09:28 +0000 (UTC)
Date:   Tue, 3 Jan 2023 23:09:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michal Sojka <michal.sojka@cvut.cz>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] trace-cmd: Allow building with GNU Make 4.4
Message-ID: <20230103230925.41dfdd8f@gandalf.local.home>
In-Reply-To: <20221226164951.2632069-1-michal.sojka@cvut.cz>
References: <20221226164951.2632069-1-michal.sojka@cvut.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Dec 2022 17:49:51 +0100
Michal Sojka <michal.sojka@cvut.cz> wrote:

> Make 4.4 introduces several backward incompatibilities and the result
> is that building trace-cmd with it never finishes. It seems that make
> ends up in some kind of infinite recursion. The symptoms are:
> 
>     $ make -d
>     GNU Make 4.4
>     Built for x86_64-pc-linux-gnu
>     Copyright (C) 1988-2022 Free Software Foundation, Inc.
>     License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
>     This is free software: you are free to change and redistribute it.
>     There is NO WARRANTY, to the extent permitted by law.
>     Reading makefiles...
>     Reading makefile 'Makefile'...
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
>     Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
> 
> Build succeeds if recursively expanded variables (defined with '='),
> which use $(shell ...) as its value, are replaced with simply expanded
> variables (defined with ':=').
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
> ---

Applied. Thanks Michal!

-- Steve
