Return-Path: <SRS0=cvyc=QO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562EDC282C2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Feb 2019 14:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F4B821916
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Feb 2019 14:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBGOlh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbfBGOlh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Feb 2019 09:41:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEBEC21908;
        Thu,  7 Feb 2019 14:41:36 +0000 (UTC)
Date:   Thu, 7 Feb 2019 09:41:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Re: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return
 error code if any
Message-ID: <20190207094135.6fda16e0@gandalf.local.home>
In-Reply-To: <CAE0o1Nuafu4H2fjf6oskCuCuXk-BB5y5D+Y0S-6mWfsYT9GPPw@mail.gmail.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
        <20190204070855.8921-7-kaslevs@vmware.com>
        <20190205101449.6d7ed6d2@gandalf.local.home>
        <CAE0o1Nuafu4H2fjf6oskCuCuXk-BB5y5D+Y0S-6mWfsYT9GPPw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 7 Feb 2019 12:52:03 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> On Tue, Feb 5, 2019 at 5:14 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Mon,  4 Feb 2019 09:08:53 +0200
> > Slavomir Kaslev <kaslevs@vmware.com> wrote:
> >
> > I accepted your patches up to here with some slight modifications to
> > the subjects and change logs. Note, when referencing function names,
> > its mostly desirable to add a "()" to the end of them to make it stand
> > out that they are functions. Like tracecmd_msg_send_close().
> >
> > But, this patch needs a change log to explain why this function should
> > return an error code. Is something going to rely on it in the future?  
> 
> Apologies for the empty commit message on this one, somehow it slipped
> me before sending.
> 
> The intention for this patch was simply stylistic, as with close()
> which returns error code but it's seldom checked.
> 
> Feel free to drop it if you find that unnecessary. Patch 7 and 8 don't
> depend on it. Should I resend them?
> 

I'll drop this patch and apply the other two (after looking a bit more
at them). No need to resend.

Thanks,

-- Steve
