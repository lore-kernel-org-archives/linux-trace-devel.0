Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666C5C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbjADRfD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjADRfC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:35:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6371C1AA05
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED6FB81733
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8B7C433D2;
        Wed,  4 Jan 2023 17:34:58 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:34:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104123456.70202ea9@gandalf.local.home>
In-Reply-To: <20230104123143.405dcc5e@gandalf.local.home>
References: <20221228082906.3272-1-dwagner@suse.de>
        <20230104104526.067d42f5@gandalf.local.home>
        <20230104170559.kn2j3abp22l56chq@carbon.lan>
        <20230104123143.405dcc5e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Jan 2023 12:31:43 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 4 Jan 2023 18:05:59 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > > It's still missing the building of the static library libtraceevent.a.    
> > 
> > This is controlled via 'meson setup --default-library {shared, static, both}'.  
> 
> Can we make it default to 'both' ?

Actually, I'm working on adding a Makefile that controls all this. I can
make that do the "both"

-- Steve
