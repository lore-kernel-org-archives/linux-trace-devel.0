Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9688C282E3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E86222AB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfDSSTQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfDSSTO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:19:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC477222E4;
        Fri, 19 Apr 2019 18:03:45 +0000 (UTC)
Date:   Fri, 19 Apr 2019 14:03:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Slavomir Kaslev <slavomir.kaslev@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
Message-ID: <20190419140344.71129b96@gandalf.local.home>
In-Reply-To: <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
        <20190418152146.27232-9-ykaradzhov@vmware.com>
        <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com>
        <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 07:46:10 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> > When is this error message going to be cleared? I don't think it
> > changes atm unless a new error comes along.  
> 
> The message will be displayed in a small widget (QErrorMessage). This 
> widget has an "OK" button and a "Show this message again" checkbox.
> 
> To clear the message you can either press "OK" or close the widget.
> If you uncheck the "Show this message again" checkbox, no message will 
> be shown next time when the error occurs.

Hmm, that dialog does appear a bit much. I wonder if we could just
change the color of the marker, or even make it into a dashed line (if
possible), or grayed out. Something immediate when a filter filters
out a marker to let the user know that it was filtered out.

That pop up would be something I would want to disable permanently in
my own use cases.

-- Steve
