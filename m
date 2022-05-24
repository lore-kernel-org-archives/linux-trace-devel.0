Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40A7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 May 2022 15:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiEXPxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 May 2022 11:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiEXPxU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 May 2022 11:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DF991549
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 08:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8904061724
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 15:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F8EC34113;
        Tue, 24 May 2022 15:53:18 +0000 (UTC)
Date:   Tue, 24 May 2022 11:53:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vineeth Pillai <vineethrp@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
Message-ID: <20220524115317.62efeeb0@gandalf.local.home>
In-Reply-To: <CA+HDTgSV3sHD_59dN=NLa4hY_bD3d4ePOwnwJgCM46SXyCEKJQ@mail.gmail.com>
References: <20220504010242.1388192-1-vineethrp@google.com>
        <20220520160842.75d0ecbe@gandalf.local.home>
        <CA+HDTgQ_pvxA6jwXCE2tnj_YWQCcqOLR9FBKRmX68THXcZGkfQ@mail.gmail.com>
        <20220523094700.26eb2a05@gandalf.local.home>
        <CA+HDTgSV3sHD_59dN=NLa4hY_bD3d4ePOwnwJgCM46SXyCEKJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 May 2022 11:35:40 -0400
Vineeth Pillai <vineethrp@google.com> wrote:

> On Mon, May 23, 2022 at 9:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> > > I think we should also think about versioning the guest/host protocols  
> >
> > We actually have that. We are currently at version 3. If this becomes too
> > much of an issue, we can always move to v4. But to do that would require a
> > lot more thinking, as I like to support all versions, and I don't want to
> > have a lot of them. Thus, if we need to update to v4. It would likely be a
> > entirely new protocol to fix and extend the issues of v3.
> >  
> Thanks for the details.. Yeah, doesn't make sense to have a version
> change for this.

But there may be other reasons to update to v4 ;-)

> 
> > > Sure, I will have a look at this again and see if/how we can fix this without
> > > touching existing protocol. I was thinking about adding the pid details to
> > > debugfs and then reading it from there. Its not optimal as we would need a
> > > supporting kernel, but it would be accurate if we have kernel support and we
> > > need not rely on trace messages to get the pids.  
> >
> > That would be useful too, in more than just trace-cmd I believe.
> >  
> Posted a patch upstream for exposing pid in debugfs:
> https://www.spinics.net/lists/kvm/msg278146.html

Saw that.

> 
> I shall work on trace-cmd changes as well once the above patch
> is finalized..

Thanks,

-- Steve
