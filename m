Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2734BC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 14:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8FE120C01
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 14:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfBZOfT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 09:35:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfBZOfT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 09:35:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C5C0309BFE6;
        Tue, 26 Feb 2019 14:35:19 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D67BD5D6AA;
        Tue, 26 Feb 2019 14:35:18 +0000 (UTC)
Date:   Tue, 26 Feb 2019 09:35:17 -0500
From:   Phil Auld <pauld@redhat.com>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: Kernel-shark and sched_switch
Message-ID: <20190226143516.GE8239@pauld.bos.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 26 Feb 2019 14:35:19 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

	I'm using kernel-shark to visualize some scheduler traces. I noticed that the visualization
does not handle the sched_switch events as well as it might. The switch event is colored with the 
task being switched from, since that's the pid of the event itself.  But this has the effect of leaving
the wrong colored task "running" in the visualization until the next event by that task.  If that next
event is a sched_switch again you can have a case where the exact opposite of what happened is being 
visualized in kernel-shark. I could post a screenshot that illustrates this if that helps. Didn't want
to add a binary attachment to my first post.  It is especially glaring when switching to/from idle.

I've tried both with and without the sched_events plugin enabled.  There was no difference I could see. 

I'm not the slightest bit familiar with the code here, but I imagine there could be a way to get the pid
from the next_pid field when the event is SchedEvent::Switch instead of the general PID field. 


If this is not of general interest I'd be happy to make the change only in my tree if anyone has a pointer 
or two on where to start.  




Cheers,
Phil


-- 
