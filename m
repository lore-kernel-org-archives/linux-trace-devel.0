Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2550C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 16:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjADQCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 11:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbjADQBi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 11:01:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97293C38E
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 08:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 857DA6178E
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 16:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92515C433F0;
        Wed,  4 Jan 2023 16:01:30 +0000 (UTC)
Date:   Wed, 4 Jan 2023 11:01:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104110128.1cabdf08@gandalf.local.home>
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

> In case you want to build/install the documentation the setup is
> 
>   meson -Ddocs-build=true .build
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

Can we make this so that building docs does not require building the rest
of the code?

-- Steve
