Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08950C10F03
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D76082054F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390413AbfCVMRr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390009AbfCVMRq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 08:17:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2388321929;
        Fri, 22 Mar 2019 12:17:46 +0000 (UTC)
Date:   Fri, 22 Mar 2019 08:17:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Have tracecmd_msg_data_send() return zero on
 zero size
Message-ID: <20190322081744.5df7cf3a@gandalf.local.home>
In-Reply-To: <66ec4786aecc3585081b932ab96b700f13f78d96.camel@vmware.com>
References: <20190321194127.4ac47d99@gandalf.local.home>
        <66ec4786aecc3585081b932ab96b700f13f78d96.camel@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 11:49:29 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
> > index 51d0ac8b..382bd766 100644
> > --- a/tracecmd/trace-msg.c
> > +++ b/tracecmd/trace-msg.c
> > @@ -590,6 +590,10 @@ int tracecmd_msg_data_send(struct
> > tracecmd_msg_handle *msg_handle,
> >  	int ret;
> >  	int count = 0;
> >  
> > +	/* Don't bother doing anything if there's nothing to do */
> > +	if (!size)
> > +		return 0;
> > +
> >  	tracecmd_msg_init(MSG_SEND_DATA, &msg);
> >  
> >  	msg.buf = malloc(MSG_MAX_DATA_LEN);  
> 
> Nice catch. Definitely a latent bug waiting for someone to step on it.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Yeah, it tripped me up, as I had a box that crashed because of it.
Delaying the finishing of the testing. Which I'm rerunning now.

-- Steve
