Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06718C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9CB2087C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfDON7U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:59:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbfDON7U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 09:59:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FA21308FC5F;
        Mon, 15 Apr 2019 13:59:20 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC1A1091EE9;
        Mon, 15 Apr 2019 13:59:19 +0000 (UTC)
Date:   Mon, 15 Apr 2019 09:59:17 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH 0/2] Optimize pid filters and add --no-filter option
Message-ID: <20190415135917.GA22646@pauld.bos.csb>
References: <20190415104343.31113-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415104343.31113-1-kaslevs@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 15 Apr 2019 13:59:20 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 01:43:41PM +0300 Slavomir Kaslev wrote:
> This patchset optimizes how pid filters are expressed and makes it less likely
> that we overflow ftrace filters' size limit of one page.
> 
> Slavomir Kaslev (2):
>   trace-cmd: Optimize how pid filters are expressed
>   trace-cmd: Add --no-filter option to not filter recording processes
> 
>  tracecmd/trace-record.c | 126 +++++++++++++++++++++++++++-------------
>  tracecmd/trace-usage.c  |   1 +
>  2 files changed, 87 insertions(+), 40 deletions(-)
> 
> -- 
> 2.19.1
> 

That worked very nicely on my setup. Collapsed from len 6300+ to :

WRITE: /sys/kernel/tracing/events/sched/sched_switch/filter, len 70, data "(common_pid<13247||common_pid>13088)||(next_pid<13247||next_pid>13088)"


--no-filter also worked as advertised.

Thanks!



Acked-by: Phil Auld <pauld@redhat.com>

-- 
