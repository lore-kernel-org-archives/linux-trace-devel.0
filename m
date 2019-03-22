Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A302C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 16:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7245D2190A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 16:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfCVQOy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 12:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729209AbfCVQOy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 12:14:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E01218A2;
        Fri, 22 Mar 2019 16:14:53 +0000 (UTC)
Date:   Fri, 22 Mar 2019 12:14:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to
 char *
Message-ID: <20190322121450.193ed84e@gandalf.local.home>
In-Reply-To: <CAE0o1Nvph5RHtEuT7rQMtrLyA76B4yVb8rxFKQupYzNLdTkFpw@mail.gmail.com>
References: <20190322150105.24136-1-kaslevs@vmware.com>
        <20190322112542.0bf2e37d@gandalf.local.home>
        <CAE0o1Nvph5RHtEuT7rQMtrLyA76B4yVb8rxFKQupYzNLdTkFpw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 15:39:11 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> You're completely right. I still think that it makes sense to have
> that patch go in, maybe with rewritten commit message.
> In tracecmd_msg_read_data()[1] we do pointer arithmetic on void
> pointer which is undefined behavior (though gcc allows it unless
> -pedantic-errors is passed) and this patch will take care of it.
> 
> Should I resend or drop it?

I think the patch cleans up the code (removes a lot of the type
casting). Resend it with a new change log.

-- Steve
