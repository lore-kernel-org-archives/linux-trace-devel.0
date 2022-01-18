Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63768C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 22:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345013AbiARWlv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jan 2022 17:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiARWlv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jan 2022 17:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEC0C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 14:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90CFAB8165F
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 22:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E892DC340E0;
        Tue, 18 Jan 2022 22:41:47 +0000 (UTC)
Date:   Tue, 18 Jan 2022 17:41:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220118174146.01904fcd@gandalf.local.home>
In-Reply-To: <20220118174019.005afcc2@gandalf.local.home>
References: <20220117201835.0991759f@gandalf.local.home>
        <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
        <20220118174019.005afcc2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Jan 2022 17:40:19 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > I guess you use 'goto err;' everywhere, because you want to stress that returning NULL is essentially exiting with 
> > error. However, so far we used just 'return NULL' everywhere and I would prefer to keep the code consistent.
> > Maybe in a separate patch we can replace all ''return NULL;' lines with a macro that can have some self-explanatory name?  
> 
> Yeah, I was trying to match the existing code, as I'm new to this. ;-)

Oh, if you haven't noticed. I created a tracefs_instance_get_affinity() API
as well ;-)

  https://patchwork.kernel.org/project/linux-trace-devel/patch/20220118030005.1603821-2-rostedt@goodmis.org/

-- Steve

