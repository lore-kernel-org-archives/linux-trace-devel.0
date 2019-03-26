Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7636C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 01:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E4482083D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 01:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfCZB6t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 21:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfCZB6t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 21:58:49 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8CD204EC;
        Tue, 26 Mar 2019 01:58:48 +0000 (UTC)
Date:   Mon, 25 Mar 2019 21:58:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
Message-ID: <20190325215846.31df78c7@oasis.local.home>
In-Reply-To: <55A448CA-1F0F-4396-89D0-22515B630A28@goodmis.org>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
        <20190307154316.19194-5-ykaradzhov@vmware.com>
        <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
        <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
        <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com>
        <f4a51b16-446a-a426-a8b4-71365b8829c4@gmail.com>
        <55A448CA-1F0F-4396-89D0-22515B630A28@goodmis.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 11:15:40 -0700
Steven Rostedt <rostedt@goodmis.org> wrote:

> >Thanks a lot for investigating this!
> >I think in this case it will be more appropriate if you sign the patch.
> >cheers,
> >Y.
> >  
> >> -- Slavi
> >>   
> >>>
> >>> But anyway, your solution looks cleaner and safer.
> >>> I will send another version of the patch.
> >>> Thanks a lot!  
> 
> 
> Signing the patch means that the person either wrote the patch or handled it to be committed.
> 
> I think you want Suggested-by:
> 

BTW, I'm confused. Does this patch need to be applied or was there another version coming?

-- Steve
