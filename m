Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B6AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 19:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiDRTkH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiDRTkG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 15:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFC722B18
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 12:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B7AA60F58
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 19:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73675C385A1;
        Mon, 18 Apr 2022 19:37:25 +0000 (UTC)
Date:   Mon, 18 Apr 2022 15:37:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] trace-cmd agent: Allow for ip connections from
 the agent
Message-ID: <20220418153723.1d723638@gandalf.local.home>
In-Reply-To: <CAPpZLN6UyZ00koS+FWWsq_SKYpoYMkSb_TTNmehG2LwBu3P6OA@mail.gmail.com>
References: <20220417184538.1044417-1-rostedt@goodmis.org>
        <20220417184538.1044417-5-rostedt@goodmis.org>
        <CAPpZLN6UyZ00koS+FWWsq_SKYpoYMkSb_TTNmehG2LwBu3P6OA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 18 Apr 2022 13:22:51 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Mon, Apr 18, 2022 at 11:28 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> >
> > Add a -N option to trace-cmd agent to listen on a network socket that
> > can be used by trace-cmd record -A to connect with.
> >  
> 
> I have concerns about exposing the agent over the network, without any
> client authentication. It runs with root privileges, the kernel
> tracing data will be exposed to anyone over the network. At least,
> this should be written clearly in the documentation and even should be
> printed by "trace-cmd agent -N ...". I saw your patch that adds a name
> or IP address of the client as parameter, it is some security, but the
> tracing data itself still flows unencrypted over the network and could
> be visible to anyone.

True. But it's similar to telnet. The use case for this option is for local
networks where you expect to "trust" the network.

I'm fine with adding more warnings and stating that this is "NOT SECURE" in
big letters to let people know the dangers of it. I'm hoping to have more
authentication in the future.

I could even have it print a warning "UNSECURE CONNECTION" or something to
enforce that this is not something you want to use in any scenario.

-- Steve
