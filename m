Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAD2C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 15:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ABC622BEF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 15:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGZPSQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 11:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfGZPSQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 11:18:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8E9216B7;
        Fri, 26 Jul 2019 15:18:15 +0000 (UTC)
Date:   Fri, 26 Jul 2019 11:18:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-trace-devel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Darren Hart <dvhart@infradead.org>, troyengel@gmail.com
Subject: Re: [PATCH 3/3] trace-cmd: Use PyLong_AsLong() for Python 3
Message-ID: <20190726111814.3a29472c@gandalf.local.home>
In-Reply-To: <076f6cad8adf6fd8eec78dfe7c8a76ed7d5914ae.camel@sipsolutions.net>
References: <20190719224613.207069107@goodmis.org>
        <20190719225030.507227790@goodmis.org>
        <076f6cad8adf6fd8eec78dfe7c8a76ed7d5914ae.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Jul 2019 09:31:57 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Fri, 2019-07-19 at 18:46 -0400, Steven Rostedt wrote:
>  
> > +#if PY_MAJOR_VERSION >= 3  
> [...]
> > +#define PY_INT_AS_LONG PyLong_AsLong
> >  #else  
> [...]
> > +#define PY_INT_AS_LONG PyInt_AS_LONG
> > +#endif  
> 
> I probably would've gone for only having a single
> 
>  #define PyLong_AsLong PyInt_AS_LONG
> 
> in the python2 case, but doesn't really matter.
> 
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 

Hi Johannes,

Thanks for the review (unfortunately, due to the rush to get
KernelShark 1.0 out, I already applied them, I should have Cc'd you on
them too).

Should we make any of the above changes you mentioned to any of these
patches? I'm looking at releasing trace-cmd 2.8.4 with all these
changes and will hold off if you think it would be better to update
them.

Thanks!

-- Steve
