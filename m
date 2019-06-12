Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5372DC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312B7208C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFLMMz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfFLMMz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 08:12:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74D9520866;
        Wed, 12 Jun 2019 12:12:54 +0000 (UTC)
Date:   Wed, 12 Jun 2019 08:12:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Alan Mikhak <alanmikhak@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Message-ID: <20190612081252.6fd3d118@gandalf.local.home>
In-Reply-To: <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
        <b0108c01-00f4-fc5e-7fef-03e6984f361e@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Jun 2019 07:34:35 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> On 12.06.19 г. 6:59 ч., Alan Mikhak wrote:
> > Fix compiler error at KsSession.cpp:457:30 on Raspberry Pi 3
> > 
> > Fix by changing the type of local variable 'pos' from uint64_t to
> > size_t in KsSession::loadDualMarker().
> > 
> > KsSession.cpp:457:30: error: no matching function for call to
> > ‘KsSession::_getMarker(const char [6], uint64_t*)’
> >    if (_getMarker("markA", &pos)) {
> >                                ^
> > In file included from KsSession.cpp:14:0:
> > KsSession.hpp:97:7: note: candidate:
> >   bool KsSession::_getMarker(const char*, size_t*)
> >    bool _getMarker(const char* name, size_t *pos);
> >         ^~~~~~~~~~
> > KsSession.hpp:97:7: note:   no known conversion for
> > argument 2 from ‘uint64_t* {aka long long unsigned int*}’
> > to ‘size_t* {aka unsigned int*}’
> > 
> > Signed-off-by: Alan Mikhak <amikhak@wirelessfabric.com>
> > ---
> >   kernel-shark/src/KsSession.cpp | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSession.cpp
> > index 9d86776..a581bbf 100644
> > --- a/kernel-shark/src/KsSession.cpp
> > +++ b/kernel-shark/src/KsSession.cpp
> > @@ -450,7 +450,7 @@ void KsSession::saveDualMarker(KsDualMarkerSM *dm)
> >    */
> >   void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTraceGraph *graphs)
> >   {
> > -	uint64_t pos;
> > +	size_t pos;
> >   
> >   	dm->reset();
> >   	dm->setState(DualMarkerState::A);
> >   
> 
> 
> Hi Alan,
> Thanks a lot for this fix!
> 
> Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> 

Thanks Alan and Yordan.

I queued this patch for my next push to the repo (currently working on
some other things before I do that push).

-- Steve
