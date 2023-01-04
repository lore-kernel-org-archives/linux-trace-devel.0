Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41C2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjADRcv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbjADRcj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:32:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755501AA05
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27225B816A2
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76749C433D2;
        Wed,  4 Jan 2023 17:32:35 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:32:33 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104123233.1c720cc0@gandalf.local.home>
In-Reply-To: <20230104171018.pghozcx2c6wyak72@carbon.lan>
References: <20221228082906.3272-1-dwagner@suse.de>
        <20230104110128.1cabdf08@gandalf.local.home>
        <20230104171018.pghozcx2c6wyak72@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Jan 2023 18:10:18 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> Yes, it could be done by introducing a new target which is not run per
> default. Currently, the docs are not added to the build when
> '-Ddocs-build=true' is missing.
> 
> If I understood you correctly you prefer:
> 
>   meson setup .build
>   meson compile -C .build
>   meson compile -C .build doc
> 
> and drop the '-Ddocs-build' option?

Yes.

Thanks!

-- Steve
