Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37198C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Dec 2021 15:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhLHPDj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 10:03:39 -0500
Received: from smtp1.axis.com ([195.60.68.17]:24977 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233750AbhLHPDi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 10:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1638975606;
  x=1670511606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l9A/soOpcH4dsKwyL9l5rK4o3lzhg1wL8TSBd+su+RI=;
  b=EKVZQIpryx/CR0vmztZKqgqHgswX4uXFt+I0hzFztWnkOdAV0hWNKBKC
   yBQKaz+UEx+JXsq7FQNLBwsVA1TqL0+PdArTt91i1/RedDaOiiuJ3Efys
   A3nlfjjcsKu5INHloOkKmJaxOIU8y0EyaJBwiRRiXHuEteg06yEccXvra
   nUidc8yZRczOiuCheU4BfPA3AAv3y+A+Zypv5ZPt5JcN4u0gA073Vmvu6
   /Gjl7tjzoo/WfkoDfN1ZRmd+6+3SbWa4zFf7asFyr670gcvfEShv/3Qtm
   NTy9GP7Zk90rrEESPpC9lJrRGTgmwzHgHES263ydW4DU6TjiyHXeThVuf
   Q==;
Date:   Wed, 8 Dec 2021 16:00:05 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, kernel <kernel@axis.com>
Subject: Re: [PATCH v2] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211208150004.GA15557@axis.com>
References: <20211208143402.28076-1-vincent.whitchurch@axis.com>
 <20211208094511.3efadb41@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211208094511.3efadb41@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Dec 08, 2021 at 03:45:11PM +0100, Steven Rostedt wrote:
> On Wed, 8 Dec 2021 15:34:02 +0100
> Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:
> 
> > Do not segfault if the event cannot be found for some reason and
> > tep_find_event_by_record() returns NULL.
> > 
> > With this patch:
> > 
> >  kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
> > [UNKNOWN EVENT][UNKNOWN EVENT] (NULL):               [UNKNOWN EVENT]
> >  kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...
> > 
> > Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
> Hi Vincent,
> 
> I already applied the update.
> 
>   https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/commit/?id=196a3a63c466204f3e8f4fa35194fc9ab7cb1ab7
> 
> Sorry, I waited a bit but your reply sounded like you wanted me to do it.

No worries, thanks.  I did think it would be easier for you to commit
it.  I pulled before reworking the patch but I didn't see your commit.
It turns out I was using a clone from the following (wrong) git which
hasn't been updated in months...

 https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/
