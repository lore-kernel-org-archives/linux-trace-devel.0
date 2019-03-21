Return-Path: <SRS0=gVBF=RY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B093C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 12:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B912218FD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Mar 2019 12:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfCUM7m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbfCUM7m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 08:59:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9313218E2;
        Thu, 21 Mar 2019 12:59:41 +0000 (UTC)
Date:   Thu, 21 Mar 2019 08:59:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Matt Helsley <mhelsley@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tools/lib/traceevent: Implement new traceevent APIs
 for accessing struct tep_handler fields
Message-ID: <20190321085940.33bf7566@gandalf.local.home>
In-Reply-To: <CACqStofWc3178z+2bk_LTSfcZ=Q2y8PDtWmr9yeDxOuBus=CBw@mail.gmail.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
        <20190319111924.17443-4-tstoyanov@vmware.com>
        <854FD5EF-691D-4BF2-8A1D-FBF6863B5C19@vmware.com>
        <CACqStofWc3178z+2bk_LTSfcZ=Q2y8PDtWmr9yeDxOuBus=CBw@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Mar 2019 10:03:22 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This one is a little bit confusing, there are two different APIs:
> int tep_host_bigendian(void) - used in perf, checks the byte order of
> the local machine
> int tep_is_host_bigendian(struct tep_handle *pevent) - checks the
> order, stored in the tep_handler
> 
> I remember that we discussed this with Steven last year, and decided
> to keep both of them. I'm not
> aware of all use cases, and what is the purpose of tep_is_host_bigendian() API ?

Yes, there's history to these names. I'll take a look at them and see
how they can change to something less confusing.

-- Steve
