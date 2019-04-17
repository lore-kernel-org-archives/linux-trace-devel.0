Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DEEC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79CA2217F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfDQOy0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfDQOy0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:54:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4BA2217F4;
        Wed, 17 Apr 2019 14:54:24 +0000 (UTC)
Date:   Wed, 17 Apr 2019 10:54:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v4 1/2] trace-cmd: Optimize how pid filters are
 expressed
Message-ID: <20190417105423.1cf2caad@gandalf.local.home>
In-Reply-To: <20190417135858.GD6118@pauld.bos.csb>
References: <20190417130959.10064-1-kaslevs@vmware.com>
        <20190417130959.10064-2-kaslevs@vmware.com>
        <20190417135858.GD6118@pauld.bos.csb>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Apr 2019 09:58:58 -0400
Phil Auld <pauld@redhat.com> wrote:

> FILTER write /sys/kernel/debug/tracing/events/sched/sched_switch/filter (len 142) value "(common_pid<21420||common_pid>21425)&&(common_pid<21265||common_pid>21418)||(next_pid<21420||next_pid>21425)&&(next_pid<21265||next_pid>21418)"
> 
> 
> The latter is correct given precendce of && before || but I wonder if () don't make sense? I always have to look
> that one up :)

Yes, as the one who wrote the parsing code (and was lectured by
Al Viro about it), I know for a fact that && has a higher precedence
than the || and it should work. I was about to comment about that, but
then remembered my "lesson" :-)

-- Steve


> 
> If I were writing that in code I'd probably put in the extra ()s, but since it's generated and no
> one actually sees it, probably okay and simpler as is. 
