Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F09AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjADRcT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjADRbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E519D320
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8142861563
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F585C433EF;
        Wed,  4 Jan 2023 17:31:45 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:31:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104123143.405dcc5e@gandalf.local.home>
In-Reply-To: <20230104170559.kn2j3abp22l56chq@carbon.lan>
References: <20221228082906.3272-1-dwagner@suse.de>
        <20230104104526.067d42f5@gandalf.local.home>
        <20230104170559.kn2j3abp22l56chq@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Jan 2023 18:05:59 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> > It's still missing the building of the static library libtraceevent.a.  
> 
> This is controlled via 'meson setup --default-library {shared, static, both}'.

Can we make it default to 'both' ?

-- Steve
