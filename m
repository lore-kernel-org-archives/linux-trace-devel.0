Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEF8C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E012077C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 18:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfDLSNR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:13:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfDLSNR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 14:13:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCC41308A958;
        Fri, 12 Apr 2019 18:13:16 +0000 (UTC)
Received: from lorien.usersys.redhat.com (ovpn-117-210.phx2.redhat.com [10.3.117.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FFDA19C65;
        Fri, 12 Apr 2019 18:13:15 +0000 (UTC)
Date:   Fri, 12 Apr 2019 14:13:13 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Josef Bacik <jbacik@fb.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: trace-cmd fails with many cpus
Message-ID: <20190412181313.GA11355@lorien.usersys.redhat.com>
References: <20190412135333.GB6201@pauld.bos.csb>
 <20190412111546.0c54576e@gandalf.local.home>
 <20190412113547.31b08902@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412113547.31b08902@gandalf.local.home>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 12 Apr 2019 18:13:17 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 12, 2019 at 11:35:47AM -0400 Steven Rostedt wrote:
> On Fri, 12 Apr 2019 11:15:46 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > 
> > > 
> > > I suppose the answer is don't run on a system with that many cpus  :)
> > > 
> > > But I wonder if it would be possible to have the threads each handle say 8 cpu
> > > files or something.  
> > 
> > Actually, I think another solution is to consolidate the pids that are
> > to be excluded and sort them. Thus if we have (which is very likely the
> > case)
> > 
> >  (common_pid!=1000)&&(common_pid!=1001)&&(common_pid!=1002)
> > 
> > That we change that to:
> > 
> >   !((common_pid>=1000)||(common_pid<=1002))  
> 
> > > WRITE: /sys/kernel/tracing/events/sched/sched_switch/filter, len 6718, data "(common_pid!=100199)&&(common_pid!=100198)&&(common_pid!=100197)&&(common_pid!=100196)&&(common_pid!=100195)&&(common_pid!=100194)&&(common_pid!=100193)&&(common_pid!=100192)&&(common_pid!=100191) ... 160 of these ...
> > > &&(common_pid!=100040)||(next_pid!=100199)&&(next_pid!=100198)&&(next_pid!=100197)&&(next_pid!=100196)&&(next_pid!=100195)&&(next_pid!=100194)&&(next_pid!=100193)&&(next_pid!=100192)...  160 of these...
> 
> Yes this would definitely help. From your output that is shown, we
> could convert that to:
> 
>  !((common_pid>=100040)||(common_pid<=100199))&&!((next_pid>=100040)||(next_pid<=100199))
> 

That'll be interesting to code given how the code works now, but does look 
like it would help. Probably save a lot of instructions when filtering too.


Thanks for looking at it. 


I can just find a smaller machine.


Cheers,
Phil


> 
> -- Steve

-- 
