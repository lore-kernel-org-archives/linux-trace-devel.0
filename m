Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04796C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Nov 2022 23:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiKYXU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 18:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKYXU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 18:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB903537F3
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 15:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79A60B82C0C
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 23:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92512C433D6;
        Fri, 25 Nov 2022 23:20:23 +0000 (UTC)
Date:   Fri, 25 Nov 2022 18:20:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Jan Engelhardt <jengelh@inai.de>, factory@lists.opensuse.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: trace-cmd build fails due to due make 'not recursively
 expanding'
Message-ID: <20221125182021.621ec979@rorschach.local.home>
In-Reply-To: <20221125103147.arrsukzbgiegfux5@carbon>
References: <20221125092058.poa4hzmz4mve7otm@carbon>
        <1o2r1723-o3o5-3p83-8131-896soq68o76@vanv.qr>
        <20221125103147.arrsukzbgiegfux5@carbon>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Nov 2022 11:31:47 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> On Fri, Nov 25, 2022 at 11:15:38AM +0100, Jan Engelhardt wrote:
> > 
> > On Friday 2022-11-25 10:20, Daniel Wagner wrote:  
> > >
> > >trace-cmd stop building and due to make getting stuck in loop
> > >and complaining with:
> > >
> > >  $ make -d
> > >  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
> > >
> > >I don't really know what's going on. Any ideas?  
> > 
> > https://lists.opensuse.org/archives/list/factory@lists.opensuse.org/thread/FPNDORIL6NDJD3HFQ76LQBIRBCWVG6TV/
> > (I already informed Steven last night via email. / Wasn't aware there 
> > is a linux-trace-devel@)  
> 
> Oops, didn't check the factory mailing list first. So there is no easy
> workaround.

Ouch. Why does "progress" always get in the way of productivity :-p

> 
> FWIW, I've got a bunch of initial Meson patches for libtraceevent and
> libtracefs. I suppose I should also look at trace-cmd. Steven told me
> that he will look at those patches but not before the holiday season.

Yeah, I'm currently on turkey leftover day, but I guess I need to start
looking at these patches. This also means I have to make sure that
Chromebook can still build with them too. As they are part of
Chomebooks now.

If this all works, the it would be great for a trace-cmd version too.

Thanks!

-- Steve
