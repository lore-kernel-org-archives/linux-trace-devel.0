Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36184C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1197D21773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbfDQOw2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbfDQOw2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:52:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58AB62173C;
        Wed, 17 Apr 2019 14:52:27 +0000 (UTC)
Date:   Wed, 17 Apr 2019 10:52:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     John Kacur <jkacur@redhat.com>,
        Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are
 expressed
Message-ID: <20190417105225.1b032833@gandalf.local.home>
In-Reply-To: <20190417142515.GF6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
        <20190417130959.10064-2-kaslevs@vmware.com>
        <20190417135858.GD6118@pauld.bos.csb>
        <alpine.LFD.2.21.1904171616010.6386@planxty>
        <20190417142515.GF6118@pauld.bos.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Apr 2019 10:25:15 -0400
Phil Auld <pauld@redhat.com> wrote:

> > > FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> > > FILTER write /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/filter (len 74) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)"
> > > ...
> > > FILTER write /sys/kernel/debug/tracing/events/sched/sched_switch/filter (len 142) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(next_pid<21420||next_pid>21425)&&(next_pid<21265||next_pid>21418)"  
> > 
> > It seems crazy that we write "common_pid", instead of "pid" or "cpid", or 
> > something like that.
> > 
> > 
> >   
> 
> I assume those have to match fields in the trace event mechanism, but I don't know a lot 
> about it. 
> 
> "pid" is used in the wakeup event filters:
> 
> FILTER write /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/filter (len 122) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(pid<21420||pid>21425)&&(pid<21265||pid>21418)"
> 

Correct, the names have to match the fields listed in the format file.
The "common_*" was added way back in the beginning so that they differ
from the field names in the events.

-- Steve
