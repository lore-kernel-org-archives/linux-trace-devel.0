Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03432C31E50
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4A020657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFQNjv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfFQNjv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:39:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C9F720657;
        Mon, 17 Jun 2019 13:39:50 +0000 (UTC)
Date:   Mon, 17 Jun 2019 09:39:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ceco <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Implemented new API
 tracecmd_add_option_v()
Message-ID: <20190617093949.4d612c75@gandalf.local.home>
In-Reply-To: <CAPpZLN4ZwsZYCzjSGkyuu8r0ih-=7K8qG+TtQA33OxTfqbFjhA@mail.gmail.com>
References: <20190617115218.6279-1-tz.stoyanov@gmail.com>
        <20190617115218.6279-2-tz.stoyanov@gmail.com>
        <20190617090603.495e4333@gandalf.local.home>
        <CAPpZLN4ZwsZYCzjSGkyuu8r0ih-=7K8qG+TtQA33OxTfqbFjhA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jun 2019 16:18:38 +0300
Ceco <tz.stoyanov@gmail.com> wrote:

> Hi Steven
> 
> On Mon, Jun 17, 2019 at 4:06 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> ...
> >
> > Hmm, I think this is a bit overkill. I don't really see anything using
> > more than one or two data vectors. All I see would be at most a "count"
> > followed by a list of data, which is what I think you are using this
> > for.
> >
> > I rather wait to implement something like this when there's more of a
> > need for it. I don't believe this change really requires it.
> >
> > -- Steve
> >  
> 
> Actually, this patch is from the patch set (N 7):
>  "trace-cmd: Timetamps sync between host and guest machines, relying
> on vsock events. "
> and I took it as-is. In timesync changes tracecmd_add_option_v() is
> used in similar way.
> That explains the tracecmd_append_options() API, which is used there.
> 
> 

Ah, that needed to be stated. Yeah, when taking a patch from another
series, make sure that the change log is updated too. Never expect that
the reviewer will know about any other series ;-)

-- Steve
