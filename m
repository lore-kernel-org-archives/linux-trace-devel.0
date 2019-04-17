Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02719C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDFFB21773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfDQOZS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfDQOZS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:25:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 664273002E1F;
        Wed, 17 Apr 2019 14:25:18 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BB4F60C62;
        Wed, 17 Apr 2019 14:25:17 +0000 (UTC)
Date:   Wed, 17 Apr 2019 10:25:15 -0400
From:   Phil Auld <pauld@redhat.com>
To:     John Kacur <jkacur@redhat.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>, rostedt@goodmis.org,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are expressed
Message-ID: <20190417142515.GF6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
 <20190417130959.10064-2-kaslevs@vmware.com>
 <20190417135858.GD6118@pauld.bos.csb>
 <alpine.LFD.2.21.1904171616010.6386@planxty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1904171616010.6386@planxty>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 17 Apr 2019 14:25:18 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 04:18:50PM +0200 John Kacur wrote:
> 
> 
> On Wed, 17 Apr 2019, Phil Auld wrote:
> 
> > On Wed, Apr 17, 2019 at 04:09:58PM +0300 Slavomir Kaslev wrote:
> > > Express pid filters as allowed/disallowed filter ranges
> > > 
> > >   (pid>=100&&pid<=103)
> > > 
> > > instead of specifying them per pid
> > > 
> > >   (pid==100||pid==101||pid==102||pid==103)
> > > 
> > > This makes the size of the resulting filter smaller (and faster) and avoids
> > > overflowing the filter size limit of one page which we can hit on bigger
> > > machines (say >160 CPUs).
> > 
> > This one works as well :)
> > 
> > I finally hit a case where my trace-cmd pids were non-contiguous and 
> > this split the range up correctly. 
> > 
> > 
> > FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> > FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> > ...
> > FILTER write /sys/kernel/debug/tracing/events/sched/sched_switch/filter (len 142) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(next_pid<21420||next_pid>21425)&&(next_pid<21265||next_pid>21418)"
> 
> It seems crazy that we write "common_pid", instead of "pid" or "cpid", or 
> something like that.
> 
> 
> 

I assume those have to match fields in the trace event mechanism, but I don't know a lot 
about it. 

"pid" is used in the wakeup event filters:

FILTER write /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/filter (len 122) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(pid<21420||pid>21425)&&(pid<21265||pid>21418)"




Cheers,
Phil
