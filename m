Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C0C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 725D42171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfDLPfv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfDLPfu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 11:35:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3CB22082E;
        Fri, 12 Apr 2019 15:35:49 +0000 (UTC)
Date:   Fri, 12 Apr 2019 11:35:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Josef Bacik <jbacik@fb.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: trace-cmd fails with many cpus
Message-ID: <20190412113547.31b08902@gandalf.local.home>
In-Reply-To: <20190412111546.0c54576e@gandalf.local.home>
References: <20190412135333.GB6201@pauld.bos.csb>
        <20190412111546.0c54576e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 11:15:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > 
> > 
> > I suppose the answer is don't run on a system with that many cpus  :)
> > 
> > But I wonder if it would be possible to have the threads each handle say 8 cpu
> > files or something.  
> 
> Actually, I think another solution is to consolidate the pids that are
> to be excluded and sort them. Thus if we have (which is very likely the
> case)
> 
>  (common_pid!=1000)&&(common_pid!=1001)&&(common_pid!=1002)
> 
> That we change that to:
> 
>   !((common_pid>=1000)||(common_pid<=1002))  

> > WRITE: /sys/kernel/tracing/events/sched/sched_switch/filter, len 6718, data "(common_pid!=100199)&&(common_pid!=100198)&&(common_pid!=100197)&&(common_pid!=100196)&&(common_pid!=100195)&&(common_pid!=100194)&&(common_pid!=100193)&&(common_pid!=100192)&&(common_pid!=100191) ... 160 of these ...
> > &&(common_pid!=100040)||(next_pid!=100199)&&(next_pid!=100198)&&(next_pid!=100197)&&(next_pid!=100196)&&(next_pid!=100195)&&(next_pid!=100194)&&(next_pid!=100193)&&(next_pid!=100192)...  160 of these...

Yes this would definitely help. From your output that is shown, we
could convert that to:

 !((common_pid>=100040)||(common_pid<=100199))&&!((next_pid>=100040)||(next_pid<=100199))


-- Steve
