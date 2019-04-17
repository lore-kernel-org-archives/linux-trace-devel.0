Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CE5C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 12:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9B9921773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 12:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfDQMtP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 08:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbfDQMtP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 08:49:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9BE206BA;
        Wed, 17 Apr 2019 12:49:14 +0000 (UTC)
Date:   Wed, 17 Apr 2019 08:49:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        jbacik@fb.com, tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 0/2] Optimize pid filters and add --no-filter option
Message-ID: <20190417084912.65faf571@gandalf.local.home>
In-Reply-To: <20190417002910.GA9705@lorien.usersys.redhat.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
        <20190416132253.GA17860@pauld.bos.csb>
        <20190416173909.7b1ff01f@gandalf.local.home>
        <20190417002910.GA9705@lorien.usersys.redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Apr 2019 20:29:10 -0400
Phil Auld <pauld@redhat.com> wrote:

> > Could we get a Tested-by: from you for this series?  
> 
> The second one for sure. I did it both with and without and
> saw the difference.
> 
> I was not comfortable with that for the first because I really
> only tested it in my setup on one machine (160 cpus). I didn't do
> really thorough testing. If that's enough for you then sure :)
> 
> Tested-by: Phil Auld <pauld@redhat.com>

I'll just put it on the second one then.

Thanks!

-- Steve
