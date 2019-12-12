Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946C8C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 19:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686AE21556
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576178135;
	bh=p8Wps23M8SCZ4Sr6iYtCzqhjuQMNUjXt/46cM5iUF/Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=tU+Z1OSkqx5tw+We2M1RTyi2dXOp8zWS1Jm0tH08GlKaTjMywLrgXvvdn36av3iaK
	 MFG4MfuNBVStr4l8papFwuz/p7zCX/PI59aGAICh8pPj5LNRBD9GgCcbcBJUrVqoct
	 ZqTMiJJHYX0kOrlnqi8mgfBsVNT3oWYerADf8tnQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfLLTPf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 14:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbfLLTPe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 14:15:34 -0500
Received: from tzanussi-mobl (c-98-220-238-81.hsd1.il.comcast.net [98.220.238.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A5C2073B;
        Thu, 12 Dec 2019 19:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576178134;
        bh=p8Wps23M8SCZ4Sr6iYtCzqhjuQMNUjXt/46cM5iUF/Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JALExRVnf5SAayjok7kPScE9p2FORpsuJnzJLSeVATFOYjE2Yrtq8TyRoLCg0soec
         nphELjHBk8Tri4a6tWPs7ET2hm5PmayiaTa+F+g85XhUZLkP+o/dGz7AvRMqyF7ts1
         mnnvYiollwidB9oROmGi1FVyNoH5h720Ky+vu1pY=
Message-ID: <1576178132.3309.1.camel@kernel.org>
Subject: Re: ftrace histogram sorting broken on BE architecures
From:   Tom Zanussi <zanussi@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sven Schnelle <svens@stackframe.org>,
        linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 12 Dec 2019 13:15:32 -0600
In-Reply-To: <20191212130729.05091d3a@gandalf.local.home>
References: <20191211123316.GD12147@stackframe.org>
         <20191211103557.7bed6928@gandalf.local.home>
         <20191211110959.2baeb70f@gandalf.local.home>
         <1576082238.2833.8.camel@kernel.org>
         <20191211120051.711582ee@gandalf.local.home>
         <1576092363.2833.20.camel@kernel.org>
         <20191212130729.05091d3a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Thu, 2019-12-12 at 13:07 -0500, Steven Rostedt wrote:
> On Wed, 11 Dec 2019 13:26:03 -0600
> Tom Zanussi <zanussi@kernel.org> wrote:
> 
> > > Are they? I see in create_key_field:
> > > 
> > > 	key_size = ALIGN(key_size, sizeof(u64));
> > > 
> > > Which to me seems that we'll have nothing smaller than
> > > sizeof(u64).
> > >   
> > 
> > Yeah, that makes them effectively u64 in this case, so I'd agree.
> 
> Hi Tom,
> 
> Does this mean it's good to go? It just passed my test suite, and I
> can
> send it to Linus now.
> 

Yes, I think so.  I'll go and ack the patch.

Thanks,

Tom

> -- Steve
