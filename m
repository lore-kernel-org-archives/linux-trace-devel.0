Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A339C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D88120842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfCERLN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:11:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfCERLN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 12:11:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB7A420652;
        Tue,  5 Mar 2019 17:11:12 +0000 (UTC)
Date:   Tue, 5 Mar 2019 12:11:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] kernel-shark: Define free_contex function for the
 sched_events plugin
Message-ID: <20190305121111.1b2d8b2c@gandalf.local.home>
In-Reply-To: <20190305155425.GA19674@box>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
        <20190305143924.11056-2-ykaradzhov@vmware.com>
        <20190305155425.GA19674@box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 5 Mar 2019 17:54:26 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:


> Nit: there's a typo in the commit message
> 
> >    kernel-shark: Define free_contex function for the sched_events plugin  
>                                      ^
> :s/free_contex/plugin_free_context/g ?

I caught that too, and fixed it.


> 
> Other than that it looks good to me.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thanks Slavomir,

I'll add your review tag.

-- Steve
