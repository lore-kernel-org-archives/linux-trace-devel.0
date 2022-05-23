Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74570C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 May 2022 13:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbiEWNrL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 May 2022 09:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbiEWNrK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 May 2022 09:47:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7881355220
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 06:47:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BC77B810FE
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7560FC385AA;
        Mon, 23 May 2022 13:47:02 +0000 (UTC)
Date:   Mon, 23 May 2022 09:47:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vineeth Pillai <vineethrp@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
Message-ID: <20220523094700.26eb2a05@gandalf.local.home>
In-Reply-To: <CA+HDTgQ_pvxA6jwXCE2tnj_YWQCcqOLR9FBKRmX68THXcZGkfQ@mail.gmail.com>
References: <20220504010242.1388192-1-vineethrp@google.com>
        <20220520160842.75d0ecbe@gandalf.local.home>
        <CA+HDTgQ_pvxA6jwXCE2tnj_YWQCcqOLR9FBKRmX68THXcZGkfQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 23 May 2022 09:39:45 -0400
Vineeth Pillai <vineethrp@google.com> wrote:

> On Fri, May 20, 2022 at 4:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> >> +     be32 max_apicid;
> >>       be32 page_size;
> >>       u64 trace_id;
> >>       char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];  
> >
> >Unfortunately, the above will break the protocol for released instances of
> >trace-cmd that is already out there. One requirement I have is that if two
> >instances of trace-cmd use to work (on host and guest) that if you upgrade
> >one of them, what use to work still does.
> >
> >We need to figure out another way to handle this :-/
> >  
> Ahh ok, understood..
> I think we should also think about versioning the guest/host protocols

We actually have that. We are currently at version 3. If this becomes too
much of an issue, we can always move to v4. But to do that would require a
lot more thinking, as I like to support all versions, and I don't want to
have a lot of them. Thus, if we need to update to v4. It would likely be a
entirely new protocol to fix and extend the issues of v3.


> >We'll have to investigate a solution for this further.  

> Sure, I will have a look at this again and see if/how we can fix this without
> touching existing protocol. I was thinking about adding the pid details to
> debugfs and then reading it from there. Its not optimal as we would need a
> supporting kernel, but it would be accurate if we have kernel support and we
> need not rely on trace messages to get the pids.

That would be useful too, in more than just trace-cmd I believe.

-- Steve

