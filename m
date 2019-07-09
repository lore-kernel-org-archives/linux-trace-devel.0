Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9843C73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6FAD21670
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGIPLO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfGIPLO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:11:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA662166E;
        Tue,  9 Jul 2019 15:11:13 +0000 (UTC)
Date:   Tue, 9 Jul 2019 11:11:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     "tz.stoyanov@gmail.com" <tz.stoyanov@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] trace-cmd: Add option to execute traced process as
 given user
Message-ID: <20190709111111.4a509459@gandalf.local.home>
In-Reply-To: <81c27b2b509f132aef9efdc37b04a29bf7c9425b.camel@vmware.com>
References: <20190709142908.13776-1-tz.stoyanov@gmail.com>
        <81c27b2b509f132aef9efdc37b04a29bf7c9425b.camel@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Jul 2019 15:06:42 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This is missing a check for allocation failure.
> 
> Other than that, looks great.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

I agree with everything Slavomir said. Tzvetomir, care to send a v4?

Thanks!

-- Steve
