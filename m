Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03809C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 13:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D24332077C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 13:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfDPNW7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 09:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfDPNW6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 09:22:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CAE22D808;
        Tue, 16 Apr 2019 13:22:58 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4765D71A;
        Tue, 16 Apr 2019 13:22:55 +0000 (UTC)
Date:   Tue, 16 Apr 2019 09:22:54 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 0/2] Optimize pid filters and add --no-filter option
Message-ID: <20190416132253.GA17860@pauld.bos.csb>
References: <20190415230016.13932-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415230016.13932-1-kaslevs@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 16 Apr 2019 13:22:58 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 02:00:14AM +0300 Slavomir Kaslev wrote:
> This patchset optimizes how pid filters are expressed and makes it less likely
> that we overflow ftrace filters' size limit of one page.
> 
> Changes since v2:
> 
> Append exclude rules with &&
> 
> Changes since v1:
> 
> Add missing tags
> Fix append_filter_pid_range() callers to pass valid range as [min,max]
> 
> 
> Slavomir Kaslev (2):
>   trace-cmd: Optimize how pid filters are expressed
>   trace-cmd: Add --no-filter option to not filter recording processes
> 
>  tracecmd/trace-record.c | 131 ++++++++++++++++++++++++++++------------
>  tracecmd/trace-usage.c  |   1 +
>  2 files changed, 92 insertions(+), 40 deletions(-)
> 
> -- 
> 2.19.1
> 


This version is also working for my use case.  The logic in the filter
does show the recording thread pids in the sched switch event, at least 
when switching to/from a non-excluded process.  But I think that's 
desired.

The --no-filter option works as expected.


Acked-by: Phil Auld <pauld@redhat.com>


Thanks,
Phil
-- 
