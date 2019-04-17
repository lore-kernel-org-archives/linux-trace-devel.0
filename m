Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCB3C10F13
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 00:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5585F21773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 00:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfDQA3N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 20:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfDQA3N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 20:29:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4E633DE0E;
        Wed, 17 Apr 2019 00:29:13 +0000 (UTC)
Received: from lorien.usersys.redhat.com (ovpn-116-148.phx2.redhat.com [10.3.116.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3EB65D9CA;
        Wed, 17 Apr 2019 00:29:12 +0000 (UTC)
Date:   Tue, 16 Apr 2019 20:29:10 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 0/2] Optimize pid filters and add --no-filter option
Message-ID: <20190417002910.GA9705@lorien.usersys.redhat.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
 <20190416132253.GA17860@pauld.bos.csb>
 <20190416173909.7b1ff01f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416173909.7b1ff01f@gandalf.local.home>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 17 Apr 2019 00:29:13 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 05:39:09PM -0400 Steven Rostedt wrote:
> On Tue, 16 Apr 2019 09:22:54 -0400
> Phil Auld <pauld@redhat.com> wrote:
> 
> > This version is also working for my use case.  The logic in the filter
> > does show the recording thread pids in the sched switch event, at least 
> > when switching to/from a non-excluded process.  But I think that's 
> > desired.
> > 
> > The --no-filter option works as expected.
> > 
> > 
> > Acked-by: Phil Auld <pauld@redhat.com>
> > 
> 
> Could we get a Tested-by: from you for this series?

The second one for sure. I did it both with and without and
saw the difference.

I was not comfortable with that for the first because I really
only tested it in my setup on one machine (160 cpus). I didn't do
really thorough testing. If that's enough for you then sure :)

Tested-by: Phil Auld <pauld@redhat.com>


Cheers,
Phil


> 
> Thanks!
> 
> -- Steve

-- 
