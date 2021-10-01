Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A419FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 15:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8831A61ACF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 15:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhJAP7g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 11:59:36 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37122 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhJAP7f (ORCPT
        <rfc822;linux-trace-devel@VGER.KERNEL.ORG>);
        Fri, 1 Oct 2021 11:59:35 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 04A8B20B8008;
        Fri,  1 Oct 2021 08:57:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 04A8B20B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633103871;
        bh=L+hTirf2j5Nmu4ftJs5tmkbZpphyA9Gv2h6o4DaLNCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YOOIg2G2JUKz8vunSF/eCpzCgpiMQwZBTcgaCBNm7+3Q2MF+6XH2kFr2mj/Bb0R4e
         CgOCFHQngtMbE9LEvoUMQt+k6+tpJGYDMBg4R+/dyaU66Mib6pn4rpTq/BaBuhHXKI
         quDH+rLcQ2NPT5ywcijiYomn8gVEY85IyUFWV2Qk=
Date:   Fri, 1 Oct 2021 08:57:46 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-trace-devel@VGER.KERNEL.ORG, rostedt@goodmis.org,
        zanussi@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] synth_events: Do not block other dyn_event systems
 during create
Message-ID: <20211001155746.GA16348@kbox>
References: <20210930223821.11025-1-beaub@linux.microsoft.com>
 <20211001125513.cf40fa1a3188416582666f66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001125513.cf40fa1a3188416582666f66@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> Thanks for clean up the synthetic event!
> This looks good to me.
> 
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
No problem, thanks for the review!

> So now are you trying to reuse synth event for user event?
> Then I think you need to register a new dyn_event ops so
> that histogram will not submit the event.
A user events patch will get sent out soon, I'm finalizing some testing.
User events will register it's own dyn_event ops and allow users the
option to create, delete and view status of user events via the
dynamic_events tracefs file (in addition to the user mode IOCTL/ABI).

As probes attach to the user events the status of this is reflected in
dynamic_events, which makes it easy for admins to see why one is busy,
etc. It also makes it easy to verifying the system is working as
expected with just a terminal.

> BTW, how do you filter an event written by a user process?
> Will you add an array of event id for the file data structure?
The filtering would happen at the trace_event level, the only filtering
at the user event level is if a probe has been enabled on the underlying
trace_event or not. That is done via the shared page bits being cleared
or set. Bits are updated as probe un/registrations occur.

Users can advertise field values, offsets, etc as well as the print_fmt
in the newer ABI/patch based on the feedback from LPC2021. These land in
the trace_event fields and are viewable via tracefs like any other
evnet. I hope that is enough to light up the history feature of trace_event.
I am not familiar with it as much as you all.

Thanks,
-Beau
